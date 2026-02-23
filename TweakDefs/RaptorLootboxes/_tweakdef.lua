-- Raptor Lootboxes v4
local function setupMeta(unitName, unitDef)
  local customparams=unitDef.customparams or {}
  local aName=unitName
  local _, _, v=string.find(unitName, "_v(%d+)")
  if v then v=tonumber(v) or 0 end
  aName=aName:gsub("_v(%d+)","") --actual_name
  local _, _, tierData=string.find(unitName, "_t(%d+)")
  if tierData then tierData=tonumber(tierData) end
  local gName=aName:gsub("_t(%d+)","") --general_name
  local isR=string.find(unitName, "_queen") or string.find(unitName, "_matriarch") or unitName == "raptorh5"
  if isR or string.find(unitName, "_hive") then tierData=5 end
  if tierData then customparams.techlevel=tierData end
  local isT if unitDef.yardmap or unitDef.speed == 0.0 then isT=unitDef.yardmap or "" end
  if isT then customparams.unitgroup="weapon" end
  local isH=string.find(unitName, "_heal") or unitName == "raptorh5"
  if isH then customparams.unitgroup="builder" end
  local meta={aName=aName;gName=gName;v=v;isRoyal=isR;isT=isT;isH=isH;}
  customparams.raptorbuildmeta=meta
  unitDef.customparams=customparams
  return meta
end
local function deepcopy(orig)
  local orig_type=type(orig)
  local copy
  if orig_type == 'table' then
    copy={}
    for orig_key, orig_value in next, orig, nil do
      copy[deepcopy(orig_key)]=deepcopy(orig_value)
    end
    setmetatable(copy, deepcopy(getmetatable(orig)))
  else
    copy=orig
  end
  return copy
end
local function setup(newName,newDef)
  UnitDefs[newName]=newDef
  newDef.unitname=newName
  newDef.maxthisunit=nil
  newDef.buildoptions={}
  local custom=newDef.customparams or {}
  custom.subfolder="other/raptors"
  newDef.customparams=custom
  return custom
end
local function unitClone(unitName,newName,newDef)
  --if newDef==nil then Spring.Echo("newDef nil:",unitName,newName) return end
  newDef.icontype=unitName
  local custom=setup(newName,newDef)
  custom.i18nfromunit=unitName
  return custom
end
local function fyn(t,n) return "custchickenunit_t"..t.."_"..string.lower(n) end
local function fyhn(n,m) if not (n=="") then n=n.." " end return n.."Raptor "..m end
local hcol={"health";"metalcost";"energycost";"buildtime";"metalmake";"metalstorage";"energymake";"energystorage"}
local hivh,hivb=50000,{1,0.5,2,4,0.003,0.25,0.04,0.5}
local hivp={{0.1,0.15,0.25,0.15,0.003,0.2,0.025,0.3},
{0.25,0.14,0.28,2,0.002,0.14,0.04,0.28},
{0.5,0.14,0.28,2,0.0014,0.14,0.04,0.28},
hivb}
local function setupHive(u,s)
  u.maxSlope=255
  local th=hivh*s[1]
  for i,col in ipairs(hcol) do
    if i==1 then u[col]=th else u[col]=th*s[i] end
  end
end
local ref,hpref={},{"Infant","Juvenile","Young",""}
for unitName, unitDef in pairs(UnitDefs) do
  if (unitDef.category == "RAPTOR") and not string.find(unitName, "custraptorunit") then
    local m = setupMeta(unitName, unitDef)
    if unitName=="raptor_hive" then
      hivh=unitDef.health
      setupHive(unitDef,hivb)
      for i,pre in ipairs(hpref) do
        if i==1 then m.isStart=true end
        local t=i-1
        local n=fyn(t,"hive")
        local u=deepcopy(unitDef)
        local c=setup(n,u)
        if i<4 then u.maxthisunit=1 u.icontype="raptor_hive" end
        local p=hivp[i]
        Spring.Echo("local p=hivp[i]",p,hivp,i)
        setupHive(u,p)
        c.i18n_en_humanname=fyhn(pre,"Hive")
        c.i18n_en_tooltip="Tier "..t.." Custom Economy/Defense"
        if i<4 then c.i18n_en_tooltip="Limit 1, "..c.i18n_en_tooltip end
        c.techlevel=t
        c.unitgroup="energy"
        for wn,wd in pairs(u.weapondefs) do for k,dam in pairs(wd.damage) do local d=dam*p[1] if wn=="spawnmeteor" then d=0 end wd.damage[k]=d end end
      end
    end
    ref[unitName]=unitDef
  end
end
Spring.Echo("Raptor Buildings Metadata Complete")

