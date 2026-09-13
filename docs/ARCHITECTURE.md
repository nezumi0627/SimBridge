# SimBridge architecture

## Boundary

SimBridge orchestrates lifecycle and integration. Baguette owns simulator
capture, streaming, and host-side input injection. Xcode and `simctl` own
building, installing, and launching the app. Tailscale owns private network
membership.

## Session lifecycle

```text
queued → starting → building → booting → ready → stopping → finished
                                      ↘ failed
```

One workflow run is one session. GitHub-hosted runners are ephemeral, so the
runner is deliberately not treated as persistent infrastructure. A session
must end before the workflow timeout and its cleanup runs regardless of the
failure stage.

When Baguette is ready, the workflow resolves the runner's MagicDNS hostname
and publishes a tailnet-only HTTP URL in the Actions job summary. The URL is
intentionally not exposed through a public tunnel.

## Reusable workflow contract

Required input: `scheme`.

Optional inputs: `device`, `runtime`, `configuration`, `ref`, `fps`,
`session-timeout-minutes`, and `baguette-ref`.

The workflow supports both `workflow_dispatch` for this repository and
`workflow_call` for external iOS repositories. The caller owns checkout
credentials and passes Tailscale secrets explicitly or with `secrets: inherit`.

## Trust model

- A manually dispatched run is the only supported way to expose a session from
  the repository itself.
- Fork pull requests are not trusted session launchers.
- Tailscale is the only intended network boundary; no public tunnel is created.
- Secrets are consumed by Actions and never written into artifacts or logs.
- Build logs and screenshots may contain repository/application data and should
  be treated as private workflow outputs.

## Known constraints

The workflow assumes an Apple Silicon `macos-26` runner with Xcode 26 and an
iOS 26 runtime. Baguette uses private Apple simulator frameworks, so its ref
is explicit and must be reviewed when Xcode changes. GitHub runner availability
and Baguette compatibility should be verified before relying on a production
session.
