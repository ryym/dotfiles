// Functions that query or control tmux. This is the only module that runs tmux commands.

import { execFileSync, spawnSync } from "node:child_process";

// Pane-scoped user option holding that pane's job state (e.g. a running Claude Code turn).
// Written here by `job-status`, read by tmux.conf to render the status line.
export const JOB_STATUS_OPTION = "@job_status";

// Pane-scoped user options holding the prompt info of that pane's directory. Written here by
// `prompt-info`, composed and colored by tmux.conf. They carry plain data (no styling) so the
// color palette stays in tmux.conf alone.
export const PROMPT_OPTIONS = [
  "@prompt_path",
  "@prompt_branch",
  "@prompt_action",
  "@prompt_ahead",
  "@prompt_behind",
  "@prompt_sync",
];

// Global user option naming the process that currently writes PROMPT_OPTIONS. tmux restarts the
// watcher whenever it dies, so a second one can appear; the newest claims this and the rest quit.
const PROMPT_OWNER_OPTION = "@prompt_info_owner";

const PROMPT_FIELDS = ["pane_id", "pane_current_path", ...PROMPT_OPTIONS];

const PROMPT_FORMAT = PROMPT_FIELDS.map((f) => `${f}=#{${f}}`).join("\t");

const FIELDS = [
  "session_name",
  "window_id",
  "window_index",
  "window_name",
  "window_active",
  "pane_index",
  "pane_id",
  "pane_active",
  "pane_title",
  JOB_STATUS_OPTION,
  "pane_current_path",
];

const FORMAT = FIELDS.map((f) => `${f}=#{${f}}`).join("\t");

const SESSION_FIELDS = ["session_name", "session_windows", "session_attached", "session_activity"];

const SESSION_FORMAT = SESSION_FIELDS.map((f) => `${f}=#{${f}}`).join("\t");

// parseTmuxTable turns tmux's `-F "key=#{key}\t..."` output into one object per line.
function parseTmuxTable(output) {
  return output
    .split("\n")
    .filter((line) => line.length > 0)
    .map((line) => {
      const row = {};
      for (const kv of line.split("\t")) {
        const idx = kv.indexOf("=");
        row[kv.slice(0, idx)] = kv.slice(idx + 1);
      }
      return row;
    });
}

export function listPanes(options) {
  const tmuxOptions = ["list-panes", options.allSessions ? "-a" : "-s", "-F", FORMAT];
  const output = execFileSync("tmux", tmuxOptions, { encoding: "utf8" });
  return parseTmuxTable(output);
}

export function listSessions() {
  const output = execFileSync("tmux", ["list-sessions", "-O", "creation", "-F", SESSION_FORMAT], {
    encoding: "utf8",
  });
  return parseTmuxTable(output);
}

// lastSessionName returns the session the current client was in before switching to the
// current one, or undefined when not run from inside tmux (no client to ask).
export function lastSessionName() {
  if (!process.env.TMUX) return undefined;
  // Query separately: this is a client attribute, so listSessions()'s format can't include it.
  const output = execFileSync("tmux", ["display-message", "-p", "#{client_last_session}"], {
    encoding: "utf8",
  }).trim();
  return output || undefined;
}

// jumpTo switches the current client to target, or attaches to it when run outside tmux.
// selectArgs, if given, is a tmux command (e.g. select-pane) run just before switching.
function jumpTo(target, selectArgs = []) {
  const clientArgs = [process.env.TMUX ? "switch-client" : "attach-session", "-t", target];
  const args = selectArgs.length > 0 ? [...selectArgs, ";", ...clientArgs] : clientArgs;
  const result = spawnSync("tmux", args, { stdio: "inherit" });
  // Only set the exit code on failure: tmux already reports the error on the inherited stderr.
  if (result.status !== 0) process.exitCode = result.status ?? 1;
}

export function jumpToPane(paneId) {
  jumpTo(paneId, ["select-pane", "-t", paneId]);
}

export function jumpToWindow(windowId) {
  jumpTo(windowId, ["select-window", "-t", windowId]);
}

export function jumpToSession(sessionName) {
  // Append ':' so tmux doesn't parse a session name containing '.' as a pane target.
  jumpTo(`${sessionName}:`);
}

// claimPromptInfo marks this process as the single writer of the prompt options.
export function claimPromptInfo() {
  execFileSync("tmux", ["set-option", "-g", PROMPT_OWNER_OPTION, String(process.pid)]);
}

// readPromptPanes returns the current owner pid alongside every pane's path and prompt options.
// Both are asked for in one tmux invocation to keep the update loop down to a single fork.
export function readPromptPanes() {
  const args = [
    "show-options",
    "-gqv",
    PROMPT_OWNER_OPTION,
    ";",
    "list-panes",
    "-a",
    "-F",
    PROMPT_FORMAT,
  ];
  const output = execFileSync("tmux", args, { encoding: "utf8" });
  const [owner, ...paneLines] = output.split("\n");
  return { owner: owner.trim(), panes: parseTmuxTable(paneLines.join("\n")) };
}

// writePromptInfo applies the given { paneId, option, value } updates. Panes can disappear
// between being listed and being written, which aborts the rest of the invocation; the caller
// is expected to ignore that and let the next pass set whatever was skipped.
export function writePromptInfo(updates) {
  if (updates.length === 0) return;

  const args = [];
  for (const { paneId, option, value } of updates) {
    if (args.length > 0) args.push(";");
    args.push("set-option", "-p", "-t", paneId, option, value);
  }
  // Redraw now instead of waiting up to status-interval for the next tick.
  args.push(";", "refresh-client", "-S");
  execFileSync("tmux", args, { stdio: "ignore" });
}

// setJobStatus sets the job status of the given pane, or clears it when status is undefined.
export function setJobStatus(paneId, status) {
  const optionArgs = status === undefined ? ["-u", JOB_STATUS_OPTION] : [JOB_STATUS_OPTION, status];
  // Redraw now instead of waiting up to status-interval for the next tick.
  execFileSync("tmux", [
    "set-option",
    "-p",
    "-t",
    paneId,
    ...optionArgs,
    ";",
    "refresh-client",
    "-S",
  ]);
}