local pref={"Juvenile","Common","Mature","Apex","Royal"}
local function fyd(n,t) return "Produces "..n.." Raptors (T"..t..")" end
local function cpLab(name,tp,list)
  local o={} for t,unitName in ipairs(list) do
    local pre=pref[t]
    local n=fyn(t,name)
    local u=deepcopy(UnitDefs[unitName])
    local c=unitClone(unitName,n,u)
    u.icontype="raptor_hive"
    c.i18nfromunit=nil
    c.i18n_en_humanname=fyhn(pre,name)
    c.i18n_en_tooltip=fyd(pre.." "..tp,t)
    c.normalmaps=true
    c.normaltex="unittextures/chicken_l_normals.png"
    c.techlevel=t
    c.areadamageresistance="_RAPTORACID_"
    local b={
      aName=n; gName=n:gsub("_t(%d+)","");
      v=1; isRoyal=t==5;
      isT=true; isH=true;
    }
    c.raptorbuildmeta=b
    o[t]=u
  end return o
end
local fmt=cpLab("Hatchery","Land",{"leglab","leghp","legalab","leggant","leggant"})[5]
fmt.energycost=fmt.energycost*5 fmt.metalcost=fmt.metalcost*5 fmt.buildtime=fmt.buildtime*5 fmt.health=fmt.health*2.5
cpLab("Nest","Air",{"legap","legaap","legaap","legapt3"})

local function cpEco(t,unitName)
  local n=fyn(t,unitName)
  if UnitDefs[n] then return end
  unitName="leg"..unitName
  local u=deepcopy(UnitDefs[unitName])
  local c=unitClone(unitName,n,u)
  c.normalmaps=true
  c.normaltex="unittextures/chicken_l_normals.png"
  c.areadamageresistance="_RAPTORACID_"
  local b={
    aName=n; gName=n:gsub("_t(%d+)","");
    v=1; isT=true; isH=false;
  }
  c.raptorbuildmeta=b
end
local eco={{"solar","win","econv","mex"};{"advsol","win","econv","mex","mext15"};{"advsol","wint2","adveconv","moho"};{"advsol","wint2","adveconv","fus","afus","moho","mohocon"};{"advsol","wint2","fus","afus","moho","mohocon","afust3","adveconvt3"};}
for t,l in ipairs(eco) do
  for i,unitName in ipairs(l) do
    cpEco(t,unitName)
  end
end

local e,f,h={},{},{} --e=everything,f=flying,h=healer,
for uName0, uDef0 in pairs(ref) do
  local uName,uDef=uName0:gsub("raptor","custraptorunit"),deepcopy(uDef0)
  local c=unitClone(uName0,uName,uDef)
  local t,m=c.techlevel or 0,c.raptorbuildmeta m.uName=uName
  local itr,bo=m.isT,m.isH
  if bo and pref[t] then
    uDef.canreclaim=1
    uDef.workertime=math.min(uDef.health,500*math.max(t,1))
    uDef.reclaimspeed=uDef.workertime
    if t == 5 and string.find(uName,"_matriarch") then bo,m.isH=nil,nil
    else c.i18nfromunit,c.i18n_en_humanname,c.i18n_en_tooltip=nil,pref[t].." Constructor Raptor","Tech "..t.." Constructor"
    end
  end
  local q
  if uDef.canfly then
    f[t]=f[t] or {}
    q=f[t]
    c.armordef = "VTOL"
  else
    e[t]=e[t] or {}
    q=e[t]
  end
  local i=q[m.gName]
  if (not i or (i.v or 0) < (m.v or 0)) and not (bo and itr) then
    q[m.gName]=m
    if bo and not itr then h[m.aName]=uDef end end
  if itr then uDef.maxSlope=uDef.maxSlope or 255 end
  local qind=string.find(uName,"_queen")
  if qind then
    local d=string.sub(uName,qind+7):gsub("very","very ")
    c.i18nfromunit=nil c.i18n_en_humanname="["..d.."] Raptor Queen"
    c.i18n_en_tooltip="The Mother of ALL "..string.upper(d).." RAPTORS!"
  end
  if type(uDef.weapondefs)=="table" then for wn,wd in pairs(uDef.weapondefs) do
    if string.find(uName,"_air_bomber_basic") then wd.reloadtime=6 end
    if wn == "spawnmeteor" then wd.damage={default=0} end
    if type(wd.explosiongenerator)=="string" and string.find(wd.explosiongenerator,"acid-explosion",1,true) then
      local s,wdc=1.5,wd.customparams if not wdc then wdc={} wd.customparams=wdc end
      if string.find(wd.explosiongenerator,"small") then s=1 end
      if string.find(wd.explosiongenerator,"xl") then s=2 end
      if wdc.area_onhit_damageCeg then wdc.area_onhit_damageceg=wdc.area_onhit_damageCeg end
      if not wdc.area_onhit_damageceg then wdc.area_onhit_damageceg="acid-damage-gen" end
      if not wdc.area_onhit_ceg then wdc.area_onhit_ceg="acid-area-"..(s*75).."-repeat" end
      if not wdc.area_onhit_time then wdc.area_onhit_time=10 end
      if not wdc.area_onhit_damage then wdc.area_onhit_damage=20*(t+1) end
      if not wdc.area_onhit_range then wdc.area_onhit_range=s*75 end
      if not wdc.area_onhit_resistance then wdc.area_onhit_resistance="_RAPTORACID_" end end
  end end
