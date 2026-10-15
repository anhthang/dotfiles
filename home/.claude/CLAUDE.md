# Personal instructions (all projects)

## Git

- Always write commit messages in Conventional Commits format: `<type>(<scope>): <summary>`, with an imperative, lowercase summary and no trailing period. Mark breaking changes with `!` or a `BREAKING CHANGE:` footer. Use the same format for pull request titles.
- Never squash, fixup, or otherwise combine commits on your own. Rewrite history (squash, amend into an earlier commit, interactive-style rebases) only when I ask for it.
- When I ask you to commit, put small fixes straight on the current branch (even `main`), without creating a new branch. Work that follows a specific plan or touches many places gets its own new branch so it can be followed and later opened as a pull request. If it's unclear which case applies, ask.
- Commit pending dependency and lockfile updates (e.g. `package.json` version bumps, `bun.lock`, `package-lock.json`) together with the rest of the change, without mentioning them in the commit message, pull request title, or pull request body, and never split them into their own commit. Mention them only when an update has breaking changes, or when I make a separate commit for them myself.
- Once a pull request is open for a branch, never push to that branch on your own, including force pushes. Commit locally, tell me the branch is ahead (or has diverged, after a history rewrite I asked for), and push only when I say so.

## Agent instructions

- Write project instructions for AI agents in the repository's `AGENTS.md`, the single source of truth shared by every tool. Tool-specific files (`CLAUDE.md`, `.github/copilot-instructions.md`, Cursor rules, and similar) only point to it and hold what is specific to that tool.
- A pointer file is never a bare `@AGENTS.md` line: it says in a sentence that the shared instructions live in `AGENTS.md` and how this tool loads them (e.g. Claude Code imports them with `@AGENTS.md`, Copilot is told to follow them), then lists only that tool's specifics.
