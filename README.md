# dotfiles

My macOS dotfiles, managed as a regular Git repository and linked into `$HOME` with [GNU Stow](https://www.gnu.org/software/stow/).

Because the repo lives in its own folder, you can open it in VS Code (or any IDE) and review diffs without seeing the rest of your home directory.

## Layout

```
dotfiles/
├── home/          # mirrors $HOME — every file here is symlinked into ~
│   ├── .zshrc
│   ├── .gitconfig
│   ├── .yabairc
│   ├── .Brewfile  # Homebrew packages (brew bundle --global)
│   ├── .claude/CLAUDE.md
│   └── .config/   # bat, fastfetch, ghostty, starship
├── install.sh     # bootstrap a new machine
└── com.googlecode.iterm2.plist
```

Only `home/` is stowed. Everything else stays in the repo.

## Set up a new machine

```bash
git clone git@github.com:anhthang/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` installs Homebrew, Oh My Zsh and its plugins, Bun, the packages in `home/.Brewfile` (including `stow`), and then links `home/` into `$HOME`.

If a real file already exists where a symlink should go, Stow refuses to overwrite it. Either remove that file, or adopt it into the repo and review the difference:

```bash
stow --dir ~/dotfiles --target ~ --no-folding --adopt home
git -C ~/dotfiles diff
```

## Daily use

Edit files either in the repo or through the symlinks in `~` (they point to the same file), then commit from the repo:

```bash
cd ~/dotfiles   # or: dotfiles status
git status
git commit -am "feat(zsh): add alias"
git push
```

### Update Homebrew packages

`~/.Brewfile` is the global Brewfile, so `brew bundle` works from any directory with `--global`:

```bash
brew bundle --global                 # install everything listed
brew bundle dump --global --force    # save what's installed now
```

### Track a new file

Move it into `home/` at the same relative path, then restow:

```bash
mkdir -p home/.config/foo
mv ~/.config/foo/config home/.config/foo/config
stow --dir ~/dotfiles --target ~ --no-folding --restow home
```

`--no-folding` makes Stow link individual files instead of whole directories, so apps can still write their own files into `~/.config/...` without them ending up in the repo.
