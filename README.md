# dotfiles

Cross-platform (macOS + Linux) configuration for my shell and CLI tools.
Managed with [GNU Stow](https://www.gnu.org/software/stow/) — configs live here
and are symlinked into place, so editing a file in this repo _is_ editing the
live config.

## What's included

| Area        | Files                                                       |
| ----------- | ----------------------------------------------------------- |
| **Shell**   | `home/.zshrc`, `home/.bashrc`, `home/.bash_profile`         |
| **Neovim**  | `config/nvim/` (kickstart-based, ~20 plugins via lazy.nvim) |
| **Ghostty** | `config/ghostty/` (terminal)                                |
| **Zellij**  | `config/zellij/` (terminal multiplexer)                     |
| **Lazygit** | `config/lazygit/` (git TUI)                                 |

The `.zshrc` is OS-aware: it auto-detects the Homebrew path and only defines the
`pbcopy`/`pbpaste` xclip aliases on Linux (macOS provides them natively).

## Structure

```
dotfiles/
├── Brewfile          # cross-platform CLI tools
├── install.sh        # Homebrew + zsh plugins + stow symlinks
├── home/             # → symlinked into ~
└── config/           # → symlinked into ~/.config
```

---

## Install on a new machine

### 1. Prerequisites

#### macOS

```bash
xcode-select --install            # Command Line Tools (git, compiler)
brew install --cask ghostty       # terminal (configured in config/ghostty/)
brew install node                 # required by Neovim/Mason language servers
curl -fsSL https://bun.sh/install | bash   # bun → installs to ~/.bun (on PATH in .zshrc)
```

> `pbcopy`/`pbpaste` are built in on macOS — no extra clipboard tool needed.

#### Fedora/Linux

```bash
sudo dnf install -y git curl nodejs xclip ghostty
curl -fsSL https://bun.sh/install | bash   # bun → installs to ~/.bun (on PATH in .zshrc)
```

> `xclip` backs the `pbcopy`/`pbpaste` aliases in `.zshrc` (native on macOS).
> `nodejs` is required by Neovim/Mason. If `ghostty` isn't in your repos yet,
> see [ghostty.org](https://ghostty.org) for install options.

### 2. Clone and run the installer

```bash
git clone https://github.com/Kittease/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` is idempotent and will:

1. Install **Homebrew** (if missing) and resolve its path for this OS/arch.
2. Install the CLI tools from the **Brewfile** (`brew bundle`).
3. Install **oh-my-zsh** and clone the external zsh plugins.
4. **Stow** `home/` into `~` and `config/` into `~/.config`.

Then restart your shell: `exec zsh`.

---

## zsh plugins

The `.zshrc` loads these. Built-ins ship with oh-my-zsh (no install); the two
external ones are cloned automatically by `install.sh`.

- **Built-in:** `bun` · `colored-man-pages` · `command-not-found` · `eza` ·
  `fancy-ctrl-z` · `git` · `sudo` · `vi-mode` · `zoxide`
- **External (cloned):** `zsh-autosuggestions` · `zsh-syntax-highlighting`

> **macOS note:** the `command-not-found` plugin needs the Homebrew tap to work:
> `brew tap homebrew/command-not-found`. Harmless if skipped (it just stays quiet).

---

## Apps to install manually

GUI apps and fonts aren't managed by stow. Install per OS:

| App         | macOS                                               | Fedora                                                    |
| ----------- | --------------------------------------------------- | --------------------------------------------------------- |
| Zen Browser | `brew install --cask zen-browser`                   | `flatpak install flathub app.zen_browser.zen`             |
| Discord     | `brew install --cask discord`                       | `flatpak install flathub com.discordapp.Discord`          |
| Obsidian    | `brew install --cask obsidian`                      | `flatpak install flathub md.obsidian.Obsidian`            |
| Nerd Font   | `brew install --cask font-jetbrains-mono-nerd-font` | download from [nerdfonts.com](https://www.nerdfonts.com/) |

A Nerd Font is required for icons in Neovim and the prompt.

---

## AI CLI tooling

These are installed and authenticated separately (their configs hold secrets and
are **not** tracked here). Reinstall the CLI, then log in:

| Tool                   | Reinstall                                               | Authenticate            |
| ---------------------- | ------------------------------------------------------- | ----------------------- |
| **Claude Code**        | see [docs](https://docs.claude.com/en/docs/claude-code) | `claude` → follow login |
| **Codex**              | `brew install codex`                                    | `codex` → follow auth   |
| **Codeium / Windsurf** | install editor/CLI                                      | log in in-app           |

### Codeium ↔ Neovim (neocodeium)

AI completion in Neovim is provided by the
[`neocodeium`](https://github.com/monkoose/neocodeium) plugin
(`config/nvim/lua/plugins/neocodeium.lua`). After cloning the dotfiles:

1. Launch `nvim` — lazy.nvim auto-installs neocodeium (pinned in `lazy-lock.json`).
2. neocodeium auto-downloads its language-server binary into `~/.codeium/bin/`.
3. Authenticate from inside nvim: run **`:NeoCodeium auth`**, open the URL, and
   paste the token back. This writes `~/.codeium/config.json` (your API key —
   **never commit it**).
4. In insert mode, **`<Tab>`** accepts a suggestion (normal Tab otherwise).

---

## AI skills

Skills are installed separately from the dotfiles. Reinstall them with
`bunx skills add <source> --skill <name>`.

Most of these come from
[`mattpocock/skills`](https://github.com/mattpocock/skills); `find-skills` comes
from [`vercel-labs/skills`](https://github.com/vercel-labs/skills).

To reinstall the Matt Pocock collection interactively, run
`bunx skills add mattpocock/skills` and select the skills below.

| Skill                              | Source                       | Reinstall                                                        |
| ---------------------------------- | ---------------------------- | ---------------------------------------------------------------- |
| `caveman`                          | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill caveman`              |
| `design-an-interface`              | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill design-an-interface`  |
| `diagnose`                         | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill diagnose`             |
| `edit-article`                     | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill edit-article`         |
| `find-skills`                      | `vercel-labs/skills`         | `bunx skills add vercel-labs/skills --skill find-skills`         |
| `git-guardrails-claude-code`       | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill git-guardrails-claude-code` |
| `grill-me`                         | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill grill-me`             |
| `grill-with-docs`                  | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill grill-with-docs`      |
| `handoff`                          | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill handoff`              |
| `improve-codebase-architecture`    | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill improve-codebase-architecture` |
| `obsidian-vault`                   | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill obsidian-vault`       |
| `prototype`                        | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill prototype`            |
| `qa`                               | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill qa`                   |
| `request-refactor-plan`            | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill request-refactor-plan` |
| `review`                           | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill review`               |
| `scaffold-exercises`               | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill scaffold-exercises`   |
| `setup-matt-pocock-skills`         | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill setup-matt-pocock-skills` |
| `tdd`                              | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill tdd`                  |
| `teach`                            | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill teach`                |
| `to-issues`                        | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill to-issues`            |
| `to-prd`                           | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill to-prd`               |
| `triage`                           | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill triage`               |
| `ubiquitous-language`              | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill ubiquitous-language`  |
| `write-a-skill`                    | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill write-a-skill`        |
| `zoom-out`                         | `mattpocock/skills`          | `bunx skills add mattpocock/skills --skill zoom-out`             |

---

## Manual setup (secrets — never committed)

1. **SSH key:**
   ```bash
   ssh-keygen -t ed25519 -C "camercey@gmail.com"
   ```
   then add the public key to GitHub.
2. **Git identity:**
   ```bash
   git config --global user.name "Carl-Adrien Mercey"
   git config --global user.email "camercey@gmail.com"
   ```
3. **GitHub CLI:** `gh auth login`
4. **AI CLIs:** authenticate each (see table above).

## Per-machine overrides

Anything host-specific goes in `~/.zshrc.local` (or `~/.bashrc.local`), which is
sourced at the end of the shell config and ignored by git.
