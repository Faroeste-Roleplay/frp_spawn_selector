

function interpCamera(entity)
    local pedCoords = GetEntityCoords(entity)
    local entityCoords = cAPI.GetFromCoordsFromPlayer(pedCoords, entity, 2.0)

end

-- camera
-- 877.77, 1264.39, 235.37, 317.95

-- 882.87, 1273.23, 235.0, 149.62
-- 884.3, 1272.65, 235.04, 142.25
-- 885.65, 1270.79, 235.12, 148.87


function PrepareSceneCamera()
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.CameraScenePosition, Config.CameraSceneRotation, 35.00, false, 0)
    N_0x11f32bb61b756732(cam, 4.0) -- SetCamFocusDistance

    -- Middle ped position.
    PointCamAtCoord(cam, Config.PedPositions[2])

    SetFocusPosAndVel(Config.CameraScenePosition, vec3(0.0, 0.0, 0.0))

    SetCamActive(cam, true)

    RenderScriptCams(true, false, 1, true, true)
    
    SetCamRot(cam, Config.CameraSceneRotation)

    if gSceneCamera then
        DestroyCam(gSceneCamera)
    end

    gSceneCamera = cam
end

function PrepareInterpToFaceCamera(entity)
    local camPos = GetOffsetFromEntityInWorldCoords(entity, 0.0, 2.0, 0.5)
    local boneIndex = GetPedBoneIndex(entity, Config.SKEL_HEAD)
    local entityBoneWorldPosition = GetWorldPositionOfEntityBone(entity, boneIndex)
    local pedPosition = GetEntityCoords(entity)

    local offset = vector3(pedPosition.x - entityBoneWorldPosition.x, 
                            pedPosition.y - entityBoneWorldPosition.y,
                            pedPosition.z - entityBoneWorldPosition.z)

    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camPos, vec3(0.0, 0.0, 0.0), 26.0, false, 0)

    N_0x11f32bb61b756732(cam, 1) -- SetCamFocusDistance

    PointCamAtEntity(cam, entity, offset.x + 0.2, offset.y, 0.5, true)

    SetCamActiveWithInterp(cam, gInterpToFaceSceneCamera or gSceneCamera, Config.INTERP_TO_FACE_TIME, true, true)

    RenderScriptCams(true, false, 0, true, true)

    if gInterpToFaceSceneCamera then
        DestroyCam(gInterpToFaceSceneCamera)
    end

    gInterpToFaceSceneCamera = cam
end

function InterpFromSelectionToSceneCamera()
    SetCamActiveWithInterp(gSceneCamera, gInterpToFaceSceneCamera, Config.INTERP_TO_FACE_TIME, true, true)
    RenderScriptCams(true, false, 0, true, true)

    SetFocusPosAndVel(Config.CameraScenePosition, vec3(0.0, 0.0, 0.0))
end



function GetInteractionAreaForEntity(entity)
    local entityModel = GetEntityModel(entity)

    local minimum, maximum = GetModelDimensions(entityModel)

    local wrldInterAreaTopLeft = GetOffsetFromEntityInWorldCoords(entity, maximum.x, 0.0, maximum.z)
    
    -- local maxZ = GetPedBoneCoords(entity, SKEL_HEAD, vec3(0.0, 0.0, 0.0))
    -- wrldInterAreaTopLeft = vec3(wrldInterAreaTopLeft.xy, maxZ.z)

    local wrldInterAreaBottomRight = GetOffsetFromEntityInWorldCoords(entity, minimum.x, 0.0, minimum.z)

    local isOnScreen, topLeftX, topLeftY = GetScreenCoordFromWorldCoord(wrldInterAreaTopLeft.x, wrldInterAreaTopLeft.y, wrldInterAreaTopLeft.z)

    while not isOnScreen do
        Wait(0)
        isOnScreen, topLeftX, topLeftY = GetScreenCoordFromWorldCoord(wrldInterAreaTopLeft.x, wrldInterAreaTopLeft.y, wrldInterAreaTopLeft.z)
    end

    local _, bottomRightX, bottomRightY = GetScreenCoordFromWorldCoord(wrldInterAreaBottomRight.x, wrldInterAreaBottomRight.y, wrldInterAreaBottomRight.z)

    local interactionAreaWidth  = topLeftX - bottomRightX
    local interactionAreaHeight = topLeftY - bottomRightY

    return {
                x = topLeftX,
                y = topLeftY,
            },
            {
                x = bottomRightX,
                y = bottomRightY,
            },
            {
                w = interactionAreaWidth,
                h = interactionAreaHeight,
            }
end
