#!/bin/bash
#
# Statusseite: senkrecht kompakter (Abstände etwa halbiert), siehe Kopf des
# Patches.
#
# Setzt auf dem Zustand nach statuspage-darkmode.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-compact.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: senkrecht kompakter"

apply_patch "$PATCH_DIR/statuspage-compact.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/www/static/status-page.css" \
  "dd{margin-bottom:8px}"
