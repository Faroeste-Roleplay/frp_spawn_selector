
local Tunnel = module("frp_lib", "lib/Tunnel")
local Proxy = module("frp_lib", "lib/Proxy")

API = Proxy.getInterface('API')
cAPI = Tunnel.getInterface("API")

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

    if Character then
        if Config.DisableAutoSpawn then
            cFirstSpawn.RegisterLastPositionCoords(_source, Character:GetLastPosition() or vec3(0,0,0))

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

RegisterNetEvent('FRP:spawnSelector:selectCharacterWithDefaultCoords', function(cid)
    local _source = source
    local User = API.GetUserFromSource(_source)
    local Character = User:SetCharacter(cid)

    cAPI.StartFade(_source, 500 )

    if Character then
        Character:SetGameAppearance()
        User:DrawCharacter()

        exports.ox_inventory:AddItem(_source, "luckybox", 1)

        cAPI.EndFade(_source, 500 )
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