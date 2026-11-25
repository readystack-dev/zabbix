#!/usr/bin/env bash
# ReadyStack Zabbix server entrypoint: wait for the external PostgreSQL, load the Zabbix schema into an
# EMPTY database (once), write /etc/zabbix/zabbix_server.conf from the environment, then exec zabbix_server
# in the foreground as the non-root zabbix user.
set -Eeuo pipefail

: "${DB_SERVER_HOST:?set DB_SERVER_HOST to the host name of your PostgreSQL server}"
: "${POSTGRES_PASSWORD:?set POSTGRES_PASSWORD to the password of the Zabbix database user}"
DB_SERVER_PORT="${DB_SERVER_PORT:-5432}"
POSTGRES_USER="${POSTGRES_USER:-zabbix}"
POSTGRES_DB="${POSTGRES_DB:-zabbix}"
CONF=/etc/zabbix/zabbix_server.conf
SCHEMA=/opt/zabbix/share/zabbix/database/postgresql/create.sql.gz

export PGHOST="$DB_SERVER_HOST" PGPORT="$DB_SERVER_PORT" PGUSER="$POSTGRES_USER" PGDATABASE="$POSTGRES_DB"
export PGPASSWORD="$POSTGRES_PASSWORD"
[ -n "${DB_SERVER_SSLMODE:-}" ] && export PGSSLMODE="$DB_SERVER_SSLMODE"

tries="${DB_WAIT_TRIES:-60}"
until pg_isready -q; do
  tries=$((tries - 1))
  if [ "$tries" -le 0 ]; then
    echo "zabbix: PostgreSQL at $PGHOST:$PGPORT did not become ready" >&2
    exit 1
  fi
  echo "zabbix: waiting for PostgreSQL at $PGHOST:$PGPORT"
  sleep 2
done

if [ -z "$(psql -tAc "SELECT 1 FROM pg_catalog.pg_tables WHERE tablename = 'dbversion'")" ]; then
  echo "zabbix: database $POSTGRES_DB has no Zabbix schema; loading it (first start only)"
  zcat "$SCHEMA" | psql -q -v ON_ERROR_STOP=1 >/dev/null
  echo "zabbix: schema loaded"
fi
unset PGPASSWORD

umask 077
{
  echo "LogType=console"
  echo "PidFile=/tmp/zabbix_server.pid"
  echo "SocketDir=/tmp"
  echo "ListenPort=${ZBX_LISTENPORT:-10051}"
  echo "DBHost=$DB_SERVER_HOST"
  echo "DBPort=$DB_SERVER_PORT"
  echo "DBName=$POSTGRES_DB"
  echo "DBUser=$POSTGRES_USER"
  echo "DBPassword=$POSTGRES_PASSWORD"
  [ -n "${DB_SERVER_SSLMODE:-}" ] && [ "$DB_SERVER_SSLMODE" != disable ] && echo "DBTLSConnect=required"
  echo "FpingLocation=/usr/bin/fping"
  echo "Fping6Location=/usr/bin/fping6"
  echo "ExportDir=/var/lib/zabbix/export"
  echo "SNMPTrapperFile=/var/lib/zabbix/snmptraps/snmptraps.log"
  echo "SSHKeyLocation=/var/lib/zabbix/ssh_keys"
  echo "SSLCertLocation=/var/lib/zabbix/ssl/certs"
  echo "SSLKeyLocation=/var/lib/zabbix/ssl/keys"
  echo "SSLCALocation=/var/lib/zabbix/ssl/ssl_ca"
  echo "LoadModulePath=/var/lib/zabbix/modules"
  # Any other server parameter: ZBX_CONF_<Parameter>=<value>, e.g. -e ZBX_CONF_StartPollers=10
  for v in $(compgen -v ZBX_CONF_ || true); do
    echo "${v#ZBX_CONF_}=${!v}"
  done
  if compgen -G "/etc/zabbix/zabbix_server.d/*.conf" >/dev/null; then
    echo "Include=/etc/zabbix/zabbix_server.d/*.conf"
  fi
} > "$CONF"
unset POSTGRES_PASSWORD

exec zabbix_server --foreground -c "$CONF" "$@"
