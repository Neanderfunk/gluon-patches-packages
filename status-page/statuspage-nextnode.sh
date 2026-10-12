#!/bin/bash
#
# Statusseite: Next-Node-Adressen (IPv4, IPv6) mit Link, siehe Kopf des
# Patches.
#
# Setzt auf dem Zustand nach statuspage-clientbands.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-nextnode.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Next-Node-Adressen mit Link"

apply_patch "$PATCH_DIR/statuspage-nextnode.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/view/status-page.html" \
  "site\.next_node\.ip4"
