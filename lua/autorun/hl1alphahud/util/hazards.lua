--[[------------------------------------------------------------------
  Declare damage type icons
]]--------------------------------------------------------------------

if SERVER then return end

local hazards = {}

--[[------------------------------------------------------------------
  Registers a texture as a hazard icon
  @param {DMG_} damage type
  @param {Texture} texture
  @param {number} width
  @param {number} height
]]--------------------------------------------------------------------
function HL1AHUD.AddHazardTexture(damage_type, texture, w, h)
  hazards[damage_type] = {
    texture = texture,
    w = w,
    h = h
  }
end

--[[------------------------------------------------------------------
  Registers a sprite as a hazard icon
  @param {DMG_} damage type
  @param {string} sprite
]]--------------------------------------------------------------------
function HL1AHUD.AddHazardSprite(damage_type, sprite)
  hazards[damage_type] = {
    sprite = sprite
  }
end

--[[------------------------------------------------------------------
  Gets a damage type's icon
  @param {DMG_} damage type
  @return {table} hazard icon
]]--------------------------------------------------------------------
function HL1AHUD.GetHazardIcon(damage_type)
  return hazards[damage_type]
end

--[[------------------------------------------------------------------
  Draws a hazard icon
  @param {number} x
  @param {number} y
  @param {DMG_} damage type
  @param {Color} colour
  @param {number} alpha
  @param {number} scale
]]--------------------------------------------------------------------
function HL1AHUD.DrawHazardIcon(x, y, damage_type, colour, alpha, scale)
  local icon = hazards[damage_type]
  local w, h
  if icon.sprite then
    HL1AHUD.DrawSprite(icon.sprite, x, y, colour, alpha, scale)
  else
    surface.SetAlphaMultiplier(alpha)
    surface.SetDrawColor(colour)
    surface.SetTexture(icon.texture)
    surface.DrawTexturedRect(x, y, icon.w * scale, icon.h * scale)
    surface.SetAlphaMultiplier(1)
  end
end
