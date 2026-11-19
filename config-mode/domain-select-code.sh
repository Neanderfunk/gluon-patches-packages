#!/bin/bash
#
# Config-Mode: Domain-Auswahl mit Code vor dem Namen ("01_vel: Velbert"),
# sortiert nach Code. Setzt auf domain-select-current auf. Siehe Kopf des
# Patches.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/config-mode/domain-select-code.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Config-Mode: Domain-Auswahl mit Code vor dem Namen"

apply_patch "$PATCH_DIR/domain-select-code.patch" \
  "package/gluon-config-mode-domain-select/luasrc/lib/gluon/config-mode/wizard/0200-domain-select.lua" \
  "domain.domain_code .. ': ' .. domain.domain_name"
