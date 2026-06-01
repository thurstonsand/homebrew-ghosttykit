# Homebrew GhosttyKit

Homebrew tap for [GhosttyKit](https://github.com/thurstonsand/ghosttykit), a Ghostty companion toolkit.

## Install

Nightly builds track recent commits on `main` and may break:

```sh
brew install thurstonsand/ghosttykit/ghosttykit-nightly
```

Start Ghostty before starting the daemon so macOS can ask for Automation permission on first start:

```sh
open -a Ghostty
brew services start thurstonsand/ghosttykit/ghosttykit-nightly
gty doctor
```

A healthy install reports:

```text
daemon: ok - socket reachable
automation: ok - Ghostty accepted Apple Events
```

Stable releases will be published as `ghosttykit` once GhosttyKit starts cutting `v*` release tags.
