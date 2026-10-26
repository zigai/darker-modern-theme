set positional-arguments

generate:
    uv run --project ../themebridge themebridge generate themes.json --output themes
    npm --prefix themes/vscode run format

check:
    uv run --project ../themebridge themebridge generate themes.json --output themes --check
    npm --prefix themes/vscode run check
