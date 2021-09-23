--[[---------------------
Half-life: Absolute Zero
    Heads Up Display
      Version 1
      23/09/21
By DyaMetR
]]-----------------------

-- Main framework table
HL1AHUD = {}

-- Version
HL1AHUD.Version = '1'

--[[------------------------------------------------------------------
  Correctly includes a file
  @param {string} file
]]--------------------------------------------------------------------
function HL1AHUD.IncludeFile(file)
  if SERVER then
    include(file)
    AddCSLuaFile(file)
  end
  if CLIENT then
    include(file)
  end
end

-- Include
HL1AHUD.IncludeFile('hl1alphahud/core.lua')
