set positional-arguments

# Generate all theme variants
generate:
    uv run --project ../themebridge themebridge generate themes.json --output themes
    npm --prefix themes/vscode run format

# Run the commit checks
check: (run-checks "formatcheck" "lockcheck" "generated-check")

# Remove generated output, caches, and dependencies
clean: (remove "node_modules" "dist" "coverage" "themes/vscode/node_modules" "themes/vscode/dist" "themes/vscode/coverage" ".ruff_cache" ".snippet-scout-cache" "**/*.tsbuildinfo")

# Build the VS Code theme package
build: generate
    npm --prefix themes/vscode run package

# Package and install the theme in VS Code
install: build
    code --install-extension themes/vscode/dist/darker-modern.vsix --force
    @printf 'installed  darker-modern-theme  VS Code  %s  %s\n' "$(du -k themes/vscode/dist/darker-modern.vsix | cut -f1 | LC_ALL=C numfmt --from-unit=1024 --to=iec-i --suffix=B --format=%.1f)" "$(node -p 'require("./themes/vscode/package.json").version')"

# Check generated files without changing them
generated-check:
    uv run --project ../themebridge themebridge generate themes.json --output themes --check

# Check the same files and tools without writing
formatcheck:
    @git ls-files -co --exclude-standard -z | while IFS= read -r -d '' file; do if [[ -f $file ]]; then printf '%s\0' "$file"; fi; done | xargs -0 -r oxfmt --check --no-error-on-unmatched-pattern '!**/*.md' '!**/package.json' '!**/package-lock.json' '!**/*-lock.json' '!themes/vscode/themes/darker-modern-theme.json' '!themes/vscode/themes/darker-modern-black-theme.json' '!themes/zed/darker-modern.json'
    @git ls-files -co --exclude-standard -z | while IFS= read -r -d '' file; do if [[ -f $file ]]; then printf '%s\0' "$file"; fi; done | xargs -0 -r shfmt -f | xargs -r -d '\n' shfmt -d
    @git ls-files -co --exclude-standard -- Justfile justfile "*.just" | while IFS= read -r file; do just --justfile "$file" --fmt --check; done
    @just markdown check
    @git ls-files -co --exclude-standard -z | while IFS= read -r -d '' file; do if [[ -f $file ]]; then printf '%s\0' "$file"; fi; done | xargs -0 -r editorconfig-checker -disable-indent-size -disable-indentation -disable-max-line-length -disable-charset

# Format every supported first-party file type
format:
    @git ls-files -co --exclude-standard -z | while IFS= read -r -d '' file; do if [[ -f $file ]]; then printf '%s\0' "$file"; fi; done | xargs -0 -r oxfmt --no-error-on-unmatched-pattern '!**/*.md' '!**/package.json' '!**/package-lock.json' '!**/*-lock.json' '!themes/vscode/themes/darker-modern-theme.json' '!themes/vscode/themes/darker-modern-black-theme.json' '!themes/zed/darker-modern.json'
    @git ls-files -co --exclude-standard -z | while IFS= read -r -d '' file; do if [[ -f $file ]]; then printf '%s\0' "$file"; fi; done | xargs -0 -r shfmt -f | xargs -r -d '\n' shfmt -w
    @git ls-files -co --exclude-standard -- Justfile justfile "*.just" | while IFS= read -r file; do just --justfile "$file" --fmt; done
    @just markdown fmt

# Apply safe lint autofixes, then format every supported file type
fix: && format

# Synchronize dependency locks without upgrading dependencies
[no-exit-message]
lock:
    @cd "themes/vscode" && npm install --package-lock-only --ignore-scripts

# Verify dependency manifests and locks without changing files
[no-exit-message]
lockcheck:
    cd "themes/vscode" && npm ci --dry-run --ignore-scripts

# Install repository dependencies
setup:
    @npm --prefix themes/vscode ci

# List available recipes
[default]
help:
    @just --list

alias fmt := format

[positional-arguments]
[private]
remove +paths:
    #!/usr/bin/env bash
    set -euo pipefail
    shopt -s nullglob globstar
    size() { LC_ALL=C numfmt --from-unit=1024 --to=iec-i --suffix=B --format=%.1f "$1"; }
    rows=() total=0
    for pattern in "$@"; do
        found=()
        for path in $pattern; do
            if [[ -e $path || -L $path ]]; then found+=("$path"); fi
        done
        if (( ${#found[@]} == 0 )); then continue; fi
        kib=$(du -sck -- "${found[@]}" | tail -n1 | cut -f1)
        rm -rf -- "${found[@]}"
        label=$pattern
        if (( ${#found[@]} > 1 )); then label+=" (${#found[@]})"; fi
        rows+=("removed  $label|$(size "$kib")")
        total=$(( total + kib ))
    done
    if [[ -n ${CLEAN_TOTAL_FILE:-} ]]; then echo "$total" >> "$CLEAN_TOTAL_FILE"; fi
    if (( ${#rows[@]} == 0 )); then echo "nothing to clean"; exit 0; fi
    printf '%s\n' "${rows[@]}" "total freed|$(size "$total")" | column -t -s '|' -R 2

[positional-arguments]
[private]
run-checks +steps:
    #!/usr/bin/env bash
    set -uo pipefail
    LC_NUMERIC=C
    log_dir="${XDG_CACHE_HOME:-$HOME/.cache}/just-check"
    mkdir -p "$log_dir"
    log=$(mktemp "$log_dir/step.XXXXXX")
    trap 'rm -f "$log"' EXIT
    width=0 failed=()
    for step in "$@"; do (( ${#step} > width )) && width=${#step}; done
    for step in "$@"; do
        read -ra command <<< "$step"
        printf 'check  %-*s  ' "$width" "$step"
        start=$EPOCHREALTIME
        run=(just --justfile {{ quote(justfile()) }} "${command[@]}")
        if [[ -t 1 ]]; then run=(script -qefc "${run[*]@Q}" /dev/null); fi
        if "${run[@]}" < /dev/null > "$log" 2>&1; then status=ok; else status=FAIL; failed+=("$step"); fi
        printf '%-4s  %7.1fs\n' "$status" "$(LC_NUMERIC=C awk -v a="$start" -v b="$EPOCHREALTIME" 'BEGIN { print b - a }')"
        if [[ "$status" == FAIL ]]; then sed 's/\r$//; s/^/    /' "$log"; fi
    done
    if (( ${#failed[@]} )); then printf '%d of %d failed: %s\n' "${#failed[@]}" "$#" "${failed[*]}"; exit 1; fi
    printf 'all %d passed\n' "$#"

[private]
markdown *args:
    rumdl {{ args }} --exclude .git,node_modules --disable MD001,MD013,MD024,MD025,MD026,MD031,MD032,MD033,MD034,MD036,MD041,MD058 --config 'MD060.enabled=true' --config 'MD060.style="aligned"' --config 'MD003.style="atx"' --config 'MD004.style="dash"' --config 'MD029.style="ordered"' --config 'MD046.style="fenced"' --config 'MD048.style="backtick"' --config 'MD049.style="asterisk"' --config 'MD050.style="asterisk"' --config 'MD055.style="leading_and_trailing"'
