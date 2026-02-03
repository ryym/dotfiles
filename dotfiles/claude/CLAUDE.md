# Working Guidelines

## Communication

If the instructions contain contradictions or you believe they won't work as directed, please clearly point out these issues.

## Temporary Files

Unless otherwise specified, store temporary files like oneshot scripts, memo for yourself, etc, in the `.local/tmp` directory.
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

- Title: Concisely describe what was done
- Body: Include decision-making context and complex implementation details that aren't obvious from the code diff
- Language: English
