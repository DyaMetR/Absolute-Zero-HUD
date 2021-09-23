--[[------------------------------------------------------------------
  Declaration of configuration variables
]]--------------------------------------------------------------------

if SERVER then return end

-- Constants
local PREFIX = 'hl1ahud_'

-- ConVars
local CONVARS = {
  ['enabled'] = 1,
  ['mode'] = 0,
  ['nouse_battery'] = 1,
  ['scale'] = 1,
  ['damage_scale'] = 1,
  ['health'] = 1,
  ['hazards'] = 1,
  ['ammo'] = 1,
  ['weapon_selector'] = 1,
  ['selector_skip'] = 1,
  ['items'] = 1,
  ['damage'] = 1,
  ['death'] = 1,
  ['volume'] = .25
}

-- Initialize
for convar, default in pairs(CONVARS) do
  CreateClientConVar(PREFIX .. convar, default, true)
end

-- Reset settings
concommand.Add(PREFIX .. 'reset', function(ply, com, args)
  for convar, default in pairs(CONVARS) do
    RunConsoleCommand(PREFIX .. convar, default)
  end
end)

--[[------------------------------------------------------------------
  Is the HUD enabled
  @return {boolean} is enabled
]]--------------------------------------------------------------------
function HL1AHUD.IsEnabled()
  return GetConVar(PREFIX .. 'enabled'):GetBool()
end

--[[------------------------------------------------------------------
  Gets the HUD variant
  @return {number} mode
]]--------------------------------------------------------------------
function HL1AHUD.GetMode()
  return math.Clamp(GetConVar(PREFIX .. 'mode'):GetInt(), 0, 3)
end

--[[------------------------------------------------------------------
  Does the battery show when is out of energy? (on green variants)
  @return {boolean} should show
]]--------------------------------------------------------------------
function HL1AHUD.ShouldBatteryAlwaysDraw()
  return GetConVar(PREFIX .. 'nouse_battery'):GetBool()
end

--[[------------------------------------------------------------------
  Gets the HUD scale
  @return {number} scale
]]--------------------------------------------------------------------
function HL1AHUD.GetScale()
  return GetConVar(PREFIX .. 'scale'):GetFloat()
end

--[[------------------------------------------------------------------
  Gets the weapon selector volume
  @return {number} volume
]]--------------------------------------------------------------------
function HL1AHUD.GetVolume()
  return GetConVar(PREFIX .. 'volume'):GetFloat()
end

--[[------------------------------------------------------------------
  Gets the damage indicator scale
  @return {number} scale
]]--------------------------------------------------------------------
function HL1AHUD.GetDamageIndicatorScale()
  return GetConVar(PREFIX .. 'damage_scale'):GetFloat()
end

--[[------------------------------------------------------------------
  Whether the health and armour element should be drawn
  @return {boolean} should show
]]--------------------------------------------------------------------
function HL1AHUD.ShouldDrawHealth()
  return GetConVar(PREFIX .. 'health'):GetBool()
end

--[[------------------------------------------------------------------
  Whether the hazard tray should be drawn
  @return {boolean} should show
]]--------------------------------------------------------------------
function HL1AHUD.ShouldDrawHazards()
  return GetConVar(PREFIX .. 'hazards'):GetBool()
end

--[[------------------------------------------------------------------
  Whether the ammunition element should be drawn
  @return {boolean} should show
]]--------------------------------------------------------------------
function HL1AHUD.ShouldDrawAmmo()
  return GetConVar(PREFIX .. 'ammo'):GetBool()
end

--[[------------------------------------------------------------------
  Whether the weapon selector should be drawn
  @return {boolean} should show
]]--------------------------------------------------------------------
function HL1AHUD.ShouldDrawWeaponSelector()
  return GetConVar(PREFIX .. 'weapon_selector'):GetBool()
end

--[[------------------------------------------------------------------
  Whether the weapon selector should skip empty weapons
  @return {boolean} should skip
]]--------------------------------------------------------------------
function HL1AHUD.ShouldSkipEmptyWeapons()
  return GetConVar(PREFIX .. 'selector_skip'):GetBool()
end

--[[------------------------------------------------------------------
  Whether the item inventory element should be drawn
  @return {boolean} should show
]]--------------------------------------------------------------------
function HL1AHUD.ShouldDrawItemInventory()
  return GetConVar(PREFIX .. 'items'):GetBool()
end

--[[------------------------------------------------------------------
  Whether the damage indicator should be drawn
  @return {boolean} should show
]]--------------------------------------------------------------------
function HL1AHUD.ShouldDrawDamageIndicator()
  return GetConVar(PREFIX .. 'damage'):GetBool()
end

--[[------------------------------------------------------------------
  Whether the death camera should be used
  @return {boolean} should show
]]--------------------------------------------------------------------
function HL1AHUD.ShouldUseDeathCam()
  return GetConVar(PREFIX .. 'death'):GetBool()
end
