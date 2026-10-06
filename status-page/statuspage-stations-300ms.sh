#!/bin/bash
#
# Statusseite: Stationsabfrage fuer den Signalgraphen alle 300 statt 150 ms -
# siehe Kopf des Patches. Unabhaengig von der restlichen status-page-Kette
# (nur src/stations.c).
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-stations-300ms.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Signalgraph alle 300 ms"

apply_patch "$PATCH_DIR/statuspage-stations-300ms.patch" \
  "package/gluon-status-page/src/stations.c" \
  'usleep(300000)'
