#!/bin/bash
#
# Config-Mode: Hinweis zu einer Domain unter der Domain-Auswahl, nur solange
# sie ausgewaehlt ist (Text aus site/i18n gluon-config-mode:domain-hint:<code>).
# Setzt auf domain-select-code auf. Siehe Kopf des Patches.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/config-mode/domain-select-hint.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Config-Mode: Hinweis zur ausgewaehlten Domain"

apply_patch "$PATCH_DIR/domain-select-hint.patch" \
  "package/gluon-config-mode-domain-select/luasrc/lib/gluon/config-mode/wizard/0200-domain-select.lua" \
  "gluon-config-mode:domain-hint:"
