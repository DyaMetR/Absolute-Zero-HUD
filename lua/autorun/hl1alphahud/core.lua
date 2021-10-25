--[[------------------------------------------------------------------
  Include all required files and run main hooks
]]--------------------------------------------------------------------

if CLIENT then
  HL1AHUD.HUD_GREEN = 0
  HL1AHUD.HUD_EARLY = 1
  HL1AHUD.HUD_E3_98 = 2
  HL1AHUD.HUD_GREEN_NO_BATTERY = 3

  HL1AHUD.ORANGE = Color(255, 152, 0)
  HL1AHUD.GREEN = Color(50, 255, 0)
end

-- Configuration
HL1AHUD.IncludeFile('config/convars.lua')
HL1AHUD.IncludeFile('config/menu.lua')

-- Utilities
HL1AHUD.IncludeFile('util/hooks.lua')
HL1AHUD.IncludeFile('util/sprites.lua')
HL1AHUD.IncludeFile('util/numbers.lua')
HL1AHUD.IncludeFile('util/weapon_icons.lua')
HL1AHUD.IncludeFile('util/bind_press.lua')
HL1AHUD.IncludeFile('util/weapon_switcher.lua')
HL1AHUD.IncludeFile('util/hazards.lua')
HL1AHUD.IncludeFile('util/items.lua')
HL1AHUD.IncludeFile('util/highlight.lua')

-- Data
HL1AHUD.IncludeFile('data/sprites.lua')
HL1AHUD.IncludeFile('data/hazards.lua')
HL1AHUD.IncludeFile('data/weapons.lua')
HL1AHUD.IncludeFile('data/items.lua')
HL1AHUD.IncludeFile('data/upset.lua')

-- Elements
HL1AHUD.IncludeFile('elements/health.lua')
HL1AHUD.IncludeFile('elements/ammunition.lua')
HL1AHUD.IncludeFile('elements/damage.lua')
HL1AHUD.IncludeFile('elements/hazards.lua')
HL1AHUD.IncludeFile('elements/weapon_selector.lua')
HL1AHUD.IncludeFile('elements/items.lua')
HL1AHUD.IncludeFile('elements/death.lua')

-- Load add-ons
local files, directories = file.Find('autorun/hl1alphahud/add-ons/*.lua', 'LUA')
for _, file in pairs(files) do
  HL1AHUD.IncludeFile('add-ons/'..file)
end

--[[------------------------------------------------------------------
  Exclusive client side
]]--------------------------------------------------------------------
if CLIENT then

  local hadSuit = false

  -- Draw HUD
  hook.Add('HUDPaint', 'hl1alphahud_draw', function()
    if not HL1AHUD.IsEnabled() then return end

    -- update suit status while being alive
    if LocalPlayer():Health() > 0 then
      hadSuit = LocalPlayer():IsSuitEquipped()
    end

    -- do not draw without the suit
    if not HL1AHUD.ShouldDrawWithoutSuit() and not hadSuit then return end

    -- get settings
    local mode, scale = HL1AHUD.GetMode(), HL1AHUD.GetScale()

    -- draw health and ammunition
    if not HL1AHUD.IsWeaponSelectorVisible() then
      HL1AHUD.DrawHealth(mode, scale)
      HL1AHUD.DrawAmmunition(mode, scale)

      -- draw hazards only in yellow mode
      if mode == HL1AHUD.HUD_E3_98 then
        HL1AHUD.DrawHazards(11, ScrH() - 44 - (15 * scale), scale)
      end
    else
      HL1AHUD.DrawItemTray(ScrW() - 20, ScrH() - 20, mode, scale)
    end

    -- draw damage indicator
    HL1AHUD.DrawDamageIndicator(mode, HL1AHUD.GetDamageIndicatorScale())
  end)

  -- Hide default HUD
  local hide = {
    CHudHealth = true,
    CHudBattery = true,
    CHudAmmo = true,
    CHudSecondaryAmmo = true,
    CHudDamageIndicator = true,
    CHudPoisonDamageIndicator = true,
    CHudSuitPower = true
  }
  hook.Add('HUDShouldDraw', 'hl1alphahud_hide', function(element)
    if not HL1AHUD.IsEnabled() then return end
    local health, ammo = HL1AHUD.ShouldDrawHealth(), HL1AHUD.ShouldDrawAmmo()
    hide.CHudHealth = health
    hide.CHudBattery = health
    hide.CHudAmmo = ammo
    hide.CHudSecondaryAmmo = ammo
    hide.CHudDamageIndicator = HL1AHUD.ShouldDrawDamageIndicator()
    hide.CHudPoisonDamageIndicator = HL1AHUD.ShouldDrawHazards() and HL1AHUD.GetMode() == HL1AHUD.HUD_E3_98
    hide.CHudSuitPower = HL1AHUD.ShouldDrawItemInventory()
    if hide[element] then return false end
  end)

end
