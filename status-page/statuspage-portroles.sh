#!/bin/bash
#
# Statusseite: Rolle je Ethernet-Port (DSA) bzw. je Portgruppe (swconfig),
# siehe Kopf des Patches.
#
# Setzt auf dem Zustand nach statuspage-distance-wired.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-portroles.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Rolle je Ethernet-Port"

apply_patch "$PATCH_DIR/statuspage-portroles.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/view/status-page.html" \
  'ROLE_ORDER'
