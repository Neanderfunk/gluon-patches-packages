-- Offline-Test fuer config-mode/domain-select-code.patch, ohne Gluon.
--
--   lua5.1 config-mode/domain-select-code.test.lua <0200-domain-select.lua>
--
-- Prueft Beschriftung ("01_vel: Velbert") und Reihenfolge (nach Code) der
-- Domain-Auswahl. Gegen die Datei ohne diesen Patch schlaegt er fehl (Name
-- ohne Code, Reihenfolge nach Name).

local wizard_file = assert(arg[1], 'Aufruf: lua5.1 domain-select-code.test.lua <0200-domain-select.lua>')

-- Nach Name waere die Reihenfolge Agios, Haan, Velbert; nach Code ist sie
-- 01_vel, 06_han, 19_agi. 25_hvb ist versteckt, aber die aktuelle Domain.
local DOMAINS = {
	['19_agi'] = { name = 'Agios' },
	['06_han'] = { name = 'Haan' },
	['01_vel'] = { name = 'Velbert' },
	['25_hvb'] = { name = 'Halteverbot - bitte eine andere Domain waehlen', hide = true },
}

local paths = {}
for code in pairs(DOMAINS) do table.insert(paths, '/lib/gluon/domains/' .. code .. '.json') end
table.sort(paths, function(a, b) return a > b end) -- glob-Reihenfolge darf nicht zaehlen

local stubs = {
	jsonc = { load = function(path)
		local code = path:match('([^/]+)%.json$')
		local d = assert(DOMAINS[code])
		return { domain_names = { [code] = d.name }, hide_domain = d.hide or false }
	end },
	['gluon.site'] = { default_domain = function() return '25_hvb' end },
	['gluon.util'] = {
		glob = function() return paths end,
		contains = function(t, v) for _, x in ipairs(t) do if x == v then return true end end return false end,
	},
	-- ab domain-select-hint
	['gluon.web.util'] = { pcdata = function(s) return s end },
}

local values = {}
local env = setmetatable({
	require = function(name) return assert(stubs[name], 'unerwartetes require ' .. name) end,
	i18n = function() return { translate = function(s) return s end, _translate = function() return nil end } end,
	Section = {},
	ListValue = {},
}, { __index = _G })

local form = { section = function()
	return { option = function()
		local o = {}
		function o:value(code, label) table.insert(values, code .. '=' .. label) end
		return o
	end }
end }

local uci = {
	get = function(_, pkg, sec, opt)
		if pkg == 'gluon' and sec == 'core' and opt == 'domain' then return '25_hvb' end
	end,
	get_first = function() return '0' end,
}

local chunk = assert(loadfile(wizard_file))
setfenv(chunk, env)
chunk()(form, uci)

local want = {
	'01_vel=01_vel: Velbert',
	'06_han=06_han: Haan',
	'19_agi=19_agi: Agios',
	'25_hvb=25_hvb: Halteverbot - bitte eine andere Domain waehlen',
}
local got = table.concat(values, ' | ')
if got == table.concat(want, ' | ') then
	print('OK      Beschriftung "Code: Name", Reihenfolge nach Code')
	os.exit(0)
end
print('FEHLER  erwartet: ' .. table.concat(want, ' | '))
print('        bekommen: ' .. got)
os.exit(1)
