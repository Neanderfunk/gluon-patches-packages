#!/bin/bash
#
# tunneldigger-watchdog startet ohne IPv4 auf br-wan nicht neu, siehe Kopf
# des Patches (Port von FirmwareConfigs v2023.2.x e362e4d).
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/mesh-vpn/tunneldigger-watchdog-no-wan.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon: tunneldigger-watchdog ohne WAN-IPv4 kein Neustart"

apply_patch "$PATCH_DIR/tunneldigger-watchdog-no-wan.patch" \
  "package/gluon-mesh-vpn-tunneldigger/luasrc/usr/bin/tunneldigger-watchdog" \
  "ip -4 addr show dev br-wan"
