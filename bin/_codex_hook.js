#!/usr/bin/env node

// Handles Codex lifecycle hooks.
// https://learn.chatgpt.com/docs/hooks
//
// Register the lifecycle events in ~/.codex/hooks.json,
// e.g. "PermissionRequest": [{ "hooks": [{ "type": "command", "command": "_codex_hook.js" }] }].

"use strict";

const fs = require("node:fs");
const path = require("node:path");
const childProcess = require("node:child_process");
const { promisify } = require("node:util");

const execFile = promisify(childProcess.execFile);
const LOG_PATH = process.env.CODEX_HOOK_LOG_PATH || "/tmp/codex_hook.log";

const dtFormat = new Intl.DateTimeFormat("sv-SE", {
  timeZone: "Asia/Tokyo",
  year: "numeric",
  month: "2-digit",
  day: "2-digit",
  hour: "2-digit",
  minute: "2-digit",
  second: "2-digit",
});

function log(value) {
  const text = String(value || "").trim();
  if (!text) return;
  try {
    fs.appendFileSync(LOG_PATH, `[${dtFormat.format(new Date())}] ${text}\n`);
  } catch {
    // Logging is deliberately best-effort: it must never fail a hook.
  }
}

async function main(raw) {
  if (!raw.trim()) return;
  const input = JSON.parse(raw);
  if (!input.hook_event_name) throw new Error("missing Codex hook_event_name");
  return handleHook(input);
}

async function handleHook(input) {
  const event = input.hook_event_name;
  const cwd = input.cwd || process.cwd();
  log(`============ hook start: ${event} ${JSON.stringify(input)}`);

  switch (event) {
    case "UserPromptSubmit":
    case "PreToolUse":
    case "PostToolUse":
      await setPaneJobStatus("running");
      break;
    case "PermissionRequest":
      await Promise.all([
        setPaneJobStatus("blocked"),
        sendNotification(
          input.tool_input?.description || "Codex needs your approval",
          "notification"
        ),
      ]);
      break;
    case "Stop":
      await Promise.all([
        setPaneJobStatus("done"),
        sendNotification("Codex finished its turn", "stop"),
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
      log(`unsupported Codex hook: ${event}`);
  }
}

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
    if (!stdout && !stderr) log(err.message);
    return { code: typeof err.code === "number" ? err.code : 1, stdout, stderr };
  }
}

function git(cwd, args) {
  return run("git", ["-C", cwd, ...args]);
}

async function gitOut(cwd, args) {
  const { code, stdout } = await git(cwd, args);
  return code === 0 ? stdout.trim() : null;
}

async function gitRun(cwd, args) {
  return (await git(cwd, args)).code === 0;
}

async function setPaneJobStatus(status) {
  await run("tmuxx", ["job-status", "set", status]);
}

async function clearPaneJobStatus() {
  await run("tmuxx", ["job-status", "clear"]);
}

async function sendNotification(message, event) {
  try {
    const noNotifPath = process.env.AGENT_NO_NOTIF_PATH;
    if (noNotifPath && fs.existsSync(noNotifPath)) return;

    await run("notifm", [message], { stdio: "ignore" });

    const webhookUrl = process.env.DISCORD_WEBHOOK_URL_CODEX;
    if (webhookUrl && fs.existsSync("/tmp/codex-notif-web")) {
      const title = event === "stop" ? "Complete" : "Need help";
      log(`send web notification: ${title}`);
      await fetch(webhookUrl, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          username: "Codex",
          embeds: [{ title, description: message, color: 14711343 }],
        }),
      });
    }
  } catch (err) {
    log(`notification error: ${err.stack || err}`);
  }
}

async function isInsideWorkTree(cwd) {
  return (await gitOut(cwd, ["rev-parse", "--is-inside-work-tree"])) === "true";
}

async function pushCurrentBranchToWorksync(cwd) {
  if (!(await isInsideWorkTree(cwd))) return;
  const remotes = await gitOut(cwd, ["remote"]);
  if (!remotes || !remotes.split("\n").includes("worksync")) return;

  const branch = await gitOut(cwd, ["symbolic-ref", "--short", "HEAD"]);
  const localSha = await gitOut(cwd, ["rev-parse", "HEAD"]);
  if (!branch || !localSha) return;

  const remote = await gitOut(cwd, ["ls-remote", "worksync", `refs/heads/${branch}`]);
  if (remote) {
    const remoteSha = remote.split("\n")[0].split("\t")[0];
    if (localSha === remoteSha) return;
    if (!(await gitRun(cwd, ["merge-base", "--is-ancestor", remoteSha, "HEAD"]))) return;
  }

  log("push new commits to worksync");
  const { code } = await git(cwd, ["push", "worksync", branch]);
  if (code !== 0) log(`worksync push of ${branch} failed (exit ${code})`);
}

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

function installGaragePreCommitHook(garageDir) {
  try {
    const hookPath = path.join(garageDir, ".git", "hooks", "pre-commit");
    fs.mkdirSync(path.dirname(hookPath), { recursive: true });
    fs.writeFileSync(hookPath, GARAGE_PRE_COMMIT_HOOK, { mode: 0o755 });
  } catch (err) {
    log(`failed to install garage pre-commit hook: ${err.stack || err}`);
  }
}

async function commitAndPushGarage(cwd) {
  const garageDir = path.join(cwd, ".local", "garage");
  if (!fs.existsSync(garageDir)) fs.mkdirSync(garageDir, { recursive: true });
  else if (!fs.statSync(garageDir).isDirectory()) {
    log(`garage is not a directory: ${garageDir}`);
    return;
  }

  if (!fs.existsSync(path.join(garageDir, ".git"))) {
    if (!(await gitRun(garageDir, ["init"]))) return;
    installGaragePreCommitHook(garageDir);
  }
  if (!(await gitRun(garageDir, ["add", "-A"]))) return;

  const staged = await gitOut(garageDir, ["diff", "--cached", "--name-only"]);
  const files = staged ? staged.split("\n").filter(Boolean) : [];
  if (!files.length) return;

  const shown = files.slice(0, 20).join(", ") + (files.length > 20 ? ", ..." : "");
  if (!(await gitRun(garageDir, ["commit", "-m", `auto: ${shown}`]))) return;
  await pushCurrentBranchToWorksync(garageDir);
}

async function autoSync(cwd) {
  await Promise.all([
    pushCurrentBranchToWorksync(cwd).catch((err) =>
      log(`worksync-push error: ${err.stack || err}`)
    ),
    commitAndPushGarage(cwd).catch((err) => log(`garage error: ${err.stack || err}`)),
  ]);
}

const input = fs.readFileSync(0, "utf8");
main(input).catch((err) => {
  log(`fatal: ${err.stack || err.message}`);
  console.error(err.message);
  process.exit(1);
});
