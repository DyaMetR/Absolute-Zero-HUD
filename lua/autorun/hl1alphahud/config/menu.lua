--[[------------------------------------------------------------------
  Create the Q menu page
]]--------------------------------------------------------------------

if SERVER then return end

-- Add the spawn menu tab
hook.Add( 'PopulateToolMenu', 'hl1ahud_menu', function()
  spawnmenu.AddToolMenuOption( 'Options', 'DyaMetR', 'hl1ahud', 'Absolute Zero HUD', nil, nil, function(panel)
    panel:ClearControls()

    panel:AddControl( 'CheckBox', {
  		Label = 'Enabled',
      Command = 'hl1ahud_enabled'
  		}
  	)

    local combobox, label = panel:ComboBox('Variant', 'hl1ahud_mode')
    combobox:AddChoice('Default', 0)
    combobox:AddChoice('Early alpha', 1)
    combobox:AddChoice('E3 1998', 2)

    panel:AddControl( 'CheckBox', {
  		Label = 'Always show battery (green variants)',
      Command = 'hl1ahud_nouse_battery'
  		}
  	)

    panel:AddControl( 'Slider', {
      Label = 'Scale',
      Type = 'Float',
      Min = '0',
      Max = '5',
      Command = 'hl1ahud_scale'}
    )

    panel:AddControl( 'Slider', {
      Label = 'Damage indicator scale',
      Type = 'Float',
      Min = '0',
      Max = '5',
      Command = 'hl1ahud_damage_scale'}
    )

    panel:AddControl( 'CheckBox', {
  		Label = 'Show health and armour',
      Command = 'hl1ahud_health'
  		}
  	)

    panel:AddControl( 'CheckBox', {
  		Label = 'Show ammunition',
      Command = 'hl1ahud_ammo'
  		}
  	)

    panel:AddControl( 'CheckBox', {
  		Label = 'Show damage indicator',
      Command = 'hl1ahud_damage'
  		}
  	)

    panel:AddControl( 'CheckBox', {
  		Label = 'Use death camera',
      Command = 'hl1ahud_items'
  		}
  	)

    panel:AddControl( 'CheckBox', {
  		Label = 'Show hazards tray',
      Command = 'hl1ahud_hazards'
  		}
  	)

    panel:AddControl( 'CheckBox', {
  		Label = 'Enable weapon selector',
      Command = 'hl1ahud_weapon_selector'
  		}
  	)

    panel:AddControl( 'CheckBox', {
  		Label = 'Skip empty weapons',
      Command = 'hl1ahud_selector_skip'
  		}
  	)

    panel:AddControl( 'CheckBox', {
  		Label = 'Show item inventory',
      Command = 'hl1ahud_items'
  		}
  	)

    panel:AddControl( 'Slider', {
      Label = 'Weapon selector volume',
      Type = 'Float',
      Min = '0',
      Max = '1',
      Command = 'hl1ahud_volume'}
    )

    panel:AddControl( 'Button', {
      Label = 'Reset settings to default',
      Command = 'hl1ahud_reset',
    });

    -- Credits
    panel:AddControl( 'Label' , { Text = ''} )

    panel:AddControl( 'Label',  { Text = 'Version ' .. HL1AHUD.Version})
    panel:AddControl( 'Label',  { Text = 'Made by DyaMetR'})
    panel:AddControl( 'Label',  { Text = 'Textures and design by ValvE'})
    panel:AddControl( 'Label',  { Text = 'Reference material by Cobalt-57'})
  end )
end)
