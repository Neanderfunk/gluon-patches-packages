#!/bin/bash
#
# Entfernung nur bei WLAN-Nachbarn setzen, siehe Kopf des Patches.
#
# Setzt auf dem Zustand nach statuspage-gateway-name.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-distance-wired.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Entfernung nur bei WLAN-Nachbarn"

apply_patch "$PATCH_DIR/statuspage-distance-wired.patch" \
  "package/gluon-status-page/javascript/status-page.js" \
  'if (tdDistance && location && nodeinfo.location)'
