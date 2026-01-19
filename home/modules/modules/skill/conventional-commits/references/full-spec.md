# Conventional Commits 1.0.0

## Summary

The Conventional Commits specification is a lightweight convention
on top of commit messages. It provides rules for creating explicit
commit histories that support automated tooling.

This convention aligns with [SemVer](https://semver.org) by
describing features, fixes, and breaking changes in commit messages.

## Message Structure

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Commit Types

1. **fix:** Patches a bug in your codebase (PATCH in SemVer)
2. **feat:** Introduces a new feature (MINOR in SemVer)
3. **BREAKING CHANGE:** Breaking API change (MAJOR in SemVer)
4. Other allowed types: `build`, `chore`, `ci`, `docs`, `perf`,
   `refactor`, `revert`, `style`, `test`

## Examples

### Breaking change with footer

```text
feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` key in config file is now used
for extending other config files
```

### Breaking change with `!`

```text
feat!: send an email to the customer when a product is shipped
```

### Scope and breaking change

```text
feat(api)!: send an email to the customer when product is shipped
```

### Both `!` and footer

```text
chore!: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.
```

### No body

```text
docs: correct spelling of CHANGELOG
```

### With scope

```text
feat(lang): add Polish language
```

### Multi-paragraph with footers

```text
fix: prevent racing of requests

Introduce a request id and a reference to latest request.
Dismiss incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing
issue but are obsolete now.

Reviewed-by: Z
Refs: #123
```

## Specification Rules

1. Commits MUST be prefixed with a type, which consists of a
   noun, `feat`, `fix`, etc., followed by the OPTIONAL scope,
   OPTIONAL `!`, and REQUIRED terminal colon and space.

2. The type `feat` MUST be used when a commit adds a new
   feature to your application or library.

3. The type `fix` MUST be used when a commit represents a
   bug fix for your application.

4. A scope MAY be provided after a type. A scope MUST
   consist of a noun describing a section of the codebase
   surrounded by parenthesis, e.g., `fix(parser):`

5. A description MUST immediately follow the colon and space
   after the type/scope prefix. The description is a short
   summary of the code changes.

6. A longer commit body MAY be provided after the short
   description, providing additional contextual information
   about the code changes. The body MUST begin one blank line
   after the description.

7. A commit body is free-form and MAY consist of any number
   of newline separated paragraphs.

8. One or more footers MAY be provided one blank line after
   the body. Each footer MUST consist of a word token,
   followed by either a `:<space>` or `<space>#` separator,
   followed by a string value.

9. A footer's token MUST use `-` in place of whitespace
   characters, e.g., `Acked-by` (to differentiate the
   footer section from a multi-paragraph body). An exception
   is made for `BREAKING CHANGE`, which MAY also be used
   as a token.

10. A footer's value MAY contain spaces and newlines, and
    parsing MUST terminate when the next valid footer
    token/separator pair is observed.

11. Breaking changes MUST be indicated in the type/scope
    prefix of a commit, or as an entry in the footer.

12. If included as a footer, a breaking change MUST consist
    of the uppercase text BREAKING CHANGE, followed by a
    colon, space, and description.

13. If included in the type/scope prefix, breaking changes
    MUST be indicated by a `!` immediately before the `:`.
    If `!` is used, `BREAKING CHANGE:` MAY be omitted from
    the footer section, and the commit description SHALL be
    used to describe the breaking change.

14. Types other than `feat` and `fix` MAY be used in your
    commit messages, e.g., _docs: update ref docs._

15. The units of information that make up Conventional
    Commits MUST NOT be treated as case sensitive by
    implementors, with the exception of BREAKING CHANGE
    which MUST be uppercase.

16. BREAKING-CHANGE MUST be synonymous with BREAKING CHANGE,
    when used as a token in a footer.

## Benefits

- Automatically generating CHANGELOGs
- Automatically determining a semantic version bump based
  on the types of commits landed
- Communicating the nature of changes to teammates, the
  public, and other stakeholders
- Triggering build and publish processes
- Making it easier for people to contribute to your
  projects, by allowing them to explore a more structured
  commit history

## Frequently Asked Questions

### Development phase commits

Proceed as if you've already released the product. Typically
_somebody_ is using your software. They'll want to know what's
fixed, what breaks, etc.

### Uppercase or lowercase types?

Any casing may be used, but it's best to be consistent.

### Multiple commit types

Go back and make multiple commits whenever possible. Part of
the benefit of Conventional Commits is its ability to drive
us to make more organized commits and PRs.

### Rapid development and iteration

It discourages moving fast in a disorganized way. It helps
you be able to move fast long term across multiple projects
with varied contributors.

### Limiting commit types

Conventional Commits encourages us to make more of certain
types of commits such as fixes. The flexibility of
Conventional Commits allows your team to come up with their
own types and change those types over time.

### Relationship with SemVer

- `fix` type commits → `PATCH` releases
- `feat` type commits → `MINOR` releases
- `BREAKING CHANGE` → `MAJOR` releases

### Versioning extensions

Use SemVer to release your own extensions to this
specification (e.g., `@org/conventional-commit-spec`).

### Wrong commit type

Prior to merging or releasing, use `git rebase -i` to edit
the commit history. After release, the cleanup will be
different according to what tools and processes you use.

### Contributor adoption

No! If you use a squash based workflow on Git, lead
maintainers can clean up the commit messages as they're
merged—adding no workload to casual committers.

### Revert commits

Reverting code can be complicated: are you reverting
multiple commits? if you revert a feature, should the next
release instead be a patch?

One recommendation is to use the `revert` type, and a footer
that references the commit SHAs that are being reverted:

```text
revert: let us never again speak of the noodle incident

Refs: 676104e, a215868
```

## References

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Git Trailer Format](https://git-scm.com/docs/git-interpret-trailers)
- [Angular Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md)
