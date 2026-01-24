---
name: conventional-commits
description: |
  Format commit messages following Conventional Commits 1.0.0 specification.
  Ensures consistent, semantic commit messages that support automated
  changelog generation and semantic versioning. Includes jujutsu and git
  examples with jujutsu-first approach for best practices.
license: MIT
---

# Conventional Commits

Format all commit messages according to the Conventional Commits 1.0.0
specification at <https://www.conventionalcommits.org/>

Ensures consistent, semantic commit messages that support automated
changelog generation and semantic versioning.

## Commit Message Format

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Type Reference

| Type             | When to Use                          | SemVer |
| ---------------- | ------------------------------------ | ------ |
| ✨ feat          | New feature                          | MINOR  |
| 🐛 fix           | Bug fix                              | PATCH  |
| 📝 docs          | Documentation only                   | -      |
| 🎨 style         | Formatting, whitespace (no code)    | -      |
| ♻️ refactor      | Code restructuring (no feature/fix) | -      |
| ⚡️ perf         | Performance improvement              | -      |
| ✅ test          | Adding/fixing tests                  | -      |
| 🏗️ build         | Build system, dependencies           | -      |
| 👷 ci            | CI/CD configuration                  | -      |
| 🧑‍💻 chore        | Maintenance, tooling                 | -      |
| ⏮️ revert        | Reverting previous commit            | -      |

## Decision Framework

When determining commit type, ask:

- New functionality? → `feat`
- Bug fix? → `fix`
- Documentation only? → `docs`
- Performance improvement? → `perf`
- Code restructuring without behavior change? → `refactor`
- Code style/formatting only? → `style`
- Tests added/modified? → `test`
- Build system or dependencies changed? → `build`
- CI/CD configuration changed? → `ci`
- Maintenance or tooling? → `chore`

## Message Best Practices

### Description (first line)

- Keep under 50 characters
- Use imperative mood ("add" not "added")
- Don't capitalize first letter
- No period at end

### Scope

Use clear, consistent names: `feat(auth):`, `fix(api):`,
`docs(readme):`

### Body

- Include when change requires explanation
- Explain why the change was made
- Describe what problem it solves
- Wrap at 72 characters per line

### Footers

- `Fixes #123` - Reference issues
- `Co-authored-by: Name <email>` - Credit contributors
- `BREAKING CHANGE: description` - Breaking changes
- `Refs: #456, #789` - Related issues

## Breaking Changes

Indicate breaking changes using either method:

```text
feat!: remove deprecated API endpoint

feat(api)!: change authentication flow

fix: update validation logic

BREAKING CHANGE: validation now rejects empty strings
```

## Command Execution

### Using Jujutsu (Recommended)

```zsh
jj describe -m 'feat(auth): add OAuth2 support'
```

For multi-line messages:

```zsh
jj describe << 'EOF'
feat(auth): add OAuth2 support

Implement OAuth2 authentication flow with support for
Google and GitHub providers.

BREAKING CHANGE: removes legacy session-based auth
EOF
```

### Using Git (Alternative)

Use single quotes to avoid shell escaping with `!`:

```bash
# Correct - single quotes
git commit -m 'feat!: add new authentication flow'

# Incorrect - DO NOT USE
git commit -m "feat\!: add new authentication flow"
```

For multi-line messages, use HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
feat(auth): add OAuth2 support

Implement OAuth2 authentication flow with support for
Google and GitHub providers.

BREAKING CHANGE: removes legacy session-based auth
EOF
)"
```

## Workflow

### Using Jujutsu (Recommended)

1. Make your code changes
2. Run `jj status` to see what changed
3. Determine type using decision framework
4. Use `jj describe` to set commit message
5. Run `jj show @ --no-patch` to verify

```zsh
# Check changes
jj diff

# Set message
jj describe -m 'feat(api): add rate limiting to endpoints'

# Verify
jj show @ --no-patch
```

### Using Git (Alternative)

1. Stage changes: `git add` first if nothing staged
2. Review changes: `git diff --cached`
3. Check recent style: `git log --oneline -5`
4. Determine type using decision framework
5. Execute commit with single quotes
6. Verify: `git log -1`

```bash
# Check for staged changes
git diff --cached --stat

# If nothing staged, stage first
git add .

# Review changes
git diff --cached

# Check recent style
git log --oneline -5

# Commit
git commit -m 'feat(api): add rate limiting to endpoints'

# Verify
git log -1
```

## Quality Checks

Before committing, verify:

- [ ] Message accurately describes the changes
- [ ] Type correctly categorizes the change
- [ ] Scope (if used) is meaningful and consistent
- [ ] Breaking changes are properly marked with `!` or footer
- [ ] Description is clear and under 50 characters
- [ ] Body wraps at 72 characters (if present)

## Examples

**Simple fix:**

```text
fix: prevent null pointer in user lookup
```

**Feature with scope:**

```text
feat(api): add rate limiting to endpoints
```

**With body:**

```text
refactor: extract validation into separate module

Move validation logic from controllers to dedicated
validator classes for better testability and reuse.
```

**Breaking change:**

```text
feat!: upgrade to v2 API format

BREAKING CHANGE: response structure changed from
{data: [...]} to {items: [...], meta: {...}}
```

**With issue reference:**

```text
fix(auth): resolve token refresh race condition

Fixes #234
```

## Full Specification

For complete specification details, see `references/full-spec.md`.

For practical patterns and common workflows, see
`references/common-patterns.md`.
