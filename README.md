# Darker Modern

A darker take on VS Code Modern with near-black workbench surfaces.

## Previews

### Darker Modern

<img src="screenshots/darker-modern-preview.png" alt="Darker Modern preview" width="820">

### Darker Modern Black

<img src="screenshots/darker-modern-black-preview.png" alt="Darker Modern Black preview" width="820">

## Themes

| Theme                 | Background | Use case                                                   |
| --------------------- | ---------- | ---------------------------------------------------------- |
| `Darker Modern`       | `#050505`  | Near-black UI while preserving visible panel separation.   |
| `Darker Modern Black` | `#000000`  | Fully black editor surface with darker surrounding chrome. |

## Install

Install from a local VSIX:

```sh
npm install
npm run package
code --install-extension dist/darker-modern.vsix
```

Then open the color theme picker with `Preferences: Color Theme` and select
`Darker Modern` or `Darker Modern Black`.

## Development

Install dependencies:

```sh
npm install
```

Run the checks:

```sh
npm run check
```

Open this repository in VS Code and press `F5` to launch an Extension
Development Host with the theme loaded.

## License

[MIT](LICENSE)
