local Proxy = module("frp_lib", "lib/Proxy")
API = Proxy.getInterface('API')

RegisterNetEvent('FRP:spawnSelector:DisplayCharSelection', function(DataUser)
    local playerId = source

    User = DataUser or API.GetUserFromSource(playerId)

    TriggerClientEvent('FRP:spawnSelector:DisplayCharSelection', User:GetSource(), User:GetCharacters(), User:GetCharactersAppearance())
end)

RegisterNetEvent('FRP:spawnSelector:selectCharacter', function(cid)
    local _source = source
    local User = API.GetUserFromSource(_source)
    local Character = User:SetCharacter(cid)

    if Character then
        User:DrawCharacter()
    end
end)

RegisterNetEvent('FRP:spawnSelector:deleteCharacter', function(cid)
    local _source = source
    local User = API.GetUserFromSource(_source)
    User:DeleteCharacter(cid)
    TriggerEvent('FRP:spawnSelector:DisplayCharSelection', source, _source)
end)
