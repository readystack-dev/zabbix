# Provenance — Zabbix (`7.4.16-CE-ubuntu24.04-r6`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://github.com/zabbix/zabbix
- Revision built: `7.4.16` (commit `b90dda2ec5983a92c9671550b5e32947cf241cd2`)
- Source tree: `1f86bf79232abe846e52688eac4f5fd49ca1d82f943844e1a342e0094ec5f931` over 6887 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-c`; base image `ubuntu:24.04`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- SOURCE_DATE_EPOCH: `1795672829` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/zabbix:7.4.16-CE-ubuntu24.04-r6` — index digest `sha256:34a21875d87e2059886b5ffa284b397b76eeb45dd67817a3a3c4963c1746471c` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:3a9714e460e17adbbd211c0d2a35e78e79a297d0fff53edf02680eba8b35291c` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/zabbix:7.4.16-CE-ubuntu24.04-r6`

## Pinned inputs, and why

- 29 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 2, image digests 1, dependency versions readystack sets 16, pins in the kit's dockerfiles 2, readystack's build engine 1, dependencies upstream chose 2, services the release checks run beside 3).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-zabbix-7.4.16-CE-ubuntu24.04-r6.trail.json`, published beside this archive and signed with the release key (`ReadyStack-zabbix-7.4.16-CE-ubuntu24.04-r6.trail.json.sigstore`), and readable at https://readystack.dev/products/zabbix/trail/7.4.16-CE-ubuntu24.04-r6.

