# GENERATED L-009 hermetic C build (--network=none, SBOM+SLSA-attestation-producing).
# Pinned bases; vendored source (in-tree deps) + extra build debs + runtime debs from Dockerfile.vendor.
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289 AS cbuild
# dpkg-install the vendored EXTRA build debs (pkg-config/libssl-dev/...) — gcc/make are in the builder.
RUN --mount=type=bind,source=vendored/build-debs,target=/tmp/bdebs \
    set --; for f in /tmp/bdebs/*.deb; do [ -e "$f" ] && set -- "$@" "$f"; done; \
    for pass in 1 2 3 4 5; do [ $# -eq 0 ] || dpkg -i --skip-same-version "$@" >/dev/null 2>&1 && break; done; \
    dpkg --configure -a && bad= && for d in "$@"; do p=$(dpkg-deb -f "$d" Package) v=$(dpkg-deb -f "$d" Version); \
      case "$(dpkg-query -W -f='${Version} ${db:Status-Abbrev}' "$p" 2>/dev/null)" in "$v ii"*) ;; *) bad="$bad $p=$v" ;; esac; done && \
    { [ -z "$bad" ] || { echo "vendored debs not installed at their vendored version:$bad" >&2; false; }; }
WORKDIR /src
COPY vendored/zabbix-src/ .
ARG SOURCE_DATE_EPOCH=1795543300
ENV SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}
ENV CFLAGS="-O2 -pipe -fPIE -fstack-protector-strong -fstack-clash-protection -D_FORTIFY_SOURCE=3 -Wformat -Werror=format-security" LDFLAGS="-pie -Wl,-z,relro,-z,now,-z,defs -Wl,--as-needed" PERL_HASH_SEED=0 PERL_PERTURB_KEYS=0
RUN ./configure --prefix=/opt/zabbix --sysconfdir=/etc/zabbix --enable-server --enable-agent --enable-ipv6 --with-postgresql --with-openssl --with-net-snmp --with-ssh --with-ldap --with-libcurl=/usr/bin/curl-config --with-libpcre2 --with-libxml2 --with-openipmi --with-libmodbus --with-ares --with-unixodbc --silent
RUN make -j"$(nproc)" -s dbschema
RUN make -j"$(nproc)" -s
RUN make -s install
RUN rm -f /opt/zabbix/sbin/zabbix_agentd /opt/zabbix/share/man/man8/zabbix_agentd.8 && strip /opt/zabbix/sbin/zabbix_server /opt/zabbix/bin/zabbix_get /opt/zabbix/bin/zabbix_sender
RUN mkdir -p /opt/zabbix/share/zabbix/database/postgresql && cat database/postgresql/schema.sql database/postgresql/images.sql database/postgresql/data.sql | gzip -9n > /opt/zabbix/share/zabbix/database/postgresql/create.sql.gz && cp COPYING /opt/zabbix/share/zabbix/COPYING
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289
ENV DEBIAN_FRONTEND=noninteractive PATH=/opt/zabbix/sbin:/opt/zabbix/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin LANG=C.UTF-8
RUN --mount=type=bind,source=vendored/debs,target=/tmp/debs \
    set --; for f in /tmp/debs/*.deb; do [ -e "$f" ] && set -- "$@" "$f"; done; \
    for pass in 1 2 3 4 5; do [ $# -eq 0 ] || dpkg -i --skip-same-version "$@" >/dev/null 2>&1 && break; done; \
    dpkg --configure -a && bad= && for d in "$@"; do p=$(dpkg-deb -f "$d" Package) v=$(dpkg-deb -f "$d" Version); \
      case "$(dpkg-query -W -f='${Version} ${db:Status-Abbrev}' "$p" 2>/dev/null)" in "$v ii"*) ;; *) bad="$bad $p=$v" ;; esac; done && \
    { [ -z "$bad" ] || { echo "vendored debs not installed at their vendored version:$bad" >&2; false; }; } && \
    rm -rf /var/lib/apt/lists/* \
           /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /var/cache/ldconfig/aux-cache /var/cache/fontconfig
ARG SOURCE_DATE_EPOCH=1795543300
RUN groupadd -r zabbix && useradd -r -g zabbix -d /var/lib/zabbix -m zabbix && \
    mkdir -p /etc/zabbix /etc/zabbix/zabbix_server.d /var/lib/zabbix/export /var/lib/zabbix/snmptraps /var/lib/zabbix/modules /var/lib/zabbix/ssh_keys /var/lib/zabbix/ssl/certs /var/lib/zabbix/ssl/keys /var/lib/zabbix/ssl/ssl_ca && chown -R zabbix:zabbix /etc/zabbix /etc/zabbix/zabbix_server.d /var/lib/zabbix/export /var/lib/zabbix/snmptraps /var/lib/zabbix/modules /var/lib/zabbix/ssh_keys /var/lib/zabbix/ssl/certs /var/lib/zabbix/ssl/keys /var/lib/zabbix/ssl/ssl_ca && \
    : "${SOURCE_DATE_EPOCH:?SOURCE_DATE_EPOCH must be set for a reproducible build}" && \
    sed -ri "s/^([^:]*:[^:]*):[0-9]*:/\1:$((SOURCE_DATE_EPOCH/86400)):/" /etc/shadow && \
    rm -f /etc/passwd- /etc/shadow- /etc/group- /etc/gshadow-
COPY --from=cbuild /opt/zabbix /opt/zabbix
COPY zabbix-entrypoint.sh /usr/local/bin/zabbix-entrypoint.sh
RUN chmod 0755 /usr/local/bin/zabbix-entrypoint.sh
RUN ! ldd /opt/zabbix/sbin/zabbix_server | grep 'not found' && /opt/zabbix/sbin/zabbix_server -V | head -n1
LABEL org.opencontainers.image.title="Zabbix"
LABEL org.opencontainers.image.description="Zabbix monitoring server built from source, PostgreSQL backend, non-root"
LABEL org.opencontainers.image.source="https://github.com/zabbix/zabbix"
LABEL org.opencontainers.image.revision="b90dda2ec5983a92c9671550b5e32947cf241cd2"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"
LABEL org.opencontainers.image.vendor="ReadyStack.dev"
LABEL org.opencontainers.image.version="7.4.16-CE-ubuntu24.04-r5"
LABEL readystack.product="zabbix"
LABEL readystack.edition="CE"
LABEL readystack.build_method="source-rebuild-c"
LABEL com.readystack.license.disclosure="This image includes Zabbix server (https://github.com/zabbix/zabbix), licensed under AGPL-3.0-only. Modifications: include/version.h has its ZABBIX_REVISION placeholder replaced by the first ten characters of the upstream commit, the revision stamp upstream's own make dist writes into its release tarballs; full diff at https://readystack.dev/source/zabbix/7.4.16/zabbix-7.4.16-readystack.patch. Security patches are applied only via upstream-published, unmodified Ubuntu packages. ReadyStack license holders have access to the image build recipe and patched-package manifest on request via support@readystack.dev."
HEALTHCHECK --interval=5s --timeout=120s --start-period=120s \
  CMD bash -c 'exec 3<>/dev/tcp/127.0.0.1/10051' || exit 1
WORKDIR /var/lib/zabbix
USER zabbix
EXPOSE 10051
ENTRYPOINT ["/usr/local/bin/zabbix-entrypoint.sh"]
