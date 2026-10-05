#!/bin/bash
#
# Vorgabe-Hostname aus neanderfunk-default-hostname, siehe Kopf des Patches.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/hostname/default-hostname.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Gluon-Core: Vorgabe-Hostname aus neanderfunk-default-hostname"

apply_patch "$PATCH_DIR/default-hostname.patch" \
  "package/gluon-core/luasrc/usr/lib/lua/gluon/util.lua" \
  "neanderfunk.default_hostname"
