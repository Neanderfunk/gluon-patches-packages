#!/bin/bash
#
# Statusseite: eine Zeile "Domain-Helfer" aus neanderfunk-respondd, siehe
# Kopf des Patches.
#
# Setzt auf dem Zustand nach statuspage-domaincode.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-domainhelper.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Zeile Domain-Helfer"

apply_patch "$PATCH_DIR/statuspage-domainhelper.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/view/status-page.html" \
  "nf_stats.domainhelper"
