#!/bin/bash
#
# Statusseite: Domain-Code hinter dem Domainnamen, siehe Kopf des Patches.
#
# Setzt auf dem Zustand nach statuspage-ddhcpd.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/status-page/statuspage-domaincode.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Statuspage: Domain-Code hinter dem Domainnamen"

apply_patch "$PATCH_DIR/statuspage-domaincode.patch" \
  "package/gluon-status-page/files/lib/gluon/status-page/view/status-page.html" \
  "(<%| nodeinfo\.system\.domain_code %>)"
