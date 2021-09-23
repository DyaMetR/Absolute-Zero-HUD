--[[------------------------------------------------------------------
  Default item icons
]]--------------------------------------------------------------------

if SERVER then return end

local suit_convar, auxpow_convar = GetConVar('gmod_suit'), GetConVar('sv_auxpow_enabled')

HL1AHUD.AddDuoItemSprite('flashlight', 'flash_off', 'flash_on', function() return LocalPlayer():FlashlightIsOn() end)
HL1AHUD.AddCountItemSprite('adrenaline', 'adrenaline')
HL1AHUD.AddCountItemSprite('antidote', 'antidote')
HL1AHUD.AddCountItemSprite('radiation', 'radiation')
HL1AHUD.AddDuoItemSprite('longjump', 'longjump_empty', 'longjump_full')
HL1AHUD.AddDuoItemSprite('airtank', 'airtank_empty', 'airtank_full', function()
  if AUXPOW and auxpow_convar:GetBool() then -- aux power addon support
    return AUXPOW:GetPower()
  else
    if suit_convar:GetBool() then
      return LocalPlayer():GetSuitPower() * .01
    else
      return 0
    end
  end
end)

--[[------------------------------------------------------------------
  HEV Mark V Auxiliary Power support
]]--------------------------------------------------------------------
hook.Add('AuxPowerHUDPaint', 'hl1ahud_auxpow', function(power, labels)
  if not HL1AHUD.IsEnabled() or not HL1AHUD.ShouldDrawItemInventory() then return end
  return true
end)
