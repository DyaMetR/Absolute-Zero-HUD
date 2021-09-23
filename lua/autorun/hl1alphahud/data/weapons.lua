--[[------------------------------------------------------------------
  Default weapon sprites
]]--------------------------------------------------------------------

if SERVER then return end

-- HL1 esque sprite sizes
local W, H = 170, 45

-- get texture files' data
local files = {
  gmod1 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud_gmod1'), 256, 256),
  gmod2 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud_gmod2'), 256, 256),
  gmod3 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud_gmod3'), 256, 256),
  gmod4 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud_gmod4'), 256, 256),
  gmod5 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud_gmod5'), 256, 256),
  gmod6 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud_gmod6'), 256, 256),
}

-- list of default weapons
local weapons = { -- weapon class, pos in sprite, file for idle sprite, file for selected sprite
  {'weapon_crowbar', 0, files.gmod1, files.gmod2},
  {'weapon_pistol', 1, files.gmod1, files.gmod2},
  {'weapon_357', 2, files.gmod1, files.gmod2},
  {'weapon_smg1', 3, files.gmod1, files.gmod2},
  {'weapon_shotgun', 4, files.gmod1, files.gmod2},
  {'weapon_annabelle', 4, files.gmod1, files.gmod2},
  {'weapon_crossbow', 0, files.gmod3, files.gmod4},
  {'weapon_rpg', 1, files.gmod3, files.gmod4},
  {'weapon_physgun', 2, files.gmod3, files.gmod4},
  {'weapon_ar2', 3, files.gmod3, files.gmod4},
  {'weapon_physcannon', 4, files.gmod3, files.gmod4},
  {'weapon_frag', 0, files.gmod5, files.gmod6},
  {'weapon_slam', 1, files.gmod5, files.gmod6},
  {'weapon_bugbait', 2, files.gmod5, files.gmod6},
  {'weapon_stunstick', 3, files.gmod5, files.gmod6}
}

-- generate weapon icons
for _, weapon in pairs(weapons) do
  local class, pos, file1, file2 = unpack(weapon)
  HL1AHUD.AddSprite(class, file1, 0, pos * H, W, H)
  HL1AHUD.AddSprite(class .. '_selected', file2, 0, pos * H, W, H)
  HL1AHUD.AddWeaponSprite(class, class, class .. '_selected')
end

-- additionally add Half-Life: Source weapons
HL1AHUD.AddWeaponSprite('weapon_357_hl1', 'magnum', 'magnum_selected')
HL1AHUD.AddWeaponSprite('weapon_glock_hl1', 'pistol', 'pistol_selected')
HL1AHUD.AddWeaponSprite('weapon_crossbow_hl1', 'crossbow', 'crossbow_selected')
HL1AHUD.AddWeaponSprite('weapon_crowbar_hl1', 'crowbar', 'crowbar_selected')
HL1AHUD.AddWeaponSprite('weapon_egon', 'gluongun', 'gluongun_selected')
HL1AHUD.AddWeaponSprite('weapon_handgrenade', 'handgrenade', 'handgrenade_selected')
HL1AHUD.AddWeaponSprite('weapon_hornetgun', 'hornetgun', 'hornetgun_selected')
HL1AHUD.AddWeaponSprite('weapon_mp5_hl1', '9mmar', '9mmar_selected')
HL1AHUD.AddWeaponSprite('weapon_tripmine', 'tripmines', 'tripmines_selected')
HL1AHUD.AddWeaponSprite('weapon_gauss', 'gaussgun', 'gaussgun_selected')
HL1AHUD.AddWeaponSprite('weapon_snark', 'snarks', 'snarks_selected')
HL1AHUD.AddWeaponSprite('weapon_shotgun_hl1', 'shotgun', 'shotgun_selected')
HL1AHUD.AddWeaponSprite('weapon_satchel', 'satchel', 'satchel_selected')
HL1AHUD.AddWeaponSprite('weapon_rpg_hl1', 'rocketlauncher', 'rocketlauncher_selected')
