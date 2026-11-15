---
name: raycast-store
description: Publish a Raycast extension to the Raycast Store and pull store changes back with a linear git history. Use when publishing (`npm run publish`, `ray publish`), updating or cleaning up a store pull request in raycast/extensions, or running `ray pull-contributions`, in any of my Raycast extension repositories.
---

# Raycast Store: publish and pull

How I publish my Raycast extensions and bring store changes back without forking `main`. `<name>` is the extension's `name` in `package.json`. The rules here apply to every extension; a repository's `AGENTS.md` only adds what is specific to it (an exception to the store cleanup below, say): read it first.

Never run `npm run publish` or `npx ray pull-contributions` unless I ask, and never push to `main` unless I ask. Asking to publish includes the store cleanup after it, pushed to the fork branch without asking again.

## Before running the Ray CLI

- `npm run publish` and `npx ray pull-contributions` only work in a shell on my Mac where the Ray CLI is signed in to GitHub: `~/.config/raycast/config.json` holds its token (never print it), and `~/.config/raycast/public-extensions-fork` is its clone, which the first command on a machine creates. Check the token is set before running either; once I signed in, run them yourself. If a previous command was interrupted, the next one asks whether to discard that attempt, which needs a terminal: ask me to run it then. In a sandboxed, remote or cloud shell that can't reach them, don't try: ask me to run the command myself in a terminal on a machine where the Ray CLI is signed in, then carry on from its result.
- Never let the Ray CLI start its GitHub sign-in. The device login needs a real terminal (it crashes without one), and a sign-in it couldn't finish leaves the CLI without a token. If it isn't signed in, or a command fails with an authorization error or an HTTP 400 while "getting fork", stop and ask me to run `npx ray login` myself in a real terminal (not through your shell), once per machine.
- First time in a repository: when its `CLAUDE.md` doesn't point to this skill yet, add a line that does ("Publishing and pulling store changes: follow the maintainer's personal `raycast-store` skill"); `AGENTS.md` needs a "Publishing" section only for what differs from this skill. When it has no `__raycast_latest_publish_ext/<name>__` tag, the pull starts its branch from the repository's first commit, so the diff also shows everything since then: compare file by file, and set the tag on `main` afterwards.

## Order for each release

1. Pull first, before any fix, when the last store pull request was merged (raycastbot dated the changelog and optimized images when merging it) or someone else pushed to the open one: see "Pulling store changes". `ray pull-contributions` refuses to run with uncommitted changes, and pulling first brings the released changelog date into `main` before the new entry, so `CHANGELOG.md` doesn't conflict.
2. Fix, add the changelog entry with the `{PR_MERGE_DATE}` placeholder, and commit.
3. Push `main`.
4. Publish.
5. Clean the pull request up in the Ray CLI's clone, right away and unasked (see "Store cleanup").

Code changes in several extensions can go on at once, one session per repository, but publish and pull one extension at a time: every extension shares the Ray CLI's clone, and each command switches it to its own branch. A command interrupted midway makes the next one ask whether to discard that attempt.

## Publishing

