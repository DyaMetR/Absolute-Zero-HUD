--[[------------------------------------------------------------------
  Item tray display
]]--------------------------------------------------------------------

if SERVER then return end

local SIZE, MARGIN = 60, 6

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

  -- draw tray
  for pos, item in pairs(HL1AHUD.GetItemTray()) do
    y = y - SIZE * scale
    HL1AHUD.DrawItem(item, x, y, colour, scale)
    y = y - MARGIN * scale
  end
end
