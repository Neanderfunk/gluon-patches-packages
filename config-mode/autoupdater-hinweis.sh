#!/bin/bash
#
# Config-Mode: Seite "Automatische Updates" mit einer Erklaerung, wozu sie gut
# sind. Siehe Kopf des Patches.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/config-mode/autoupdater-hinweis.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Config-Mode: Hinweis auf der Seite Automatische Updates"

apply_patch "$PATCH_DIR/autoupdater-hinweis.patch" \
  "package/gluon-web-autoupdater/luasrc/lib/gluon/config-mode/model/admin/autoupdater.lua" \
  "Neanderfunk: why automatic updates matter"
