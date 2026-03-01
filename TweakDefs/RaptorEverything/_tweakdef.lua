--RaptorEverything v0.1
local UnitDefs = UnitDefs or {}
local behaviors = {
	"raider", -- This is the default, that doesn't get any behaviors. You can specify it but it won't do anything.
	"berserk", -- Run towards target after getting hit by enemy or after hitting the target
	"skirmisher", -- Keep distance from the target
	"healer", -- Getting long max lifetime and always use Fight command. These units spawn as healers from burrows and queen
	"artillery", -- Long lifetime and no regrouping, always uses Fight command to keep distance, friendly fire enabled (assuming nothing else in the game stops it)
	"kamikaze", -- Long lifetime and no regrouping, always uses Move command to rush into the enemy
}
local shipList, hoverList, subList = {
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
	}, {
		UBOAT4 = true,
		EPICSUBMARINE = true
	}
local function getMovement(def)
	if def.canfly then
		return 2
	elseif subList[def.movementclass] or shipList[def.movementclass] or (hoverList[def.movementclass] and def.maxwaterdepth and def.maxwaterdepth >=1) then
		return 3
	elseif (def.speed or 0) > 0 then
		return 1
	else
		return -1
	end
end
--do the thing
for name,def in pairs(UnitDefs) do
	local techlevel = (def.customparams or {}).techlevel or 1
	local params = {
		raptorcustomsquad = true, -- bool - allow this unit to be processed by this whole thing
		raptorsquadunitsamount = 50, -- number, integrer - maximum amount of these units that can spawn in a squad
		raptorsquadminanger = 25*(techlevel-1), -- number, integrer - minimum evolution percentage this unit can spawn at
		raptorsquadmaxanger = 25*(techlevel+1), -- number, integrer - maximum evolution percentage this unit can spawn at
		raptorsquadweight = 1, -- number, integrer - how often will this unit be picked relative to other options. higher number = more often.
		raptorsquadrarity = "basic", -- string - either "basic" or "special", defaults to special. Basic squads are your spammable cannon fodder while specials are more specialised elemental units.
		raptorsquadbehavior = "artillery", -- string - explained below
		raptorsquadbehaviordistance = 400, -- number, integrer - Distance at which the behaviors operate. Usually means the fleeing distance, except berserks and kamikazes, where it defines reaction range.
		raptorsquadbehaviorchance = 0, -- number, float between 0 and 1 - How sensitive the unit is to the behavior triggers.
	}
	if def.workertime then
		params.raptorsquadbehavior = "healer"
	end
	local movementtype = getMovement(def)
	if (not ((def.customparams or {}).iscommander))
		and (def.health or 560001) < 560000
		and (movementtype == 2 or movementtype == 1)
		and not string.find(name,"raptor") then
		def.customparams = table.merge(def.customparams or {},params)
	end
end