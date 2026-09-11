// Auto-sync of the agent's work: push the current branch to the "worksync" remote
// if it is ahead, and auto-commit/push the contents of the ".local/garage" directory.

import fs from "node:fs";
import path from "node:path";
import { log } from "./log.js";
import { git, gitOut, gitRun } from "./run.js";

/** Run all auto-sync tasks. Errors are only logged, never propagated. */
export async function autoSync(cwd) {
  await Promise.all([
    pushCurrentBranchToWorksync(cwd).catch((err) => {
      log(`worksync-push error: ${err.stack || err}`);
    }),
    commitAndPushGarage(cwd).catch((err) => {
      log(`garage error: ${err.stack || err}`);
    }),
  ]);
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
    fs.mkdirSync(garageDir, { recursive: true });
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
