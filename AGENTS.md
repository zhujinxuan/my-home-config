# AGENTS.md

Home Manager configuration for jinxuanzhu's macOS machines (`jinxuanzhu@MacBookM1-Pro.local`, aarch64-darwin). Nix flake; entry points are `flake.nix` → `common.nix` + `darwin/home.nix` + `darwin/sops.nix`.

## Package ownership

`frpc` stays under Homebrew (`/opt/homebrew`), outside this flake, for now: it must stay alive while home-manager configurations are being updated or rebuilt. When touching `home.packages`, leave `frpc` in brew.

## Agent skills

### Issue tracker

Issues live as local markdown files under `.scratch/` (one directory per feature, one file per ticket). See `docs/agents/issue-tracker.md`.

### Triage labels

Default label vocabulary, unchanged: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` and `docs/adr/` at the repo root, created lazily by `/domain-modeling`. See `docs/agents/domain.md`.
