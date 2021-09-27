--[[------------------------------------------------------------------
  Displays the player's current health and suit battery values
]]--------------------------------------------------------------------

if SERVER then return end

-- Constants
local ZERO_SPRITE = '0'
local G_ZERO_SPRITE = 'g_0'
local GE_ZERO_SPRITE = 'ge_0'
local G_BATTERY_EMPTY = 'g_battery_empty'
local G_BATTERY_FILL = 'g_battery_fill'
local BATTERY_EMPTY = 'battery_empty'
local BATTERY_FILL = 'battery_fill'
local SEPARATOR = 'separator'
local FULL_RED_MIN = 20 --15
local YELLOW_MARK = 70 --70
local BRIGHTNESS = 255 --125
local RED = Color(245, 8, 8)
local DEFAULT_ALPHA = 1
local EMPTY_ALPHA = .2
local NUMBER_ALPHA = 130 / 255
local HIGHLIGHT = 'health'

-- Variables
local health_colour = Color(0, 0, 5)
local last_health = 100

-- Add highlights
HL1AHUD.AddHighlight(HIGHLIGHT)

--[[------------------------------------------------------------------
  Returns a colour based on current health (green variants)
  @return {Color} colour
]]--------------------------------------------------------------------
function HL1AHUD.GetHealthColour()
  local health = math.Clamp(LocalPlayer():Health(), 0, 100)
  if health >= YELLOW_MARK then
    health_colour.r = ((-health + FULL_RED_MIN + 100) / (100 + FULL_RED_MIN - YELLOW_MARK)) * BRIGHTNESS
    health_colour.g = BRIGHTNESS
  else
    health_colour.r = BRIGHTNESS
    health_colour.g = health / YELLOW_MARK * BRIGHTNESS
  end
  return health_colour
end

-- Draws the armour battery
local function DrawBattery(x, y, colour, style, scale, alpha)
  alpha = alpha or DEFAULT_ALPHA
  local armour = LocalPlayer():Armor()
  local battery_empty, battery_fill, offset = G_BATTERY_EMPTY, G_BATTERY_FILL, 6
  if style == HL1AHUD.HUD_E3_98 then battery_empty = BATTERY_EMPTY; battery_fill = BATTERY_FILL; offset = 13 end

  -- armour looks empty when dead
  if not LocalPlayer():Alive() then armour = 0 end

  -- draw background
  HL1AHUD.DrawSprite(battery_empty, x, y, colour, alpha, scale)

  -- draw fill
  local data = HL1AHUD.GetSprite(battery_fill)
  x = x + (offset * scale)
  render.SetScissorRect( x, y, x + (data.w * scale) * armour * 0.01, y + (data.h * scale), true )
  HL1AHUD.DrawSprite(battery_fill, x, y, colour, alpha, scale)
  render.SetScissorRect( 0, 0, 0, 0, false )
end

-- Draws the green health indicator
local function DrawGreenHealth(x, y, style, scale)
  local zero = G_ZERO_SPRITE
  local digit = HL1AHUD.DIGIT_GREEN
  if style == HL1AHUD.HUD_EARLY then zero = GE_ZERO_SPRITE; digit = HL1AHUD.DIGIT_EARLY end

  local colour = HL1AHUD.GetHealthColour()
  local data = HL1AHUD.GetSprite(zero) -- digit sprite data

  -- move hud upwards in case scale is higher than 1
  y = y - data.h * (scale - 1)

  -- draw armour
  if style == HL1AHUD.HUD_GREEN or style == HL1AHUD.HUD_E3_98 then
    local alpha = DEFAULT_ALPHA

    -- reduce alpha if there's no armour left
    if style == HL1AHUD.HUD_GREEN and not LocalPlayer():Alive() then
      alpha = EMPTY_ALPHA
    end

    -- draw battery
    DrawBattery(x, y - (35 * scale), colour, style, scale * 1, alpha)
  end

  -- move health digits
  x = x + data.w * 3 * scale

  -- draw health
  local health = LocalPlayer():Health()
  if health > 0 then
    HL1AHUD.DrawNumber(health, digit, x, y, colour, DEFAULT_ALPHA, scale)
  end

  -- draw zeroes
  if health >= 100 then return end
  local digits = 0
  if health > 0 then digits = math.floor(math.log10(health)) + 1 end
  for i=1, 3 - digits do
    HL1AHUD.DrawSprite(zero, x - ((digits + i) * data.w * scale), y, colour, 0.2, scale)
  end
end

-- Draws the E3 98 health indicator
local function DrawE398Health(x, y, scale)
  local health = LocalPlayer():Health()
  local colour = HL1AHUD.ORANGE
  local data = HL1AHUD.GetSprite(ZERO_SPRITE)
  local size = data.w * 3 * scale
  local alpha = HL1AHUD.GetHighlight(HIGHLIGHT)
  y = y - (HL1AHUD.GetSprite(SEPARATOR).h * (scale - 1))

  -- Highlight elements
  if last_health ~= health then
    HL1AHUD.Highlight(HIGHLIGHT)
    last_health = health
  end

  -- When on low health, alpha is maximum
  if health <= 15 then alpha = DEFAULT_ALPHA end

  -- Draw armour
  HL1AHUD.DrawSprite(SEPARATOR, x + size + (11 * scale), y - (4 * scale), colour, NUMBER_ALPHA, scale)
  DrawBattery(x + size + (22 * scale), y - (3 * scale), colour, HL1AHUD.HUD_E3_98, scale, NUMBER_ALPHA)

  -- Draw armour highlight
  HL1AHUD.DrawSprite(SEPARATOR, x + size + (11 * scale), y - (4 * scale), colour, alpha, scale)
  DrawBattery(x + size + (22 * scale), y - (3 * scale), colour, HL1AHUD.HUD_E3_98, scale, alpha)

  -- Draw health
  if health <= 25 then colour = RED end
  HL1AHUD.DrawNumber(health, HL1AHUD.DIGIT_E3_98, x + size, y, colour, NUMBER_ALPHA, scale)
  HL1AHUD.DrawNumber(health, HL1AHUD.DIGIT_E3_98, x + size, y, colour, alpha, scale) -- highlight
end

--[[------------------------------------------------------------------
  Draws the health component
  @param {HUD_} style
  @param {number} scale
]]--------------------------------------------------------------------
function HL1AHUD.DrawHealth(style, scale)
  if not HL1AHUD.ShouldDrawHealth() then return end
  scale = scale or 1
  if style == HL1AHUD.HUD_E3_98 then
    DrawE398Health(11, ScrH() - 44, scale)
  else
    DrawGreenHealth(14, ScrH() - 61, style, scale)
  end
end
