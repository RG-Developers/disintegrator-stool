hook.Add("PlayerDeathThink", "disintegration", function(ply)
	if ply:GetNWBool("disintegration") == nil then
		ply:SetNWBool("disintegration", false)
		return nil
	end
	if ply:GetNWBool("disintegration") ~= nil and ply:GetNWBool("disintegration") == true then 
		return false
	end
end)