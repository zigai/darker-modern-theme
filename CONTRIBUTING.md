# Contributing

## Development

Install dependencies:

```sh
npm install
```

Launch the extension development host from VS Code with `F5`, then select either
`Lumenweld` or `Lumenweld Black` from the color theme picker.

Theme files live in `themes/`:

- `lumenweld-theme.json`
- `lumenweld-black-theme.json`

## Checks

Run the local validation and formatting checks before opening a pull request:

```sh
npm run check
```

Create a local VSIX package:

```sh
npm run package
```
