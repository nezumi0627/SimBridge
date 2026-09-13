# SimBridge contributor guide

SimBridge is an orchestration layer for short-lived macOS GitHub Actions
runners, Xcode builds, iOS Simulator, Baguette, and Tailscale. It does not
reimplement Simulator screen capture or input injection.

## Working rules

- Keep the public workflow inputs small, explicit, and backward compatible.
- Never commit Tailscale credentials, GitHub tokens, provisioning profiles, or
  other secrets. Use GitHub Actions secrets.
- Treat workflow inputs and repository contents as untrusted. Quote shell
  variables, avoid `eval`, and do not use `pull_request_target`.
- Pin third-party actions and Baguette to reviewed versions or commits before
  a production release.
- Every session must have a bounded timeout and cleanup that runs on failure.
- Preserve machine-readable failure codes for automation and Codex.

## MVP validation

The MVP path is `workflow_dispatch` or `workflow_call` → macOS runner →
simulator boot → build/install/launch → Baguette web UI → Tailscale-only access
→ screenshot → cleanup. The reusable workflow is the source of truth for this
path.
