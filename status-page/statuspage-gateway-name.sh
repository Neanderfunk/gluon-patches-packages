#!/bin/bash
#
# Gateway mit Hostnamen statt nur MAC, siehe Kopf des Patches.
#
# Setzt auf dem Zustand nach statuspage-ssid-owe-private.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-gateway-name.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Gateway mit Hostnamen"

apply_patch "$PATCH_DIR/statuspage-gateway-name.patch" \
  "package/gluon-status-page/javascript/status-page.js" \
  "'gateway': (function()"