end
Spring.Echo("Raptor Buildings Copying Complete")

local ae,af,atr={},{},{} --allTurrets
for t, pre in ipairs(pref) do
  local th,tf,te={},{},{} --th=tierHealer,tf=tierFlyers,te=tierEverything
  for gName, m in pairs(e[t]) do
    if not m.isT then
      th[m.uName]=h[m.aName]
      table.insert(te,m.uName)
      ae[gName]=m.uName
    else
      atr[gName]=m.uName
    end
    --Spring.Echo("eUnit Debug:",gName, m)
  end
  if t==5 then
    for gName, m in pairs(e[0] or {}) do
      if not m.isT then
        th[m.uName]=h[m.aName]
        table.insert(te,m.uName)
        ae[gName]=m.uName
      elseif not m.isStart then
        atr[gName]=m.uName
      end
      --Spring.Echo("eUnit Debug:",gName, m)
    end
  end
  for gName, m in pairs(f[t] or {}) do
    th[m.uName]=h[m.aName]
    af[gName]=m.uName
    --Spring.Echo("fUnit Debug:",gName, m)
  end
  if t==4 then
    for gName, m in pairs(f[0] or {}) do
      th[m.uName]=h[m.aName]
      af[gName]=m.uName
      --Spring.Echo("fUnit Debug:",gName, m)
    end
  end
  for gName, uName in pairs(af) do table.insert(tf,uName) end
  local lfy,afy,hiv=fyn(t,"hatchery"),fyn(t,"nest"),fyn(math.min(t,3),"hive")
  local lfyDef,afyDef=UnitDefs[lfy],UnitDefs[afy] or {}
  lfyDef.buildoptions,afyDef.buildoptions=te,tf
  --Spring.Echo("Land Factory Debug:",lfyDef)
  local thb,nPre={lfy,afy,hiv}, pref[t+1]
  Spring.Echo("buildorderdebug thb",t,thb)
  if t == 1 then
    for _,fy in ipairs(thb) do
      if fy==fyn(1,"hive") then fy=fyn(0,"hive") end
    end
  elseif t==5 then
    table.insert(thb, fyn(t-1,"hatchery"))
    table.insert(thb, fyn(t-1,"nest"))
  end
  if nPre then table.insert(thb, fyn(t+1,"hatchery")) end
  for gName, uName in pairs(atr) do table.insert(thb, uName) end
  for _,ecop in ipairs(eco[t]) do table.insert(thb,fyn(t,ecop)) end
  for uName,uDef in pairs(th) do uDef.buildoptions=thb end
  --Spring.Echo("builder buildoptionsdebug:",th)
end
Spring.Echo("Raptor Buildings BuildOptions Complete")
for k,v in pairs(UnitDefs) do if string.find(k,"_hive") then Spring.Echo(k,v) end end

local mappings = {
	lootboxbronze = {"custchickenunit_t1_hatchery", {
		health = 33500,
		workertime = 2700,
		metalmake = 20,
		energymake = 400,
    yardmap="eeeeee eeeeee eeeeee eeeeee eeeeee eeeeee",
	}},
	lootboxsilver = {"custchickenunit_t2_hatchery", {
		health = 44500,
		workertime = 2700,
		metalmake = 40,
		energymake = 800,
	}},
	lootboxgold = {"custchickenunit_t4_hatchery", {
		health = 56000,
		workertime = 30000,
		metalmake = 80,
		energymake = 1600,
	}},
	lootboxplatinum = {"custchickenunit_t5_hatchery", {
		health = 67000,
		workertime = 100000,
		metalmake = 9000,
		energymake = 90000,
	}},
}
for orig,data in pairs(mappings) do
	local new = data[1]
	Spring.Echo("Attempting to replace " .. orig .. " as " .. new)
	if UnitDefs[orig] and UnitDefs[new] then
		UnitDefs[orig] = table.merge(UnitDefs[new], data[2])
		Spring.Echo("Replaced " .. orig .. " as " .. new)
	end
end