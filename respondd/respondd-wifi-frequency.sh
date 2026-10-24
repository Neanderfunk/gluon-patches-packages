#!/bin/bash
#
# respondd: Frequenz (MHz) je WLAN-Interface in neighbours.wifi melden.
# Uebernommen von 4830.org (ffgtso/site-4830-v2025.1 28c7644), Einzelheiten
# im Patchkopf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut.

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "respondd: WLAN-Frequenz in neighbours.wifi"

apply_patch "$PATCH_DIR/respondd-wifi-frequency.patch" \
  "package/gluon-respondd/src/respondd-neighbours.c" '"frequency"'
