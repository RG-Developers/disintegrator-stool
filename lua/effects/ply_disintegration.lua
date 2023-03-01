
function EFFECT:Init( data )

    if ( GetConVarNumber( "gmod_drawtooleffects" ) == 0 ) then return end

    local TargetEntity = data:GetEntity()
    if ( !IsValid( TargetEntity ) ) then return end

    local vOffset = TargetEntity:GetPos()
    local Low, High = TargetEntity:WorldSpaceAABB()

    local NumParticles = TargetEntity:BoundingRadius()
    NumParticles = NumParticles * 2

    NumParticles = math.Clamp( NumParticles, 32, 256 )

    local emitter = ParticleEmitter( vOffset )

    for i = 0, NumParticles do

        local vPos = Vector( math.Rand( Low.x, High.x ), math.Rand( Low.y, High.y ), math.Rand( Low.z, High.z ) )
        local particle = emitter:Add( "effects/spark", vPos )
        if ( particle ) then

            particle:SetVelocity( Vector( 0, 0, math.random(50, 10) ) )
            particle:SetLifeTime( 0 )
            particle:SetDieTime( math.Rand( 0.5, 1.0 ) )
            particle:SetStartAlpha( math.Rand( 200, 255 ) )
            particle:SetEndAlpha( 0 )
            particle:SetStartSize( math.random(1, 2) )
            particle:SetEndSize( 0 )
            --particle:SetRoll( math.Rand(0, 360) )
            particle:SetRollDelta( 0 )
            if math.random(0,1) == 1 then
                particle:SetColor(math.random(155, 255), 0, 0)
            else
                particle:SetColor(math.random(155, 255), math.random(155, 255), 0)
            end

            particle:SetAirResistance( 100 )
            particle:SetGravity( Vector( 0, 0, math.random(50, 10) ) )
            particle:SetCollide( false )

        end

    end

    emitter:Finish()

end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end