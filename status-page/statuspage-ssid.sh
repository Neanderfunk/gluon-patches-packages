#!/bin/bash
#
# SSID und HT-Modus je Radio: auf Gluon 2025.1 schon upstream, hier nur unsere
# Abweichungen (robuste Zeilen, Offline-SSID-Zeile), siehe Kopf des Patches.
#
# Setzt auf dem Zustand nach statuspage-moredetails.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-ssid.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: SSID und HT-Modus je Radio"

apply_patch "$PATCH_DIR/statuspage-ssid.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/view/status-page.html" \
  'offline_ssid_triggered'
