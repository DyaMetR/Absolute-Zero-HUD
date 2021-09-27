--[[------------------------------------------------------------------
  Item tray display
]]--------------------------------------------------------------------

if SERVER then return end

-- Constants
local SIZE, MARGIN = 60, 6
local WHITE, BACKGROUND_ALPHA = surface.GetTextureID('hl1alphahud/white_additive'), 7
local ICON_SCALE, EMPTY, FULL = 1.4, 'suit_empty', 'suit_full'

-- Variables
local bgCol = Color(0, 0, 0, 0)

-- draws the armour as an item icon
local function drawArmour(x, y, colour, scale)
  -- copy colour
  bgCol.r = colour.r
  bgCol.g = colour.g
  bgCol.b = colour.b
  bgCol.a = BACKGROUND_ALPHA

  -- draw background
  surface.SetTexture(WHITE)
  surface.SetDrawColor(bgCol)
  surface.DrawTexturedRect(x, y, SIZE * scale, SIZE * scale)

  -- displace icon
  x = x + scale
  y = y + scale

  -- draw background
  HL1AHUD.DrawSprite(EMPTY, x, y, colour, nil, scale * ICON_SCALE)

  -- draw foreground
  render.SetScissorRect(x, y + (1 - (LocalPlayer():Armor() * .01)) * SIZE * scale, x + SIZE * scale, y + SIZE * scale, true)
  HL1AHUD.DrawSprite(FULL, x, y, colour, nil, scale * ICON_SCALE)
  render.SetScissorRect(0, 0, 0, 0, false)
end

--[[------------------------------------------------------------------
  Draws the item tray
  @param {number} x
  @param {number} y
  @param {HUD_} hud mode
  @param {number} scale
]]--------------------------------------------------------------------
function HL1AHUD.DrawItemTray(x, y, mode, scale)
  if not HL1AHUD.ShouldDrawItemInventory() then return end

  -- offset
  x = x - SIZE * scale
  y = y - SIZE * scale

  -- select colour
  local colour = HL1AHUD.GREEN
  if mode == HL1AHUD.HUD_E3_98 then
    colour = HL1AHUD.ORANGE
  end

  -- displace the whole tray when using Early version
  if mode == HL1AHUD.HUD_EARLY or mode == HL1AHUD.HUD_GREEN_NO_BATTERY then y = y + SIZE * scale end

  -- draw tray
  local tray = HL1AHUD.GetItemTray()
  for pos, item in pairs(tray) do
    y = y - SIZE * scale
    -- when using Early version, we need to draw here the armour
    if (mode == HL1AHUD.HUD_EARLY or mode == HL1AHUD.HUD_GREEN_NO_BATTERY) and pos == math.min(5, #tray) then
      drawArmour(x, y, colour, scale)
      y = y - (SIZE + MARGIN) * scale
    end

    -- draw item
    HL1AHUD.DrawItem(item, x, y, colour, scale)
    y = y - MARGIN * scale
  end
end
