--Atlas Vanilla+ v1.2.0
local UnitDefs = UnitDefs or {}
local function deepcopy(a)
	local b = type(a)
	local c; if b == 'table' then
		c = {}
		for d, e in next, a, nil do c[deepcopy(d)] = deepcopy(e) end; setmetatable(c, deepcopy(getmetatable(a)))
	else
		c = a
	end; return c
end
local function copybuildoptions(sourcedef,targetdef)
	if sourcedef == nil then return end
	local k = deepcopy(sourcedef.buildoptions)
	targetdef.buildoptions = {}
	for l, m in ipairs(k) do targetdef.buildoptions[l] = m end
end
do --building nanos
	local f = { 'arm', 'cor', 'leg' }
	for g, h in ipairs(f) do
		do--tier 1 land
			local i = { h .. 'nanotc', h .. 'respawn', 'legnanotcbase' }
			for g, j in ipairs(i) do
				if UnitDefs[j] then
					copybuildoptions(UnitDefs[h .. 'ck'],UnitDefs[j])
				end
			end
		end

		do --tier 1 navy
			local n = { h .. 'frock', h .. 'gplat'}
			if UnitDefs[h .. 'nanotcplat'] then
				local cs = h .. 'cs'
				local o = {}
				if h == 'leg' then
					cs = 'legnavyconship'
					o = {'legfhive'}
				end
				for g, m in ipairs(o) do
					table.insert(n, m)
				end;
				copybuildoptions(UnitDefs[cs],UnitDefs[h .. 'nanotcplat'])
				for g, m in ipairs(n) do
					table.insert(UnitDefs[h .. 'nanotcplat'].buildoptions, m)
				end
			end
		end

		do --tier2 land
			local n = { h .. 'apt3', h .. 'afust3', h .. 'gatet3', h .. 'nanotct2', h .. 'wint2', h .. 'aap', h .. 'avp' } --extra units that aren't part of the default
			local o = {}
			if h == 'arm' then
				o = { 'armminivulc', 'armbotrail', 'armannit3', 'armmmkrt3', 'armshockwave', 'armlwall' }
			elseif h == 'cor' then
				o = {
					'corminibuzz', 'corhllllt', 'cordoomt3', 'cormmkrt3', 'cormwall' }
			elseif h == 'leg' then
				o = {
					'legministarfall', 'legadveconvt3', 'legmohocon', 'legrwall' }
			end;
			for g, m in ipairs(o) do
				table.insert(n, m)
			end;
			if UnitDefs[h .. 'nanotct2'] then
				copybuildoptions(UnitDefs[h .. 'ack'], UnitDefs[h .. 'nanotct2'])
				for g, m in ipairs(n) do
					table.insert(UnitDefs[h .. 'nanotct2'].buildoptions, m)
				end
			end
		end
		
		do--tier2 sea
			local n = { h .. 'fgate', h .. 'nanotc2plat'}
			if UnitDefs[h .. 'nanotc2plat'] then
				copybuildoptions(UnitDefs[h .. 'acsub'], UnitDefs[h .. 'nanotc2plat'])
				for g, m in ipairs(n) do
					table.insert(UnitDefs[h .. 'nanotc2plat'].buildoptions, m)
				end
			end
		end
	end
