#!/bin/bash
#
# Setup-Mode: Config-Mode auch per https auf Port 443 (Geraete mit dem Feature
# tls). Setzt auf setup-mode-captive und setup-mode-wifi auf. Einzelheiten im
# Patchkopf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut.

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Setup-Mode: Config-Mode auch per https (Port 443)"

apply_patch "$PATCH_DIR/setup-mode-tls.patch" \
  "package/gluon-config-mode-core/files/lib/gluon/setup-mode/rc.d/S50uhttpd" 'setup_tls'
