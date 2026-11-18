#!/bin/bash
#
# Config-Mode: Karte startet auf der aktuellen Domain und folgt der
# Domain-Auswahl (Domain-Schluessel neanderfunk_map). Siehe Kopf des Patches.
#
# Setzt auf dem Zustand nach status-page/web-static-version.sh auf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut:
#   cd gluon && <dieses Repo>/config-mode/geo-location-domain-map.sh

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Config-Mode: Karte folgt der Domain-Auswahl"

apply_patch "$PATCH_DIR/geo-location-domain-map.patch" \
  "package/gluon-config-mode-geo-location-osm/luasrc/usr/lib/lua/gluon/config-mode/geo-location-osm.lua" \
  "function M.domain_maps"
