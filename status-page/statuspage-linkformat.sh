#!/bin/bash
#
# Statusseite: Ethernet-Link als "1000 FDX" / "100 HDX" / "1000TX", siehe Kopf
# des Patches.
#
# Setzt auf dem Zustand nach statuspage-portroles.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-linkformat.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Ethernet-Link als FDX/HDX"

apply_patch "$PATCH_DIR/statuspage-linkformat.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/view/status-page.html" \
  "' FDX'"
