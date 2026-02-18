-- Atlas Legendary Eco v2.1
local UnitDefs = UnitDefs or {}
local baseFusions = { arm = "armafust3", cor = "corafust3", leg = "legafust3"}
local baseConverters = { arm = "armmmkrt3", cor = "cormmkrt3", leg = "legadveconvt3"}
local baseEnStorage = { arm = "armuwadves", cor = "coruwadves", leg = "legadvestore"}
local baseMeStorage = { arm = "armuwadvms", cor = "coruwadvms", leg = "legamstor"}
local evolvedSteps = {Epic = 2, Legendary = 10}
local s = string.rep
local NewFusions,NewConverters,NewEnStor,NewMeStor = {},{},{},{}
for faction, base in pairs(baseFusions) do
	local prefix,mult ="Legendary",10 do
		local unitName = faction .. "evfus" .. mult
		NewFusions[unitName] = {
			name = faction:upper().." "..prefix.." Fusion Reactor",
			description =
				"The "..prefix.." Fusion Reactor",
			customparams = { i18n_en_humanname = prefix.." Fusion Reactor", i18n_en_tooltip = "Produces " .. (mult * 30000) .. " Energy" },
		}
	end
end
for faction, base in pairs(baseConverters) do
	local prefix,mult ="Legendary",10 do
		local unitName = faction .. "mmkrt3" .. mult
		NewConverters[unitName] = {
			name = faction:upper().." "..prefix.." Energy Converter",
			description =
				"The "..prefix.." Energy Converter ",
			customparams = { i18n_en_humanname = prefix.." Energy Converter", i18n_en_tooltip = "Converts " .. (mult * 6000) .. " energy into " .. (mult * 150) .. " metal per sec (Hazardous)", },
		}
	end
end
for faction, base in pairs(baseEnStorage) do
	for prefix,mult in pairs(evolvedSteps) do
		local unitName = faction .. "uwadves" .. mult*5
		NewEnStor[unitName] = {
			name = faction:upper() .. " "..prefix.." Energy Storage",
			description =
				"The "..prefix.." Energy Storage ",
			customparams = { i18n_en_humanname = prefix.." Energy Storage", i18n_en_tooltip = "Increases Energy Storage (" .. (mult*5 * 40000) .. ")", },
		}
	end
end
for faction, base in pairs(baseMeStorage) do
	for prefix,mult in pairs(evolvedSteps) do
		local unitName = faction .. "uwadvms" .. mult*5
		NewMeStor[unitName] = {
			name = faction:upper() .. " "..prefix.." Metal Storage",
			description =
				"The "..prefix.." Metal Storage ",
			customparams = { i18n_en_humanname = prefix.." Metal Storage", i18n_en_tooltip = "Increases Energy Metal (" .. (mult*5 * 10000) .. ")", },
		}
	end
end
for faction, baseFusion in pairs(baseFusions) do
	if UnitDefs[baseFusion] then
		local basefus = UnitDefs[baseFusion]
		local prefix,mult ="Legendary",10 do
			local f = NewFusions[faction .. "evfus" .. mult]
			if f then
				f.metalcost = basefus.metalcost * mult
				f.energycost = basefus.energycost * mult
				f.energymake = basefus.energymake * mult
				f.energystorage = basefus.energystorage * mult
				if not UnitDefs[faction .. "evfus" .. mult] then
					UnitDefs[faction .. "evfus" .. mult] = table.merge(basefus, f)
					UnitDefs[faction .. "evfus" .. mult].customparams = UnitDefs[faction .. "evfus" .. mult].customparams or {}
				end
			end
		end
	end
end
for faction, baseConverter in pairs(baseConverters) do
	if UnitDefs[baseConverter] then
		local basemmkrt3 = UnitDefs[baseConverter]
		local prefix,mult ="Legendary",10 do
			local c = NewConverters[faction .. "mmkrt3" .. mult]
			if c then
				c.metalcost = basemmkrt3.metalcost * mult
				c.energycost = basemmkrt3.energycost * mult
				c.customparams.energyconv_capacity = basemmkrt3.customparams.energyconv_capacity * mult
				c.customparams.energyconv_efficiency = 0.025
				if not UnitDefs[faction .. "mmkrt3" .. mult] then
					UnitDefs[faction .. "mmkrt3" .. mult] = table.merge(basemmkrt3, c)
					UnitDefs[faction .. "mmkrt3" .. mult].customparams = UnitDefs[faction .. "mmkrt3" .. mult].customparams or {}
				end
			end
		end
	end
end
for faction, baseEnStor in pairs(baseEnStorage) do
	if UnitDefs[baseEnStor] then
		local basefus = UnitDefs[baseEnStor]
		for prefix,mult in pairs(evolvedSteps) do
			local f = NewEnStor[faction .. "uwadves" .. mult*5]
			if f then
				f.metalcost = basefus.metalcost * mult*5
				f.energycost = basefus.energycost * mult*5
				f.energystorage = basefus.energystorage * mult*5
				if not UnitDefs[faction .. "uwadves" .. mult*5] then
					UnitDefs[faction .. "uwadves" .. mult*5] = table.merge(basefus, f)
					UnitDefs[faction .. "uwadves" .. mult*5].customparams = UnitDefs[faction .. "uwadves" .. mult*5].customparams or {}
				end
			end
		end
	end
end
for faction, baseMeStor in pairs(baseMeStorage) do
	if UnitDefs[baseMeStor] then
		local basefus = UnitDefs[baseMeStor]
		for prefix,mult in pairs(evolvedSteps) do
			local f = NewMeStor[faction .. "uwadvms" .. mult*5]
			if f then
				f.metalcost = basefus.metalcost * mult*5
				f.energycost = basefus.energycost * mult*5
				f.metalstorage = basefus.metalstorage * mult*5
				if not UnitDefs[faction .. "uwadvms" .. mult*5] then
					UnitDefs[faction .. "uwadvms" .. mult*5] = table.merge(basefus, f)
					UnitDefs[faction .. "uwadvms" .. mult*5].customparams = UnitDefs[faction .. "uwadvms" .. mult*5].customparams or {}
				end
			end
		end
	end
end

local builders = { arm = { "armaca", "armack", "armacsub", "armacv" }, cor = { "coraca", "corack", "coracsub", "coracv" }, leg = { "legaca", "legack", "legacv", "legcomt2com" }, }
local function addBuildOption(unitDef, option)
	for _, existing in ipairs(unitDef.buildoptions) do if existing == option then return end end
	table.insert(unitDef.buildoptions, option)
end
for faction, blds in pairs(builders) do
	for _, builder in ipairs(blds) do
		local unitDef = UnitDefs[builder]
		if unitDef and unitDef.buildoptions then
			addBuildOption(unitDef, faction .. "evfus" .. 10)
			addBuildOption(unitDef, faction .. "mmkrt3" .. 10)
			for prefix,mult in pairs(evolvedSteps) do
				addBuildOption(unitDef, faction .. "uwadves".. mult*5)
				addBuildOption(unitDef, faction .. "uwadvms" .. mult*5)
			end
		end
	end
end
