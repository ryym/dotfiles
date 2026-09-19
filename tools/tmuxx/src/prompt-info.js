// Manages the prompt information (cwd and Git state) shown on tmux's pane border.
// The same information normally lives in the shell prompt, but there it goes stale whenever
// another process changes the Git state while the shell is not being used. Keeping the
// information in one place and refreshing it continuously lets tmux always show the current one.

import { gitState } from "./git.js";
import { shortenPath } from "./paths.js";
import { PROMPT_OPTIONS, claimPromptInfo, readPromptPanes, writePromptInfo } from "./tmux.js";

// Matches status-interval in tmux.conf. Changes are pushed with an explicit redraw, so this is
// only how long a change made outside tmux takes to be noticed.
const INTERVAL_MS = 2000;

// paneValues renders a pane's desired prompt options ("@prompt_*"). Every option is always
// given a value so that a pane leaving a repository clears the previous one.
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
// Returns the pid currently owning the prompt options, or undefined when tmux is unreachable.
function update() {
  let owner, panes;
  try {
    ({ owner, panes } = readPromptPanes());
  } catch {
    return undefined; // The tmux server is gone.
  }

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
  return owner;
}

// watch keeps every pane updated until tmux goes away or a newer watcher takes over.
function watch() {
  // Record this process as the owner so that several processes never poll at once. Once another
  // process claims ownership, this watcher stops.
  //
  // Known limitation: tmux keeps format jobs per attached client, so a second attached client
  // starts a second watcher. The two then take ownership from each other in turn, and tmux
  // restarts whichever one exits, leaving them respawning every tick. Only one client is ever
  // attached here, so this is left alone; fixing it would mean letting the loser idle instead of
  // exiting. https://github.com/tmux/tmux/blob/3.7b/format.c#L382-L385
  claimPromptInfo();

  // tmux replaces a format job that has produced no output for a second with the placeholder
  // "<'...' not ready>", so give it one empty line to display. Everything this process actually
  // does is a side effect on the pane options, so nothing else is ever printed.
  // The man page mentions a placeholder but neither its text nor this condition:
  // https://github.com/tmux/tmux/blob/3.7b/format.c#L426-L427
  process.stdout.write("\n");

  const tick = () => {
    if (update() === String(process.pid)) {
      setTimeout(tick, INTERVAL_MS);
    }
  };
  tick();
}

// runPromptInfo updates every pane once, or keeps them updated with --watch.
export function runPromptInfo(args) {
  if (args.includes("--watch")) watch();
  else update();
}