end
local mines = { --MiningMines
	armmine1 = "Light",
	armmine2 = "Medium",
	armmine3 = "Heavy",
	cormine1 = "Light",
	cormine2 = "Medium",
	cormine3 = "Heavy",
	cormine4 = "Medium", --commando mine
	legmine1 = "Light",
	legmine2 = "Medium",
	legmine3 = "Heavy",
}
local function getminername(base) return "miningmines_mining_"..base end
local function getlevelname(base) return "miningmines_level_"..base end do
	
	local weapondefs = {
		Light = {
			areaofeffect = 100,
			craterboost = 1,
			cratermult = 75,
			edgeeffectiveness = 0.5,
			explosiongenerator = "custom:genericunitexplosion-small-dirty",
			impulsefactor = 1,
			name = "LightMiningMine",
			range = 100,
			reloadtime = 3.6,
			soundhit = "mine1",
			soundstart = "largegun",
			weaponvelocity = 250,
			damage = {
				default = 115,
				mines = 1,
			},
		},
		Medium = {
			areaofeffect = 125,
			craterboost = 1,
			cratermult = 130,
			edgeeffectiveness = 0.5,
			explosiongenerator = "custom:genericunitexplosion-medium-dirty",
			impulsefactor = 1,
			name = "MediumMiningMine",
			range = 125,
			reloadtime = 3.6,
			soundhit = "xplomed1",
			soundstart = "largegun",
			weaponvelocity = 250,
			damage = {
				default = 260,
				mines = 1,
			},
		},
		Heavy = {
			areaofeffect = 160,
			craterboost = 1,
			cratermult = 200,
			edgeeffectiveness = 0.5,
			explosiongenerator = "custom:genericunitexplosion-large-dirty",
			impulsefactor = 1,
			name = "HeavyMiningMine",
			range = 160,
			reloadtime = 3.6,
			soundhit = "xplolrg3",
			soundstart = "largegun",
			weaponvelocity = 250,
			damage = {
				default = 1000,
				mines = 1,
			},
		},
	}
	
	local function createMiner(base_unit,mine_type)
		if base_unit == nil or mine_type == nil then
			return
		end

		local og = UnitDefs[base_unit]
		if og == nil then
			return
		end

		local new_unit_name = getminername(base_unit)

		local new_unit_def = deepcopy(og)
		new_unit_def.unitname=new_unit_name
		new_unit_def.icontype=base_unit
		new_unit_def.maxthisunit=nil

		new_unit_def.footprintx = 3
		new_unit_def.footprintz = 3
		
		new_unit_def.buildtime = new_unit_def.buildtime*20
		new_unit_def.metalcost = new_unit_def.metalcost*10
		new_unit_def.energycost = new_unit_def.energycost*5
		new_unit_def.cloakcost = new_unit_def.cloakcost

		local new_unit_customparams = new_unit_def.customparams
		new_unit_customparams.i18n_en_humanname=mine_type.." Mining Mine"
		new_unit_customparams.i18n_en_tooltip="An expensive mine that will make a "..mine_type.." crater"

		local weapondef = weapondefs[mine_type]
		local weaponname = weapondef.name
		new_unit_def.weapondefs[weaponname] = weapondef

		new_unit_def.explodeas=weaponname
		new_unit_def.selfdestructas=weaponname

		UnitDefs[new_unit_name] = new_unit_def
	end
	local function createLevel(base_unit,mine_type)
		if base_unit == nil or mine_type == nil then
			return
		end

		local og = UnitDefs[base_unit]
		if og == nil then
			return
		end

		local new_unit_name = getlevelname(base_unit)

		local new_unit_def = deepcopy(og)
		new_unit_def.unitname=new_unit_name
		new_unit_def.maxthisunit=nil
		new_unit_def.maxslope=90
		new_unit_def.levelground = true

		local weapondef = weapondefs[mine_type]
		new_unit_def.footprintx = math.ceil(weapondef.areaofeffect/16)
		new_unit_def.footprintz = math.ceil(weapondef.areaofeffect/16)

		local new_unit_customparams = new_unit_def.customparams
		new_unit_customparams.i18n_en_humanname=mine_type.." Leveling Mine"
		new_unit_customparams.i18n_en_tooltip="A mine that will require flattening of the build area prior to building the mine itself."

		UnitDefs[new_unit_name] = new_unit_def
	end
	for name,type in pairs(mines) do
		createMiner(name,type)
		createLevel(name,type)
	end
end
local dragons = {
	corcrw = "Archaic Dragon Deez",
	corcrwh = "Dragon Deez",
	corcrwt4 = "Dragon Deez Epic",
}
for uN, uD in pairs(UnitDefs) do
	if uD.yardmap or uD.speed == 0.0 then --BuildAnywhere
		uD.maxslope=255
		uD.levelground = uD.levelground or false
	end

	if type(uD.buildoptions) == "table" then --MiningMines
		for i,buildname in ipairs(uD.buildoptions) do
			if mines[buildname] ~= nil then
				table.insert(uD.buildoptions,getminername(buildname))
				table.insert(uD.buildoptions,getlevelname(buildname))
			end
		end
	end

	if type(uD.transportcapacity) == "number" and uD.transportcapacity > 0 then --TeraTransports
		uD.transportcapacity=1
		uD.transportsize=12000
		uD.transportmass=99999999
		uD.isFirePlatform = true
		uD.unloadspread=math.max(uD.unloadspread or 0,1)
	else
		uD.cantbetransported = false
	end
	local c=uD.customparams or {}
	uD.customparams=c
	c.paratrooper=true
	c.fall_damage_multiplier=math.min(c.fall_damage_multiplier or 5,0.25)

	local drag = dragons[uN]
	if drag then
		uD.customparams.i18n_en_humanname=drag.." Nutz"
	end
end