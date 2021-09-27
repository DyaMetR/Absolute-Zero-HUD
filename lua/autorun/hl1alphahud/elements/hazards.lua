--[[------------------------------------------------------------------
  Displays the type of damage the player is receiving
]]--------------------------------------------------------------------

local NET = 'hl1ahud_hazards'

if CLIENT then

  -- Constants
  local MAX_TIME = 3
  local FREQ = 0.016
  local RED = Color(255, 0, 0)

  -- Variables
  local hazards = {}
  local hazard_types = {}
  local time = 0
  local alpha = 0
  local blinked = false
  local tick = 0

  --[[------------------------------------------------------------------
    Animates the hazard tray
  ]]--------------------------------------------------------------------
  local function Animate()
    if #hazards <= 0 then return end

    -- make icons blink
    if tick < CurTime() then
      if blinked then
        alpha = math.max(alpha - FREQ, 0)
        blinked = alpha > 0
      else
        alpha = math.min(alpha + FREQ, 1)
        blinked = alpha >= 1
      end
      tick = CurTime() + .01
    end

    -- end blinking after some time
    if time < CurTime() and not blinked then
      table.Empty(hazards)
      table.Empty(hazard_types)
    end
  end

  --[[------------------------------------------------------------------
    Draws the hazard tray
    @param {number} x
    @param {number} y
    @param {number} scale
  ]]--------------------------------------------------------------------
  function HL1AHUD.DrawHazards(x, y, scale)
    if not HL1AHUD.ShouldDrawHazards() then return end

    -- get colour to use
    local colour = HL1AHUD.ORANGE
    if LocalPlayer():Health() <= 25 then colour = RED end

    -- animate
    Animate()

    for _, hazard in pairs(hazards) do
      -- get icon height
      local icon, h = HL1AHUD.GetHazardIcon(hazard)
      if icon.sprite then
        h = HL1AHUD.GetSprite(icon.sprite).h
      else
        h = icon.h
      end

      -- displace
      y = y - h * scale

      -- draw
      HL1AHUD.DrawHazardIcon(x, y, hazard, colour, alpha, scale)
    end
  end

  --[[------------------------------------------------------------------
    Receives the hazards
  ]]--------------------------------------------------------------------
  net.Receive(NET, function(len)
    -- receive hazard type
    local hazard = net.ReadInt(32)

    -- if there's no valid hazard icon, skip
    if not HL1AHUD.GetHazardIcon(hazard) then return end

    -- reset delay
    time = CurTime() + MAX_TIME

    -- if it's already present, do not add
    if hazard_types[hazard] then return end

    -- add hazard to tray
    table.insert(hazards, hazard)

    -- register hazard type to avoid duplicates
    hazard_types[hazard] = true
  end)

end

if SERVER then

  -- create network string
  util.AddNetworkString(NET)

  -- detect damage type inflicted
  hook.Add('EntityTakeDamage', 'hl1alphahud_hazards', function(_player, dmginfo)
    if not _player:IsPlayer() or not _player:Alive() or math.Round(dmginfo:GetDamage()) <= 0 then return end -- players only
    -- send new hazard
    net.Start(NET)
    net.WriteInt(dmginfo:GetDamageType(), 32)
    net.Send(_player)
  end)

end
