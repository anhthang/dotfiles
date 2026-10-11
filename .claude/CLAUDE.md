# Personal instructions (all projects)

## Git

- Always write commit messages in Conventional Commits format: `<type>(<scope>): <summary>`, with an imperative, lowercase summary and no trailing period. Mark breaking changes with `!` or a `BREAKING CHANGE:` footer. Use the same format for pull request titles.
- Never squash, fixup, or otherwise combine commits on your own. Rewrite history (squash, amend into an earlier commit, interactive-style rebases) only when I ask for it.
- Once a pull request is open for a branch, never push to that branch on your own, including force pushes. Commit locally, tell me the branch is ahead (or has diverged, after a history rewrite I asked for), and push only when I say so.
