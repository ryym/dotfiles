---
name: my.pr-create
description: Create a GitHub pull request via `gh pr create` using the repository's PR template.
allowed-tools: Bash(gh pr create --draft --assignee @me --body-file .local/pr.md --title *), Bash(gh pr view --web *)
---

# my.pr-create

Create a pull request for the current branch using the `gh` CLI.

## Local Rules

Before starting any steps, always check if `.local/rules/pull-requests.md` exists first.
If it exists, read it and follow the instructions there too. Local rules always take precedence over rules in this skill.
If local rules conflict with instructions in this skill file, follow the local rules.

## Steps

1. If the branch has no upstream yet or it is not synced with the upstream, ask the user to push it. Do not push by yourself.
2. Determine the base branch for the pull request.
   - If the user explicitly specified the base branch, use it.
   - Otherwise, use the default branch of the repository.
     get by `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`.
3. Understand the full set of changes against the base branch using `git log`, `git diff`, etc.
   - If the working tree has uncommitted changes that look like they belong in the PR,
     ask the user about it before creating the PR.
4. Read `.github/pull_request_template.md` if it exists, to get the exact template structure.
   Some repos place it under `docs/` or `.github/PULL_REQUEST_TEMPLATE/`; check those too if the main path is missing.
5. Draft the PR title and body:
   - **Title:** short (under ~70 chars), present tense, English.
   - **Body:** follow the `How to write good PR Body` section below.
   - Do not forget to prioritize `.local/rules/pull-requests.md` if it exists.
6. For each sentence in the body, ask yourself: "Could a reviewer know this just by seeing the diff?"
   If yes, cut that sentence.
7. Ask the user for review by:
   1. Save the drafted body in `.local/pr.md`.
   2. Print the drafted title.
   3. Print the content of `.local/pr.md` as rendered markdown directly (not inside a code block).
   4. Wait for their approval before proceeding. If they ask for changes, revise and show it again until approved.
8. Create the PR with `gh pr create`. Use the following command:
   ```bash
   gh pr create --draft --assignee @me --body-file .local/pr.md --title "<title>"
   ```
9. Open the created PR in a browser by `gh pr view --web <url>`.
10. Remove `.local/pr.md`.
11. Return the PR URL to the user.

## How to write good PR Body

### Principles

- Write in English.
- Follow the template. If no template exists, use an arbitrary format to summarize what the PR does.
- BE CONCISE AND ABSTRACT
  - Never restate code changes one by one even if the PR template seems to require it.
    Instead, BRIEFLY summarize which portions were modified, grouping them by purpose.
  - Focus on "where" changed and "why". Avoid describing "how" they changed (that should be understood through diffs).

### Techniques

- Avoid long run-on sentences that cram multiple points together. Instead,
  use bullets effectively to break down similar changes in a structured and human-friendly format.
