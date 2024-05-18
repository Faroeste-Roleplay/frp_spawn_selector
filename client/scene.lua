
RegisterNetEvent("FRP:spawnSelector:DisplayCharSelection", function(characterArray, charAppearence)
    FlushScene()

    -- O characterARRAY tá enviando TODA INFORMAÇÃO DO CHARACTER
    -- O characterARRAY tá enviando TODA INFORMAÇÃO DO CHARACTER
    -- O characterARRAY tá enviando TODA INFORMAÇÃO DO CHARACTER

    local lang = i18n.getCurrentLanguage()
    local locales = i18n.exportData()
    local translation = locales[lang]

    SendNUIMessage(
        {
            type = "translation",
            locale = translation
        }
    )

    TriggerServerEvent("net.charSelectorHandlerSetPlayerRoutingBucket")

    cAPI.StartFade(500)

    cAPI.PlayerAsInitialized(false)
    local playerPed = PlayerPedId()

    SetFocusEntity(playerPed) 
    SetEntityInvincible(playerPed, true)
    SetEntityVisible(playerPed, false)
    NetworkSetEntityInvisibleToNetwork(playerPed, true)

    ShutdownLoadingScreen()

    PrepareSceneCamera()

    -- SendNUIMessage({type = 2}) -- clear UI

    -- Wait(500)

    SetNuiFocus(true, true)

    if charAppearence ~= nil then
        for i = 1, #charAppearence do
            local charId = characterArray[i].id

            local appearance = charAppearence[i]
            local pedIsMale = appearance.appearance.isMale
            local pedModel = pedIsMale and 'mp_male' or 'mp_female'
            

            if appearance?.overridePedModel and appearance?.overridePedModel ~= "" then
                pedModel = appearance.overridePedModel
            end

            local pedModelHash = GetHashKey(pedModel)

            if not HasModelLoaded(pedModelHash) then
                RequestModel(pedModelHash)
                while not HasModelLoaded(pedModelHash) do
                    Citizen.Wait(10)
                end
            end

            local position = Config.PedPositions[i]

            local ped = CreatePed(pedModelHash, position.x, position.y, position.z, position.w, true, 0)

            TriggerServerEvent("net.charSelectorHandlerSetRoutingBucket", ped)

            Wait(100)

            cAPI.ApplyCharacterAppearance(ped, appearance)

            table.insert(gEntities, ped)
            gEntityFromCharId[charId] = ped
            gCharIdFromEntity[ped] = charId
            
            local coords = GetEntityCoords(ped, false)

            gCharactersAppearance[charId] = appearance
            
            Citizen.InvokeNative(0x322BFDEA666E2B0E, ped,  coords.x, coords.y, coords.z, 5.0, -1, 1, 1, 1, 1)                
        end
    end

    cAPI.EndFade(500)

    SendNUIMessage(
        {
            type = 1,
            list = characterArray
        }
    )
end)


function FlushScene()
    for _, entity in ipairs(gEntities) do
        DeleteEntity(entity)
    end

    RenderScriptCams(false, false, 0, 1, 0)
    
    DestroyCam(gSceneCamera, false)
    DestroyCam(gInterpToFaceSceneCamera, false)

    ClearFocus()
    
    local playerPed = PlayerPedId()

    SetFocusEntity(playerPed) 
    SetEntityInvincible(playerPed, false)
    SetEntityVisible(playerPed, true)
    NetworkSetEntityInvisibleToNetwork(playerPed, false)

    gSceneChars = { }
    gEntities = { }
    gCharIdFromEntity = { }
    gEntityFromCharId = { }

    gSceneCamera = nil
    gInterpToFaceSceneCamera = nil

    gIsInSelectedScene = false

    DisplayHud(true)
    DisplayRadar(true)

    FreezeEntityPosition(PlayerPedId(), false)

    TriggerServerEvent("net.charSelectorHandlerRemovePlayerRoutingBucket")
end