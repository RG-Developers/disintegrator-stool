TOOL.Category = "Construction"
TOOL.Name = "#tool.disintegrator.name"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}


local function DoRemoveEntity( ent )
	if ( !IsValid( ent ) || ent:IsPlayer() ) then return false end

	-- Nothing for the client to do here
	if ( CLIENT ) then return true end

	-- Remove all constraints (this stops ropes from hanging around)
	constraint.RemoveAll( ent )

	local t = 5

	-- Remove it properly in ~1 second
	timer.Simple( t-0.01, function() if ( IsValid( ent ) ) then
		ent:SetNoDraw( true )
		local ed = EffectData()
			ed:SetOrigin( ent:GetPos() )
			ed:SetEntity( ent )
		util.Effect( "entity_remove", ed, true, true )
		timer.Simple( 0.5, function() if ( IsValid( ent ) ) then
			ent:Remove()
		end end )
	end end )

	if ent:IsNPC() then
		for i=1,50 do
			timer.Simple( t*i/50, function() if ( IsValid( ent ) ) then 
				ent:SetHealth(ent:Health()+5)
				ent:TakeDamage(5)
				local effectdata = EffectData()
					effectdata:SetOrigin(ent:GetPos())
				    effectdata:SetEntity(ent)
				util.Effect("npc_disentigration", effectdata)
			end end)
		end
		timer.Simple( t-0.01, function() if ( IsValid( ent ) ) then
			local oldrags = ents.FindByClass("prop_ragdoll")
			ent:TakeDamage(ent:Health())
			local newrags = ents.FindByClass("prop_ragdoll")
			for i in pairs(newrags) do
				for j in pairs(oldrags) do
					if i == j then table.remove(newrags, j) break end
				end
			end
			ent = newrags[1]
		end end)
	else
		for i=1,50 do
			timer.Simple( t*i/50, function() if ( IsValid( ent ) ) then 
				local effectdata = EffectData()
					effectdata:SetOrigin(ent:GetPos())
				    effectdata:SetEntity(ent)
				util.Effect("disentigration", effectdata)
			end end)
		end
	end

	-- Make it non solid
	ent:SetNotSolid( true )
	ent:SetMoveType( MOVETYPE_NONE )

	-- Send Effect
	local ed = EffectData()
		ed:SetOrigin( ent:GetPos() )
		ed:SetEntity( ent )
	util.Effect( "prop_remove", ed, true, true )

	return true
end

function TOOL:LeftClick( trace )
	if ( DoRemoveEntity( trace.Entity ) ) then
		if ( !CLIENT ) then
			self:GetOwner():SendLua( "achievements.Remover()" )
		end
		return true
	end
	return false
end

function TOOL:RightClick( trace )
	local Entity = trace.Entity
	if ( !IsValid( Entity ) || Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	local ConstrainedEntities = constraint.GetAllConstrainedEntities( trace.Entity )
	local Count = 0

	-- Loop through all the entities in the system
	for _, Entity in pairs( ConstrainedEntities ) do
		if ( DoRemoveEntity( Entity ) ) then
			Count = Count + 1
		end
	end
	self:GetOwner():SendLua( string.format( "for i=1,%i do achievements.Remover() end", Count ) )
	return true
end

function TOOL:Reload( trace )
	if ( !IsValid( trace.Entity ) || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	return constraint.RemoveAll( trace.Entity )
end



function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Description = "#tool.disintegrator.desc" } )
end