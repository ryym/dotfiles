// Handles Claude Code hooks, run via bin/_claude_hook.js.
// https://docs.anthropic.com/en/docs/claude-code/hooks
//
// To use this, register bin/_claude_hook.js for each handled event in .claude/settings.json,
// e.g. "Stop": [{ "hooks": [{ "type": "command", "command": "_claude_hook.js" }] }].

import { autoSync } from "./autosync.js";
import { runHook } from "./hook.js";
import { clearPaneJobStatus, setPaneJobStatus } from "./job-status.js";
import { log } from "./log.js";
import { isNotificationDisabled, notifyDesktop, notifyDiscord } from "./notify.js";
import { run } from "./run.js";

export function main() {
  return runHook({
    logPath: process.env.CLAUDE_HOOK_LOG_PATH || "/tmp/claude_hook.log",
    handle: handleHook,
  });
}

async function handleHook(input) {
  const eventName = input.hook_event_name;
  switch (eventName) {
    case "UserPromptSubmit":
      await handleUserPromptSubmitEvent(input);
      break;
    case "PostToolUse":
      await handlePostToolUseEvent(input);
      break;
    case "Notification":
      await handleNotificationEvent(input);
      break;
    case "Stop":
      await handleStopEvent(input);
      break;
    case "StopFailure":
      await handleStopFailureEvent(input);
      break;
    case "SubagentStop":
      await handleSubagentStopEvent(input);
      break;
    case "SessionEnd":
      await handleSessionEndEvent(input);
      break;
    default:
      throw new Error(`unsupported Claude hook: ${eventName}`);
  }
}

/**
 * Handle "UserPromptSubmit" Event.
 * https://code.claude.com/docs/en/hooks#userpromptsubmit
 */
async function handleUserPromptSubmitEvent() {
  await setPaneJobStatus("running");
}

/**
 * Handle "PostToolUse" Event.
 * https://code.claude.com/docs/en/hooks#posttooluse
 */
async function handlePostToolUseEvent() {
  // A tool just ran, so Claude is working. This also recovers the pane from a lingering
  // `blocked` after the user grants a permission and Claude resumes: the resumed tool's
  // PreToolUse already fired before the block, so its PostToolUse is the first event
  // after approval that can flip the status back to running.
  //
  // Race note (parallel subagents): @job_status is a single per-pane value, last-write-
  // wins with no priority, so this running write can stomp a still-pending `blocked`. A
  // subagent's own tools can't cause it -- they don't fire main-session PostToolUse (see
  // claude-code issue #34692) -- but the main agent running tools while a *background*
  // subagent waits on a permission will. Accepted as-is: it's transient (the next
  // Notification/Stop re-derives the state), the permission still raises a desktop
  // notification so nothing is silently lost, and distinguishing "approved-and-resumed"
  // from "another actor still blocked" would need per-actor tracking that isn't worth it.
  await setPaneJobStatus("running");
}

/**
 * Handle "SessionEnd" Event.
 * https://code.claude.com/docs/en/hooks#sessionend
 */
async function handleSessionEndEvent() {
  await clearPaneJobStatus();
}

/**
 * Handle "Notification" Event.
 * https://code.claude.com/docs/en/hooks#notification-input
 */
async function handleNotificationEvent(input) {
  // Ignore "Claude is waiting for your input".
  if (input.notification_type === "idle_prompt") {
    return;
  }
  await Promise.all([
    // A notification means Claude is blocked on the user (permission/input).
    setPaneJobStatus("blocked"),
    sendNotification({ message: input.message }),
  ]);
}

async function sendNotification({ message }) {
  try {
    if (isNotificationDisabled()) return;

    const paneTitle = await getClaudeTmuxPaneTitle();
    await notifyDesktop({ message, subtitle: paneTitle });
    await notifyDiscord({
      webhookUrl: process.env.DISCORD_WEBHOOK_URL_CLAUDE,
      flagPath: "/tmp/claude-notif-web",
      username: "Claude Code",
      title: message,
      description: paneTitle || undefined,
    });
  } catch (err) {
    log(`notification error: ${err.stack || err}`);
  }
}

/**
 * Return the current tmux pane's title, but only when it looks like one Claude Code
 * set automatically (it always starts with "✳"). Returns null outside tmux, or when
 * the title was set by something else (e.g. the user, or a shell default).
 */
async function getClaudeTmuxPaneTitle() {
  const tmuxPane = process.env.TMUX_PANE;
  if (!process.env.TMUX || !tmuxPane) return null;

  const { code, stdout } = await run("tmux", [
    "display-message",
    "-p",
    "-t",
    tmuxPane,
    "#{pane_title}",
  ]);
  if (code !== 0) return null;

  const title = stdout.trim();
  return title.startsWith("✳") ? title : null;
}

/**
 * Handle "Stop" Event.
 * https://code.claude.com/docs/en/hooks#stop
 */
async function handleStopEvent(input) {
  // Keep the `running` state unless all background work has completed.
  const backgroundTasks = input.background_tasks || [];
  if (backgroundTasks.length > 0) {
    log(`stop with ${backgroundTasks.length} background task(s) in flight; skip notification`);
    return;
  }

  await Promise.all([
    setPaneJobStatus("done"),
    sendNotification({ message: "Claude finished task" }),
    autoSync(input.cwd || process.cwd()),
  ]);
}

/**
 * Handle "StopFailure" Event.
 * https://code.claude.com/docs/en/hooks#stopfailure
 */
async function handleStopFailureEvent(input) {
  let errorInfo = input.error;
  if (input.error_details) {
    errorInfo += ` (${input.error_details})`;
  }
  await Promise.all([
    setPaneJobStatus("blocked"),
    sendNotification({ message: `Claude stopped due to an ERROR: ${errorInfo}` }),
  ]);
}

/**
 * Handle "SubagentStop" Event.
 * https://code.claude.com/docs/en/hooks#subagentstop
 */
async function handleSubagentStopEvent(input) {
  await autoSync(input.cwd || process.cwd());
}
