#!/bin/bash
#
# Setup-Mode: Die Portal-Erkennung der Clients (Probe-Hosts per DNS, 404 per
# uhttpd -E) fuehrt auf die Setup-Seite. Setzt auf setup-mode-hostnames auf.
# Einzelheiten im Patchkopf.
#
# Wird aus dem Gluon-Verzeichnis heraus aufgerufen, so wie apply.sh es tut.

. "$(dirname "${BASH_SOURCE[0]}")/../lib-patch.sh"

echo "Setup-Mode: Portal-Erkennung fuehrt auf die Setup-Seite"

# Zweiter Lauf auf demselben Baum: setup-mode-wifi aendert danach das hier
# angelegte Portal-CGI. Dann passt der Patch weder vor- noch rueckwaerts, und
# apply_patch ersetzt die angelegte Datei, bevor es nach dem Merkmal sieht -
# und scheitert am schon gepatchten S50uhttpd (Build-Abbruch). Darum hier
# vorab: Merkmal in S50uhttpd und Portal-CGI vorhanden = schon angewendet.
UHTTPD="package/gluon-config-mode-core/files/lib/gluon/setup-mode/rc.d/S50uhttpd"
PORTAL="package/gluon-config-mode-core/files/lib/gluon/config-mode/www/cgi-bin/portal"
if grep -qF '/cgi-bin/portal' "$UHTTPD" 2>/dev/null && [ -f "$PORTAL" ]; then
  echo "  $PATCH_DIR/setup-mode-captive.patch: bereits angewendet (S50uhttpd und portal vorhanden)."
else
  apply_patch "$PATCH_DIR/setup-mode-captive.patch" "$UHTTPD" '/cgi-bin/portal'
fi

# patch legt neue Dateien ohne Ausfuehrungsrecht an; uhttpd startet ein CGI
# nur, wenn es ausfuehrbar ist. Gluon kopiert files/ mit "cp -fpR", das Recht
# kommt also ins Image.
chmod 755 "$PORTAL"
