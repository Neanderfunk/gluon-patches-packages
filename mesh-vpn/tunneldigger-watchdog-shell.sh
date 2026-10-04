#!/bin/bash
#
# tunneldigger-watchdog als Shell statt Lua, ohne WAN-IPv4 kein Neustart,
# siehe Kopf des Patches (Port von gluon-patches-fixes
# lowmem/tunneldigger-watchdog-shell, inkl. FirmwareConfigs e362e4d).
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/mesh-vpn/tunneldigger-watchdog-shell.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon: tunneldigger-watchdog als Shell, ohne WAN-IPv4 kein Neustart"

apply_patch "$PATCH_DIR/tunneldigger-watchdog-shell.patch" \
  "package/gluon-mesh-vpn-tunneldigger/files/usr/bin/tunneldigger-watchdog" \
  "ip -4 addr show dev br-wan"
