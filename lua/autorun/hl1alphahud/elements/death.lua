--[[------------------------------------------------------------------
  Sideways camera when dying
]]--------------------------------------------------------------------

if SERVER then return end

--[[------------------------------------------------------------------
  Implementation
]]--------------------------------------------------------------------
hook.Add('CalcView', 'hl1alphahud_death', function(_player, origin, angles, fov, znear, zfar)
  if LocalPlayer():Alive() or not HL1AHUD.IsEnabled() or not HL1AHUD.ShouldUseDeathCam() then return end

  -- hide ragdoll
  local ragdoll = LocalPlayer():GetRagdollEntity()
  if ragdoll and IsValid(ragdoll) and ragdoll.SetNoDraw then ragdoll:SetNoDraw(true) end

  -- generate table
  local view = {
    origin = _player:GetPos() + Vector(0, 0, 5),
    angles = angles + Angle(0, 0, 90),
    fov = fov
  }

  -- return it
  return view
end)
