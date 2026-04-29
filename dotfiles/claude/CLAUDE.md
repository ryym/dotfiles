# Working Guidelines

## Communication

- **Distinguish questions from instructions.** When the user is asking about reasoning or intent behind a decision, explain the rationale. Do not treat questions as implicit requests to change code. Only modify code when the user explicitly asks for a change.
- **Push back when appropriate.** If the user's instructions contain contradictions, seem likely to break things, or ignore trade-offs, point that out clearly before proceeding. Do not silently comply.
- **Do not be a yes-man.** Agreeing with everything is not helpful — it is harmful. If the current approach is better than what the user suggested, say so and explain why. If the user still insists after hearing the reasoning, then follow the instruction.

## Temporary Files

Unless otherwise specified, store temporary files like oneshot scripts, memo for yourself, etc, in the `.local` directory.
The `.local` directory is excluded from Git so you don't need to commit it.

## Documentation

When you write documents, store them in the `.local/claude` directory.
For example, you create a markdown document when instructed to investigate something and summarize results.
A file name should be English in kebab-case like `.local/claude/research-result-of-something.md`.

### Markdown Styles

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

## Git Usage

### Commit Granularity

Commit changes in appropriate, focused chunks. Avoid large commits that mix multiple concerns.
If your commit message contains several sentences like "Create User model and add login page",
it is a sign that your commit is too big.
In this case, you should separate it into 2 commits like "Create User model" and "Add login page".

Each commit should:

- Have a single responsibility
- Be reviewable on its own
- Have a clear commit message explaining the changes

Also, all tests should pass at each commit. Do NOT commit incomplete work.

### Commit Messages

Default format:

- Language: English
- Title: Concisely describe what was done in the present tense
- Body: Include decision-making context and complex implementation details that aren't obvious from the code diff

But prioritize the format and rules in the repository you are working on.

### Fixing up Commits

If you create a commit that should have been done in any previous commits, commit it with `--fixup` or `--fixup=ammend`.
Human will clean up commits before push.

### Bash Usage

Never use command substitutions like `$(cat <<'EOF'...)` or backticks on Git operation.
Specify commit messages with simple strings like `git commit -m "..."`.

## Shell Script Rules

Follow these rules as much as possible when using Bash to avoid requiring additional human approval.

- Avoid accessing outside of the current directory.
  - For example, you can just create temporary files in `.local` instead of `/tmp`.
- Avoid using absolute paths for the current directory.
  - When you take actions inside the current directory, use a relative path like `path/to/file` instead of `/Users/bob/home/repo/path/to/file`.
- Avoid using `cd` as it will confuse yourself.
- Avoid chaining commands like `ls foo; echo "---"; ls bar` or `git add foo && git commit` unless you want to run commands conditionally.
  Otherwise, just run each command separately.
- Avoid running `echo "---"` which triggers human approval as a false positive of quoted flag name.

## Misc

### English by default

Regardless of the language used in a session, use English for development like below:

- Code comment
- Git commit messages

Exceptions:

- If the language is explicitly specified, use it.
- If existing code base or commits doesn't use English, use the same language with them.
