# Zabbix: ReadyStack build kit

The offline build kit for the Docker image `readystack/zabbix:7.4.16-CE-ubuntu24.04-r5`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [7.4.16-CE-ubuntu24.04-r5](https://github.com/readystack-dev/zabbix/releases/tag/7.4.16-CE-ubuntu24.04-r5)
- Image: [`docker.io/readystack/zabbix:7.4.16-CE-ubuntu24.04-r5`](https://hub.docker.com/r/readystack/zabbix/tags), manifest digest `sha256:80069ab6126f54e1956f45af09f1eb6f359cfd4a8595a69ac9f813a80ff1b55b`
- Product page: https://readystack.dev/products/zabbix
- Source and build recipe: https://readystack.dev/products/zabbix/recipe
- Build trail: https://readystack.dev/products/zabbix/trail/7.4.16-CE-ubuntu24.04-r5
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=zabbix

## The image

Single container running zabbix_server in the foreground as the non-root zabbix user: the Zabbix monitoring engine (pollers, trappers, triggers, alerting) built from source. It REQUIRES an external PostgreSQL database (13 or newer); on first start against an empty database the entrypoint loads the Zabbix schema and seed data into it. The Zabbix web frontend and its JSON-RPC API are NOT in this image: run a Zabbix frontend (PHP) against the same database to configure hosts and see data. No Zabbix agent runs in this container.

## Who uses Zabbix and why

IT operations teams who monitor networks, servers, virtual machines, applications and cloud services.

Zabbix is an open-source distributed monitoring solution. It discovers devices, collects metrics with or without agents, detects problems, sends alerts, and shows the data in graphs, maps and dashboards.

A typical use: An IT team looks after switches, servers and databases across several offices. Zabbix discovers the devices, applies ready-made templates to monitor them, raises a problem when a disk fills or a link drops, and notifies the on-call administrator, including for offices behind firewalls.

From the upstream project's own description: https://github.com/zabbix/zabbix, https://www.zabbix.com/documentation/current/en/manual/introduction/about.

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-25 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 126 packages with copyleft licences (GPL, LGPL, MPL), all of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component).
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`zabbix`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-25; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/zabbix.

Zabbix is distributed under its upstream licence (AGPL-3.0-only); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [7.4.16-CE-ubuntu24.04-r5 release](https://github.com/readystack-dev/zabbix/releases/tag/7.4.16-CE-ubuntu24.04-r5): `ReadyStack-zabbix-7.4.16-CE-ubuntu24.04-r5.tar.gz` (371.4 MB), SHA-256 `126249b5ea624c1ca23f454daae3ef4bc362cdb562b04e60c562e1971b407abf`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-zabbix-7.4.16-CE-ubuntu24.04-r5.rebuild.json.sigstore ReadyStack-zabbix-7.4.16-CE-ubuntu24.04-r5.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-zabbix-7.4.16-CE-ubuntu24.04-r5.tar.gz
cd 7.4.16-CE-ubuntu24.04-r5
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-zabbix-7.4.16-CE-ubuntu24.04-r5.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/zabbix/recipe. The complete kit is the release download. Each release is a tag here.

— ReadyStack · https://readystack.dev
