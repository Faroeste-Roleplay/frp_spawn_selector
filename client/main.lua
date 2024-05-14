local Tunnel = module("frp_core", "lib/Tunnel")
local Proxy = module("frp_core", "lib/Proxy")

cAPI = Proxy.getInterface("API")
API = Tunnel.getInterface("API")

gEntities = { }
gCharIdFromEntity = { }

gEntityFromCharId = { }

gSceneCamera = nil
gInterpToFaceSceneCamera = nil

gHoveredCharId = nil

gIsInSelectedScene = false 
gSelectedCharId = nil


gCharactersAppearance = {}

RegisterNUICallback("createCharacter", function()
    local confirm = lib.alertDialog({
        header = i18n.translate("start_char_creation"),
        content = i18n.translate("start_char_creation_description"),
        centered = true,
        cancel = true
    })

    if confirm == "confirm" then
        SetNuiFocus(false, false)
        SendNUIMessage({type = "hide"})
        cAPI.StartFade(500)
        FlushScene()
        TriggerEvent("FRPCreator:Client:StartScript")
    end
end)


RegisterCommand("start", function()
    TriggerServerEvent("FRP:spawnSelector:DisplayCharSelection")
end)

RegisterNUICallback("selectCharacter", function(charId)
    local entity = gEntityFromCharId[charId]

    PrepareInterpToFaceCamera(entity)

    gSelectedCharacterId = charId

    while IsCamInterpolating(gInterpToFaceSceneCamera) do
        Wait(0)
    end

end)

RegisterNUICallback("spawnCharacterSelected", function(charId)
    SetNuiFocus(false, false)
    DisplayHud(true)

    cAPI.SetDataAppearence(gCharactersAppearance[charId])
    cAPI.SetPlayerDefaultModel()

    TriggerServerEvent("FRP:spawnSelector:selectCharacter", charId)
    cAPI.StartFade(500)
    Citizen.Wait(500)

    ClonePedToTarget(gEntityFromCharId[charId], PlayerPedId())

    FlushScene()

    cAPI.EndFade(500)
end)

RegisterNUICallback("deleteCharacter", function(charId)
    TriggerServerEvent("FRP:spawnSelector:deleteCharacter", charId)
    TriggerEvent("FRP:NOTIFY:Simple", i18n.translate("char_deleted"))
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() or resourceName == "frp_core" then
        FlushScene()
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() or resourceName == "frp_core" then
        SendNUIMessage({
            type = 2,
        })    
    end
end)
