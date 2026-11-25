# Zabbix 7.4.16 — ReadyStack release `7.4.16-CE-ubuntu24.04-r5`

Generated 2026-11-25 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/zabbix:7.4.16-CE-ubuntu24.04-r5` (linux/amd64). Index digest `sha256:d6a63ce708442f4ee5b1a41d9117c416a1e1d2f24bfa3e3b9ed91b6e0b95ea86` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:80069ab6126f54e1956f45af09f1eb6f359cfd4a8595a69ac9f813a80ff1b55b` [`TARGET_DIGEST.txt`].
- **Upstream:** Zabbix 7.4.16 built from source at `7.4.16` of https://github.com/zabbix/zabbix — upstream notes: https://github.com/zabbix/zabbix/releases/tag/7.4.16 [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** `ubuntu:24.04`; runtime user `zabbix`.
- **Build:** `source-rebuild-c`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `7.4.16-CE-ubuntu24.04-r4`.

## What changed in this release

- Upstream version unchanged (7.4.16); ReadyStack rebuild.
- Zabbix 7.4.16 is unchanged from the release this supersedes (7.4.16-CE-ubuntu24.04-r4); this release rebuilds it. Changes: libssh-4 moves from 0.10.6-2ubuntu0.5 to 0.10.6-2ubuntu0.6 (USN-9187-1). Settings, ports and the database are those of 7.4.16-CE-ubuntu24.04-r4: replace the container with this image, connected to the same database.

## Security status at release (measured 2026-11-25)

- **Docker Scout:** 0 fixable critical/high vulnerabilities; runs as `zabbix` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/zabbix:7.4.16-CE-ubuntu24.04-r5` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.
- **Known default credential (upstream behaviour, kept):** `Admin` / `zabbix` — upstream's default password for the frontend/API super-admin account Admin, which the schema this image loads into an empty database seeds (create/src/data.tmpl, users row 1: bcrypt hash $2y$10$92nDno4n0Zm7Ej7Jfsz8WukBfgSS/U0QkIuu8WkJPihXBb2A1UrEK; checked 2026-10-22 with bcrypt.checkpw: it is "zabbix"). The account is used only through a Zabbix web frontend, which this image does not contain; change the password in the frontend at the first sign-in, before the frontend is reachable by anyone else. Change it before exposing the service.
- **Before exposing this service:** The schema seeds the frontend account Admin with password zabbix: change it as soon as a frontend is connected.
- **Before exposing this service:** Port 10051 accepts data from any agent or sender that can reach it: keep it on a private network or configure TLS/PSK for agents.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:80069ab6126f54e1956f45af09f1eb6f359cfd4a8595a69ac9f813a80ff1b55b`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 7 of 7 use cases passed (7 authored) against the running image [`docs/validation/test-results.json`].

## Known issues

- **high** (upstream): Ships a known default credential (Admin) [`RSD-zabbix-1f8ca22880`]

## Defects fixed

- 24 problems found before release and fixed before it shipped (24 by review); each is listed in `docs/defects/defects.json`.

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/zabbix:7.4.16-CE-ubuntu24.04-r5
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

