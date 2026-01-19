# Common Conventional Commits Patterns

This file provides practical patterns, troubleshooting tips, and
common workflows for using Conventional Commits with both Jujutsu
and Git.

## Practical Patterns

### Breaking Changes

Breaking changes are API changes that require consumers to update
their code. Always mark them clearly.

#### Method 1: Breaking change marker in type

**Jujutsu:**

```zsh
jj describe -m 'feat(api)!: change response structure

Response format changed from {data: [...]} to {items: [...], meta: {...}}'
```

**Git:**

```bash
git commit -m 'feat(api)!: change response structure

Response format changed from {data: [...]} to {items: [...], meta: {...}}'
```

#### Method 2: Breaking change footer

When you want to be explicit or have multiple footers:

**Jujutsu:**

```zsh
jj describe -m 'feat: upgrade to new API

Added support for OAuth2 authentication.

BREAKING CHANGE: session-based auth no longer supported
Fixes #123'
```

**Git:**

```bash
git commit -m 'feat: upgrade to new API

Added support for OAuth2 authentication.

BREAKING CHANGE: session-based auth no longer supported
Fixes #123'
```

### Reverting Commits

When you need to undo a previous commit:

**Jujutsu:**

```zsh
jj describe -m 'revert: remove experimental feature flag

Refs: abc123d, def456e'
```

**Git:**

```bash
git revert abc123d
git commit -m 'revert: remove experimental feature flag

Refs: abc123d, def456e'
```

### Multiple Scopes

If your change touches multiple areas:

**Jujutsu:**

```zsh
jj describe -m 'refactor(api,auth): consolidate authentication

Extract shared validation logic from API and auth modules
into dedicated validator service.'
```

**Git:**

```bash
git commit -m 'refactor(api,auth): consolidate authentication

Extract shared validation logic from API and auth modules
into dedicated validator service.'
```

### Co-authored Changes

When working with others:

**Jujutsu:**

```zsh
jj describe -m 'feat(ui): add dark mode toggle

Co-authored-by: Alice <alice@example.com>
Co-authored-by: Bob <bob@example.com>'
```

**Git:**

```bash
git commit -m 'feat(ui): add dark mode toggle

Co-authored-by: Alice <alice@example.com>
Co-authored-by: Bob <bob@example.com>'
```

### Complex Multi-Line Messages

For comprehensive descriptions:

**Jujutsu:**

```zsh
jj describe << 'EOF'
feat(database): implement connection pooling

Implement efficient connection pooling for PostgreSQL to
reduce latency and improve throughput.

Key improvements:
- Reuses idle connections
- Reduces connection overhead by 60%
- Automatically closes stale connections after 5 minutes
- Adds monitoring metrics

Performance impact:
- Query latency: -45%
- Connection time: -70%
- Memory usage: +15% (acceptable)

Fixes #456
EOF
```

**Git:**

```bash
git commit -m "$(cat <<'EOF'
feat(database): implement connection pooling

Implement efficient connection pooling for PostgreSQL to
reduce latency and improve throughput.

Key improvements:
- Reuses idle connections
- Reduces connection overhead by 60%
- Automatically closes stale connections after 5 minutes
- Adds monitoring metrics

Performance impact:
- Query latency: -45%
- Connection time: -70%
- Memory usage: +15% (acceptable)

Fixes #456
EOF
)"
```

## Scope Naming Conventions

Scopes should represent logical sections of your codebase. Here are
common patterns:

### By Module

```text
feat(auth): add two-factor authentication
fix(ui): resolve button alignment issue
docs(api): update rate limiting docs
```

### By Feature

```text
feat(search): add full-text search support
refactor(cache): extract cache layer
test(payments): add integration tests
```

### By Layer

```text
fix(frontend): resolve CSS specificity issue
fix(backend): fix race condition in worker
fix(database): optimize slow query
```

### By Domain

```text
feat(billing): add invoice generation
fix(notifications): resolve email delivery
perf(analytics): optimize event processing
```

**Best Practice**: Be consistent within your project. Document your
scope naming convention in CONTRIBUTING.md.

## Issue References

Different issue trackers require different formats:

### GitHub

```text
Fixes #123
Closes #123
Resolves #123
```

### GitLab

```text
Fixes #123
Closes #123
Resolves #123
```

### Jira

```text
PROJ-123: description
Fixes PROJ-123
```

### Multiple Issues

```text
fix: resolve user authentication issue

Fixes #123, #124
Related to #125
```

## Troubleshooting

### Problem: Forgot conventional format

**Solution with Jujutsu:**

