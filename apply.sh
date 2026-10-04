#!/bin/bash
#
# apply.sh <pre-update|post-update>
#
# Wendet die Patches dieses Repos auf einen Gluon-Baum an, in fester
# Reihenfolge. Aufruf aus dem Gluon-Verzeichnis, einmal je Phase:
#
#   cd gluon
#   <dieses Repo>/apply.sh pre-update     vor  "make update"
#   make update
#   <dieses Repo>/apply.sh post-update    nach "make update"
#
# pre-update legt Dateien unter patches/openwrt oder patches/packages im
# Gluon-Baum ab, die "make update" per "git am" auf die Module einspielt.
# Alles andere, insbesondere jeder Patch am OpenWrt-Baum, gehoert nach
# post-update: "make update" setzt die Module neu auf.
#
# Bricht beim ersten fehlgeschlagenen Skript ab. Einzelne Skripte lassen sich
# genauso allein aufrufen; die Reihenfolge unten ist nur dort wichtig, wo die
# README eine Abhaengigkeit nennt.

set -o errexit -o nounset -o pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Hier gibt es nichts fuer vor "make update"; der Aufruf ist trotzdem erlaubt,
# damit alle Patch-Repos gleich aufgerufen werden.
PRE_UPDATE=()

# Zwei Ketten, jede auf ihre eigenen Dateien; zwischen den Ketten ist die
# Reihenfolge egal, innerhalb nicht (README, Abhaengigkeiten).
POST_UPDATE=(
  status-page/statuspage-moredetails.sh         # Statusseite: weitere MACs und Gluon-Version
  status-page/statuspage-ssid.sh                # Statusseite: SSID, HT-Modus und ssid-changer
  status-page/statuspage-hwdetails.sh           # Statusseite: CPU-Typ, Kernzahl und BIOS
  status-page/statuspage-ethlinks.sh            # Statusseite: Ethernet-Geschwindigkeit je Port
  status-page/statuspage-ssidchanger-zaehler.sh # Statusseite: Zaehler des ssid-changer seit Boot
  status-page/statuspage-respondd.sh            # Statusseite: Werte aus neanderfunk-respondd, live
  status-page/web-static-version.sh             # Statusseite und Config-Mode: CSS/JS mit Versionsanhang
  status-page/statuspage-i18n.sh                # Statusseite: Texte aus dem Katalog neanderfunk-status-page
  status-page/statuspage-darkmode.sh            # Statusseite: Darkmode nach prefers-color-scheme
  status-page/statuspage-ssid-owe-private.sh    # Statusseite: SSID von OWE und privatem WLAN
  status-page/statuspage-gateway-name.sh       # Statusseite: Gateway mit Hostnamen
  status-page/statuspage-distance-wired.sh     # Statusseite: Entfernung nur bei WLAN-Nachbarn (Gluon-Fehler)
  status-page/statuspage-portroles.sh          # Statusseite: Rolle je Ethernet-Port bzw. LAN-/WAN-Gruppe
  status-page/statuspage-linkformat.sh         # Statusseite: Ethernet-Link als 1000 FDX / 100 HDX
  setup-mode-network/setup-mode-hostnames.sh    # Setup-Mode: gluon.setup und setup.gluon per DNS
  setup-mode-network/setup-mode-captive.sh      # Setup-Mode: Portal-Erkennung fuehrt auf die Setup-Seite
  setup-mode-network/setup-mode-wifi.sh         # Setup-Mode: dnsmasq an br-setup (fuer neanderfunk-setup-wifi)
)

PHASE="${1:-}"
case "$PHASE" in
  pre-update)  LISTE=( "${PRE_UPDATE[@]}" ) ;;
  post-update) LISTE=( "${POST_UPDATE[@]}" ) ;;
  *)
    echo "Aufruf: $0 pre-update|post-update (aus dem Gluon-Verzeichnis)" >&2
    exit 2
    ;;
esac

if [ ! -f Makefile ] || [ ! -f modules ] || [ ! -d package ]; then
  echo "apply.sh: $(pwd) sieht nicht nach einem Gluon-Verzeichnis aus." >&2
  exit 2
fi

echo "$(basename "$REPO_DIR"): Phase $PHASE, ${#LISTE[@]} Skript(e)"
for SKRIPT in "${LISTE[@]}"; do
  [ -x "$REPO_DIR/$SKRIPT" ] || { echo "apply.sh: $SKRIPT fehlt oder ist nicht ausfuehrbar." >&2; exit 1; }
  echo "== $SKRIPT"
  # Subshell: ein cd im Skript (etwa nach openwrt) betrifft das naechste nicht.
  ( "$REPO_DIR/$SKRIPT" ) || { echo "apply.sh: $SKRIPT fehlgeschlagen." >&2; exit 1; }
done
