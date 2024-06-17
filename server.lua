
local Tunnel = module("frp_lib", "lib/Tunnel")
local Proxy = module("frp_lib", "lib/Proxy")

API = Proxy.getInterface('API')
VirtualWorld = Proxy.getInterface("virtual_world")
FirstSpawn = Proxy.getInterface("spawn_selector")
cFirstSpawn = Tunnel.getInterface("spawn_selector")

RegisterNetEvent("FRP:onUserLoaded", function(User)
    TriggerEvent("FRP:spawnSelector:DisplayCharSelection", User)
end)

RegisterNetEvent("FRP:onCharacterLogout", function(User)
    TriggerEvent("FRP:spawnSelector:DisplayCharSelection", User)
end)

RegisterNetEvent('FRP:spawnSelector:DisplayCharSelection', function(DataUser)
    local playerId = source
    local User = DataUser ~= nil and DataUser or API.GetUserFromSource(playerId)

    TriggerClientEvent('FRP:spawnSelector:DisplayCharSelection', User:GetSource(), User:GetCharacters(), User:GetCharactersAppearance())
end)

RegisterNetEvent('FRP:spawnSelector:selectCharacter', function(cid)
    local _source = source
    local User = API.GetUserFromSource(_source)
    local Character = User:SetCharacter(cid)

    local spawnCoords

    if Character then
        if Config.DisableAutoSpawn then
            cFirstSpawn.RegisterLastPositionCoords(_source, Character:GetLastPosition())

            if FirstSpawn.CharIdHasSpawnedAfterRestart( cid ) then
                User:DrawCharacter()
            else
                TriggerClientEvent("firstSpawnSelector:requestSpawnSelector", _source)
            end
        else
            User:DrawCharacter()
        end
    end
end)

RegisterNetEvent('FRP:spawnSelector:deleteCharacter', function(cid)
    local _source = source
    local User = API.GetUserFromSource(_source)
    User:DeleteCharacter(cid)
    TriggerEvent('FRP:spawnSelector:DisplayCharSelection', source, _source)
end)


RegisterNetEvent("net.charSelectorHandlerSetPlayerRoutingBucket", function()
    local playerId = source
    VirtualWorld:AddPlayerOnVirtualWorld( playerId, tonumber(playerId) )
end)

RegisterNetEvent("net.charSelectorHandlerRemovePlayerRoutingBucket", function()
    local playerId = source
    VirtualWorld:AddPlayerToGlobalWorld( playerId )
end)

RegisterNetEvent("net.charSelectorHandlerSetRoutingBucket", function(entityId)
    local playerId = source
    SetEntityRoutingBucket(NetworkGetEntityFromNetworkId(entityId), tonumber(playerId))
end)