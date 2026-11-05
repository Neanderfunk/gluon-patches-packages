#!/bin/bash
#
# Config-Mode, Seite "Netzwerk": genau eine Rolle je Schnittstelle
# (Radio-Buttons statt Haekchen). Einzelheiten im Patchkopf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut.

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Config-Mode: eine Rolle je Schnittstelle auf der Seite Netzwerk"

apply_patch "$PATCH_DIR/network-one-role.patch" \
  "package/gluon-web-network/luasrc/lib/gluon/config-mode/model/admin/network.lua" \
  'neanderfunk.one_role'
