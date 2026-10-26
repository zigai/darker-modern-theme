# Contributing

## Theme sources

The canonical variants are `palette/darker-modern.json` and `palette/darker-modern-black.json`. Both conform to Theme IR 2.0 and preserve app-specific settings under `target_overrides`.

Checked-in native themes live under:

- `themes/vscode`
- `themes/nvim`
- `themes/ghostty`
- `themes/fish`
- `themes/tmux`
- `themes/zed`
- `themes/zellij`

A palette change must be reflected in both variants where appropriate. Run `just generate` to update native files and `just check` to detect drift. Keep app-specific settings in target overrides with palette references.

## VS Code development

Install package dependencies from the repository root:

```sh
npm install --prefix themes/vscode
```

Press `F5` in VS Code to launch an Extension Development Host using `themes/vscode`, then select `Darker Modern` or `Darker Modern Black` from the color theme picker.

Run the package check before opening a pull request:

```sh
npm --prefix themes/vscode run check
```

Create a local VSIX with:

```sh
npm --prefix themes/vscode run package
```

The package is written to `themes/vscode/dist/darker-modern.vsix`.

## Native ports

Keep every native file directly installable according to the instructions in the root README. Zed's family file and both Zellij theme definitions must continue to expose both variant names exactly: `Darker Modern` / `Darker Modern Black` for display-name formats and `darker-modern` / `darker-modern-black` for identifier formats.
