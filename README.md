# Gluon-Patches zu den Neanderfunk-Paketen

*Patches for Gluon v2025.1.x / OpenWrt 24.10 that go together with packages
from the [Neanderfunk/packages](https://github.com/Neanderfunk/packages) feed:
an extended status page (neanderfunk-respondd, neanderfunk-ssid-changer) and
setup-mode network services (neanderfunk-setup-mode, neanderfunk-setup-wifi).
Used by Freifunk im Neanderland (Neanderfunk). `apply.sh` applies all of them
in order.*

Änderungen an Gluon-Dateien, die Pakete aus dem Feed
[Neanderfunk/packages](https://github.com/Neanderfunk/packages) ergänzen. Sie
liegen nicht im Feed selbst: Der Feed wird unter `gluon/packages/<name>`
eingehängt, die Patches laufen aber vom Gluon-Verzeichnis aus.

Die Zweige folgen Gluon: `v2025.1.x` passt zu Gluon v2025.1.x (OpenWrt 24.10,
Kernel 6.6) und zum Feed-Zweig `v2025.1.x`; `v2023.2.x` zu Gluon v2023.2.x.

Auf `v2025.1.x` ist die Statusseiten-Kette gegen die 2025.1-Statusseite neu
aufgesetzt: SSID und HT-Modus je Radio stehen dort schon upstream (7c040c2d),
`statuspage-ssid` traegt nur noch unsere Abweichungen (robuste Zeilen,
Offline-SSID-Zeile). Die Statusseite sieht aus wie auf v2023.2.x im Feld.

## Anwenden

Alles auf einmal, aus dem Gluon-Verzeichnis:

```
cd gluon
<dieses Repo>/apply.sh pre-update
make update
<dieses Repo>/apply.sh post-update
```

Beide Gruppen laufen post-update; `pre-update` tut hier nichts und ist nur da,
damit alle Patch-Repos gleich aufgerufen werden.

Einzeln: das Skript samt seiner Patchdateien und `lib-patch.sh` kopieren,
Struktur `<gruppe>/…` und `lib-patch.sh` eine Ebene darüber beibehalten, und
aus dem Gluon-Verzeichnis aufrufen, etwa `cd gluon && <repo>/setup-mode-network/setup-mode-hostnames.sh`.
Die Skripte sind idempotent: Ist ein Patch schon drin, melden sie das und
machen weiter. Scheitert einer, brechen sie mit Fehler ab. Ausnahme: Die
`status-page/`-Kette läuft nur auf einem frischen Baum durch. Ein zweiter Lauf
bricht bei `statuspage-hwdetails` ab, weil `statuspage-respondd` dessen Teil
umgeschrieben hat.

## Inhalt

| Skript | Zweck | nutzt aus dem Feed |
| --- | --- | --- |
| `status-page/statuspage-moredetails.sh` | Statusseite: weitere MACs und Gluon-Version | |
| `status-page/statuspage-ssid.sh` | Statusseite: SSID, HT-Modus und ssid-changer | |
| `status-page/statuspage-hwdetails.sh` | Statusseite: CPU-Typ, Kernzahl und BIOS | |
| `status-page/statuspage-ethlinks.sh` | Statusseite: Ethernet-Geschwindigkeit je Port | |
| `status-page/statuspage-ssidchanger-zaehler.sh` | Statusseite: Zustand und Zähler des ssid-changer seit Boot | `neanderfunk-ssid-changer` |
| `status-page/statuspage-respondd.sh` | Statusseite: Werte aus neanderfunk-respondd, live, inkl. Temperatur | `neanderfunk-respondd` |
| `status-page/web-static-version.sh` | Statusseite und Config-Mode: CSS/JS mit Versionsanhang gegen den Browser-Cache | |
| `status-page/statuspage-i18n.sh` | Statusseite: Texte der Neanderfunk-Zeilen aus dem eigenen Katalog statt fest im Template | `neanderfunk-status-page` |
| `status-page/statuspage-darkmode.sh` | Statusseite: Darkmode nach `prefers-color-scheme`, Farben aus dem Darkmode von `neanderfunk-config-mode-theme` | |
| `status-page/statuspage-ssid-owe-private.sh` | Statusseite: SSID des OWE-BSS und des privaten WLANs je Radio, sonst "aus"; nie den Schlüssel | `neanderfunk-status-page` |
| `status-page/statuspage-gateway-name.sh` | Statusseite: Gateway mit Hostnamen (per respondd vom Gateway selbst), MAC als Tooltip | `neanderfunk-status-page` (CGI `gateway-name`) |
| `status-page/statuspage-distance-wired.sh` | Statusseite: Entfernung nur bei WLAN-Nachbarn setzen; behebt einen TypeError aus Gluon bei Nachbarn am Kabel | |
| `setup-mode-network/setup-mode-hostnames.sh` | `gluon.setup` und `setup.gluon` per DNS auf 192.168.1.1 | |
| `setup-mode-network/setup-mode-captive.sh` | Portal-Erkennung der Clients führt auf die Setup-Seite | |
| `setup-mode-network/setup-mode-wifi.sh` | dnsmasq an br-setup, Portal-Umleitung | `neanderfunk-setup-wifi` |

Alle Skripte laufen post-update. `setup-mode-hostnames` und
`setup-mode-captive` brauchen kein Paket; sie gehören hierher, weil
`setup-mode-wifi` auf ihnen aufbaut und die Setup-Seite aus
`neanderfunk-setup-mode` das Ziel ist.

## Abhängigkeiten

* **`status-page/`** ist eine Kette auf dieselbe Datei: `moredetails` →
  `ssid` → `hwdetails` → `ethlinks` → `ssidchanger-zaehler` → `respondd` →
  `web-static-version` → `i18n` → `ssid-owe-private` (setzt auf `i18n` auf,
  läuft nach `darkmode`) → `gateway-name` → `distance-wired`. Nur in dieser Reihenfolge oder als Ganzes übernehmen.
  `statuspage-i18n` braucht das Feed-Paket `neanderfunk-status-page` für die
  Übersetzungen; ohne es erscheinen die Zeilen englisch.
  `statuspage-darkmode` ändert nur das Stylesheet und hängt an keinem
  Glied der Kette.
  Ohne `neanderfunk-respondd` entfallen Ethernet-Tabelle und Hardware-Zeilen;
  ohne `neanderfunk-ssid-changer` bleibt es bei einer Zahl statt der Zähler.
* **`setup-mode-network/`**: `setup-mode-captive` baut auf
  `setup-mode-hostnames` auf, `setup-mode-wifi` auf beiden.
  `setup-mode-wifi` ist nur mit dem Paket `neanderfunk-setup-wifi` sinnvoll;
  ohne das Paket ändert es nichts.
* Zwischen den beiden Gruppen gibt es keine Abhängigkeit, und keine der
  Dateien wird von den anderen Neanderfunk-Patch-Repos
  ([gluon-patches-hardware](https://github.com/Neanderfunk/gluon-patches-hardware),
  [gluon-patches-fixes](https://github.com/Neanderfunk/gluon-patches-fixes))
  berührt.

## Herkunft und Lizenz

Herausgelöst aus Neanderfunk/FirmwareConfigs (bis September 2026
Neanderfunk/firmware), Stand `851194f217a7fb165d101ed9c7b12a2597a9029e`,
Verzeichnisse `patches/status-page/` und `patches/setup-mode-network/`. Die
Geschichte der einzelnen Dateien steht dort.

`lib-patch.sh` ist eine Kopie; jedes Patch-Repo trägt seine eigene, damit es
allein nutzbar bleibt.

Skripte (`apply.sh`, `lib-patch.sh`, `*/*.sh`): BSD-3-Clause, siehe
`LICENSE`. Patchdateien stehen unter der Lizenz des Projekts, das sie
ändern: Gluon BSD-2-Clause.

### status-page/statuspage-portroles

Rolle je Ethernet-Port in der Statusseite (Wunsch adorfer 04.10.2026): bei DSA
eine dritte Spalte je Port mit der Rolle ausgeschrieben ("Uplink/VPN", "Mesh",
"Client", mehrere durch Komma). Bei swconfig-Geraeten (WDR3600 u. a.), wo
respondd keine einzelnen Ports kennt, eine Zeile je Gruppe ("LAN Mesh",
"WAN Uplink/VPN"). Quelle ist gluon.iface_* beim Laden der Seite. Texte im
Katalog neanderfunk-status-page. Getestet am Cudy WR3000S (DSA) und WDR3600
(swconfig).

Nebenbei (04.10.2026): Die Merkmale von statuspage-moredetails,
-hwdetails und -ethlinks standen nach der ganzen Kette nicht mehr im Baum
(spaetere Patches schreiben die Stellen um). Ein zweiter Lauf auf demselben
Baum brach deshalb ab. Jetzt Merkmale, die nach dem Patch und im Endstand
stehen (mesh_if.other, cpu_model, ethlinks); doppelt angewendet geprueft.

### status-page/statuspage-linkformat

Ethernet-Link kurz wie auf Switch-Aufklebern (Wunsch adorfer 04.10.2026):
"1000 FDX" / "100 HDX" mit bekannter Duplex-Angabe (DSA, eigene Karten),
sonst "1000TX". Lua-Format und JS-Formatierer nfLink (auch min.js).

