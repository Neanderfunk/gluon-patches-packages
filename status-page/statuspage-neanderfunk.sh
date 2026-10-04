#!/bin/bash
#
# Statusseite: Neanderfunk-Anbauten (Hardware, SSID live, Offline-SSID,
# Ethernet, Temperaturen, Gateway-Name), siehe Kopf des Patches.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-neanderfunk.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Neanderfunk-Anbauten"

apply_patch "$PATCH_DIR/statuspage-neanderfunk.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/view/status-page.html" \
  'neanderfunk/ssid_changer/offline'
