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

### mesh-vpn/tunneldigger-watchdog-no-wan

Port von FirmwareConfigs v2023.2.x `e362e4d`. Der Watchdog
(`/usr/bin/tunneldigger-watchdog`, alle 5 min) startet tunneldigger nicht
mehr neu, solange br-wan keine IPv4-Adresse hat: Der Client spricht nur IPv4,
ein Neustart setzt nur dieselbe vergebliche Broker-Suche neu auf (Knoten mit
VPN an, aber ohne WAN, z. B. nur LAN-Mesh). Mit Adresse bleibt alles wie
bisher; die PID-Prüfung (toter oder doppelter Prozess) greift weiter.

Gegenstück im Client selbst (Reinit-Pause, kein modprobe-Sturm, `f9a3053`)
ist ein Patch am Paketfeed-Modul und liegt in `gluon-patches-fixes`.
