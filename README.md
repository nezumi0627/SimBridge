# SimBridge

SimBridge connects a Windows browser to an iOS Simulator running on a
short-lived Apple Silicon GitHub Actions runner:

```text
Windows browser → Tailscale → GitHub Actions macOS → Xcode → iOS Simulator
                                                        ↓
                                                     Baguette
```

The first milestone is a reusable GitHub Actions workflow. It checks out an
iOS repository, selects or creates a simulator, builds and launches the app,
installs Baguette, and keeps the session available for a bounded period.

## Use from an iOS repository

Create `.github/workflows/simbridge.yml` in the iOS repository:

```yaml
name: SimBridge

on:
  workflow_dispatch:
    inputs:
      scheme:
        description: Xcode scheme to build
        required: true
        type: string

jobs:
  simulator:
    uses: nezumi0627/SimBridge/.github/workflows/simulator.yml@main
    with:
      scheme: ${{ inputs.scheme }}
      device: iPhone 17 Pro
      runtime: iOS 26
    secrets: inherit
```

Configure these secrets in the caller repository or organization:

- `TS_OAUTH_CLIENT_ID`
- `TS_OAUTH_SECRET`

The OAuth client must be allowed to create ephemeral devices and use a tag
accepted by the tailnet ACL. The runner is not an internet-facing server;
access is intended to be through Tailscale only.

## Local repository mode

For this repository itself, open Actions → `SimBridge simulator` → Run
workflow. This dispatch mode is useful while the sample project and the
Windows client are still being developed.

## Current scope

Implemented in v0.1 foundation:

- `macos-26` runner target
- simulator selection/creation and headless boot
- Xcode workspace/project build
- app installation and launch
- pinned Baguette source ref
- Tailscale connection using ephemeral-node credentials
- bounded session lifetime and failure classification
- screenshot and logs as Actions artifacts

The browser UI is currently Baguette’s UI at the Tailscale hostname. A
dedicated Windows CLI and SimBridge UI are planned for later milestones.

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the decisions and
boundaries of the MVP.
