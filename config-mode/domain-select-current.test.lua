-- Offline-Test fuer config-mode/domain-select-current.patch, ohne Gluon.
--
--   lua5.1 config-mode/domain-select-current.test.lua <0200-domain-select.lua>
--
-- Laedt Gluons Wizard-Datei (gepatcht oder nicht) mit nachgebauten
-- gluon-web-Objekten und prueft je Fall die Liste und die Vorbelegung.
-- Gegen die ungepatchte Datei schlaegt Fall "frisch" fehl, das ist der
-- Fehler, den der Patch behebt.

local wizard_file = assert(arg[1], 'Aufruf: lua5.1 domain-select-current.test.lua <0200-domain-select.lua>')

-- Domains wie im Multi-Image: 25_hvb ist default_domain und versteckt,
-- 26_knr ein weiteres verstecktes, 19_agi steht nach Namen vorne.
local DOMAINS = {
	['19_agi'] = { name = 'Agios' },
	['13_dusfl'] = { name = 'Duesseldorf-Flingern' },
	['17_wip'] = { name = 'Wipperfuerth' },
	['25_hvb'] = { name = 'Halteverbot - bitte eine andere Domain waehlen', hide = true },
	['26_knr'] = { name = 'Kaarst-Neuss-Rhein', hide = true },
}
local DEFAULT_DOMAIN = '25_hvb'

local function run(case)
	-- Umgebung je Lauf neu, die Wizard-Datei bekommt sie ueber setfenv
	local paths = {}
	for code in pairs(DOMAINS) do table.insert(paths, '/lib/gluon/domains/' .. code .. '.json') end
	table.sort(paths)

	local stubs = {
		jsonc = { load = function(path)
			local code = path:match('([^/]+)%.json$')
			local d = assert(DOMAINS[code])
			return { domain_names = { [code] = d.name }, hide_domain = d.hide or false }
		end },
		['gluon.site'] = { default_domain = function() return DEFAULT_DOMAIN end },
		['gluon.util'] = {
			glob = function() return paths end,
			contains = function(t, v) for _, x in ipairs(t) do if x == v then return true end end return false end,
		},
	}

	local option
	local env = setmetatable({
		require = function(name) return assert(stubs[name], 'unerwartetes require ' .. name) end,
		i18n = function() return { translate = function(s) return s end } end,
		Section = {},
		ListValue = {},
	}, { __index = _G })

	local form = { section = function(_, _, _, _)
		return { option = function(_, _, _, _)
			option = { values = {} }
			function option:value(code, name) table.insert(self.values, code) end
			return option
		end }
	end }

	local uci = {
		get = function(_, pkg, sec, opt)
			if pkg == 'gluon' and sec == 'core' and opt == 'domain' then return case.domain end
		end,
		get_first = function(_, pkg, typ, opt)
			if pkg == 'gluon-setup-mode' and opt == 'configured' then return case.configured end
		end,
	}

	local chunk = assert(loadfile(wizard_file))
	setfenv(chunk, env)
	chunk()(form, uci)
	return option
end

local function has(list, v) for _, x in ipairs(list) do if x == v then return true end end return false end

local cases = {
	{
		name = 'frisch: keine Altwerte, 005-set-domain hat default_domain gesetzt',
		domain = '25_hvb', configured = '0',
		default = '25_hvb', listed = { '25_hvb' }, hidden = { '26_knr' },
	},
	{
		name = 'Altwerte erkannt: 004 hat 17_wip gesetzt, noch nicht konfiguriert',
		domain = '17_wip', configured = '0',
		default = '17_wip', listed = { '17_wip' }, hidden = { '25_hvb', '26_knr' },
	},
	{
		name = 'Altwerte erkannt auf versteckte Domain 26_knr',
		domain = '26_knr', configured = '0',
		default = '26_knr', listed = { '26_knr' }, hidden = { '25_hvb' },
	},
	{
		name = 'schon konfiguriert auf 13_dusfl',
		domain = '13_dusfl', configured = '1',
		default = '13_dusfl', listed = { '13_dusfl' }, hidden = { '25_hvb', '26_knr' },
	},
	{
		name = 'schon konfiguriert, aber in 25_hvb geblieben',
		domain = '25_hvb', configured = '1',
		default = '25_hvb', listed = { '25_hvb' }, hidden = { '26_knr' },
	},
}

local failed = 0
for _, c in ipairs(cases) do
	local o = run(c)
	local errs = {}
	if o.default ~= c.default then
		table.insert(errs, ('Vorbelegung %s statt %s'):format(tostring(o.default), c.default))
	end
	for _, v in ipairs(c.listed) do
		if not has(o.values, v) then table.insert(errs, v .. ' fehlt in der Liste') end
	end
	for _, v in ipairs(c.hidden) do
		if has(o.values, v) then table.insert(errs, v .. ' steht in der Liste, sollte versteckt sein') end
	end
	if o.default and not has(o.values, o.default) then
		table.insert(errs, 'Vorbelegung ' .. o.default .. ' steht nicht in der Liste')
	end
	if #errs == 0 then
		print('OK      ' .. c.name)
	else
		failed = failed + 1
		print('FEHLER  ' .. c.name .. ': ' .. table.concat(errs, '; '))
	end
end
print(('%d von %d Faellen bestanden'):format(#cases - failed, #cases))
os.exit(failed == 0 and 0 or 1)
