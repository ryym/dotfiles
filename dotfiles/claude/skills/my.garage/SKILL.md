---
name: my.garage
description: Carry out the user's instruction and place the resulting artifact (a markdown document by default, or a script/file when asked) into the .local/garage directory. Use when invoked as /my.garage, or when the user says to do something and stash the result under .local/garage.
---

# my.garage

## Purpose

Shorthand for "do this, then put the result into `.local/garage`".
For example, understand an instruction like "/my.garage Research X" as
"Research X and summarize it into a document under `.local/garage`".

## Workflow

1. **Do the work the instruction asks for.** Research, plan, design, write code,
   etc. Use whatever tools are needed. This is the real task — the file is just
   where the result lands.
2. **Pick the artifact type from the instruction:**
   - Research / investigation / planning / design / explanation
     → a **markdown document** (`.md`).
   - "Write a script", "generate a config", "make a data file", etc.
     → the file type that fits the artifact (script, JSON, etc.).
3. **Write the result into `.local/garage/`.** Create the directory if it does not exist.
4. **Report the created file path(s).**

## Rules

- Always save under `.local/garage/` (relative to the current working directory).
- Derive a concise English kebab-case file name from the content
  (e.g. `auth-flow-research.md`, `cleanup-old-logs.sh`).
- Fro documents, follow the `Markdown Style Guide` below.
- For scripts, no need to do `chmod +x`.
- The substance must equal what the long-form instruction would have produced;
  `/my.garage` only shortens _how_ the request is phrased, not the quality of
  the result.

## Examples

- `/my.garage Research how our zsh prompt shows git divergence` → investigate,
  then write `.local/garage/zsh-prompt-git-divergence.md`.
- `/my.garage Plan the migration to the new config format` → produce a planning
  document at `.local/garage/config-format-migration-plan.md`.
- `/my.garage Write a script to prune .local/garage files older than 30 days` →
  write `.local/garage/prune-garage.sh`.

## Markdown Style Guide

Always insert a blank line before and after a table so that Prettier can format it correctly.

Good:

```markdown
columns:

| Column | Type       |
| ------ | ---------- |
| id     | integer PK |
| foo_id | integer FK |

Using this columns, we can ...
```

Bad:

```markdown
columns:
| Column | Type |
| ------ | ---------- |
| id | integer PK |
| foo_id | integer FK |
Using this columns, we can ...
```
