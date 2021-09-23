--[[------------------------------------------------------------------
  Allow elements to be highlighted on command
]]--------------------------------------------------------------------

if SERVER then return end

local TICK_RATE = .1

local highlight = {}
local tick = 0

--[[------------------------------------------------------------------
  Adds a highlight to use
  @param {string} id
]]--------------------------------------------------------------------
function HL1AHUD.AddHighlight(id)
  highlight[id] = 0
end

--[[------------------------------------------------------------------
  Gets the alpha amount of a highlight
  @param {string} id
  @return {number} alpha
]]--------------------------------------------------------------------
function HL1AHUD.GetHighlight(id)
  return highlight[id]
end

--[[------------------------------------------------------------------
  Triggers the given highlight's animation
  @param {string} id
]]--------------------------------------------------------------------
function HL1AHUD.Highlight(id)
  highlight[id] = 1
end

--[[------------------------------------------------------------------
  Animation implementation
]]--------------------------------------------------------------------
hook.Add('HUDPaint', 'hl1alphahud_highlight', function()
  if tick < CurTime() then
    for i, value in pairs(highlight) do
      highlight[i] = math.max(value - .01, 0)
    end
    tick = CurTime() + TICK_RATE
  end
end)
