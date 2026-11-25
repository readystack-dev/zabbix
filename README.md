# Zabbix: ReadyStack build kit

The offline build kit for the Docker image `readystack/zabbix:7.4.16-CE-ubuntu24.04-r5`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [7.4.16-CE-ubuntu24.04-r5](https://github.com/readystack-dev/zabbix/releases/tag/7.4.16-CE-ubuntu24.04-r5)
- Image: [`docker.io/readystack/zabbix:7.4.16-CE-ubuntu24.04-r5`](https://hub.docker.com/r/readystack/zabbix/tags), manifest digest `sha256:80069ab6126f54e1956f45af09f1eb6f359cfd4a8595a69ac9f813a80ff1b55b`
- Product page: https://readystack.dev/products/zabbix
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=zabbix

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
