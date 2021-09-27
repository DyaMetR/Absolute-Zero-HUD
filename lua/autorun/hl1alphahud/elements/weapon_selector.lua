--[[------------------------------------------------------------------
  Weapon switcher visual representation
]]--------------------------------------------------------------------

if SERVER then return end

-- Constants
local BUCKET = 'slot'
local SLOTS = {'slot1', 'slot2', 'slot3', 'slot4', 'slot5', 'slot6'}
local NUM_X, NUM_Y = 6, 7
local SLOT_MARGIN, BUCKET_HORIZONTAL_MARGIN, BUCKET_VERTICAL_MARGIN = 28, 174, 49
local BAR_BACKGROUND_COLOUR = Color(HL1AHUD.ORANGE.r, HL1AHUD.ORANGE.g, HL1AHUD.ORANGE.b, 100)
local BAR_FOREGROUND_COLOUR = Color(0, 255, 0, 255)
local BAR_MARGIN, BAR_WIDTH = 5, 20
local BAR_TEXTURE = surface.GetTextureID('hl1alphahud/white_additive')
local OUT_OF_AMMO_COLOUR = Color(255, 0, 0)

-- draws a slot header
local function DrawSlotHeader(slot, x, y, colour, scale)
  slot = math.Clamp(slot, 1, 6)
  HL1AHUD.DrawSprite(BUCKET, x, y, colour, nil, scale)
  HL1AHUD.DrawSprite(SLOTS[slot], x + NUM_X * scale, y + NUM_Y * scale, colour, nil, scale)
end

-- draw ammunition bar
local function DrawBar(x, y, value, scale)
  value = math.min(value, 1)
  surface.SetTexture(BAR_TEXTURE)

  local w = BAR_WIDTH * scale
  local fill = math.Round(w * value)

  -- background
  surface.SetDrawColor(BAR_BACKGROUND_COLOUR)
  surface.DrawTexturedRect(x + fill, y, w - fill, 4 * scale)

  -- foreground
  surface.SetDrawColor(BAR_FOREGROUND_COLOUR)
  surface.DrawTexturedRect(x, y, fill, 4 * scale)
end

-- draws a weapon bucket
local function DrawWeaponBucket(weapon, selected, x, y, colour, scale)
  HL1AHUD.DrawWeaponIcon(x, y, weapon, colour, scale, selected)

  -- get ammunition type
  local primary = weapon:GetPrimaryAmmoType()
  local secondary = weapon:GetSecondaryAmmoType()
  if primary <= 0 then
    primary = secondary
    secondary = 0
  end

  -- get ammunition amounts
  local reserve = LocalPlayer():GetAmmoCount(primary)
  local alt = LocalPlayer():GetAmmoCount(secondary)

  -- do not draw if there's no more reserve ammo
  if reserve <= 0 and alt <= 0 then return end

  -- draw primary ammunition
  DrawBar(x + 10 * scale, y, reserve / game.GetAmmoMax(primary), scale)

  -- draw secondary ammunition
  if secondary > 0 then
    DrawBar(x + (15 + BAR_WIDTH) * scale, y, alt / game.GetAmmoMax(secondary), scale)
  end
end

--[[------------------------------------------------------------------
  Draws the weapon selector
  @param {number} x
  @param {number} y
  @param {number} currently selected slot
  @param {number} currently selected position
  @param {table} weapons
  @param {Color} colour
  @param {number} scale
]]--------------------------------------------------------------------
function HL1AHUD.DrawWeaponSelector(x, y, cur_slot, cur_pos, weapons, colour, scale)
  for slot, buckets in pairs(weapons) do
    local is_cur_slot = cur_slot == slot and cur_pos > 0

    -- draw header
    DrawSlotHeader(slot, x, y, colour, scale)

    -- draw buckets
    local i = y + SLOT_MARGIN * scale
    for pos, weapon in pairs(buckets) do
      -- reserve colour
      local col = colour

      -- select colour
      if not weapon:HasAmmo() then
        col = OUT_OF_AMMO_COLOUR
      end

      -- draw weapon
      if is_cur_slot then
        DrawWeaponBucket(weapon, cur_pos == pos, x, i, col, scale)
        i = i + BUCKET_VERTICAL_MARGIN * scale
      else
        HL1AHUD.DrawSprite(BUCKET, x, i, col, nil, scale)
        i = i + SLOT_MARGIN * scale
      end
    end

    -- displace the following slots
    if is_cur_slot then
      x = x + BUCKET_HORIZONTAL_MARGIN * scale
    else
      x = x + SLOT_MARGIN * scale
    end
  end
end
