# Tailscale setup

`TAILSCALE_AUTHKEY` is a Tailscale auth key that lets GitHub Actions register
an ephemeral macOS runner in your tailnet. It must be tagged for SimBridge.

## Create the credential

1. Open the Tailscale admin console's [Access controls](https://login.tailscale.com/admin/acls) page.
2. Create the tag `tag:simbridge` if it does not yet
   exist. The tag owner can be `autogroup:admin`.
3. Open [Keys](https://login.tailscale.com/admin/settings/keys) and generate a
   new auth key with the `simbridge` tag, **Reusable**
   enabled, **Ephemeral** enabled, and **Preauthorized** enabled if your
   tailnet uses device approval.
4. Copy the new auth key immediately.

The account creating it must have sufficient tailnet administration rights.
The secret is case-sensitive and must never be committed or pasted into chat.

## Store it in GitHub

In the `nezumi0627/SimBridge` repository, open **Settings** → **Secrets and
variables** → **Actions** → **New repository secret** and create:

| Name | Value |
| --- | --- |
| `TAILSCALE_AUTHKEY` | New tagged, reusable, ephemeral auth key |

The auth key requests `tag:simbridge`; the tailnet policy must permit that tag
and permit your Windows Tailscale device to reach the runner on TCP port 8421.
Install and sign in to Tailscale on Windows before starting a session.

The workflow prints a private `http://...ts.net:8421/simulators` link in the
Actions job summary once Baguette is ready. Do not use Tailscale Funnel or
expose port 8421 to the public internet.
