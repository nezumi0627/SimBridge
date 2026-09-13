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

Configure this secret in the caller repository or organization:

- `TAILSCALE_AUTHKEY`

The auth key must use the `tag:simbridge` identity. The runner is not an
internet-facing server;
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
- pinned Baguette source ref (`v0.1.97` by default)
- Tailscale connection using ephemeral-node credentials
- bounded session lifetime and failure classification
- screenshot and logs as Actions artifacts

The browser UI is currently Baguette’s UI at the Tailscale hostname. A
dedicated Windows CLI and SimBridge UI are planned for later milestones.

For the exact Tailscale credential steps, see
[docs/NETWORKING.md](docs/NETWORKING.md).

## Run the included example

The repository includes a small SwiftUI app so the workflow can be tested
without another iOS repository. Run `SimBridge simulator` manually with:

```text
scheme: SimBridgeExample
device: iPhone 17 Pro
runtime: iOS 26
```

After the build succeeds, open the Baguette URL shown in the job summary.

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the decisions and
boundaries of the MVP.
