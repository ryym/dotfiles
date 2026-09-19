// Reads the state of a Git repository for the pane border's prompt info.
//
// The cheap parts (branch name, in-progress operation) are read straight from files under the
// Git directory, so a branch switch made in any pane shows up on the next tick. Only the
// ahead/behind counts need a real git process, and those are cached.

import { execFileSync, spawn } from "node:child_process";
import { readFileSync, statSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";

// How long ahead/behind counts are reused before git is run again. A checkout or commit changes
// HEAD and refreshes them immediately, so this only delays changes made outside this repository.
const SYNC_TTL_MS = 5000;

// Minimum interval between background fetches of a repository's remote-tracking refs.
const FETCH_INTERVAL_MS = 300_000;

// Throttle stamp for the background fetch. Shared with zshrc's _maybe_fetch_upstream, which
// refreshes the same refs, so the two never fetch twice within one interval.
const FETCH_STAMP = ".fetch_stamp";

// Drop cache entries for repositories no pane has visited for this long.
const CACHE_MAX_AGE_MS = 600_000;

// In-progress operations, most specific first, keyed by the marker git creates while running
// them under the Git directory.
const ACTIONS = [
  ["rebase-merge/interactive", "rebase-i"],
  ["rebase-merge", "rebase"],
  ["rebase-apply/applying", "am"],
  ["rebase-apply", "rebase"],
  ["MERGE_HEAD", "merge"],
  ["CHERRY_PICK_HEAD", "cherry-pick"],
  ["REVERT_HEAD", "revert"],
  ["BISECT_LOG", "bisect"],
];

function readIfExists(file) {
  try {
    return readFileSync(file, "utf8").trim();
  } catch {
    return undefined;
  }
}

function exists(file) {
  try {
    return statSync(file, { throwIfNoEntry: false }) !== undefined;
  } catch {
    return false;
  }
}

function stripBranchPrefix(ref) {
  return ref.replace(/^refs\/heads\//, "");
}

// findGitDir walks up from dir to the repository's Git directory, following the `gitdir:`
// pointer that linked worktrees and submodules use. Returns undefined outside a repository.
function findGitDir(dir) {
  for (;;) {
    const dotGit = join(dir, ".git");
    let stat;
    try {
      stat = statSync(dotGit, { throwIfNoEntry: false });
    } catch {
      return undefined;
    }
    if (stat?.isDirectory()) return dotGit;
    if (stat?.isFile()) {
      const pointer = readIfExists(dotGit)?.match(/^gitdir:\s*(.+)$/m);
      return pointer ? resolve(dir, pointer[1].trim()) : undefined;
    }

    const parent = dirname(dir);
    if (parent === dir) return undefined;
    dir = parent;
  }
}

function branchFromHead(head) {
  const ref = head.match(/^ref:\s*(.+)$/);
  // Detached HEAD: fall back to the short commit hash, like the shell prompt does.
  return ref ? stripBranchPrefix(ref[1].trim()) : head.slice(0, 7);
}

function currentAction(gitDir) {
  const found = ACTIONS.find(([marker]) => exists(join(gitDir, marker)));
  return found ? found[1] : "";
}

// rebaseBranch returns the branch being rebased, which HEAD no longer names because a rebase
// leaves it detached.
function rebaseBranch(gitDir) {
  const name =
    readIfExists(join(gitDir, "rebase-merge", "head-name")) ??
    readIfExists(join(gitDir, "rebase-apply", "head-name"));
  return name ? stripBranchPrefix(name) : undefined;
}

// countAgainstUpstream compares the current branch with its upstream. Only local refs are read,
// so this never touches the network; maybeFetch is what keeps the remote-tracking refs current.
function countAgainstUpstream(cwd) {
  try {
    const output = execFileSync("git", ["rev-list", "--left-right", "--count", "@{upstream}...HEAD"], {
      cwd,
      encoding: "utf8",
      stdio: ["ignore", "pipe", "ignore"],
    });
    const [behind, ahead] = output.trim().split(/\s+/).map(Number);
    return { upstream: true, ahead, behind };
  } catch {
    // No upstream to compare against (or git failed): show the branch on its own.
    return { upstream: false, ahead: 0, behind: 0 };
  }
}

// maybeFetch refreshes the repository's remote-tracking refs in the background, throttled by a
// stamp file, so the ahead/behind counts stay meaningful without ever blocking the update loop.
function maybeFetch(gitDir, cwd) {
  const stamp = join(gitDir, FETCH_STAMP);
  let stat;
  try {
    stat = statSync(stamp, { throwIfNoEntry: false });
  } catch {
    return;
  }
  if (stat && Date.now() - stat.mtimeMs < FETCH_INTERVAL_MS) return;

  try {
    writeFileSync(stamp, "");
  } catch {
    return;
  }

  const child = spawn("git", ["fetch", "--quiet", "--no-tags"], {
    cwd,
    stdio: "ignore",
    detached: true,
  });
  child.on("error", () => {});
  child.unref();
}

const syncCache = new Map();

function pruneCache(now) {
  for (const [gitDir, entry] of syncCache) {
    if (now - entry.usedAt > CACHE_MAX_AGE_MS) syncCache.delete(gitDir);
  }
}

function syncState(gitDir, cwd, head) {
  const now = Date.now();
  pruneCache(now);

  const cached = syncCache.get(gitDir);
  if (cached && cached.head === head && now - cached.checkedAt < SYNC_TTL_MS) {
    cached.usedAt = now;
    return cached.sync;
  }

  const sync = countAgainstUpstream(cwd);
  syncCache.set(gitDir, { head, sync, checkedAt: now, usedAt: now });
  return sync;
}

// gitState returns { branch, action, upstream, ahead, behind } for the repository containing
// cwd, or undefined when cwd is not inside one.
export function gitState(cwd) {
  const gitDir = findGitDir(cwd);
  if (!gitDir) return undefined;

  const head = readIfExists(join(gitDir, "HEAD"));
  if (head === undefined) return undefined;

  const action = currentAction(gitDir);
  const branch = (action ? rebaseBranch(gitDir) : undefined) ?? branchFromHead(head);
  const sync = syncState(gitDir, cwd, head);
  if (sync.upstream) maybeFetch(gitDir, cwd);

  return { branch, action, ...sync };
}
