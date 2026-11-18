-- Offline-Test fuer config-mode/geo-location-domain-map.patch, ohne Gluon.
--
--   lua5.1 config-mode/geo-location-domain-map.test.lua <geo-location-osm.lua>
--
-- <geo-location-osm.lua> ist Gluons
-- package/gluon-config-mode-geo-location-osm/luasrc/usr/lib/lua/gluon/config-mode/geo-location-osm.lua
-- nach dem Patch. Geprueft wird, welche Domainwerte die Seite bekommt
-- (domain_maps) und wo die Karte startet (pos/zoom). Das Verhalten im Browser
-- (Karte folgt der Auswahl, bleibt bei gesetzter Position stehen) prueft
-- dieser Test nicht.

local module_file = assert(arg[1], 'Aufruf: lua5.1 geo-location-domain-map.test.lua <geo-location-osm.lua>')

local SITE_OSM = { center = { lat = 51.227356, lon = 6.948973 }, zoom = 8 }

-- Domain-Dateien wie im Multi-Image, als fertige Tabellen statt JSON
local DOMAIN_FILES = {
	['/lib/gluon/domains/01_vel.json'] = { neanderfunk_map = { center = { lat = 51.330611638, lon = 7.084465027 }, zoom = 12 } },
	['/lib/gluon/domains/21_dias.json'] = { neanderfunk_map = { center = { lat = 51.45, lon = 9.77 }, zoom = 5 } },
	['/lib/gluon/domains/25_hvb.json'] = {},                                                   -- ohne Eintrag
	['/lib/gluon/domains/30_sol.json'] = { neanderfunk_map = { center = { lat = 51.17 } } },   -- unvollstaendig
	['/lib/gluon/domains/31_lvrno.json'] = { neanderfunk_map = { center = { lat = 51.3, lon = 6.6 } } }, -- ohne zoom
}

-- Accessor wie gluon.site: site.a.b(default)
local function accessor(v)
	return setmetatable({}, {
		__index = function(_, k) return accessor(type(v) == 'table' and v[k] or nil) end,
		__call = function(_, default) if v == nil then return default end return v end,
	})
end

local function load_module(current_domain)
	local merged = { config_mode = { geo_location = { osm = SITE_OSM } } }
	local dom = current_domain and DOMAIN_FILES['/lib/gluon/domains/' .. current_domain .. '.json']
	if dom then
		for k, v in pairs(dom) do merged[k] = v end
	end
	package.loaded['gluon.site'] = accessor(merged)
	package.loaded['gluon.web.model.osm'] = { MapValue = {} }
	package.loaded['jsonc'] = { load = function(p) return DOMAIN_FILES[p] end }
	package.loaded['gluon.util'] = { glob = function(pattern)
		local dir = pattern:match('^(.*)/%*%.json$')
		local list = {}
		for p in pairs(DOMAIN_FILES) do
			if p:sub(1, #dir + 1) == dir .. '/' then table.insert(list, p) end
		end
		table.sort(list)
		return list
	end }
	return assert(loadfile(module_file))()
end

local failed, total = 0, 0
local function check(name, ok, detail)
	total = total + 1
	if ok then
		print('OK      ' .. name)
	else
		failed = failed + 1
		print('FEHLER  ' .. name .. (detail and (': ' .. detail) or ''))
	end
end

-- domain_maps
local M = load_module('21_dias')
local maps = M.options().domain_maps
check('01_vel mit Mittelpunkt und Zoom', maps['01_vel'] and maps['01_vel'].lat == 51.330611638
	and maps['01_vel'].lon == 7.084465027 and maps['01_vel'].zoom == 12)
check('21_dias mit Zoom 5', maps['21_dias'] and maps['21_dias'].zoom == 5)
check('25_hvb ohne Eintrag fehlt', maps['25_hvb'] == nil)
check('30_sol unvollstaendig (ohne lon) fehlt', maps['30_sol'] == nil)
check('31_lvrno ohne zoom: Mittelpunkt da, zoom nil', maps['31_lvrno'] and maps['31_lvrno'].lon == 6.6
	and maps['31_lvrno'].zoom == nil)

-- Startausschnitt
local o = M.options()
check('Start auf aktueller Domain 21_dias', o.pos.lat == 51.45 and o.pos.lon == 9.77 and o.zoom == 5,
	('pos %s/%s zoom %s'):format(tostring(o.pos.lat), tostring(o.pos.lon), tostring(o.zoom)))

o = load_module('25_hvb').options()
check('Start ohne Domaineintrag (25_hvb): Site-Werte', o.pos.lat == SITE_OSM.center.lat and o.zoom == 8)

o = load_module('31_lvrno').options()
check('Start mit Domain ohne zoom: Mittelpunkt der Domain, Zoom der Site',
	o.pos.lat == 51.3 and o.pos.lon == 6.6 and o.zoom == 8)

o = load_module(nil).options()
check('Single-Domain (kein Domaineintrag): Site-Werte', o.pos.lat == SITE_OSM.center.lat and o.zoom == 8)

local M2 = load_module(nil)
check('Ohne domains-Verzeichnis: leere Tabelle', next(M2.domain_maps('/nicht/da')) == nil)

print(('%d von %d Pruefungen bestanden'):format(total - failed, total))
os.exit(failed == 0 and 0 or 1)
