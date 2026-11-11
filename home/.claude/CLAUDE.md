# Personal instructions (all projects)

## Git

- Always write commit messages in Conventional Commits format: `<type>(<scope>): <summary>`, with an imperative, lowercase summary and no trailing period. Mark breaking changes with `!` or a `BREAKING CHANGE:` footer. Use the same format for pull request titles.
- Never squash, fixup, or otherwise combine commits on your own. Rewrite history (squash, amend into an earlier commit, interactive-style rebases) only when I ask for it.
- When I ask you to commit, put small fixes straight on the current branch (even `main`), without creating a new branch. Work that follows a specific plan or touches many places gets its own new branch so it can be followed and later opened as a pull request. If it's unclear which case applies, ask.
- Commit pending dependency and lockfile updates (e.g. `package.json` version bumps, `bun.lock`, `package-lock.json`) together with the rest of the change, without mentioning them in the commit message, pull request title, or pull request body, and never split them into their own commit. Mention them only when an update has breaking changes, or when I make a separate commit for them myself.
- Once a pull request is open for a branch, never push to that branch on your own, including force pushes. Commit locally, tell me the branch is ahead (or has diverged, after a history rewrite I asked for), and push only when I say so.
- Generate `.gitignore` with gitignore.io (`https://www.toptal.com/developers/gitignore/api/<templates>`), keeping its output unedited between the `# Created by` and `# End of` lines. Always include `macos`, `windows` and `linux`, plus the templates for the project's stack (e.g. `node`). Put project-specific entries in a commented section below the generated block, and regenerate with the same template list when one is added.

## Agent instructions

- Write project instructions for AI agents in the repository's `AGENTS.md`, the single source of truth shared by every tool. Tool-specific files (`CLAUDE.md`, `.github/copilot-instructions.md`, Cursor rules, and similar) only point to it and hold what is specific to that tool.
- A pointer file is never a bare `@AGENTS.md` line: it says in a sentence that the shared instructions live in `AGENTS.md` and how this tool loads them (e.g. Claude Code imports them with `@AGENTS.md`, Copilot is told to follow them), then lists only that tool's specifics.
- Run search and lookup subagents (Explore, or a general-purpose agent that only finds code or answers a factual question) on `model: "haiku"`. Keep the session's model for subagents that review, design, or write code.

## Markdown

- I lint Markdown with markdownlint. Keep the files you write or reformat free of its warnings, following the project's markdownlint config when it has one; in particular, indent nested list items by 2 spaces (MD007/ul-indent). `npx markdownlint-cli2 <files>` checks them.
- Prettier indents nested lists by its `tabWidth`, so where a project's Prettier config sets 4, give `*.md` a `tabWidth: 2` override rather than fixing the indentation by hand after each run.

## Supabase

- Use the Supabase skills and MCP server for reading only: listing projects, tables, migrations, extensions, and branches, reading logs and advisors, searching the docs, generating types, and `select` queries.
- Never write through them, even when asked in passing: no `apply_migration`, no `execute_sql` that changes data or schema (`insert`, `update`, `delete`, DDL, grants), no edge function deploys, no branch create/merge/rebase/reset/delete, and no project create/pause/restore. Write schema changes as migration files for me to review and run myself.
