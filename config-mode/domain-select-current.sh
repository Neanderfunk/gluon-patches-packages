#!/bin/bash
#
# Config-Mode: aktuelle Domain immer in der Domain-Auswahl und vorbelegt,
# auch wenn sie versteckt ist (default_domain eines frischen Knotens). Siehe
# Kopf des Patches.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/config-mode/domain-select-current.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Config-Mode: aktuelle Domain immer in der Domain-Auswahl"

apply_patch "$PATCH_DIR/domain-select-current.patch" \
  "package/gluon-config-mode-domain-select/luasrc/lib/gluon/config-mode/wizard/0200-domain-select.lua" \
  "Neanderfunk: the current domain is always listed"
