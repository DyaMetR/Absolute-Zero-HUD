--[[------------------------------------------------------------------
  Support for upset's Half-Life weapons
]]--------------------------------------------------------------------

if SERVER then return end

-- Half-Life SWEPs
HL1AHUD.AddWeaponSprite('weapon_hl1_357', 'magnum', 'magnum_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_glock', 'pistol', 'pistol_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_crossbow', 'crossbow', 'crossbow_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_crowbar', 'crowbar', 'crowbar_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_egon', 'gluongun', 'gluongun_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_handgrenade', 'handgrenade', 'handgrenade_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_hornetgun', 'hornetgun', 'hornetgun_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_mp5', '9mmar', '9mmar_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_tripmine', 'tripmines', 'tripmines_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_gauss', 'gaussgun', 'gaussgun_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_snark', 'snarks', 'snarks_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_shotgun', 'shotgun', 'shotgun_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_satchel', 'satchel', 'satchel_selected')
HL1AHUD.AddWeaponSprite('weapon_hl1_rpg', 'rocketlauncher', 'rocketlauncher_selected')

-- Half-Life: Absolute Zero SWEPs
HL1AHUD.AddWeaponSprite('weapon_hlaz_357', 'magnum', 'magnum_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_crossbow', 'crossbow', 'crossbow_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_crowbar', 'crowbar', 'crowbar_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_egon', 'gluongun', 'gluongun_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_handgrenade', 'handgrenade', 'handgrenade_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_hornetgun', 'hornetgun', 'hornetgun_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_mp5', '9mmar', '9mmar_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_tripmine', 'tripmines', 'tripmines_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_gauss', 'gaussgun', 'gaussgun_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_snark', 'snarks', 'snarks_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_shotgun', 'shotgun', 'shotgun_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_satchel', 'satchel', 'satchel_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_rpg', 'rocketlauncher', 'rocketlauncher_selected')
HL1AHUD.AddWeaponSprite('weapon_hlaz_chumtoad', 'chumtoads', 'chumtoads_selected')
HL1AHUD.AddWeaponDynamicIcon('weapon_hlaz_glock', function(x, y, weapon, colour, scale, selected)
  local sprite = 'pistol'

  -- change to silenced
  if weapon:GetSilenced() then
    sprite = 'pistol_silenced'
  end

  -- change to selected
  if selected then
    sprite = sprite .. '_selected'
  end

  -- draw icon
  HL1AHUD.DrawSprite(sprite, x, y, colour, nil, scale)
end)
