--[[------------------------------------------------------------------
  Default sprites
]]--------------------------------------------------------------------

if SERVER then return end

-- get texture files' data
local files = {
  pain0 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640_painmod_0'), 128, 48),
  pain1 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640_painmod_1'), 48, 128),
  pain2 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640_painmod_2'), 128, 48),
  pain3 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640_painmod_3'), 48, 128),
  hud_green = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud_green'), 256, 128),
  hud_green1 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud_green1'), 256, 128),
  hud_green_e = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud_green_e'), 256, 128),
  hud_green1_e = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud_green1_e'), 256, 128),
  hud1 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud1'), 256, 256),
  hud2 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud2'), 256, 256),
  hud3 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud3'), 256, 256),
  hud4 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud4'), 256, 256),
  hud5 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud5'), 256, 256),
  hud6 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud6'), 256, 256),
  hud10 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud10'), 256, 64),
  hud11 = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud11'), 256, 256),
  misc = HL1AHUD.GenerateFileData(surface.GetTextureID('hl1alphahud/640hud_misc'), 24, 24)
}

-- pain sprites
HL1AHUD.AddSprite('pain0', files.pain0, 0, 0, 128, 48)
HL1AHUD.AddSprite('pain1', files.pain1, 0, 0, 48, 128)
HL1AHUD.AddSprite('pain2', files.pain2, 0, 0, 128, 48)
HL1AHUD.AddSprite('pain3', files.pain3, 0, 0, 48, 128)

-- green hud
for i=0, 4 do -- numbers from 0 to 4
  HL1AHUD.AddSprite('g_' .. i, files.hud_green, 30 * i, 0, 29, 41)
end
for i=0, 4 do -- numbers from 5 to 9
  HL1AHUD.AddSprite('g_' .. (i + 5), files.hud_green1, 30 * i, 0, 29, 41)
end
HL1AHUD.AddSprite('g_battery_empty', files.hud_green, 0, 51, 64, 26)
HL1AHUD.AddSprite('g_battery_fill', files.hud_green, 67, 51, 48, 26)
for i=0, 9 do -- small numbers from 0 to 9
  HL1AHUD.AddSprite('g_s_' .. i, files.hud_green, 16 * i, 88, 16, 22)
end
HL1AHUD.AddSprite('g_separator', files.hud_green, 160, 88, 16, 22)
HL1AHUD.AddSprite('g_b1', files.hud_green, 205, 55, 12, 12)
HL1AHUD.AddSprite('g_b2', files.hud_green, 205, 73, 12, 12)
HL1AHUD.AddSprite('g_b3', files.hud_green, 205, 91, 12, 12)
HL1AHUD.AddSprite('g_b4', files.hud_green, 222, 55, 12, 12)
HL1AHUD.AddSprite('g_b5', files.hud_green, 222, 73, 12, 12)
HL1AHUD.AddSprite('g_b6', files.hud_green, 222, 91, 12, 12)

-- early green hud
for i=0, 4 do -- numbers from 0 to 4
  HL1AHUD.AddSprite('ge_' .. i, files.hud_green_e, 30 * i, 0, 29, 41)
end
for i=0, 4 do -- numbers from 5 to 9
  HL1AHUD.AddSprite('ge_' .. (i + 5), files.hud_green1_e, 30 * i, 0, 29, 41)
end
for i=0, 9 do -- small numbers from 0 to 9
  HL1AHUD.AddSprite('ge_s_' .. i, files.hud_green_e, 16 * i, 88, 16, 22)
end

-- E3 '98 hud
HL1AHUD.AddSprite('battery_empty', files.hud1, 170, 0, 80, 31)
HL1AHUD.AddSprite('battery_fill', files.hud1, 183, 32, 54, 31)
for i=0, 9 do -- numbers from 0 to 9
  HL1AHUD.AddSprite(tostring(i), files.hud1, 24 * i, 226, 19, 24)
end
HL1AHUD.AddSprite('separator', files.hud1, 170, 64, 3, 33)

-- hazards
HL1AHUD.AddSprite('dmg_chem', files.hud2, 170, 0, 64, 64)
HL1AHUD.AddSprite('dmg_drown', files.hud2, 170, 64, 64, 64)
HL1AHUD.AddSprite('dmg_bio', files.hud2, 170, 128, 64, 64)
HL1AHUD.AddSprite('dmg_shock', files.hud2, 170, 192, 64, 64)
HL1AHUD.AddSprite('dmg_bleed', files.hud11, 192, 0, 64, 64)

