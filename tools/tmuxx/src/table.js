// Functions that render rows as an aligned table, either printed or picked from in fzf.

import { spawnSync } from "node:child_process";
import { stripVTControlCharacters } from "node:util";

// Wide ranges per East Asian Width (Unicode UAX #11): CJK, Hangul, fullwidth forms, emoji, etc.
const WIDE_RANGES = [
  [0x1100, 0x115f],
  [0x2e80, 0x303e],
  [0x3041, 0x33ff],
  [0x3400, 0x4dbf],
  [0x4e00, 0x9fff],
  [0xa000, 0xa4cf],
  [0xac00, 0xd7a3],
  [0xf900, 0xfaff],
  [0xff00, 0xff60],
  [0xffe0, 0xffe6],
  [0x1f300, 0x1f64f],
  [0x1f900, 0x1f9ff],
  [0x20000, 0x2fffd],
  [0x30000, 0x3fffd],
];

function charWidth(codePoint) {
  return WIDE_RANGES.some(([from, to]) => codePoint >= from && codePoint <= to) ? 2 : 1;
}

// strWidth returns the display width of str in terminal columns, ignoring ANSI escape sequences.
function strWidth(str) {
  return Array.from(stripVTControlCharacters(str)).reduce(
    (w, ch) => w + charWidth(ch.codePointAt(0)),
    0,
  );
}

function padEndDisplay(str, targetWidth) {
  return str + " ".repeat(Math.max(0, targetWidth - strWidth(str)));
}

function truncate(str, maxWidth, fromStart) {
  if (strWidth(str) <= maxWidth) return str;

  const chars = Array.from(str);
  if (fromStart) chars.reverse();

  const budget = maxWidth - 3; // reserve width for "..."
  const picked = [];
  let w = 0;
  for (const ch of chars) {
    const cw = charWidth(ch.codePointAt(0));
    if (w + cw > budget) break;
    w += cw;
    picked.push(ch);
  }

  return fromStart ? `...${picked.reverse().join("")}` : `${picked.join("")}...`;
}

function underline(str) {
  return `\x1b[4m${str}\x1b[24m`;
}

// renderCell fits a cell into its column. A cell is either a plain string or a marked cell
// `{ text, mark, highlight }`, where mark is one column wide (" " for none).
function renderCell(cell, column) {
  const fit = (text, maxWidth) =>
    column.fixed ? text : truncate(text, maxWidth, column.truncateFromStart);
  if (typeof cell === "string") return fit(cell, column.maxWidth);

  // Truncate before decorating, since truncate would count ANSI escape sequences as columns.
  const text = fit(cell.text, column.maxWidth - 1); // the mark takes one column
  return `${cell.mark}${cell.highlight ? underline(text) : text}`;
}

export function buildRow(cells, columns) {
  return cells.map((cell, i) => renderCell(cell, columns[i]));
}

function columnWidths(table, columns) {
  return columns.map((_, col) => Math.max(...table.map((row) => strWidth(row[col]))));
}

function formatRow(row, widths) {
  return row
    .map((cell, i) => padEndDisplay(cell, widths[i]))
    .join("  ")
    .trimEnd();
}

export function printTable(rows, columns) {
  const header = columns.map((c) => c.header);
  const table = [header, ...rows];
  const widths = columnWidths(table, columns);

  for (const row of table) {
    console.log(formatRow(row, widths));
  }
}

// selectWithFzf lets the user pick a row in fzf and returns the id (via getId) of its item,
// or undefined if aborted. previewCmd is a shell command where {1} expands to the item's id.
export function selectWithFzf(items, rows, columns, getId, { previewCmd } = {}) {
  const widths = columnWidths(rows, columns);
  // Prepend the id as a column hidden by --with-nth, so it survives in fzf's output.
  const lines = items.map((item, i) => `${getId(item)}\t${formatRow(rows[i], widths)}`).join("\n");

  const fzfArgs = ["--ansi", "--delimiter", "\t", "--with-nth", "2.."];
  if (previewCmd) {
    fzfArgs.push("--preview-window", "bottom:nowrap");
    fzfArgs.push("--preview", previewCmd);
  }

  const result = spawnSync("fzf", fzfArgs, {
    input: lines,
    encoding: "utf8",
    stdio: ["pipe", "pipe", "inherit"],
  });

  const selected = result.stdout;
  if (!selected || !selected.trim()) return undefined;

  return selected.split("\t")[0];
}
