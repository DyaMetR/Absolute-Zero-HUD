--[[------------------------------------------------------------------
  Displays where is the player being attacked from
]]--------------------------------------------------------------------

-- ENUMS
local UP = 1
local DOWN = 2
local LEFT = 3
local RIGHT = 4

-- NET
local NET = 'hl1alphahud_damage'

if CLIENT then

  local W, H = 120, 48 -- pain indicators sizes
  local TICK = 0.01 -- how often does the indicator tick
  local FREQ = 0.05 -- how fast it fades off
  local LYT_ADD_FREQ = 0.4 -- how fast the layout fades in
  local LYT_DWN_FREQ = 0.04 -- how fast the layout fades off
  local ALPHA = 1 -- starting alpha
  local DEFAULT_COLOUR = Color(255, 0, 0) -- default colour
  local SPRITES = { 'pain0', 'pain2', 'pain1', 'pain3' }
  local TEXTURE = surface.GetTextureID('hl1alphahud/white_additive')
  local SEPARATOR = 100

  local red_colour = Color(255, 0, 0) -- red layout colour
  local tick = 0 -- animation ticker
  local damage = {} -- directional indicators
  local damaged, _damage = false, 0 -- damage layout alpha
  for i=1, 4 do
    damage[i] = 0
  end

  -- animates the directional indicators
  local function Animate()
    if tick < CurTime() then
      -- fade out directional indicators
      for i, dmg in pairs(damage) do
        damage[i] = math.max(dmg - FREQ, 0)
      end
      -- fade out layout
      if damaged then
        if _damage >= 1 then damaged = false end
        _damage = math.min(_damage + LYT_ADD_FREQ, 1)
      else
        _damage = math.max(_damage - LYT_DWN_FREQ, 0)
      end
      tick = CurTime() + TICK
    end
  end

  --[[------------------------------------------------------------------
    Draws the directional damage indicators
    @param {HUD_} style
    @param {number} scale
  ]]--------------------------------------------------------------------
  function HL1AHUD.DrawDamageIndicator(style, scale)
    if not HL1AHUD.ShouldDrawDamageIndicator() then return end

    -- animate
    Animate()

    -- layout damage
    red_colour.a = 255 * _damage
    surface.SetTexture(TEXTURE)
    surface.SetDrawColor(red_colour)
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

    -- pain indicators
    local colour = HL1AHUD.GetHealthColour()
    if style == HL1AHUD.HUD_E3_98 then colour = DEFAULT_COLOUR end
    local x, y = ScrW() * .5, ScrH() * .5
    local w, h, sep = W * scale, H * scale, (SEPARATOR * scale)

    HL1AHUD.DrawSprite(SPRITES[UP], x - (w * .5), y - h - sep, colour, damage[UP], scale)
    HL1AHUD.DrawSprite(SPRITES[DOWN], x - (w * .5), y + sep, colour, damage[DOWN], scale)
    HL1AHUD.DrawSprite(SPRITES[RIGHT], x - h - sep, y - (w * .5), colour, damage[RIGHT], scale)
    HL1AHUD.DrawSprite(SPRITES[LEFT], x + sep, y - (w * .5), colour, damage[LEFT], scale)
  end

  -- Receive damage
  net.Receive(NET, function()
    local up = net.ReadBool()
    local down = net.ReadBool()
    local left = net.ReadBool()
    local right = net.ReadBool()
    if up then damage[UP] = 1 end
    if down then damage[DOWN] = 1 end
    if left then damage[LEFT] = 1 end
    if right then damage[RIGHT] = 1 end
    damaged = true
  end)

end

if SERVER then

  util.AddNetworkString(NET)

  local GENERIC = {
    [DMG_GENERIC] = true,
    [DMG_CRUSH] = true,
    [DMG_SONIC] = true
  }
  local DISTANCE = 100 * 100

  -- Process the damage taken
  hook.Add('EntityTakeDamage', 'hl1alphahud_damage', function(_player, dmginfo)
    if not _player:IsPlayer() or not _player:Alive() or not IsValid(dmginfo:GetAttacker()) or dmginfo:GetDamage() <= 0 then return end

    local origin = dmginfo:GetAttacker():GetPos() -- position of the attacker
    local noHeight = Vector(_player:GetPos().x, _player:GetPos().y, 0) -- ignore height, this is only for the direction
    local yaw = Angle(0, _player:EyeAngles().y, 0) -- get only the yaw, which is the only angle we need
    local worldToLocal = WorldToLocal(origin, angle_zero, noHeight, yaw) -- get the relative angle
    local angle = worldToLocal:Angle().y -- take out only the yaw

    -- get brackets to light up
    local tooClose = (dmginfo:GetAttacker() == _player and dmginfo:GetDamagePosition():DistToSqr(_player:GetPos()) < DISTANCE) or GENERIC[dmginfo:GetDamageType()]
    local up = angle >= 295 or angle < 65 or tooClose
    local down = (angle >= 115 and angle < 245) or tooClose
    local left = (angle >= 205 and angle < 335) or tooClose
    local right = (angle >= 25 and angle < 155) or tooClose

    -- send result to player
    net.Start(NET)
    net.WriteBool(up)
    net.WriteBool(down)
    net.WriteBool(left)
    net.WriteBool(right)
    net.Send(_player)
  end)

end
