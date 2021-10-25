--[[------------------------------------------------------------------
  DyaMetR's weapon switcher script
  September 19th, 2021

  API to be used in a custom weapon selector.
]]--------------------------------------------------------------------

if SERVER then return end -- do not run on server

-- Configuration
local MAX_SLOTS = 6 -- maximum number of weapon slots

-- Constants
local SKIPEMPTY_HOOK = 'ShouldSkipEmptyWeapons'
local PHYSICS_GUN, CAMERA = 'weapon_physgun', 'gmod_camera'
local SLOT, INV_PREV, INV_NEXT, ATTACK, ATTACK2 = 'slot', 'invprev', 'invnext', '+attack', '+attack2'

-- Variables
local curSlot = 0 -- current slot selected
local curPos = 0 -- current weapon position selected
local weaponCount = 0 -- current weapon count
local cache = {} -- cached weapons sorted per slot
local cacheLength = {} -- how many weapons are there in each slot
local weaponPos = {} -- assigned table position in slot

-- Initialize cache
for slot = 1, MAX_SLOTS do
  cache[slot] = {}
  cacheLength[slot] = 0
end

--[[------------------------------------------------------------------
  Whether empty weapons should be skipped by the selector
  @param {Weapon} weapon
  @return {boolean} skip
]]--------------------------------------------------------------------
local function skipEmpty(weapon)
  local override = HL1AHUD.RunHook(SKIPEMPTY_HOOK, weapon)
  if override ~= nil then return override end
  return HL1AHUD.ShouldSkipEmptyWeapons()
end

--[[------------------------------------------------------------------
  Sorting function to order a weapon inventory slot by slot position
  @param {Weapon} a
  @param {Weapon} b
]]--------------------------------------------------------------------
local function sortWeaponSlot(a, b)
  return a:GetSlotPos() < b:GetSlotPos()
end

--[[------------------------------------------------------------------
  Caches the current weapons the player has
  @param {boolean} force update
]]--------------------------------------------------------------------
local function cacheWeapons(force)
  -- get current weapons
  local weapons = LocalPlayer():GetWeapons()

  -- only cache when weapon count is different
  if not force and weaponCount == #weapons then return end

  -- reset cache
  for slot = 1, MAX_SLOTS do
    for pos = 0, cacheLength[slot] do
      cache[slot][pos] = nil
    end
    cacheLength[slot] = 0
  end
  table.Empty(weaponPos)

  -- update weapon count
  weaponCount = #weapons

  -- add weapons
  for _, weapon in pairs(weapons) do
    -- weapon slots start at 0, so we need to make it start at 1 because of lua tables
    local slot = weapon:GetSlot() + 1

    -- do not add if the slot is out of bounds
    if slot <= 0 or slot > MAX_SLOTS then continue end

    -- cache weapon
    table.insert(cache[slot], weapon)
    cacheLength[slot] = cacheLength[slot] + 1
  end

  -- sort slots
  for slot = 1, MAX_SLOTS do
    table.sort(cache[slot], sortWeaponSlot)

    -- get sorted weapons' positions
    for pos, weapon in pairs(cache[slot]) do
      weaponPos[weapon] = pos
    end
  end

  -- check whether we're out of bounds
  if curSlot > 0 then
    if weaponCount <= 0 then
      curSlot = 0
      curPos = 1
    else
      curPos = math.min(curPos, cacheLength[curSlot])
    end
  end
end

--[[------------------------------------------------------------------
  Finds the next slot with weapons
  @param {number} starting slot
  @param {boolean} move forward
  @return {number} slot found
]]--------------------------------------------------------------------
local function findSlot(slot, forward)
  -- do not search if there are no weapons
  if weaponCount <= 0 then return slot end

  -- otherwise, search for the next slot with weapons
  while (not cacheLength[slot] or cacheLength[slot] <= 0) do
    if forward then
      if slot < MAX_SLOTS then
        slot = slot + 1
      else
        slot = 1
      end
    else
      if slot > 1 then
        slot = slot - 1
      else
        slot = MAX_SLOTS
      end
    end
  end

  return slot
end

--[[------------------------------------------------------------------
  Finds the next weapon with ammo to select
  @param {number} starting slot
  @param {number} starting slot position
  @param {boolean} move forward
  @param {boolean} move only inside the given slot
  @return {number} slot found
  @return {number} slot position found
]]--------------------------------------------------------------------
local function findWeapon(slot, pos, forward, inSlot)
  -- do not search if there are no weapons
  if weaponCount <= 0 then return slot, pos end

  -- otherwise, search for the next weapon with ammo
  local weapons = #LocalPlayer():GetWeapons() -- current weapon count
  local noAmmo = 0 -- weapons with no ammunition left
  local weapon
  while (not weapon or (not weapon:HasAmmo() and skipEmpty(weapon))) do
    if forward then
      if pos < cacheLength[slot] then
        pos = pos + 1
      else
        pos = 1

        -- find next slot
        if not inSlot then
          slot = findSlot(slot + 1, true)
        end
      end
      weapon = cache[slot][pos] -- update current weapon
    else
      if pos > 1 then
        pos = pos - 1
      else
        -- find next slot
        if not inSlot then
          slot = findSlot(slot - 1, false)
        end

        pos = cacheLength[slot]
      end
      weapon = cache[slot][pos] -- update current weapon
    end

    -- add to no ammo list
    if not weapon:HasAmmo() then noAmmo = noAmmo + 1 end

    -- check whether all weapons are empty to stop search
    if noAmmo >= weapons then break end
  end

  -- if there are no weapons with ammo, show the selector empty
  if noAmmo >= weapons then pos = 0 end

  return slot, pos
end

