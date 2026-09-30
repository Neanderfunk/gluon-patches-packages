#!/bin/bash
#
# SSID des OWE-BSS und des privaten WLANs je Radio, siehe Kopf des Patches.
#
# Setzt auf dem Zustand nach statuspage-darkmode.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-ssid-owe-private.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: SSID von OWE und privatem WLAN"

apply_patch "$PATCH_DIR/statuspage-ssid-owe-private.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/view/status-page.html" \
  'local function ap_ssid'
