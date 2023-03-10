TOOL.Category = "Construction"
TOOL.Name = "#tool.disintegrator.name"

TOOL.Information = {
	{ name = "left" },	
	{ name = "right" },
	{ name = "reload" }
}

local function DoRemoveEntity( entity, requester )
	local ent = entity
    if ( not IsValid( ent ) or ( ent:IsPlayer() and not requester:IsAdmin() ) ) then return false end

	-- Nothing for the client to do here
	if ( CLIENT ) then return true end

	-- Remove all constraints (this stops ropes from hanging around)
	constraint.RemoveAll( ent )

	local t = 1 -- Effect time

	if ent:IsNPC() and ent:Health() > 0 then
		local oldrags = ents.FindByClass("prop_ragdoll")
		ent:TakeDamage(ent:Health()-1)
		ent:TakeDamage(2)
		local newrags = ents.FindByClass("prop_ragdoll")
		for i in pairs(newrags) do
			for j in pairs(oldrags) do
				if i == j then table.remove(newrags, j) break end
			end
		end
		ent = newrags[1]
		if not IsValid(ent) then return false end
		for i=1,50 do
			timer.Simple( t*i/50, function() if ( IsValid( ent ) ) then 
				local effectdata = EffectData()
					effectdata:SetOrigin(ent:GetPos())
				    effectdata:SetEntity(ent)
				util.Effect("npc_disintegration", effectdata)
			end end)
		end
	elseif ent:IsPlayer() and ent:Health() > 0 then
		local oldrags = ents.FindByClass("prop_ragdoll")
		ent:TakeDamage(ent:Health()-1)
		ent:TakeDamage(2)
		local newrags = ents.FindByClass("prop_ragdoll")
		for i in pairs(newrags) do
			for j in pairs(oldrags) do
				if i == j then table.remove(newrags, j) break end
			end
		end
		ent = newrags[1]
		if not IsValid(ent) then return false end
		player.GetAll()[entity:EntIndex()]:SetNWBool("disintegration", true) 
		for i=1,50 do
			timer.Simple( t*i/50, function() if ( IsValid( ent ) ) then 
				local effectdata = EffectData()
					effectdata:SetOrigin(ent:GetPos())
				    effectdata:SetEntity(ent)
				util.Effect("ply_disintegration", effectdata)
			end end)
		end
	else
		for i=1,50 do
			timer.Simple( t*i/50, function() if ( IsValid( ent ) ) then 
				local effectdata = EffectData()
					effectdata:SetOrigin(ent:GetPos())
				    effectdata:SetEntity(ent)
				util.Effect("prop_disintegration", effectdata)
			end end)
		end
	end

	if not IsValid(ent) then return false end

	-- Make it non solid
	ent:SetNotSolid( false )
	ent:SetMoveType( MOVETYPE_NONE )

	-- Send Effect
	local ed = EffectData()
		ed:SetOrigin( ent:GetPos() )
		ed:SetEntity( ent )
	util.Effect( "ent_despawn", ed, true, true )

	-- Remove it properly later
	timer.Simple( t-0.01, function() 
		if ( IsValid( ent ) ) then
			ent:Remove()
		end 
		if ( IsValid( entity ) ) then
			if entity:IsPlayer() then 
				player.GetAll()[entity:EntIndex()]:SetNWBool("disintegration", false) 
				player.GetAll()[entity:EntIndex()]:Kick("You was disintegrated...") 
			else 
				entity:Remove() 
			end
		end
	end )

	return true

end

function TOOL:LeftClick( trace )
	if ( DoRemoveEntity( trace.Entity, self:GetOwner() ) ) then
		if ( not CLIENT ) then
			self:GetOwner():SendLua( "achievements.Remover()" )
		end
		return true
	end
	return false

end

function TOOL:RightClick( trace )
	local Entity = trace.Entity
	if ( not IsValid( Entity ) or Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	local ConstrainedEntities = constraint.GetAllConstrainedEntities( trace.Entity )
	local Count = 0
	-- Loop through all the entities in the system
	for _, Entity in pairs( ConstrainedEntities ) do
		if ( DoRemoveEntity( Entity, self:GetOwner() ) ) then
			Count = Count + 1
		end
	end
	self:GetOwner():SendLua( string.format( "for i=1,%i do achievements.Remover() end", Count ) )
	return true

end

function TOOL:Reload( trace )
	if ( not IsValid( trace.Entity ) or trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	return constraint.RemoveAll( trace.Entity )

end

function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Description = "#tool.disintegrator.desc" } )
end