-- inventory
HL1AHUD.AddSprite('longjump_empty', files.hud11, 0, 0, 60, 60)
HL1AHUD.AddSprite('longjump_full', files.hud11, 60, 0, 60, 60)
HL1AHUD.AddSprite('airtank_empty', files.hud11, 0, 60, 60, 60)
HL1AHUD.AddSprite('airtank_full', files.hud11, 60, 60, 60, 60)
HL1AHUD.AddSprite('flash_on', files.hud11, 0, 120, 60, 60)
HL1AHUD.AddSprite('flash_off', files.hud11, 60, 120, 60, 60)
HL1AHUD.AddSprite('antidote', files.hud11, 0, 180, 60, 60)
HL1AHUD.AddSprite('adrenaline', files.hud11, 60, 180, 60, 60)
HL1AHUD.AddSprite('radiation', files.hud11, 120, 180, 60, 60)

-- weapon selector
HL1AHUD.AddSprite('highlight', files.hud3, 0, 180, 170, 45)
HL1AHUD.AddSprite('slot', files.misc, 0, 0, 24, 24)
HL1AHUD.AddSprite('slot1', files.hud_green, 202, 52, 17, 18)
HL1AHUD.AddSprite('slot2', files.hud_green, 202, 70, 17, 18)
HL1AHUD.AddSprite('slot3', files.hud_green, 202, 88, 17, 18)
HL1AHUD.AddSprite('slot4', files.hud_green, 219, 52, 17, 18)
HL1AHUD.AddSprite('slot5', files.hud_green, 219, 70, 17, 18)
HL1AHUD.AddSprite('slot6', files.hud_green, 219, 88, 17, 18)

-- default weapon icons
HL1AHUD.AddSprite('crowbar', files.hud1, 0, 0, 170, 45)
HL1AHUD.AddSprite('crowbar_selected', files.hud4, 0, 0, 170, 45)
HL1AHUD.AddSprite('pistol', files.hud1, 0, 45, 170, 45)
HL1AHUD.AddSprite('pistol_selected', files.hud4, 0, 45, 170, 45)
HL1AHUD.AddSprite('magnum', files.hud1, 0, 90, 170, 45)
HL1AHUD.AddSprite('magnum_selected', files.hud4, 0, 90, 170, 45)
HL1AHUD.AddSprite('9mmar', files.hud1, 0, 135, 170, 45)
HL1AHUD.AddSprite('9mmar_selected', files.hud4, 0, 135, 170, 45)
HL1AHUD.AddSprite('shotgun', files.hud1, 0, 180, 170, 45)
HL1AHUD.AddSprite('shotgun_selected', files.hud4, 0, 180, 170, 45)
HL1AHUD.AddSprite('crossbow', files.hud2, 0, 0, 170, 45)
HL1AHUD.AddSprite('crossbow_selected', files.hud5, 0, 0, 170, 45)
HL1AHUD.AddSprite('rocketlauncher', files.hud2, 0, 45, 170, 45)
HL1AHUD.AddSprite('rocketlauncher_selected', files.hud5, 0, 45, 170, 45)
HL1AHUD.AddSprite('gaussgun', files.hud2, 0, 90, 170, 45)
HL1AHUD.AddSprite('gaussgun_selected', files.hud5, 0, 90, 170, 45)
HL1AHUD.AddSprite('gluongun', files.hud2, 0, 135, 170, 45)
HL1AHUD.AddSprite('gluongun_selected', files.hud5, 0, 135, 170, 45)
HL1AHUD.AddSprite('hornetgun', files.hud2, 0, 180, 170, 45)
HL1AHUD.AddSprite('hornetgun_selected', files.hud5, 0, 180, 170, 45)
HL1AHUD.AddSprite('handgrenade', files.hud3, 0, 0, 170, 45)
HL1AHUD.AddSprite('handgrenade_selected', files.hud6, 0, 0, 170, 45)
HL1AHUD.AddSprite('satchel', files.hud3, 0, 45, 170, 45)
HL1AHUD.AddSprite('satchel_selected', files.hud6, 0, 45, 170, 45)
HL1AHUD.AddSprite('tripmines', files.hud3, 0, 90, 170, 45)
HL1AHUD.AddSprite('tripmines_selected', files.hud6, 0, 90, 170, 45)
HL1AHUD.AddSprite('snarks', files.hud3, 0, 135, 170, 45)
HL1AHUD.AddSprite('snarks_selected', files.hud6, 0, 135, 170, 45)
HL1AHUD.AddSprite('pistol_silenced', files.hud10, 0, 0, 170, 45)
HL1AHUD.AddSprite('pistol_silenced_selected', files.hud10, 0, 45, 170, 45)
HL1AHUD.AddSprite('chumtoads', files.hud10, 0, 90, 170, 45)
HL1AHUD.AddSprite('chumtoads_selected', files.hud10, 0, 135, 170, 45)
