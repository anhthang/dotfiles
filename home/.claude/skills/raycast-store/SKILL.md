---
name: raycast-store
description: Publish a Raycast extension to the Raycast Store and pull store changes back with a linear git history. Use when publishing (`npm run publish`, `ray publish`), updating or cleaning up a store pull request in raycast/extensions, or running `ray pull-contributions`, in any of my Raycast extension repositories.
---

# Raycast Store: publish and pull

How I publish my Raycast extensions and bring store changes back without forking `main`. `<name>` is the extension's `name` in `package.json`. Each repository's `AGENTS.md` lists what is specific to it, above all the files its store pull request must not change: read it first.

Never run `npm run publish` or `npx ray pull-contributions` unless I ask, and never push to `main` or to the fork branch unless I ask.

## Order for each release

1. Pull first, before any fix, when the last store pull request was merged (raycastbot dated the changelog and optimized images when merging it) or someone else pushed to the open one: see "Pulling store changes". `ray pull-contributions` refuses to run with uncommitted changes, and pulling first brings the released changelog date into `main` before the new entry, so `CHANGELOG.md` doesn't conflict.
2. Fix, add the changelog entry with the `{PR_MERGE_DATE}` placeholder, and commit.
3. Push `main`.
4. Publish.
5. Clean the pull request up in the Ray CLI's clone (see "Publishing").

Code changes in several extensions can go on at once, one session per repository, but publish and pull one extension at a time: every extension shares the Ray CLI's clone, and each command switches it to its own branch. A command interrupted midway makes the next one ask whether to discard that attempt.

## Publishing

- `npm run publish` pushes the extension folder to the `ext/<name>` branch of my fork of [raycast/extensions](https://github.com/raycast/extensions). While a store pull request from that branch is open, a new publish adds a commit to it instead of opening another, and the pull request keeps its title and description.
- Publish only from a commit already on `origin/main`, so the tag below points into the real history: push first.
- Publishing sends the whole folder, so files the repository keeps differently from the store come back into the pull request every time (typically `AGENTS.md`, `CLAUDE.md`, a gitignore.io `.gitignore`, and the original icon and screenshots where the store keeps Raycast's optimized copies). After each publish, remove them with one commit on the fork branch, never by changing the repository. Make that commit in the Ray CLI's own clone, `~/.config/raycast/public-extensions-fork` (sparse, on `ext/<name>`, with `origin` the fork and `upstream` raycast/extensions), so the clone stays in step with the branch and the next publish doesn't ask for a pull. Its remote URLs carry a GitHub token: never print `git remote -v` or its config.

  ```bash
  git -C ~/.config/raycast/public-extensions-fork fetch upstream main --depth=1
  ```

  Then, in that clone, `git rm` the files the store doesn't have, restore the others with `git checkout upstream/main -- extensions/<name>/<file>`, commit (`chore(<name>): …`) and `git push origin ext/<name>`. Check the pull request's file list afterwards (`gh pr view <number> --repo raycast/extensions --json files`).

- Store pull request titles and descriptions follow my earlier ones: a Conventional Commits title scoped to the extension (`feat(<name>): …`), a description summing up the changelog entry in bold-led bullets, `## Screencast` and the checklist from the template.

## Pulling store changes

`npm run publish` stops and asks for `npx ray pull-contributions` in two cases:

- "some edits were made on your PR": the `ext/<name>` branch on the fork has commits the Ray CLI's clone doesn't (a raycastbot or reviewer commit, or a cleanup made in another clone).
- "some contributions are available": no store pull request is open, and the extension on raycast/extensions `main` changed since the last pull and differs from the last published commit (raycastbot dating the changelog and optimizing images when it merged the last one, a later fix by someone else).

The pull brings the Ray CLI's clone up to date, which is all those checks look at; it also marks it with the clone's tag `__raycast_latest_pull_ext/<name>__`. In the repository it then creates a `contributions/merge-<id>` branch from the local tag `__raycast_latest_publish_ext/<name>__` (the last published commit), commits the pulled copy over it as "Pull contributions" (only overwriting files, never deleting them) and merges that branch into the current one. Publishing doesn't need that merge, and keeping it forks the history and brings back whatever the store keeps differently, so:

1. Pull as usual, then undo the merge it makes:

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
