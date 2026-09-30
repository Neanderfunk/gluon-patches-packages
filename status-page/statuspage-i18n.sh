#!/bin/bash
#
# Statusseite: Texte der Neanderfunk-Zeilen aus dem Katalog des Feed-Pakets
# neanderfunk-status-page - siehe Kopf des Patches.
#
# Setzt auf dem Ende der Statusseiten-Kette auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-i18n.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Texte aus dem Katalog neanderfunk-status-page"

apply_patch "$PATCH_DIR/statuspage-i18n.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/view/status-page.html" \
  "i18n 'neanderfunk-status-page'"
