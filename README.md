# Gluon-Patches zu den Neanderfunk-Paketen (v2021.1.x)

*Patches for Gluon v2021.1.x / OpenWrt 19.07 that go together with packages
from the [Neanderfunk/packages](https://github.com/Neanderfunk/packages) feed,
branch `v2021.1.x`. Used by Freifunk im Neanderland (Neanderfunk) for the last
"Sackgasse" build for 4/32 devices. `apply.sh` applies all of them in order.*

Zweig `v2021.1.x` passt zu Gluon v2021.1.x (Ende `3181e496`, OpenWrt 19.07)
und zum Feed-Zweig `v2021.1.x`. Angelegt am 04.10.2026 für die Überarbeitung
der Sackgasse (FirmwareConfigs `v2021.x`, `docs/ueberarbeitung-2026.md`). Die
Statusseiten- und Setup-Mode-Patches der höheren Zweige gehören zu 2023.2/2025.1
und fehlen hier.

## Anwenden

Aus dem Gluon-Verzeichnis:

```
cd gluon
<dieses Repo>/apply.sh pre-update
make update
<dieses Repo>/apply.sh post-update
```

`pre-update` tut hier nichts und ist nur da, damit alle Patch-Repos gleich
aufgerufen werden. Die Skripte sind idempotent: Ist ein Patch schon drin,
melden sie das und machen weiter.

## Patches

### mesh-vpn/tunneldigger-watchdog-shell

Port von gluon-patches-fixes `lowmem/tunneldigger-watchdog-shell` (v2023.2.x,
v2025.1.x, mit FirmwareConfigs `e362e4d`). Der Watchdog
(`/usr/bin/tunneldigger-watchdog`, alle 5 min) läuft als Shell statt Lua:
Auf 4/32-Geräten kam die Lua-Laufzeit samt simple-uci jedes Mal vom Flash
(am Testknoten 0,11 s in Shell). Gleiche Entscheidungen wie die Lua-Fassung
von 2021.1 einschließlich ihrer PID-Prüfung. Neu: Solange br-wan keine
IPv4-Adresse hat, startet er tunneldigger nicht neu; der Client spricht nur
IPv4, ein Neustart setzt nur dieselbe vergebliche Broker-Suche neu auf
(Knoten mit VPN an, aber ohne WAN). Das Skript wandert von `luasrc/` nach
`files/`, weil luasrcdiet Shell zerstören würde; der Patch ist im git-Format,
damit es ausführbar (100755) ankommt.

Gegenstück im Client selbst (Reinit-Pause, kein modprobe-Sturm, `f9a3053`)
ist ein Patch am Paketfeed-Modul und liegt in `gluon-patches-fixes`.

### status-page/statuspage-neanderfunk

Die Neanderfunk-Anbauten der Statusseite aus v2025.1.x in einem Patch
(moredetails, ssid, hwdetails, ethlinks, ssidchanger-zaehler, respondd,
gateway-name, distance-wired, ?v= an CSS/JS). Ohne OWE/privates WLAN und
ohne eigenen Katalog (Image nur Englisch). Braucht im Image
`neanderfunk-respondd` (Werte, SSID live per nl80211) und
`neanderfunk-status-page` (Gateway-Name); ohne sie fehlen die Zeilen bzw.
steht die Gateway-MAC da. Einzelheiten im Kopf des Patches.

### status-page/statuspage-darkmode

Unverändert aus v2025.1.x, passt auf 2021.1 ohne Anpassung.

### status-page/statuspage-stations-300ms

Der Provider fuer den Signalgraphen der Mesh-Nachbarn (`providers/stations`)
fragt die Stationsliste alle 300 statt 150 ms ab. Am 841v9 kostete er mit
offener Statusseite ~11 % CPU samt Kernel-Arbeit, die Load stieg von 0,09 auf
0,17-0,21 (Entscheidung adorfer 06.10.2026). Haengt an keinem anderen Patch.

### setup-mode-network/

`setup-mode-hostnames`, `setup-mode-captive`, `setup-mode-wifi` unverändert
aus v2025.1.x: S60dnsmasq, S50uhttpd und das Portal-CGI sind in Gluon 2021.1
gleich. `setup-mode-wifi` bindet den ersten dnsmasq an br-setup, damit
`neanderfunk-setup-wifi` einen zweiten an br-setupwifi starten kann.
