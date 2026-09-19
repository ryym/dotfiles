// Keeps every pane's prompt options (cwd and Git state) up to date so the pane border can show
// them no matter what is running in the pane.
//
// This deliberately polls from one central process instead of having each shell push its own
// state: a shell only knows what it saw at its last prompt, so panes sitting in an editor, or
// simply idle while another pane switches the branch, would keep showing stale information.

import { gitState } from "./git.js";
import { shortenPath } from "./paths.js";
import { PROMPT_OPTIONS, claimPromptInfo, readPromptPanes, writePromptInfo } from "./tmux.js";

// Matches status-interval in tmux.conf. Changes are pushed with an explicit redraw, so this is
// only how long a change made outside tmux takes to be noticed.
const INTERVAL_MS = 2000;

// paneValues renders a pane's desired prompt options. Every option is always given a value so
// that a pane leaving a repository clears the previous one.
function paneValues(cwd) {
  const values = Object.fromEntries(PROMPT_OPTIONS.map((option) => [option, ""]));
  if (!cwd) return values;

  values["@prompt_path"] = shortenPath(cwd);

  let git;
  try {
    git = gitState(cwd);
  } catch {
    // A repository being rewritten under us (rebase, clone, delete) can fail any of the reads.
    return values;
  }
  if (!git) return values;

  values["@prompt_branch"] = git.branch;
  values["@prompt_action"] = git.action;
  if (git.upstream) {
    values["@prompt_ahead"] = git.ahead ? String(git.ahead) : "";
    values["@prompt_behind"] = git.behind ? String(git.behind) : "";
    // Mark an upstream that has nothing to exchange, so "no marker" keeps meaning "no upstream".
    values["@prompt_sync"] = git.ahead || git.behind ? "" : "=";
  }
  return values;
}

// update writes what changed since the last pass. Unchanged panes are left alone: setting a pane
// option redraws the border, so writing them all every tick would redraw everything constantly.
// Returns false when this process should stop.
function update() {
  let owner, panes;
  try {
    ({ owner, panes } = readPromptPanes());
  } catch {
    return false; // The tmux server is gone.
  }
  if (owner !== String(process.pid)) return false; // A newer watcher took over.

  const updates = [];
  for (const pane of panes) {
    const values = paneValues(pane.pane_current_path);
    for (const [option, value] of Object.entries(values)) {
      if (pane[option] !== value) updates.push({ paneId: pane.pane_id, option, value });
    }
  }

  try {
    writePromptInfo(updates);
  } catch {
    // A pane vanished mid-update; the next pass sets whatever was skipped.
  }
  return true;
}

// runPromptInfo updates every pane once, or keeps them updated with --watch.
//
// The watcher is started from a `#()` in tmux.conf's status line rather than managed as a
// separate daemon: tmux keeps the process alive, restarts it if it dies, and kills it with the
// server, so there is no pid file or supervisor to maintain.
export function runPromptInfo(args) {
  claimPromptInfo();

  if (!args.includes("--watch")) {
    update();
    return;
  }

  // tmux replaces a format job that has produced no output for a second with the placeholder
  // "<'...' not ready>", so give it one empty line to display. Everything this process actually
  // does is a side effect on the pane options, so nothing else is ever printed.
  // The man page mentions a placeholder but neither its text nor this condition:
  // https://github.com/tmux/tmux/blob/3.7b/format.c#L426-L427
  process.stdout.write("\n");

  const tick = () => {
    if (update()) setTimeout(tick, INTERVAL_MS);
  };
  tick();
}