--[[------------------------------------------------------------------
  Moves the cursor one position going to across all slots
  @param {boolean} move forward
]]--------------------------------------------------------------------
local function moveCursor(forward)
  -- do not move cursor if there are no weapons to cycle through
  if weaponCount <= 0 then return end

  -- if slot is out of bounds, get the current weapon's
  if curSlot <= 0 then
    local weapon = LocalPlayer():GetActiveWeapon()

    -- if there are no weapons equipped, start at the first slot
    if IsValid(weapon) then
      -- make sure weapon is on the cache
      if not weaponPos[weapon] then
        cacheWeapons(true)
      end

      -- get weapon information
      curSlot = weapon:GetSlot() + 1
      curPos = weaponPos[weapon]
    else
      curSlot = 1
      curPos = 0
    end
  end

  -- move cursor
  curSlot, curPos = findWeapon(curSlot, curPos, forward)
end

--[[------------------------------------------------------------------
  Moves the cursor inside a slot
  @param {number} slot
]]--------------------------------------------------------------------
local function cycleSlot(slot)
  -- do not move cursor if there are no weapons to cycle through
  if cacheLength[slot] <= 0 then
    curSlot = slot
    curPos = 0
    return
  end

  -- position to search from
  local pos = curPos

  -- if slot is new, start from the beginning
  if curSlot ~= slot then pos = 0 end

  -- search for weapon
  curSlot, curPos = findWeapon(slot, pos, true, true)
end

--[[------------------------------------------------------------------
  Selects the weapon highlighted in the switcher
]]--------------------------------------------------------------------
local function equipSelectedWeapon()
  local weapon = cache[curSlot][curPos]
  if not weapon or not IsValid(weapon) then return end
  input.SelectWeapon(weapon)
end

--[[------------------------------------------------------------------
  Whether the weapon selector is visible to the user
]]--------------------------------------------------------------------
function HL1AHUD.IsWeaponSelectorVisible()
  return HL1AHUD.IsEnabled() and HL1AHUD.ShouldDrawWeaponSelector() and (LocalPlayer and LocalPlayer().Alive and LocalPlayer():Alive()) and curSlot > 0
end

--[[------------------------------------------------------------------
  Implementation
]]--------------------------------------------------------------------

local hud_fastswitch = GetConVar('hud_fastswitch')

-- sounds
local UNABLE = 'hl1alphahud/wpn_denyselect.wav'
local CANCEL = 'hl1alphahud/wpn_hudoff.wav'
local SLOT_SELECT = 'hl1alphahud/wpn_hudon.wav'
local MOVE = 'hl1alphahud/wpn_moveselect.wav'
local SELECT = 'hl1alphahud/wpn_select.wav'

-- emits a sound from the weapon selector
local function emitSound(sound)
  LocalPlayer():EmitSound(sound, nil, nil, HL1AHUD.GetVolume(), CHAN_WEAPON)
end

-- draws the weapon selector
local function drawHUD()
  -- cache weapons
  cacheWeapons()

  -- do not draw if it shouldn't
  if not HL1AHUD.IsWeaponSelectorVisible() then return end

  -- choose colour
  local colour = HL1AHUD.GREEN
  if HL1AHUD.GetMode() == HL1AHUD.HUD_E3_98 then
    colour = HL1AHUD.ORANGE
  end

  -- draw weapon selector
  HL1AHUD.DrawWeaponSelector(28, 4, curSlot, curPos, cache, colour, HL1AHUD.GetScale())
end

-- paint into HUD
hook.Add('HUDPaint', 'hl1alphahud_switcher', function()
  drawHUD()
end)

-- paint into overlay if the camera is out
hook.Add('DrawOverlay', 'hl1alphahud_overlay', function()
  if not LocalPlayer or not LocalPlayer().GetActiveWeapon then return end -- avoid pre-init errors
  local weapon = LocalPlayer():GetActiveWeapon()
  if not IsValid(weapon) or weapon:GetClass() ~= CAMERA or gui.IsGameUIVisible() then return end
  drawHUD()
end)

-- select
UnintrusiveBindPress.add('hl1alphahud', function(_player, bind, pressed, code)
  if hud_fastswitch:GetBool() or LocalPlayer():InVehicle() or not HL1AHUD.IsEnabled() or not HL1AHUD.ShouldDrawWeaponSelector() then return end -- ignore if it shouldn't draw
  if not pressed then return end -- ignore if bind was not pressed

  -- check whether the physics gun is in use
  local weapon = LocalPlayer():GetActiveWeapon()
  if IsValid(weapon) and weapon:GetClass() == PHYSICS_GUN and LocalPlayer():KeyDown(IN_ATTACK) and (bind == INV_PREV or bind == INV_NEXT) then return true end

  -- move backwards
  if bind == INV_PREV then
    moveCursor(false)
    emitSound(MOVE)
    return true
  end

  -- move forward
  if bind == INV_NEXT then
    moveCursor(true)
    emitSound(MOVE)
    return true
  end

  -- cycle through slot
  if string.sub(bind, 1, 4) == SLOT then
    local slot = tonumber(string.sub(bind, 5))

    -- ignore if we go out of bounds
    if slot > 0 and slot <= MAX_SLOTS then
      if curSlot <= 0 then
        emitSound(SLOT_SELECT)
      else
        emitSound(MOVE)
      end
      cycleSlot(slot)
      return true
    end
  end

  -- select
  if curSlot > 0 and bind == ATTACK then
    if curPos > 0 then
      emitSound(SELECT)
    else
      emitSound(UNABLE)
    end
    equipSelectedWeapon()
    curSlot = 0
    return true
  end

  -- cancel
  if curSlot > 0 and bind == ATTACK2 then
    emitSound(CANCEL)
    curSlot = 0
    return true
  end
end)
