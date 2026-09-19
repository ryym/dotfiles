// Personal tmux helper subcommands, run via bin/tmuxx.
// Usage: tmuxx <subcommand> [args...]

import {
  JOB_STATUS_OPTION,
  jumpToPane,
  jumpToSession,
  jumpToWindow,
  lastSessionName,
  listPanes,
  listSessions,
  setJobStatus,
} from "./tmux.js";
import { shortenPath } from "./paths.js";
import { runPromptInfo } from "./prompt-info.js";
import { buildRow, printTable, selectWithFzf } from "./table.js";

// Valid job statuses, most urgent first. rollupJobStatus relies on this order.
const JOB_STATUSES = ["blocked", "running", "done"];

const PANE_COLUMNS = [
  { header: "SESSION", maxWidth: 15 },
  { header: "WINDOW", maxWidth: 20 },
  { header: "JOB", fixed: true },
  { header: "PANE", maxWidth: 60 },
  { header: "CWD", maxWidth: 40, truncateFromStart: true },
];

const WINDOW_COLUMNS = [
  { header: "SESSION", maxWidth: 15 },
  { header: "WINDOW", maxWidth: 20 },
  { header: "PANES", fixed: true },
  { header: "JOB", fixed: true },
  { header: "CWD", maxWidth: 60, truncateFromStart: true },
  { header: "ACTIVE PANE", maxWidth: 60 },
];

const SESSION_COLUMNS = [
  { header: "SESSION", maxWidth: 20 },
  { header: "WINDOWS", fixed: true },
  { header: "JOB", fixed: true },
  { header: "ACTIVITY", fixed: true },
  { header: "CWD", maxWidth: 40, truncateFromStart: true },
];

// Marks rendered in the JOB column. Colored via ANSI so status is readable at a glance
// without spending column width on the status word itself.
const JOB_MARKS = {
  running: "\x1b[33m▶\x1b[0m",
  blocked: "\x1b[31m⏸\x1b[0m",
  done: "\x1b[32m✓\x1b[0m",
};

// Mark shown for the currently active window/pane; distinct from JOB_MARKS' colors.
const ACTIVE_MARK = "\x1b[1;36m➤\x1b[0m";

// Mark shown for the session the current client was in before switching to the current one
// (i.e. what `prefix + L` / switch-last-session would jump back to).
const LAST_SESSION_MARK = "\x1b[35m↩\x1b[0m";

// rollupJobStatus collapses a session's pane statuses down to the single most urgent one.
function rollupJobStatus(statuses) {
  return JOB_STATUSES.find((status) => statuses.includes(status));
}

// jobStatusBySession maps each session name to the rollup of its panes' job statuses.
function jobStatusBySession(panes) {
  const statusesBySession = new Map();
  for (const p of panes) {
    const status = p[JOB_STATUS_OPTION];
    if (!status) continue;
    if (!statusesBySession.has(p.session_name)) statusesBySession.set(p.session_name, []);
    statusesBySession.get(p.session_name).push(status);
  }

  const rollup = new Map();
  for (const [session, statuses] of statusesBySession) {
    rollup.set(session, rollupJobStatus(statuses));
  }
  return rollup;
}

// activeCwdBySession maps each session name to the cwd of its active pane (the pane in its
// active window), i.e. the pane you'd land in if you switched to that session right now.
function activeCwdBySession(panes) {
  const cwdBySession = new Map();
  for (const p of panes) {
    if (p.window_active === "1" && p.pane_active === "1") {
      cwdBySession.set(p.session_name, p.pane_current_path);
    }
  }
  return cwdBySession;
}

// formatRelativeTime renders a unix timestamp (seconds) as a short "how long ago" string.
function formatRelativeTime(unixSeconds) {
  const diff = Math.max(0, Math.floor(Date.now() / 1000) - Number(unixSeconds));
  if (diff < 60) return `${diff}s`;
  if (diff < 3600) return `${Math.floor(diff / 60)}m`;
  if (diff < 86400) return `${Math.floor(diff / 3600)}h`;
  return `${Math.floor(diff / 86400)}d`;
}

function activeCell(text, isActive) {
  return { text, mark: isActive ? ACTIVE_MARK : " ", highlight: isActive };
}

function buildPaneRows(panes) {
  return panes.map((p) => {
    const windowName = `${p.window_index}:${p.window_name}`;
    const paneName = `${p.pane_index}${p.pane_title ? `:${p.pane_title}` : ""}`;
    const cells = [
      p.session_name,
      activeCell(windowName, p.window_active === "1"),
      JOB_MARKS[p[JOB_STATUS_OPTION]] || "",
      activeCell(paneName, p.pane_active === "1"),
      shortenPath(p.pane_current_path),
    ];
    return buildRow(cells, PANE_COLUMNS);
  });
}

