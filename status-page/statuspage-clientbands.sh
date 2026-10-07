#!/bin/bash
#
# Statusseite: Clients je Band nur fuer Baender, die das Geraet hat, siehe Kopf
# des Patches.
#
# Setzt auf dem Zustand nach statuspage-stations-300ms.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-clientbands.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Clients je Band nur fuer vorhandene Baender"

apply_patch "$PATCH_DIR/statuspage-clientbands.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/view/status-page.html" \
  "has_band\['5g'\]"
