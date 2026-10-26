# Darker Modern

Darker Modern is a dark theme family for editors, terminals, and command-line tools. It ships two variants built from the same syntax palette:

| Theme | Background | Character |
| --- | --- | --- |
| `Darker Modern` | `#050505` | Near-black surfaces with visible panel separation |
| `Darker Modern Black` | `#000000` | A fully black editor and terminal canvas |

## Previews

### Darker Modern

<img src="screenshots/darker-modern-preview.png" alt="Darker Modern preview" width="820">

### Darker Modern Black

<img src="screenshots/darker-modern-black-preview.png" alt="Darker Modern Black preview" width="820">

## Repository layout

- `palette/darker-modern.json` and `palette/darker-modern-black.json` are the canonical Theme IR 2.0 documents.
- `themes/vscode` is the complete VS Code extension package.
- `themes/nvim`, `themes/ghostty`, `themes/fish`, `themes/tmux`, and `themes/zellij` contain native configuration files.
- `themes/zed/darker-modern.json` is a Zed user-theme family, not a packaged Zed extension.

The palette files define shared colors and explicit app overrides. Every native port can be copied directly into its application's user configuration.

## Install

### VS Code

Build and install a local VSIX from the package directory:

```sh
npm install --prefix themes/vscode
npm --prefix themes/vscode run package
code --install-extension themes/vscode/dist/darker-modern.vsix
```

Open `Preferences: Color Theme` and select `Darker Modern` or `Darker Modern Black`.

For extension development, open the repository in VS Code and press `F5`. The launch configuration loads `themes/vscode` as the extension root.

### Neovim

Copy both Lua files into Neovim's colors directory:

```sh
mkdir -p ~/.config/nvim/colors
cp themes/nvim/darker-modern.lua themes/nvim/darker-modern-black.lua ~/.config/nvim/colors/
```

Then set one of the following in `init.lua`:

```lua
vim.cmd.colorscheme("darker-modern")
-- vim.cmd.colorscheme("darker-modern-black")
```

### Ghostty

Copy both theme files into Ghostty's theme directory:

```sh
mkdir -p ~/.config/ghostty/themes
cp themes/ghostty/darker-modern themes/ghostty/darker-modern-black ~/.config/ghostty/themes/
```

Set either `theme = darker-modern` or `theme = darker-modern-black` in `~/.config/ghostty/config`.

### Fish

Copy both Fish theme files into the user theme directory:

```sh
mkdir -p ~/.config/fish/themes
cp themes/fish/darker-modern.theme themes/fish/darker-modern-black.theme ~/.config/fish/themes/
fish_config theme choose darker-modern
```

Use `fish_config theme choose darker-modern-black` for the black variant.

### tmux

Source the desired native configuration from `~/.tmux.conf`:

```tmux
source-file /absolute/path/to/darker-modern/themes/tmux/darker-modern.conf
# source-file /absolute/path/to/darker-modern/themes/tmux/darker-modern-black.conf
```

Reload with `tmux source-file ~/.tmux.conf`.

### Zed

Install the family as a user theme by copying it into Zed's configuration directory. This repository does not package it as a Zed extension.

```sh
mkdir -p ~/.config/zed/themes
cp themes/zed/darker-modern.json ~/.config/zed/themes/
```

Select `Darker Modern` or `Darker Modern Black` from Zed's theme selector.

### Zellij

Copy both KDL files into the theme directory reported by `zellij setup --check` (normally `~/.config/zellij/themes`):

```sh
mkdir -p ~/.config/zellij/themes
cp themes/zellij/darker-modern.kdl themes/zellij/darker-modern-black.kdl ~/.config/zellij/themes/
```

Set `theme "darker-modern"` or `theme "darker-modern-black"` in `config.kdl`, or launch with `zellij options --theme darker-modern`.

## Development

Install VS Code package dependencies with `npm install --prefix themes/vscode`. Keep Themebridge checked out beside this repository as `themebridge`, then run:

```sh
just generate
just check
npm --prefix themes/vscode run package
```

Change colors in the canonical palettes, then run `just generate`. `themes.json` lists every generated port; app overrides preserve native settings and reference the shared palette.

## License

[MIT](LICENSE)
