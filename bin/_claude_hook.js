#!/usr/bin/env node

// A script to handle Claude Code hooks.
// https://docs.anthropic.com/en/docs/claude-code/hooks
//
// To use this script, register it for each handled event in .claude/settings.json,
// e.g. "Stop": [{ "hooks": [{ "type": "command", "command": "_claude_hook.js" }] }].
// Handled events: UserPromptSubmit, PostToolUse, Notification, Stop, SubagentStop, SessionEnd.

const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");
const childProcess = require("node:child_process");
const { promisify } = require("node:util");

const execFile = promisify(childProcess.execFile);

/**
 * The main function which is an entry point.
 */
async function main(json) {
  const input = JSON.parse(json);
  const eventName = input.hook_event_name;
  log(`============ hook start: ${eventName} ${json}`);

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

const LOG_PATH = process.env.CLAUDE_HOOK_LOG_PATH || "/tmp/claude_hook.log";

// Use the Sweden locale to print a timestamp with ISO8601-like format.
const dtFormat = new Intl.DateTimeFormat("sv-SE", {
  timeZone: "Asia/Tokyo",
  year: "numeric",
  month: "2-digit",
  day: "2-digit",
  hour: "2-digit",
  minute: "2-digit",
  second: "2-digit",
});

/** Append a line of text to the log file. Never throws (logging must not break the hook). */
function log(text) {
  text = text.trim();
  if (text === "") {
    return;
  }
  try {
    fs.appendFileSync(LOG_PATH, `[${dtFormat.format(new Date())}] ${text.trim()}\n`);
  } catch {
    // ignore
  }
}

/** Run a command, with logging its stdout and stderr. Returns { code, stdout, stderr }; */
async function run(file, args, options = {}) {
  try {
    log(`RUN: ${file} ${args.join(" ")}`);
    const { stdout, stderr } = await execFile(file, args, { encoding: "utf8", ...options });
    log(stdout);
    log(stderr);
    return { code: 0, stdout, stderr };
  } catch (err) {
    const stdout = err.stdout || "";
    const stderr = err.stderr || "";
    log(stdout);
    log(stderr);
    if (!stdout && !stderr) {
      log(err.message); // e.g. spawn failure (command not found)
    }
    // err.code is the exit code (number) or a spawn-error string such as "ENOENT".
    const code = typeof err.code === "number" ? err.code : 1;
    return { code, stdout, stderr };
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
 * Report this pane's job status (running/blocked/done) to the tmux status line
 * via `tmuxx job-status`. Failures are only logged by `run`, never propagated.
 */
async function setPaneJobStatus(status) {
  await run("tmuxx", ["job-status", "set", status]);
}

async function clearPaneJobStatus() {
  await run("tmuxx", ["job-status", "clear"]);
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
    sendNotification(input.message, "notification"),
  ]);
}

async function sendNotification(message, event) {
  try {
    // The existence of the file means the user don't want to send a notification.
    const noNotifPath = process.env.AGENT_NO_NOTIF_PATH;
    if (noNotifPath && fs.existsSync(noNotifPath)) return;

    await run("notifm", [message], { stdio: "ignore" });

    const webhookUrl = process.env.DISCORD_WEBHOOK_URL_CLAUDE;
    if (webhookUrl && fs.existsSync("/tmp/claude-notif-web")) {
      await sendNotificationWeb(webhookUrl, event, message);
    }
  } catch (err) {
    log(`notification error: ${err.stack || err}`);
  }
}

async function sendNotificationWeb(webhookUrl, event, description) {
  const title = event === "stop" ? "Complete" : "Need help";
  const body = {
    username: "Claude Code",
    embeds: [{ title, description, color: 14711343 }],
  };

  log(`send web notification: "${title}"`);
  await fetch(webhookUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
}

/**
 * Handle "Stop" Event.
 * https://code.claude.com/docs/en/hooks#stop
 */
async function handleStopEvent(input) {
  await Promise.all([
    setPaneJobStatus("done"),
    sendNotification("Claude finished task", "stop"),
    autoSync(input.cwd || process.cwd()),
  ]);
}

/**
 * Handle "SubagentStop" Event.
 * https://code.claude.com/docs/en/hooks#subagentstop
 */
async function handleSubagentStopEvent(input) {
  await autoSync(input.cwd || process.cwd());
}

/**
 * On Stop, push the current branch to the "worksync" remote if it is ahead,
 * and auto-commit/push the contents of the ".local/garage" directory.
 */
async function autoSync(cwd) {
  await Promise.all([
    pushCurrentBranchToWorksync(cwd).catch((err) => {
      log(`worksync-push error: ${err.stack || err}`);
    }),
    commitAndPushGarage(cwd).catch((err) => {
      log(`garage error: ${err.stack || err}`);
    }),
  ]).catch((err) => {
    log(`autoSync error: ${err.stack || err}`);
  });
}

/** Run a git command (output auto-logged). Returns { code, stdout, stderr }. */
function git(cwd, args) {
  return run("git", ["-C", cwd, ...args]);
}

/** Run a git command and return trimmed stdout, or null on failure. */
async function gitOut(cwd, args) {
  const { code, stdout } = await git(cwd, args);
  return code === 0 ? stdout.trim() : null;
}

/** Run a git command for its side effect. Returns whether it succeeded. */
async function gitRun(cwd, args) {
  return (await git(cwd, args)).code === 0;
}

async function isInsideWorkTree(cwd) {
  return (await gitOut(cwd, ["rev-parse", "--is-inside-work-tree"])) === "true";
}

async function hasWorksyncRemote(cwd) {
  const out = await gitOut(cwd, ["remote"]);
  return out != null && out.split("\n").includes("worksync");
}

/** Return the SHA of a branch on the remote, or null if it does not exist. */
async function remoteBranchSha(cwd, remote, branch) {
  const out = await gitOut(cwd, ["ls-remote", remote, `refs/heads/${branch}`]);
  if (!out) return null;
  return out.split("\n")[0].split("\t")[0] || null;
}

/** Auto-push new commits to the "worksync" remote. */
async function pushCurrentBranchToWorksync(cwd) {
  if (!(await isInsideWorkTree(cwd))) return;
  if (!(await hasWorksyncRemote(cwd))) return;

  const branch = await gitOut(cwd, ["symbolic-ref", "--short", "HEAD"]);
  if (!branch) return; // detached HEAD

  const localSha = await gitOut(cwd, ["rev-parse", "HEAD"]);
  if (!localSha) return;

  // If a same-named branch already exists on worksync, only push when the local
  // branch is strictly ahead of it (contains the remote commit, not diverged).
  // Otherwise the branch is new on worksync, so push it to create it.
  const remoteSha = await remoteBranchSha(cwd, "worksync", branch);
  if (remoteSha) {
    if (localSha === remoteSha) return; // already up to date
    // A non-zero exit here is the normal "not an ancestor" case, so don't flag it.
    if (!(await gitRun(cwd, ["merge-base", "--is-ancestor", remoteSha, "HEAD"]))) return;
  }

  log("push new commits to worksync");
  const { code } = await git(cwd, ["push", "worksync", branch]);
  if (code !== 0) log(`worksync push of "${branch}" failed (exit ${code})`);
}

/** Auto-commit and push everything under ".local/garage" to the "worksync" remote. */
async function commitAndPushGarage(cwd) {
  const garageDir = path.join(cwd, ".local/garage");

  if (!fs.existsSync(garageDir)) {
    fs.mkdirSync(garageDir);
  } else if (!fs.statSync(garageDir).isDirectory()) {
    log(`garage is not a directory: ${garageDir}`);
    return;
  }

  if (!fs.existsSync(path.join(garageDir, ".git"))) {
    if (!(await gitRun(garageDir, ["init"]))) return;
    installGaragePreCommitHook(garageDir);
  }

  if (!(await gitRun(garageDir, ["add", "-A"]))) return;

  const files = await stagedFiles(garageDir);
  if (files.length === 0) return;

  if (!(await gitRun(garageDir, ["commit", "-m", buildGarageCommitMessage(files)]))) return;

  await pushCurrentBranchToWorksync(garageDir);
}

// Best-effort prettier formatting of staged files. Never blocks the commit
// (every step is guarded and the script always exits 0).
const GARAGE_PRE_COMMIT_HOOK = `#!/usr/bin/env bash
if command -v prettier >/dev/null 2>&1; then
  files=$(git diff --cached --name-only --diff-filter=ACMR | grep -E '\\.(js|jsx|ts|tsx|css|html|md)$' || true)
  if [ -n "$files" ]; then
    echo "$files" | xargs prettier --ignore-path /dev/null --write 2>/dev/null || true
    echo "$files" | xargs git add 2>/dev/null || true
  fi
fi
exit 0
`;

/** Install the prettier pre-commit hook into a freshly initialized garage repo. */
function installGaragePreCommitHook(garageDir) {
  try {
    const hookPath = path.join(garageDir, ".git", "hooks", "pre-commit");
    fs.mkdirSync(path.dirname(hookPath), { recursive: true });
    fs.writeFileSync(hookPath, GARAGE_PRE_COMMIT_HOOK, { mode: 0o755 });
  } catch (err) {
    log(`failed to install garage pre-commit hook: ${err.stack || err}`);
  }
}

/** Paths of currently staged files (one per line, no status prefix to parse). */
async function stagedFiles(cwd) {
  const out = await gitOut(cwd, ["diff", "--cached", "--name-only"]);
  if (!out) return [];
  return out.split("\n").filter(Boolean);
}

function buildGarageCommitMessage(files) {
  const max = 20;
  let shown = files.slice(0, max).join(", ");
  if (files.length > max) shown += ", ...";
  return `auto: ${shown}`;
}

main(fs.readFileSync(0, "utf8")).catch((err) => {
  log(`fatal: ${err.stack || err.message}`);
  console.error(err.message);
  process.exit(1);
});
