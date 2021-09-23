--[[------------------------------------------------------------------
  Displays the player's current weapon's ammunition count
]]--------------------------------------------------------------------

if SERVER then return end

-- Constants
local DEFAULT_COLOUR = Color(0, 255, 0)
local E3_ZERO_SPRITE = '0'
local ZERO_SPRITE = 'g_s_0'
local E_ZERO_SPRITE = 'ge_s_0'
local G_SEPARATOR = 'g_separator'
local SEPARATOR = 'separator'
local NUMBER_ALPHA = 130 / 255
local HIGHLIGHT = 'ammo'

-- Variables
local last_clip = 0

-- Add highlight
HL1AHUD.AddHighlight(HIGHLIGHT)

-- Draws a three digit number with the faint zeroes
local function DrawGreenNumber(number, x, y, digit_style, colour, scale)
  local zero = ZERO_SPRITE
  if digit_style == HL1AHUD.DIGIT_SMALL_EARLY then zero = E_ZERO_SPRITE end
  local data = HL1AHUD.GetSprite(zero)

  -- move hud upwards in case scale is higher than 1
  y = y - (data.h * (scale - 1))

  if number > 0 then
    HL1AHUD.DrawNumber(number, digit_style, x, y, colour, DEFAULT_ALPHA, scale)
  end

  if number >= 100 then return data.w * scale * 3 end
  local digits = 0
  if number > 0 then digits = math.floor(math.log10(number)) + 1 end
  for i=1, 3 - digits do
    HL1AHUD.DrawSprite(zero, x - ((digits + i) * data.w * scale), y, colour, 0.2, scale)
  end
  return data.w * scale * 3
end

-- Draws the green ammunition counter
local function DrawGreenAmmo(x, y, style, scale)
  local digit = HL1AHUD.DIGIT_SMALL
  if style == HL1AHUD.HUD_EARLY then digit = HL1AHUD.DIGIT_SMALL_EARLY end
  local primary = LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()
  local secondary = LocalPlayer():GetActiveWeapon():GetSecondaryAmmoType()
  local clip1 = LocalPlayer():GetActiveWeapon():Clip1()

  y = y - (24 * (scale - 1))

  if secondary <= 0 and primary > 0 and clip1 <= -1 then
    secondary = primary
    primary = 0
  end

  -- Draw primary ammo
  if primary > 0 then
    local offset = DrawGreenNumber(LocalPlayer():GetAmmoCount(primary), x, y, digit, DEFAULT_COLOUR, scale)
    offset = offset + (HL1AHUD.GetSprite(G_SEPARATOR).w * scale)
    HL1AHUD.DrawSprite(G_SEPARATOR, x - offset - scale, y - (HL1AHUD.GetSprite(G_SEPARATOR).h * (scale - 1)), DEFAULT_COLOUR, DEFAULT_ALPHA, scale)

    -- Draw clip
    if clip1 > -1 then
      DrawGreenNumber(clip1, x - offset, y, digit, DEFAULT_COLOUR, scale)
    end
  end

  -- Draw secondary ammo
  if secondary > 0 then
    DrawGreenNumber(LocalPlayer():GetAmmoCount(secondary), x - (16 * scale), y + (27 * scale), digit, DEFAULT_COLOUR, scale)
  end
end

-- Draws the ammo indicator from the E3 '98 version
local function DrawE398Ammo(x, y, scale)
  local primary = LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()
  local secondary = LocalPlayer():GetActiveWeapon():GetSecondaryAmmoType()
  local clip1 = LocalPlayer():GetActiveWeapon():Clip1()
  local data = HL1AHUD.GetSprite(E3_ZERO_SPRITE)
  local size = data.w * 3 * scale
  local alpha = HL1AHUD.GetHighlight(HIGHLIGHT)

  y = y - (HL1AHUD.GetSprite(SEPARATOR).h * (scale - 1))

  -- Check if secondary is the only type
  if primary <= 0 and secondary > 0 then
    primary = secondary
    secondary = 0
    clip1 = -1
  end

  -- Value to compare
  local compare = clip1
  if clip1 <= -1 then compare = primary end

  -- Highlight
  if last_clip ~= compare then
    HL1AHUD.Highlight(HIGHLIGHT)
    last_clip = compare
  end

  -- Draw secondary ammo
  if secondary > 0 then
    HL1AHUD.DrawNumber(LocalPlayer():GetAmmoCount(secondary), HL1AHUD.DIGIT_E3_98, x - (19 * scale), y - (41 * scale), HL1AHUD.ORANGE, NUMBER_ALPHA, scale)
    HL1AHUD.DrawNumber(LocalPlayer():GetAmmoCount(secondary), HL1AHUD.DIGIT_E3_98, x - (19 * scale), y - (41 * scale), HL1AHUD.ORANGE, alpha, scale) -- highlight
  end

  -- Draw primary ammo
  HL1AHUD.DrawNumber(LocalPlayer():GetAmmoCount(primary), HL1AHUD.DIGIT_E3_98, x, y, HL1AHUD.ORANGE, NUMBER_ALPHA, scale)
  HL1AHUD.DrawNumber(LocalPlayer():GetAmmoCount(primary), HL1AHUD.DIGIT_E3_98, x, y, HL1AHUD.ORANGE, alpha, scale) -- highlight
  x = x - size - (12 * scale)
  if clip1 > -1 then
    HL1AHUD.DrawSprite(SEPARATOR, x, y - (4 * scale), HL1AHUD.ORANGE, NUMBER_ALPHA, scale)
    HL1AHUD.DrawNumber(clip1, HL1AHUD.DIGIT_E3_98, x - (11 * scale), y, HL1AHUD.ORANGE, NUMBER_ALPHA, scale)

    -- draw highlight
    HL1AHUD.DrawSprite(SEPARATOR, x, y - (4 * scale), HL1AHUD.ORANGE, alpha, scale)
    HL1AHUD.DrawNumber(clip1, HL1AHUD.DIGIT_E3_98, x - (11 * scale), y, HL1AHUD.ORANGE, alpha, scale)
  end
end

--[[------------------------------------------------------------------
  Draws the ammunition component
  @param {HUD_} style
  @param {number} scale
]]--------------------------------------------------------------------
function HL1AHUD.DrawAmmunition(style, scale)
  if not HL1AHUD.ShouldDrawAmmo() then return end
  if not IsValid(LocalPlayer():GetActiveWeapon()) or (LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() <= 0 and LocalPlayer():GetActiveWeapon():GetSecondaryAmmoType() <= 0) then return end
  if style < HL1AHUD.HUD_E3_98 then
    DrawGreenAmmo(ScrW() - 16, ScrH() - 55, style, scale)
  else
    DrawE398Ammo(ScrW() - 21, ScrH() - 44, scale)
  end
end
