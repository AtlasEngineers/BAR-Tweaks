--T3 Flying AntiAir v5.11-alpha
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
local function modname(n) return "t3aa_"..n end
local newUnits = {
	armfepocht4 = {function(origDef)
		local newDef = deepcopy(origDef)
		newDef.health = 87000
		newDef.category = "ALL WEAPON VTOL NOTSUB NOTHOVER"
		newDef.nochasecategory = "ALL"
		local cpm = newDef.customparams or {}
		cpm.i18n_en_humanname = "Flying AA Epoch"
		cpm.i18n_en_tooltip = "Anti-Air Flagship with VTOL thrusters"
		cpm.armordef = "VTOL"
		newDef.customparams = cpm

		local wD = newDef.weapondefs
		wD.ferret_missile = deepcopy(UnitDefs.armcir.weapondefs.arm_cir)
		wD.mediumplasma = deepcopy(UnitDefs.armfepocht4.weapondefs.mediumplasma)
		local mp = wD.mediumplasma
		mp.name = "Secondary AA rapid-fire heavy plasma cannon"
		mp.accuracy = 250
		mp.areaofeffect = 172
		mp.avoidfriendly = false
		mp.burnblow = true
		mp.collidefriendly = false
		mp.cylindertargeting = 1
		mp.edgeeffectiveness = 1
		mp.predictboost = 1
		mp.reloadtime = 0.5
		mp.weaponvelocity = 1600
		mp.range = 1500
		mp.damage = {vtol=650}

		wD.heavyplasma = deepcopy(UnitDefs.armfepocht4.weapondefs.heavyplasma)
		local hp = wD.heavyplasma
		hp.name = "Primary AA rapid-fire heavy long-range plasma cannon"
		hp.accuracy = 100
		hp.areaofeffect = 350
		hp.avoidfriendly = false
		hp.burnblow = true
		hp.collidefriendly = false
		hp.cylindertargeting = 1
		hp.edgeeffectiveness = 1
		hp.predictboost = 1
		hp.reloadtime = 0.5
		hp.weaponvelocity = 1800
		hp.range = 2500
		hp.damage = {vtol=1500}

		for i,w in pairs(newDef.weapons) do
			w.badtargetcategory = "NOTAIR"
			w.onlytargetcategory = "VTOL"
		end
		return newDef
	end},
	armlichet4 = {function(origDef)
		local newDef = deepcopy(origDef)
		newDef.category = "ALL WEAPON VTOL NOTSUB NOTHOVER"
		newDef.nochasecategory = "ALL"
		newDef.energycost = newDef.energycost/1.5
		newDef.metalcost = newDef.metalcost/1.5
		newDef.firestate = -1
		newDef.stealth = true
		newDef.canCloak = true
		newDef.initCloaked = true
		newDef.mincloakdistance = 250
		newDef.cloakcost = 100
		newDef.decloakSphereical = false
		newDef.cruisealtitude = 160
		local cpm = newDef.customparams or {}
		cpm.i18n_en_humanname = "Epic Zephyr"
		cpm.i18n_en_tooltip = "Large Cloaking Fighter with Nuclear AA Missile"
		cpm.armordef = "VTOL"
		cpm.fighter = 1
		cpm.attacksafetydistance = 300
		newDef.customparams = cpm

		local wD = newDef.weapondefs
		wD.nuclear_missile = deepcopy(UnitDefs.armlichet4.weapondefs.nuclear_missile)
		local nm = wD.nuclear_missile
		nm.name = "Nuclear Anti-Air Missile"
		nm.burnblow = true
		nm.impulsefactor = 4
		nm.cratermult = 0
		nm.collideenemy = true
		nm.edgeeffectiveness = 0.45
		nm.turnrate=28000
		nm.weaponacceleration=250
		nm.weapontimer=7
		nm.weaponvelocity=970
		nm.flighttime=2
		nm.mygravity=0
		nm.startvelocity = 515
		nm.range=800
		nm.tolerance=8000
		nm.tracks=true
		nm.weapontype="MissileLauncher"
		nm.damage = {vtol = 50000}

		for i,w in pairs(newDef.weapons) do
			w.badtargetcategory = "NOTAIR"
			w.onlytargetcategory = "VTOL"
		end
		return newDef
	end,nil,"armliche"},
	armliche = {function(origDef)
		local newDef = deepcopy(origDef)
		newDef.category = "ALL WEAPON VTOL NOTSUB NOTHOVER"
		newDef.nochasecategory = "ALL"
		newDef.firestate = -1
		newDef.health = 1000
		newDef.energycost = newDef.energycost/2
		newDef.metalcost = newDef.metalcost/4
		newDef.buildtime = 31500
		newDef.canCloak = true
		newDef.initCloaked = true
		newDef.mincloakdistance = 40
		newDef.cloakcost = 10
		newDef.speed = 358.8
		newDef.decloakSphereical = false
		newDef.cruisealtitude = 160
		local cpm = newDef.customparams or {}
		cpm.i18n_en_humanname = "Zephyr"
		cpm.i18n_en_tooltip = "Cloaking Fighter"
		cpm.armordef = "VTOL"
		cpm.fighter = 1
		cpm.attacksafetydistance = 300
		newDef.customparams = cpm

		local wD = newDef.weapondefs
		wD.arm_pidr = deepcopy(UnitDefs.armhawk.weapondefs.armvtol_advmissile)
		wD.arm_pidr.burst = 2
		wD.arm_pidr.range = 990
		for i,w in pairs(newDef.weapons) do
			w.badtargetcategory = "NOTAIR"
			w.onlytargetcategory = "VTOL"
		end
		return newDef
	end,nil,"armhawk"},
	armdfly = {function(origDef)
		local newDef = deepcopy(origDef)
		newDef.category = "ALL WEAPON VTOL NOTSUB NOTHOVER"
		newDef.nochasecategory = "ALL"
		newDef.stealth = true
		newDef.health = newDef.health*4
		newDef.energycost = newDef.energycost*25
		newDef.metalcost = newDef.metalcost*25
		newDef.canCloak = true
		newDef.initCloaked = true
		newDef.mincloakdistance = 200
		newDef.cloakcost = 50
		newDef.speed = 150
		newDef.decloakSphereical = false
		newDef.transportcapacity=1
		newDef.transportsize=12000
		newDef.transportmass=99999999
		newDef.isFirePlatform = true
		newDef.cruisealtitude = 60
		local cpm = newDef.customparams or {}
		cpm.i18n_en_humanname = "Epic Abductor"
		cpm.i18n_en_tooltip = "Cloaking Flying Fire Platform (Transport)"
		cpm.armordef = "VTOL"
		cpm.techlevel = 3
		newDef.customparams = cpm

		newDef.weapons = {}

		return newDef
	end,"armapt3"},
	
	corcrw = {function(origDef)
		local newDef = deepcopy(origDef)
		newDef.category = "ALL WEAPON VTOL NOTSUB NOTHOVER"
		newDef.cruisealtitude = 230
		newDef.health = newDef.health/2
		newDef.nochasecategory = "NOTAIR VTOL"
		local cpm = newDef.customparams or {}
		cpm.i18n_en_humanname = "AA Archaic Dragon"
		cpm.i18n_en_tooltip = "Supportive Flying Anti-Air Fortress"
		cpm.armordef = "VTOL"
		newDef.customparams = cpm

		local wD = newDef.weapondefs
		wD.krowlaser = deepcopy(UnitDefs.corcrw.weapondefs.krowlaser2)
		local sL = wD.krowlaser
		sL.avoidfriendly = false
		sL.collidefriendly = false
		sL.name = "High Energy Anti-Air Laser"
		sL.predictboost = 1
		sL.range = 1250
		sL.reloadtime = 1.3
		sL.damage = {
			vtol = 300,
		}

		wD.krowlaser2 = deepcopy(UnitDefs.cordoom.weapondefs.atadr)
		local mL = wD.krowlaser2
		mL.avoidfriendly = false
		mL.collidefriendly = false
		mL.name = "Long-Range Anti-Air Tachyon Accelerator"
		mL.predictboost = 1
		mL.range = 1500
		mL.reloadtime = 1.5
		mL.damage = {
			vtol = 750,
		}

		

		for i,w in pairs(newDef.weapons) do
			--if w.def == "SEMIAUTO" or w.def == "PLASMA" then
				w.badtargetcategory = "NOTAIR"
				w.onlytargetcategory = "VTOL"
			--end
		end

		return newDef
	end,"coraap"},
	corcrwh = {function(origDef)
		local newDef = deepcopy(origDef)
		newDef.category = "ALL WEAPON VTOL NOTSUB NOTHOVER"
		newDef.cruisealtitude = 220
		newDef.nochasecategory = "NOTAIR"
		local cpm = newDef.customparams or {}
		cpm.i18n_en_humanname = "AA Dragon"
		cpm.i18n_en_tooltip = "Aggressive Flying Anti-Air Fortress"
		cpm.armordef = "VTOL"
		newDef.customparams = cpm

		local wD = newDef.weapondefs
		local sL = wD.krowlaserh
		sL.avoidfriendly = false
		sL.collidefriendly = false
		sL.name = "Anti-Air Laser"
		sL.predictboost = 1
		sL.range = 750
		sL.reloadtime = 1.3
		sL.damage = {
			vtol = 300,
		}

		wD.dragonmawh = deepcopy(UnitDefs.corcrwh.weapondefs.dragonmawh)
		local mL = wD.dragonmawh
		mL.avoidfriendly = true
		mL.collidefriendly = false
		mL.name = "Dragon's Maw: Heavy medium range AA AoE flamethrower"
		mL.predictboost = 1
		mL.range = 750
		mL.damage = {
			vtol = 50,
		}

		for i,w in pairs(newDef.weapons) do
			w.badtargetcategory = "NOTAIR"
			w.onlytargetcategory = "VTOL"
			if w.def == "dragonmawh" then
				w.fastautoretargeting = true
			end
		end

		return newDef
	end},
	corcrwt4 = {function(origDef)
		local newDef = deepcopy(origDef)
		newDef.category = "ALL WEAPON VTOL NOTSUB NOTHOVER"
		newDef.cruisealtitude = 260
		newDef.health = 87000
		newDef.energycost = newDef.energycost*1.5
		newDef.metalcost = newDef.metalcost*1.5
		newDef.nochasecategory = "NOTAIR"
		local cpm = newDef.customparams or {}
		cpm.i18n_en_humanname = "Epic AA Dragon"
		cpm.i18n_en_tooltip = "Gigantic Aggressive Flying Anti-Air Fortress (WILL HURT FRIENDLY AIR)"
		cpm.armordef = "VTOL"
		newDef.customparams = cpm

		local wD = newDef.weapondefs
		wD.kmaw = deepcopy(UnitDefs.corjugg.weapondefs.juggernaut_fire)
		local mC = wD.kmaw
		mC.avoidfriendly = true
		mC.collidefriendly = false
		mC.gravityaffected = false
		mC.name = "Nuclear Flak Cannon"
		mC.predictboost = 1
		mC.range = 750
		mC.cylinderTargeting = 1
		mC.reloadtime = 5
		mC.weaponvelocity = 7500
		mC.damage = {
			vtol = 2400,
		}

		wD.krowbosslaser = deepcopy(UnitDefs.cordoom.weapondefs.atadr)
		local wS1 = wD.krowbosslaser
		wS1.avoidfriendly = false
		wS1.collidefriendly = false
		wS1.name = "Long-Range Anti-Air Tachyon Accelerator"
		wS1.predictboost = 1
		wS1.range = 1500
		wS1.reloadtime = 1.5
		wS1.damage = {
			vtol = 100,
		}

		wD.krowbosslaser2 = deepcopy(UnitDefs.corcrwt4.weapondefs.kmaw)
		local wS2 = wD.krowbosslaser2
		wS2.avoidfriendly = true
		wS2.collidefriendly = false
		wS2.name = "Demon's Maw; Heavy long range AA AoE flamethrower"
		wS2.predictboost = 1
		wS2.range = 1000
		wS2.damage = {
			vtol = 100,
		}
		
		for i,w in pairs(newDef.weapons) do
			--if w.def == "SEMIAUTO" or w.def == "PLASMA" then
				w.badtargetcategory = "NOTAIR"
				w.onlytargetcategory = "VTOL"
			--end
		end
		newDef.weapons[4].def = "KROWBOSSLASER2"
		newDef.weapons[4].fastautoretargeting = true
		newDef.weapons[6].def = "KROWBOSSLASER2"
		newDef.weapons[6].fastautoretargeting = true

		return newDef
	end},
	corfblackhyt4 = {function(origDef)
		local newDef = deepcopy(origDef)
		newDef.category = "ALL WEAPON VTOL NOTSUB NOTHOVER"
		newDef.nochasecategory = "ALL"
		newDef.health = 100000
		local cpm = newDef.customparams or {}
		cpm.i18n_en_humanname = "Flying AA Black Hydra"
		cpm.i18n_en_tooltip = "Anti-Air Flagship with VTOL thrusters"
		cpm.armordef = "VTOL"
		newDef.customparams = cpm

		local wD = newDef.weapondefs
		wD.ferret_missile = deepcopy(UnitDefs.corerad.weapondefs.cor_erad)
		wD.heavylaser = deepcopy(UnitDefs.corfblackhyt4.weapondefs.heavylaser)
		local mp = wD.heavylaser
		mp.name = "High Energy AA Laser"
		mp.avoidfriendly = false
		mp.burnblow = true
		mp.collidefriendly = false
		mp.cylindertargeting = 1
		mp.edgeeffectiveness = 1
		mp.predictboost = 1
		mp.reloadtime = 0.25
		mp.weaponvelocity = 1600
		mp.weaponrange = 1500
		mp.damage = {vtol=650}

		wD.heavyplasma = deepcopy(UnitDefs.corfblackhyt4.weapondefs.heavyplasma)
		local hp = wD.heavyplasma
		hp.name = "AA Battleship Cannon"
		hp.accuracy = 100
		hp.areaofeffect = 350
		hp.avoidfriendly = false
		hp.burnblow = true
		hp.collidefriendly = false
		hp.cylindertargeting = 1
		hp.edgeeffectiveness = 1
		hp.predictboost = 1
		hp.reloadtime = 0.5
		hp.weaponvelocity = 1800
		hp.range = 2500
		hp.damage = {vtol=1500}

		for i,w in pairs(newDef.weapons) do
			w.badtargetcategory = "NOTAIR"
			w.onlytargetcategory = "VTOL"
			if w.def == "HEAVYLASER" then
				w.fastautoretargeting = true
			end
		end
		return newDef
	end},

	legfortt4 = {function(origDef)
		local newDef = deepcopy(origDef)
		newDef.category = "ALL WEAPON VTOL NOTSUB NOTHOVER"
		newDef.cruisealtitude = 260
		newDef.nochasecategory = "NOTAIR VTOL"
		local cpm = newDef.customparams or {}
		cpm.i18n_en_humanname = "Epic AA Tyrannus"
		cpm.i18n_en_tooltip = "Gigantic Flying Anti-Air Fortress"
		cpm.armordef = "VTOL"
		newDef.customparams = cpm
		local wD = newDef.weapondefs
		wD.semiauto = deepcopy(UnitDefs.legmg.weapondefs.armmg_weapon)
		local mg = wD.semiauto
		mg.avoidfriendly = false
		mg.beamtime = 0.07
		mg.burst = mg.burst*2
		mg.burstrate = 0.02
		mg.corethickness = 0.45
		mg.collidefriendly = false
		mg.name = "Heavy Rapid-fire Anti-Air Gun"
		mg.predictboost = 1
		mg.range = 1500
		mg.reloadtime = 0.4
		mg.sprayangle = 968*4
		mg.thickness = 7.5
		mg.damage = {
			vtol = 80,
		}

		wD.plasma = deepcopy(UnitDefs.leglraa.weapondefs.railgunt2)
		local rg = wD.plasma
		rg.avoidfriendly = false
		rg.collidefriendly = false
		rg.energypershot = 0
		rg.proximitypriority = -1
		rg.reloadtime = 0.66

		local msl = wD.aa_missiles
		msl.flighttime = 5
		msl.range = 1900
		msl.reload = 0.2
		msl.weaponacceleration = 1600

		for i,w in pairs(newDef.weapons) do
			if w.def == "SEMIAUTO" or w.def == "PLASMA" then
				w.badtargetcategory = "NOTAIR"
				w.onlytargetcategory = "VTOL"
			end
			if w.def == "SEMIAUTO" or w.def =="AA_MISSILES" then
				w.fastautoretargeting = true
			end
		end

		return newDef
	end};
	legfort = {function(origDef)
		local newDef = deepcopy(origDef)
		newDef.category = "ALL WEAPON VTOL NOTSUB NOTHOVER"
		newDef.cruisealtitude = 230
		newDef.nochasecategory = "NOTAIR VTOL"
		local cpm = newDef.customparams or {}
		cpm.i18n_en_humanname = "AA Tyrannus"
		cpm.i18n_en_tooltip = "Flying Anti-Air Fortress"
		cpm.armordef = "VTOL"
		newDef.customparams = cpm
		local wD = newDef.weapondefs
		wD.semiauto = deepcopy(UnitDefs.legmg.weapondefs.armmg_weapon)
		local mg = wD.semiauto
		mg.avoidfriendly = false
		mg.burst = mg.burst*2
		mg.burstrate = 0.03
		mg.collidefriendly = false
		mg.name = "Rapid-fire Anti-Air Gun"
		mg.predictboost = 1
		mg.range = 1000
		mg.reloadtime = 0.4
		mg.sprayangle = 968*4
		mg.damage = {
			vtol = 40,
		}

		wD.plasma = deepcopy(UnitDefs.leglupara.weapondefs.legflak_gun)
		local rg = wD.plasma
		rg.avoidfriendly = false
		rg.burst = 1
		rg.collidefriendly = false
		rg.energypershot = 0
		rg.range = 1500
		rg.reloadtime = 0.66

		local msl = wD.aa_missiles
		msl.range = 1250

		for i,w in pairs(newDef.weapons) do
			if w.def == "SEMIAUTO" or w.def == "PLASMA" then
				w.badtargetcategory = "NOTAIR"
				w.onlytargetcategory = "VTOL"
			end
			if w.def == "SEMIAUTO" or w.def =="AA_MISSILES" then
				w.fastautoretargeting = true
			end
		end

		return newDef
	end};

	legstarfall = {function(origDef)
		local newDef = table.merge(origDef,{
			firestate = 2,
			buildtime = 180000,
			customparams = {
				i18n_en_humanname = "Epic Cacophony",
				i18n_en_tooltip = "Extreme Land/Air Gatling Gun Turret"
			},
			weapondefs = {
				starfire = table.merge(UnitDefs.legmg.weapondefs.armmg_weapon, {
					avoidfriendly = false,
					beamtime = 0.07,
					burst = 189,
					burstrate = 0.01,
					collidefriendly = false,
					corethickness = 0.45,
					duration = 0.07,
					interceptedbyshieldtype = 4,
					name = "Very Long-Range Rapid-fire Gatling Gun",
					predictboost = 1,
					range = 2500,
					reloadtime = 7,
					sprayangle = 968,
					thickness = 7.5,
					tolerance = 3000,
					weaponvelocity = 1000,
					damage = {
						default = 500,
					},
				})
			},
			weapons = {
				[1] = {
					badtargetcategory = nil,
					onlytargetcategory = "NOTSUB VTOL",
					burstControlWhenOutOfArc = 2,
				},
				[2] = {
					onlytargetcategory = "",
					badtargetcategory = "ALL",
				}
			}
		})
		return newDef
	end};
}
for n,nU in pairs(newUnits) do
	local f = nU[1]
	if UnitDefs[n] then
		local newName,newDef = modname(n),f(UnitDefs[n])
		newDef.id=modname(n)
		newDef.icontype=nU[3] or n
		UnitDefs[modname(n)] = newDef
	end
	if nU[2] and UnitDefs[nU[2]] then
		table.insert(UnitDefs[nU[2]].buildoptions,modname(n))
	end
end
--Add to builders
for name,def in pairs(UnitDefs) do
	if type(def.buildoptions) == "table" then
		for i,buildname in ipairs(def.buildoptions) do
			if newUnits[buildname] ~= nil and newUnits[buildname][2] == nil then
				local newName = modname(buildname)
				Spring.Echo("Attempting to add " .. newName .. " to " .. name)
				local has = false
				for _,v in ipairs(def.buildoptions) do
					if v == newName then has = true break end
				end
				if has == false then
					table.insert(def.buildoptions,newName)
					Spring.Echo("Added " .. newName .. " to " .. name)
				end
			end
		end
	end
end