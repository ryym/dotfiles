// Handles Codex lifecycle hooks, run via bin/_codex_hook.js.
// https://learn.chatgpt.com/docs/hooks
//
// Register the lifecycle events in ~/.codex/hooks.json,
// e.g. "PermissionRequest": [{ "hooks": [{ "type": "command", "command": "_codex_hook.js" }] }].

import { autoSync } from "./autosync.js";
import { runHook } from "./hook.js";
import { clearPaneJobStatus, setPaneJobStatus } from "./job-status.js";
import { log } from "./log.js";
import { isNotificationDisabled, notifyDesktop, notifyDiscord } from "./notify.js";

export function main() {
  return runHook({
    logPath: process.env.CODEX_HOOK_LOG_PATH || "/tmp/codex_hook.log",
    handle: handleHook,
  });
}

async function handleHook(input) {
  const event = input.hook_event_name;
  const cwd = input.cwd || process.cwd();

  switch (event) {
    case "UserPromptSubmit":
    case "PreToolUse":
    case "PostToolUse":
      await setPaneJobStatus("running");
      break;
    case "PermissionRequest":
      await Promise.all([
        setPaneJobStatus("blocked"),
        sendNotification({
          message: input.tool_input?.description || "Codex needs your approval",
          webTitle: "Need help",
        }),
      ]);
      break;
    case "Stop":
      await Promise.all([
        setPaneJobStatus("done"),
        sendNotification({ message: "Codex finished its turn", webTitle: "Complete" }),
        autoSync(cwd),
      ]);
      break;
    case "SubagentStop":
      await autoSync(cwd);
      break;
    case "SessionEnd":
      await clearPaneJobStatus();
      break;
    default:
      throw new Error(`unsupported Codex hook: ${event}`);
  }
}

async function sendNotification({ message, webTitle }) {
  try {
    if (isNotificationDisabled()) return;

    await notifyDesktop({ message });
    await notifyDiscord({
      webhookUrl: process.env.DISCORD_WEBHOOK_URL_CODEX,
      flagPath: "/tmp/codex-notif-web",
      username: "Codex",
      title: webTitle,
      description: message,
    });
  } catch (err) {
    log(`notification error: ${err.stack || err}`);
  }
}
