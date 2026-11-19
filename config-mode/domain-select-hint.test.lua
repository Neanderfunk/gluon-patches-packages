-- Offline-Test fuer config-mode/domain-select-hint.patch, ohne Gluon.
--
--   lua5.1 config-mode/domain-select-hint.test.lua <0200-domain-select.lua>
--
-- Prueft: Fuer eine Domain mit Site-Text gluon-config-mode:domain-hint:<code>
-- entsteht genau ein Hinweis (model/warning), sichtbar nur bei dieser Domain
-- (depends auf die Domain-Auswahl), Text escaped. Domains ohne Text bekommen
-- keinen. Gegen die Datei ohne diesen Patch schlaegt er fehl (kein Hinweis).

local wizard_file = assert(arg[1], 'Aufruf: lua5.1 domain-select-hint.test.lua <0200-domain-select.lua>')

local DOMAINS = {
	['01_vel'] = { name = 'Velbert' },
	['06_han'] = { name = 'Haan' },
	['25_hvb'] = { name = 'Halteverbot', hide = true },
}
local HINTS = { ['gluon-config-mode:domain-hint:25_hvb'] = 'Bitte nicht hier & <b>nicht</b> dort.' }

local paths = {}
for code in pairs(DOMAINS) do table.insert(paths, '/lib/gluon/domains/' .. code .. '.json') end

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
	['gluon.web.util'] = { pcdata = function(s)
		return (s:gsub('&', '&amp;'):gsub('<', '&lt;'):gsub('>', '&gt;'))
	end },
}

local elements = {}
local option
local env = setmetatable({
	require = function(name) return assert(stubs[name], 'unerwartetes require ' .. name) end,
	i18n = function() return {
		translate = function(s) return s end,
		_translate = function(s) return HINTS[s] end,
	} end,
	Section = {},
	ListValue = {},
}, { __index = _G })

local form = { section = function()
	return {
		option = function()
			option = { value = function() end }
			return option
		end,
		element = function(_, template, kv, name)
			local e = { template = template, content = kv.content, name = name, deps = {} }
			function e:depends(field, value) table.insert(self.deps, { field = field, value = value }) end
			table.insert(elements, e)
			return e
		end,
	}
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

local function fail(msg) print('FEHLER  ' .. msg) os.exit(1) end
if #elements ~= 1 then fail('erwartet 1 Hinweis, bekommen ' .. #elements) end
local e = elements[1]
if e.template ~= 'model/warning' then fail('Vorlage ' .. tostring(e.template)) end
if e.content ~= 'Bitte nicht hier &amp; &lt;b&gt;nicht&lt;/b&gt; dort.' then fail('Text nicht escaped: ' .. tostring(e.content)) end
if #e.deps ~= 1 or e.deps[1].field ~= option or e.deps[1].value ~= '25_hvb' then
	fail('Hinweis haengt nicht an Domain-Auswahl = 25_hvb')
end
print('OK      Hinweis nur bei 25_hvb, aus Site-i18n, escaped')
os.exit(0)
