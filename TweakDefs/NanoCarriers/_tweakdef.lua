--Nano Carriers v1.0
local UnitDefs = UnitDefs or {}
local function modname(i,n) return "nanocarrier_"..i.."_"..n end
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
		return {table.merge(origDef, {
			--builder = false,
			canassist = false,
			hoverattack = true,
			repairable = false,
			usesmoothmesh = 0,
			customparams = {
				drone = 1,
			},
		})}
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
local function createwepdefs(fact,type)
	return {
		customparams = {
			carried_unit = modname(1,fact..droneName),
			dronetype = type,
			decayrate = 0,
			deathdecayrate = 0,
			docktohealthreshold = 99,
			dockingarmor = 0.1,
			stockpilemetal = metalCost,
			metalcost = metalCost,
			stockpileenergy = energyCost,
			energycost = energyCost
		},
	}
end
for name,def in pairs(UnitDefs) do
	local fact,factind = string.sub(name,1,3),getMovement(def)
	local wepdefnames, droneCount = {}, 0
	for wName, wDef in pairs(def.weapondefs or {}) do
		if wDef.customparams and wDef.customparams.carried_unit then
			wepdefnames[wName] = true
			droneCount = droneCount + wDef.customparams.maxunits
		end
	end
	if next(wepdefnames) ~= nil then
		Spring.Echo(name .. " is a carrier")
		newUnits[name] = {function(origDef)
			local output = {}
			for i,t in ipairs({{"nano","Repair"},{"default","Reclaim"}}) do
				local wepdefs = {}
				for n in pairs(wepdefnames) do
					wepdefs[n] = createwepdefs(fact,t[1])
				end
				output[i] = table.merge(origDef, {
					builder = false,
					movestate = 1,
					weapondefs = wepdefs,
					customparams = {
						unitgroup = "util",
						i18n_en_humanname = ("[%s] %s Carrier"):format(string.upper(name),t[2]),
						i18n_en_tooltip = ("Carries %d %s Drones (costs %dm %de each)"):format(droneCount,t[2],metalCost,energyCost)
					}
				})
			end
			return output
		end,fact and faction[fact] and faction[fact][factind]}
	end
end
--Add custom units
local units = {}
for n,nU in pairs(newUnits) do
	local f,builderID = nU[1],(nU[2] and UnitDefs[nU[2]])
	if UnitDefs[n] then
		local output = {}
		for i, newDef in ipairs(f(UnitDefs[n])) do
			local newName = modname(i,n)
			newDef.id=i..newName
			newDef.icontype=nU[3] or n
			UnitDefs[newName] = newDef
			if builderID then
				table.insert(UnitDefs[nU[2]].buildoptions,newName)
			end
			output[i] = newName
		end
		units[n] = output
	end
end
--Add to builders
for name,def in pairs(UnitDefs) do
	if type(def.buildoptions) == "table" then
		for _,buildname in ipairs(def.buildoptions) do
			if units[buildname] ~= nil then
				for _,newName in ipairs(units[buildname]) do
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
end