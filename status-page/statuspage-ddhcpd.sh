#!/bin/bash
#
# Statusseite: Block "DHCP (ddhcpd)" mit Pool, Leases und Roaming aus
# neanderfunk-respondd, siehe Kopf des Patches.
#
# Setzt auf dem Zustand nach statuspage-compact.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-ddhcpd.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Block DHCP (ddhcpd)"

apply_patch "$PATCH_DIR/statuspage-ddhcpd.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/view/status-page.html" \
  "neanderfunk/ddhcpd/blocks/free"
