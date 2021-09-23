--[[------------------------------------------------------------------
  Item inventory
]]--------------------------------------------------------------------

if SERVER then return end

local NUMBERS = {'slot1', 'slot2', 'slot3', 'slot4', 'slot5', 'slot6'}
local NUMBER_HORIZONTAL_MARGIN, NUMBER_VERTICAL_MARGIN = 4, 38
local BOOL_TYPE = 'boolean'

local items = {}
local tray = {}

-- base function for adding new items
local function addItem(id, data)
  items[id] = data
  table.insert(tray, id)
end

--[[------------------------------------------------------------------
  Overrides an existing item's function
  @param {string} id
  @param {function} new checker function
]]--------------------------------------------------------------------
function HL1AHUD.OverrideItem(id, func)
  items[id].func = func
end

--[[------------------------------------------------------------------
  Adds a double-texture item icon, returning a number in function
  makes it a vertical progress bar
  @param {string} id
  @param {Texture} off/background
  @param {Texture} on/foreground
  @param {number} width
  @param {number} height
  @param {function} function
]]--------------------------------------------------------------------
function HL1AHUD.AddDuoItemTexture(id, off, on, w, h, func)
  addItem(id, {
    is_duo = true,
    off = off,
    on = on,
    w = w,
    h = h,
    func = func
  })
end

--[[------------------------------------------------------------------
  Adds a double-sprite item icon, returning a number in function
  makes it a vertical progress bar
  @param {string} id
  @param {string} off/background
  @param {string} on/foreground
  @param {function} function
]]--------------------------------------------------------------------
function HL1AHUD.AddDuoItemSprite(id, off, on, func)
  addItem(id, {
    is_duo = true,
    is_sprite = true,
    off = off,
    on = on,
    func = func
  })
end

--[[------------------------------------------------------------------
  Adds a cumulative item texture
  @param {string} id
  @param {Texture} icon
  @param {number} width
  @param {number} height
  @param {function} function
]]--------------------------------------------------------------------
function HL1AHUD.AddCountItemTexture(id, icon, w, h, func)
  addItem(id, {
    texture = icon,
    w = w,
    h = h,
    func = func
  })
end

--[[------------------------------------------------------------------
  Adds a cumulative item sprite
  @param {string} id
  @param {Texture} icon
  @param {function} function
]]--------------------------------------------------------------------
function HL1AHUD.AddCountItemSprite(id, sprite, func)
  addItem(id, {
    is_sprite = true,
    sprite = sprite,
    func = func
  })
end

--[[------------------------------------------------------------------
  Draws an item icon
  @param {string} id
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {number} scale
]]--------------------------------------------------------------------
function HL1AHUD.DrawItem(id, x, y, colour, scale)
  local item = items[id]
  local texture
  local value

  -- select background texture
  if item.is_duo then
    if item.func then value = item.func() end

    -- select
    if value and type(value) == BOOL_TYPE then
      texture = item.on
    else
      texture = item.off
    end
  else
    if item.is_sprite then
      texture = item.sprite
    else
      texture = item.texture
    end
  end

  -- draw background
  if item.is_sprite then
    HL1AHUD.DrawSprite(texture, x, y, colour, nil, scale)
  else
    surface.SetTexture(texture)
    surface.SetDrawColor(colour)
    surface.DrawTexturedRect(x, y, item.w * scale, item.h * scale)
  end

  -- draw foreground
  if not item.is_duo then
    if (value or 0) <= 0 then return end -- do not draw if count is below zero
    HL1AHUD.DrawSprite(NUMBERS[math.max(value, #NUMBERS)], x + (NUMBER_HORIZONTAL_MARGIN * scale), y + (NUMBER_VERTICAL_MARGIN * scale), colour, nil, scale)
  else
    -- if not numeric, do not draw
    if type(value) == BOOL_TYPE then return end

    local w, h

    -- get size for scissor
    if item.is_sprite then
      local sprite = HL1AHUD.GetSprite(item.on)
      w = sprite.w * scale
      h = sprite.h * scale
    else
      w = item.w * scale
      h = item.h * scale
    end

    -- draw foreground
    local v = h * (1 - (value or 0))
    render.SetScissorRect(x, y + v, x + w, y + h, true)
    if item.is_sprite then
      HL1AHUD.DrawSprite(item.on, x, y, colour, nil, scale)
    else
      surface.SetTexture(item.on)
      surface.SetDrawColor(colour)
      surface.DrawTexturedRect(x, y, w, h)
    end
    render.SetScissorRect(0, 0, 0, 0, false)
  end
end


--[[------------------------------------------------------------------
  Gets the order of items in the tray
  @return {table} tray
]]--------------------------------------------------------------------
function HL1AHUD.GetItemTray()
  return tray
end
