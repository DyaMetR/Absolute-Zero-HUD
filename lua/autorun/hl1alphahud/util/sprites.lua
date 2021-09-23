--[[------------------------------------------------------------------
  Register and display sprites
]]--------------------------------------------------------------------

if SERVER then return end

-- Constants
local DEFAULT_COLOUR = Color(255, 255, 255)

-- Variables
local sprites = {}

--[[------------------------------------------------------------------
  Generates a texture file descriptor table
  @param {number} texture
  @param {number} file width
  @param {number} file height
]]--------------------------------------------------------------------
function HL1AHUD.GenerateFileData(texture, file_w, file_h)
  return { file = texture, w = file_w, h = file_h }
end

--[[------------------------------------------------------------------
  Registers a sprite for its use
  @param {string} name
  @param {table} texture file data
  @param {number} x position in the file
  @param {number} y position in the file
  @param {number} sprite width
  @param {number} sprite height
]]--------------------------------------------------------------------
function HL1AHUD.AddSprite(name, texture_file_data, u, v, w, h)
  sprites[name] = { texture = texture_file_data, x = u, y = v, w = w, h = h }
end

--[[------------------------------------------------------------------
  Gets a registered sprite
  @param {string} sprite name
  @return {table} sprite data
]]--------------------------------------------------------------------
function HL1AHUD.GetSprite(name)
  return sprites[name]
end

--[[------------------------------------------------------------------
  Whether the given sprite is registered
  @param {string} name
  @return {boolean} is the sprite registered
]]--------------------------------------------------------------------
function HL1AHUD.HasSprite(name)
  return sprites[name] ~= nil
end

--[[------------------------------------------------------------------
  Draws the given sprite with the given properties
  @param {string} name
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {number} alpha
  @param {number} scale
]]--------------------------------------------------------------------
function HL1AHUD.DrawSprite(sprite, x, y, colour, alpha, scale)
  x = x or 0
  y = y or 0
  colour = colour or DEFAULT_COLOUR
  alpha = alpha or 1
  scale = scale or 1

  -- get sprite data
  local data = HL1AHUD.GetSprite(sprite)

  -- get previous alpha multiplier
  local mul = surface.GetAlphaMultiplier()

  -- sub-pixel correction
  local du = 0.5 / (data.texture.w * scale)
  local dv = 0.5 / (data.texture.h * scale)
  local u0, v0 = data.x / data.texture.w, data.y / data.texture.h
  local u1, v1 = (data.x + data.w) / data.texture.w, (data.y + data.h) / data.texture.h
  u0, v0 = (u0 - du) / (1 - 2 * du), (v0 - dv) / (1 - 2 * dv)
  u1, v1 = (u1 - du) / (1 - 2 * du), (v1 - dv) / (1 - 2 * dv)

  -- draw sprite
  surface.SetAlphaMultiplier(alpha)
  surface.SetTexture(data.texture.file)
  surface.SetDrawColor(colour)
  surface.DrawTexturedRectUV(x, y, data.w * scale, data.h * scale, u0, v0, u1, v1)
  surface.SetAlphaMultiplier(mul)
end
