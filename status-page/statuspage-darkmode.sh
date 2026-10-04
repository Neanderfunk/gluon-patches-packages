#!/bin/bash
#
# Statusseite: Darkmode nach prefers-color-scheme, Farben aus
# neanderfunk-config-mode-theme - siehe Kopf des Patches.
#
# Unabhaengig von der restlichen status-page-Kette (nur das Stylesheet).
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-darkmode.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Darkmode"

apply_patch "$PATCH_DIR/statuspage-darkmode.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/www/static/status-page.css" \
  'prefers-color-scheme: dark'