```zsh
# View current message
jj show @ --no-patch

# Update it
jj describe -m 'feat(scope): properly formatted message'

# Verify
jj show @ --no-patch
```

**Solution with Git:**

```bash
# View current message
git log -1

# Update it (only if not pushed)
git commit --amend -m 'feat(scope): properly formatted message'

# Verify
git log -1
```

### Problem: Wrong commit type used

If you classified a commit as `fix` but it's actually a `refactor`:

**With Jujutsu:**

```zsh
jj show @ --no-patch
```

**With Git:**

```bash
# If not pushed yet
git commit --amend -m 'refactor(module): reorganize code structure'

# If already pushed, use revert + new commit
git revert HEAD
git commit -m 'refactor(module): reorganize code structure'
```

### Problem: Need to split one commit into multiple

You committed multiple logical changes that should be separate commits:

**With Jujutsu:**

Simple approach (creates parent-child commits):

```zsh
# Split: specified files go to first commit, rest to new child commit
jj split src/auth.ts src/validators.ts

# Describe first commit
jj describe -m 'feat(auth): add OAuth2 support' @-

# Describe second commit
jj describe -m 'feat(validation): add email validation' @
```

Alternative approach with `--parallel` (creates sibling commits):

```zsh
# Split: creates two sibling commits instead of parent-child
jj split --parallel src/auth.ts src/validators.ts

# Describe first commit
jj describe -m 'feat(auth): add OAuth2 support' @-

# Describe second commit
jj describe -m 'feat(validation): add email validation' @
```

**With Git:**

```bash
# Reset to before the commit
git reset HEAD~1

# Stage part 1, commit it
git add src/auth.ts src/validators.ts
git commit -m 'feat(auth): add OAuth2 support'

# Stage part 2, commit it
git add src/utils.ts
git commit -m 'feat(validation): add email validation'
```

### Problem: Commit message wraps incorrectly

Always wrap at 72 characters for body and footer text:

**Correct (47 chars):**

```text
feat(api): add feature that improves performance
```

**Incorrect (86 chars):**

```text
feat(api): add feature that does something really important to our system
```

Use a text editor that shows line length or configure your editor
for markdown line wrapping.

## Workflow Comparison: Jujutsu vs Git

### Change Made, Ready to Commit

| Step              | Jujutsu                         | Git                  |
| ----------------- | ------------------------------- | -------------------- |
| Check status      | `jj status`                     | `git status`         |
| Review changes    | `jj diff`                       | `git diff`           |
| Stage changes     | Automatic                       | `git add <files>`    |
| Commit            | `jj describe -m 'type(s): msg'` | `git commit -m ...`  |
| Verify            | `jj show @ --no-patch`              | `git log -1`         |

### Amend Last Commit

| Task                  | Jujutsu                        | Git                            |
| --------------------- | ------------------------------ | ------------------------------ |
| Update message        | `jj describe -m 'new message'` | `git commit --amend -m ...`    |
| Add forgotten file    | `jj squash`                    | `git add <file>; git amend`    |

## Best Practices Checklist

Before committing, verify:

- [ ] Type is one of: feat, fix, docs, style, refactor, perf,
      test, build, ci, chore, revert
- [ ] Type (and scope if used) is lowercase
- [ ] Scope is meaningful and project-consistent
- [ ] Description is under 50 characters
- [ ] Description uses imperative mood ("add" not "added")
- [ ] Breaking changes marked with `!` or BREAKING CHANGE footer
- [ ] Body wrapped at 72 characters (if present)
- [ ] Issue references accurate and correct format
- [ ] No period at end of description

## Emoji Reference

Many teams add optional emojis to commit messages for visual clarity:

| Type     | Emoji | Example                                        |
| -------- | ----- | ---------------------------------------------- |
| feat     | ✨    | `✨ feat(auth): add OAuth2 support`           |
| fix      | 🐛    | `🐛 fix(api): resolve race condition`         |
| docs     | 📝    | `📝 docs(readme): update installation`        |
| style    | 🎨    | `🎨 style(ui): improve button appearance`     |
| refactor | ♻️    | `♻️ refactor(parser): simplify logic`         |
| perf     | ⚡️    | `⚡️ perf(query): optimize database lookup`    |
| test     | ✅    | `✅ test(auth): add integration tests`        |
| build    | 🏗️    | `🏗️ build(deps): update dependencies`        |
| ci       | 👷    | `👷 ci(github): add linting workflow`         |
| chore    | 🧑‍💻    | `🧑‍💻 chore(lint): configure eslint`         |
| revert   | ⏮️    | `⏮️ revert: remove experimental feature`      |

**Note**: Emojis are optional and should be consistent if used.
