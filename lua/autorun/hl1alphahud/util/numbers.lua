--[[------------------------------------------------------------------
  Draw numbers from all styles
]]--------------------------------------------------------------------

if SERVER then return end

-- enums
HL1AHUD.DIGIT_GREEN = 0
HL1AHUD.DIGIT_SMALL = 1
HL1AHUD.DIGIT_EARLY = 2
HL1AHUD.DIGIT_SMALL_EARLY = 3
HL1AHUD.DIGIT_E3_98 = 4

-- Constants
local DEFAULT_COLOUR = Color(255, 255, 255)
local SPRITE_SETS = {
  [HL1AHUD.DIGIT_GREEN] = 'g_',
  [HL1AHUD.DIGIT_SMALL] = 'g_s_',
  [HL1AHUD.DIGIT_SMALL_EARLY] = 'ge_s_',
  [HL1AHUD.DIGIT_EARLY] = 'ge_',
  [HL1AHUD.DIGIT_E3_98] = ''
}

--[[------------------------------------------------------------------
  Draws a number with the given style
  @param {number} number
  @param {DIGIT_} style
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {number} alpha
  @param {number} scale
]]--------------------------------------------------------------------
function HL1AHUD.DrawNumber(number, style, x, y, colour, alpha, scale)
  number = tostring(math.max(0, number)) -- can't do negative numbers
  colour = colour or DEFAULT_COLOUR
  scale = scale or 1

  -- get digit size
  local data = HL1AHUD.GetSprite(SPRITE_SETS[style] .. string.sub(number, 1, 1))
  local size = string.len(number) * data.w * scale
  x = x - size

  for i=1, string.len(number) do
    HL1AHUD.DrawSprite(SPRITE_SETS[style] .. string.sub(number, i, i), x + (data.w * scale * (i - 1)), y, colour, alpha, scale)
  end
end
