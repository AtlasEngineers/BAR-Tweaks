--Nano Carriers v0.1
local UnitDefs = UnitDefs or {}
local function modname(n) return "nanocarrier_"..n end
local droneName, metalCost, energyCost = "assistdrone",58,2900
local newUnits = {}
--Generate custom units
local faction = {
	arm = {"armshltx","armapt3","armasy"},
	cor = {"corgant","corapt3","corasy"},
	leg = {"leggant","legapt3","legadvshipyard"}
}
for k in pairs(faction) do
	newUnits[k..droneName] = {function(origDef)
		return table.merge(origDef, {
			--builder = false,
			canassist = false,
			hoverattack = true,
			repairable = false,
			usesmoothmesh = 0,
			customparams = {
				drone = 1,
			},
		})
	end}
end
local shipList, hoverList = {
		BOAT3 = true,
		BOAT4 = true,
		BOAT5 = true,
		BOAT9 = true,
		EPICSHIP = true
	}, {
		HOVER2 = true,
		HOVER3 = true,
		HHOVER4 = true,
		AHOVER2 = true
	}
local function getMovement(def)
	if def.canfly then
		return 2
	elseif shipList[def.movementclass] or (hoverList[def.movementclass] and def.maxwaterdepth and def.maxwaterdepth >=1) then
		return 3
	elseif (def.speed or 0) > 0 then
		return 1
	else
		return -1
	end
end
for name,def in pairs(UnitDefs) do
	local fact,factind = string.sub(name,1,3),getMovement(def)
	local wepdefs, droneCount = {}, 0
	for wName, wDef in pairs(def.weapondefs or {}) do
		if wDef.customparams and wDef.customparams.carried_unit then
			wepdefs[wName] = {
				customparams = {
					carried_unit = modname(fact..droneName),
					dronetype = "nano",
					decayrate = 0,
					deathdecayrate = 0,
					stockpilemetal = metalCost,
					metalcost = metalCost,
					stockpileenergy = energyCost,
					energycost = energyCost
				},
			}
			droneCount = droneCount + wDef.customparams.maxunits
		end
	end
	if next(wepdefs) ~= nil then
		Spring.Echo(name .. " is a carrier")
		newUnits[name] = {function(origDef)
			return table.merge(origDef, {
				builder = false,
				movestate = 1,
				weapondefs = wepdefs,
				customparams = {
					i18n_en_humanname = ("[%s] Repair Carrier"):format(string.upper(name)),
					i18n_en_tooltip = ("Carries %d Repair Drones (costs %dm %de each)"):format(droneCount,metalCost,energyCost)
				}
			})
		end,fact and faction[fact] and faction[fact][factind]}
	end
end
--Add custom units
for n,nU in pairs(newUnits) do
	local newName,f = modname(n),nU[1]
	if UnitDefs[n] then
		local newDef = f(UnitDefs[n])
		newDef.id=newName
		newDef.icontype=nU[3] or n
		UnitDefs[newName] = newDef
	end
	if nU[2] and UnitDefs[nU[2]] then
		table.insert(UnitDefs[nU[2]].buildoptions,newName)
	end
end
--Add to builders
for name,def in pairs(UnitDefs) do
	if type(def.buildoptions) == "table" then
		for i,buildname in ipairs(def.buildoptions) do
			if newUnits[buildname] ~= nil then
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