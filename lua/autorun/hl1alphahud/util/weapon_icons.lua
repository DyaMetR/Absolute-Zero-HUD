--[[------------------------------------------------------------------
  Register custom weapon icons
]]--------------------------------------------------------------------

if SERVER then return end

local GENERIC_BUCKET = surface.GetTextureID('hl1alphahud/640hud_bucket')
local BUCKET_WIDTH, BUCKET_HEIGHT = 256, 64
local BUCKET_HORIZONTAL_MARGIN, BUCKET_VERTICAL_MARGIN = 170, 45
local HIGHLIGHT = 'highlight'
local DEFAULT_ALPHA = 255
local MISSING_ICON = '%s icon'

local icons = {}

--[[------------------------------------------------------------------
  Adds a weapon icon in the form of custom textures
  @param {string} weapon class
  @param {Texture} idle icon
  @param {Texture|nil} highlighted icon
  @param {number} width
  @param {number} height
]]--------------------------------------------------------------------
function HL1AHUD.AddWeaponTexture(weapon_class, idle, selected, w, h)
  icons[weapon_class] = {
    idle = idle,
    selected = selected,
    w = w,
    h = h
  }
end

--[[------------------------------------------------------------------
  Registers a sprite as a weapon icon
  @param {string} weapon class
  @param {string} weapon icon
  @param {string} selected weapon icon
]]--------------------------------------------------------------------
function HL1AHUD.AddWeaponSprite(weapon_class, idle, selected)
  icons[weapon_class] = {
    is_sprite = true,
    idle = idle,
    selected = selected
  }
end

--[[------------------------------------------------------------------
  Registers a custom function to call when rendering the weapon's icon
  @param {string} weapon class
  @param {function} draw function
]]--------------------------------------------------------------------
function HL1AHUD.AddWeaponDynamicIcon(weapon_class, func)
  icons[weapon_class] = {
    is_dynamic = true,
    func = func
  }
end

--[[------------------------------------------------------------------
  Retrieves the weapon icon data
  @param {string} weapon class
  @return {table} weapon icon
]]--------------------------------------------------------------------
function HL1AHUD.GetWeaponIcon(weapon_class)
  return icons[weapon_class]
end

--[[------------------------------------------------------------------
  Draws a weapon icon
  @param {number} x
  @param {number} y
  @param {Weapon} weapon
  @param {Color} colour
  @param {number} scale
  @param {boolean|nil} only valid with sprites -- uses the 'selected' sprite
]]--------------------------------------------------------------------
function HL1AHUD.DrawWeaponIcon(x, y, weapon, colour, scale, selected)
  local icon = HL1AHUD.GetWeaponIcon(weapon:GetClass())

  -- draw icon
  if not icon then
    local frame_w, frame_h = BUCKET_HORIZONTAL_MARGIN * scale, BUCKET_VERTICAL_MARGIN * scale
    local w, h = 128 * scale, 96 * scale

    -- draw background
    surface.SetTexture(GENERIC_BUCKET)
    surface.SetDrawColor(colour)
    surface.DrawTexturedRect(x, y, BUCKET_WIDTH * scale, BUCKET_HEIGHT * scale)

    -- draw which weapon is missing the icon
    if not weapon.DrawWeaponSelection then
      draw.SimpleText(string.format(MISSING_ICON, language.GetPhrase(weapon:GetPrintName())), 'default', x + frame_w * .5, y + frame_h * .5, colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
      -- disable bouncy icon
      local bounce = weapon.BounceWeaponIcon
      weapon.BounceWeaponIcon = false

      -- draw icon
      render.SetScissorRect(x, y, x + frame_w, y + frame_h, true)
      weapon:DrawWeaponSelection(x + (frame_w * .5) - (w * .5), y + (frame_h * .5) - (h * .37), w, h, DEFAULT_ALPHA)
      render.SetScissorRect(0, 0, 0, 0, false)

      -- restore bouncy icon
      weapon.BounceWeaponIcon = bounce
    end
  else
    if icon.is_sprite then
      local sprite = icon.idle
      if selected then sprite = icon.selected end
      HL1AHUD.DrawSprite(sprite, x, y, colour, nil, scale)
    elseif icon.is_dynamic then
      icon.func(x, y, weapon, colour, scale, selected)
    else
      local texture = icon.idle
      if selected then texture = icon.selected end
      surface.SetTexture(texture)
      surface.SetDrawColor(colour)
      surface.DrawTexturedRect(x, y, icon.w * scale, icon.h * scale)
    end
  end

  -- draw highlight if selected
  if not selected then return end
  HL1AHUD.DrawSprite(HIGHLIGHT, x, y, colour, nil, scale)
end