// windowsFromPanes collapses panes down to one entry per window, preserving the order windows
// first appear in (which matches session/window order from `tmux list-panes -a`).
function windowsFromPanes(panes) {
  const windows = new Map();
  for (const p of panes) {
    const key = `${p.session_name}\0${p.window_index}`;
    if (!windows.has(key)) {
      windows.set(key, {
        session_name: p.session_name,
        window_id: p.window_id,
        window_index: p.window_index,
        window_name: p.window_name,
        window_active: p.window_active,
        paneCount: 0,
        jobStatuses: [],
        activePaneTitle: "",
        activePaneCwd: "",
      });
    }
    const w = windows.get(key);
    w.paneCount++;
    if (p[JOB_STATUS_OPTION]) w.jobStatuses.push(p[JOB_STATUS_OPTION]);
    if (p.pane_active === "1") {
      w.activePaneTitle = p.pane_title;
      w.activePaneCwd = p.pane_current_path;
    }
  }
  return Array.from(windows.values());
}

function buildWindowRows(windows) {
  return windows.map((w) => {
    const windowName = `${w.window_index}:${w.window_name}`;
    const cells = [
      w.session_name,
      activeCell(windowName, w.window_active === "1"),
      String(w.paneCount),
      JOB_MARKS[rollupJobStatus(w.jobStatuses)] || "",
      shortenPath(w.activePaneCwd),
      w.activePaneTitle,
    ];
    return buildRow(cells, WINDOW_COLUMNS);
  });
}

function buildSessionRows(sessions, panes) {
  const jobBySession = jobStatusBySession(panes);
  const cwdBySession = activeCwdBySession(panes);
  const lastSession = lastSessionName();
  return sessions.map((s) => {
    // Never both: the currently attached session can't also be the previous one.
    const isActive = s.session_attached !== "0";
    const mark = isActive ? ACTIVE_MARK : s.session_name === lastSession ? LAST_SESSION_MARK : " ";
    const cells = [
      { text: s.session_name, mark, highlight: isActive },
      s.session_windows,
      JOB_MARKS[jobBySession.get(s.session_name)] || "",
      formatRelativeTime(s.session_activity),
      shortenPath(cwdBySession.get(s.session_name) || ""),
    ];
    return buildRow(cells, SESSION_COLUMNS);
  });
}

// showPanes prints panes as a table, or lets the user pick one in fzf and jumps to it.
function showPanes(panes, args) {
  const rows = buildPaneRows(panes);

  if (args.includes("--fzf")) {
    const paneId = selectWithFzf(panes, rows, PANE_COLUMNS, (p) => p.pane_id);
    if (paneId) jumpToPane(paneId);
  } else {
    printTable(rows, PANE_COLUMNS);
  }
}

function runPanes(args) {
  showPanes(listPanes({ allSessions: args.includes("--all") }), args);
}

// runJobs is runPanes narrowed down to the panes that have a job status.
function runJobs(args) {
  const panes = listPanes({ allSessions: args.includes("--all") });
  showPanes(panes.filter((p) => p[JOB_STATUS_OPTION]), args);
}

function runWindows(args) {
  const panes = listPanes({ allSessions: args.includes("--all") });
  const windows = windowsFromPanes(panes);
  const rows = buildWindowRows(windows);

  if (args.includes("--fzf")) {
    const windowId = selectWithFzf(windows, rows, WINDOW_COLUMNS, (w) => w.window_id);
    if (windowId) jumpToWindow(windowId);
  } else {
    printTable(rows, WINDOW_COLUMNS);
  }
}

function runSessions(args) {
  const sessions = listSessions();
  const panes = listPanes({ allSessions: true });
  const rows = buildSessionRows(sessions, panes);

  if (args.includes("--fzf")) {
    // Append ':' to {1} for the same reason as jumpToSession.
    const sessionName = selectWithFzf(sessions, rows, SESSION_COLUMNS, (s) => s.session_name, {
      previewCmd: "tmux capture-pane -e -p -t {1}:",
    });
    if (sessionName) jumpToSession(sessionName);
  } else {
    printTable(rows, SESSION_COLUMNS);
  }
}

// runJobStatus sets or clears the calling pane's own job status for tmux.conf to render.
// Each pane only writes its own option, so no locking is needed. Window/session rollups are
// never stored: they are derived from live panes on read (here and in tmux.conf).
function runJobStatus(args) {
  const [action, status] = args;
  if (action !== "set" && action !== "clear") {
    console.error("Usage: tmuxx job-status <set STATUS|clear>");
    process.exit(1);
  }

  if (action === "set" && !JOB_STATUSES.includes(status)) {
    console.error(`Unknown status: ${status || "(none)"}. Expected: ${JOB_STATUSES.join(", ")}`);
    process.exit(1);
  }

  // Not inside tmux (e.g. Claude Code run from a plain terminal), so there is no pane to mark.
  const pane = process.env.TMUX_PANE;
  if (!pane) return;

  setJobStatus(pane, action === "set" ? status : undefined);
}

const SUBCOMMANDS = {
  panes: runPanes,
  jobs: runJobs,
  windows: runWindows,
  sessions: runSessions,
  "job-status": runJobStatus,
  "prompt-info": runPromptInfo,
};

// main runs the subcommand named by the first of args (the command line without node and script).
export function main(args) {
  const [subcommand, ...subcommandArgs] = args;
  const run = SUBCOMMANDS[subcommand];
  if (!run) {
    console.log("Usage: tmuxx <subcommand>");
    console.log(`Subcommands: ${Object.keys(SUBCOMMANDS).join(", ")}`);
    process.exit(1);
  }

  run(subcommandArgs);
}