- `npm run publish` pushes the extension folder to the `ext/<name>` branch of my fork of [raycast/extensions](https://github.com/raycast/extensions). While a store pull request from that branch is open, a new publish adds a commit to it instead of opening another, and the pull request keeps its title and description.
- Publish only from a commit already on `origin/main`, so the tag below points into the real history: push first.
- Before publishing, note the commit the tag `__raycast_latest_publish_ext/<name>__` points at (the last published one): publishing moves it to `HEAD`, and the store cleanup needs the old one.
- Store pull request titles and descriptions follow my earlier ones: a Conventional Commits title scoped to the extension (`feat(<name>): …`), a description summing up the changelog entry in bold-led bullets, `## Screencast` and the checklist from the template.

## Store cleanup

Publishing sends the whole folder, so every publish brings back files the repositories keep differently from the store. Right after each publish, without being asked, remove them from the pull request with one commit on `ext/<name>`, made in the Ray CLI's own clone, `~/.config/raycast/public-extensions-fork` (sparse, on `ext/<name>`, `origin` the fork, `upstream` raycast/extensions), so the clone stays in step with the branch and the next publish doesn't ask for a pull. Its remote URLs carry a GitHub token: never print `git remote -v` or its config.

```bash
git -C ~/.config/raycast/public-extensions-fork fetch upstream main --depth=1
```

Then, under `extensions/<name>/` in that clone:

- **Delete** what is only there for development and the store doesn't have: agent instructions (`AGENTS.md`, `CLAUDE.md`, `.claude/`, `.cursor/`, `.github/copilot-instructions.md`), the rest of `.github/`, and lockfiles other than `package-lock.json` (`bun.lock`).
- **Restore the store's copy** (`git checkout upstream/main -- <file>`) of `.gitignore` (the repositories keep a gitignore.io one, the store Raycast's default), and of every image under `assets/` and `metadata/` that the store already has and that didn't change in the repository since the last published commit (`git -C <repo> diff --quiet <last published commit> HEAD -- <file>`): the store keeps raycastbot's optimized copies, the repositories the originals. A changed or new image stays as published.
- Leave everything else, and keep any file the repository's `AGENTS.md` names as an exception.

Commit (`chore(<name>): keep the store's copies of files kept differently in the repository`), `git push origin ext/<name>`, and check the pull request's file list (`gh pr view <number> --repo raycast/extensions --json files`): it should hold only real changes. Never change the repository for this.

## Pulling store changes

`npm run publish` stops and asks for `npx ray pull-contributions` in two cases:

- "some edits were made on your PR": the `ext/<name>` branch on the fork has commits the Ray CLI's clone doesn't (a raycastbot or reviewer commit, or a cleanup made in another clone).
- "some contributions are available": no store pull request is open, and the extension on raycast/extensions `main` changed since the last pull and differs from the last published commit (raycastbot dating the changelog and optimizing images when it merged the last one, a later fix by someone else).

The pull brings the Ray CLI's clone up to date, which is all those checks look at; it also marks it with the clone's tag `__raycast_latest_pull_ext/<name>__`. In the repository it then creates a `contributions/merge-<id>` branch from the local tag `__raycast_latest_publish_ext/<name>__` (the last published commit), commits the pulled copy over it as "Pull contributions" (only overwriting files, never deleting them) and merges that branch into the current one. Publishing doesn't need that merge, and keeping it forks the history and brings back whatever the store keeps differently, so:

1. Pull as usual, then undo the merge it makes. When I ran the pull myself, start here with the undo, before anything else moves `ORIG_HEAD`:

   ```bash
   npx ray pull-contributions
   ```

   If the merge stopped on conflicts, abort it:

   ```bash
   git merge --abort
   ```

   If it went through (a fast-forward or a merge commit), drop it:

   ```bash
   git reset --hard ORIG_HEAD
   ```

2. See where the store differs from `main`, leaving out the lockfile and the images:

   ```bash
   git diff HEAD contributions/merge-<id> -- . ':!package-lock.json' ':!*.png'
   ```

   Files the repository deleted but the store still has show up as added: skip them, along with the files the repository keeps differently. Look only for real changes, such as the changelog date or a reviewer's fix.

3. Take only the files worth keeping, for example the changelog, and commit them as a normal Conventional Commits commit (`docs(changelog): …`):

   ```bash
   git checkout contributions/merge-<id> -- CHANGELOG.md
   ```

4. Delete the temporary branch:

   ```bash
   git branch -D contributions/merge-<id>
   ```

5. Point the tag at `main`'s published commit if it points anywhere else (a dropped merge, for example), or the next pull branches from there again:

   ```bash
   git tag -f -a __raycast_latest_publish_ext/<name>__ -m "Used by the Ray CLI to track the latest commit that was published" <commit>
   ```

The history stays linear, with at most one normal commit per pull, and none when the store changed nothing. If a pull's merge was already pushed, removing it needs a force push of `main`: only when I ask.
