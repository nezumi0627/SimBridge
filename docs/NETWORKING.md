# Tailscale setup

`TS_OAUTH_CLIENT_ID` and `TS_OAUTH_SECRET` are not values you invent. They are
the two parts of a Tailscale OAuth credential that lets GitHub Actions register
an ephemeral macOS runner in your tailnet.

## Create the credential

1. Open the Tailscale admin console's [Trust credentials](https://login.tailscale.com/admin/settings/keys) page.
2. Choose **Credential** → **OAuth**.
3. Grant the `auth_keys` scope and allow the tag `tag:simbridge`.
4. Generate the credential.
5. Copy the client ID and secret immediately. Tailscale does not show the
   secret again after leaving the creation page.

The account creating it must have sufficient tailnet administration rights.
The secret is case-sensitive and must never be committed or pasted into chat.

## Store it in GitHub

In the `nezumi0627/SimBridge` repository, open **Settings** → **Secrets and
variables** → **Actions** → **New repository secret** and create:

| Name | Value |
| --- | --- |
| `TS_OAUTH_CLIENT_ID` | Tailscale OAuth client ID |
| `TS_OAUTH_SECRET` | Tailscale OAuth client secret |

The workflow requests `tag:simbridge`; the tailnet policy must permit that tag
and permit your Windows Tailscale device to reach the runner on TCP port 8421.
Install and sign in to Tailscale on Windows before starting a session.

The workflow prints a private `http://...ts.net:8421/simulators` link in the
Actions job summary once Baguette is ready. Do not use Tailscale Funnel or
expose port 8421 to the public internet.
