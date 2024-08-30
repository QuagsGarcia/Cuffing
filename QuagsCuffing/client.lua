local timer = 0
local draggedPed = 0
RegisterNetEvent("QuagsCuffing:CuffHandling")
AddEventHandler("QuagsCuffing:CuffHandling", function()
     local closestPed = 0
     if timer < GetGameTimer() then
        timer = GetGameTimer() + 3000
     if not GetPedConfigFlag(GetPlayerPed(-1), 120) and not cuffProcess then
         RemoveAnimDict('mp_arrest_paired')
         RemoveAnimDict('mp_arresting')
         for _, i in pairs(GetActivePlayers()) do
            local a = GetPlayerPed(i)
            local dist1 = #(GetEntityCoords(GetPlayerPed(-1)) - GetEntityCoords(a))
            local dist2 = #(GetEntityCoords(GetPlayerPed(-1)) - GetEntityCoords(closestPed))
            if dist1 < dist2 and a ~= GetPlayerPed(-1) then
                closestPed = a
            end
         end
         local dist = #(GetEntityCoords(GetPlayerPed(-1)) - GetEntityCoords(closestPed))
         if GetEntitySpeed(closestPed) > 2.0 then
            closestPed = 694206969
         end
         if dist > 2  then
            closestPed = 69420696969
         end
         if dist > 5  then
            closestPed = 0
         end
         if closestPed == 694206969 then
            Notify("Player moving too fast.")
         elseif closestPed == 69420696969 then
            Notify("Player too far away.")
         elseif closestPed ~= 0 then
            if GetPedConfigFlag(closestPed, 120) then
                TriggerServerEvent("QuagsCuffing:CuffHandler", GetPlayerServerId(PlayerId()), GetPlayerServerId(NetworkGetPlayerIndexFromPed(closestPed)), false)
            else
                TriggerServerEvent("QuagsCuffing:CuffHandler", GetPlayerServerId(PlayerId()), GetPlayerServerId(NetworkGetPlayerIndexFromPed(closestPed)), true)
            end
         else
            Notify("Player not found.")
         end
    else
        Notify("Can't handcuff a player while handcuffed.")
    end
    end
end, false )

CreateThread(function()
    while true do
        Citizen.Wait(200)
        SetEnableHandcuffs(GetPlayerPed(-1), GetPedConfigFlag(GetPlayerPed(-1), 120))
        if not IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "mp_arresting", "idle", 3) and GetPedConfigFlag(GetPlayerPed(-1), 120) then
            RemoveAnimDict('mp_arresting')
            loadAnimDict( "mp_arresting" )
            TaskPlayAnim(GetPlayerPed(PlayerId()), "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
            SetPedConfigFlag(GetPlayerPed(-1), 122, true)
            TriggerEvent("QuagsJailing:UpdateJailStat", true)
        end
        if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "mp_arresting", "idle", 3) and not GetPedConfigFlag(GetPlayerPed(-1), 120) then
            RemoveAnimDict('mp_arresting')
            loadAnimDict( "mp_arresting" )
            TaskPlayAnim(GetPlayerPed(PlayerId()), "mp_arresting", "idle", 8.0, -8, 1, 49, 0, 0, 0, 0)
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
            SetPedConfigFlag(GetPlayerPed(-1), 122, false)
            TriggerEvent("QuagsJailing:UpdateJailStat", false)
        end
        if IsPedRagdoll(GetPlayerPed(-1)) and GetPedConfigFlag(GetPlayerPed(-1), 120) then
            while IsPedRagdoll(GetPlayerPed(-1)) do
                Citizen.Wait(10)
            end
            RemoveAnimDict('mp_arresting')
            loadAnimDict( "mp_arresting" )
            TaskPlayAnim(GetPlayerPed(PlayerId()), "mp_arresting", "idle", 8.0, -8, 1, 49, 0, 0, 0, 0)
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
            SetPedConfigFlag(GetPlayerPed(-1), 122, true)
            TriggerEvent("QuagsJailing:UpdateJailStat", true)
        end
        if IsEntityDead(GetPlayerPed(-1)) and GetPedConfigFlag(GetPlayerPed(-1), 120) then
            SetPedConfigFlag(GetPlayerPed(-1), 120, false)
            SetPedConfigFlag(GetPlayerPed(-1), 122, false)
            TriggerEvent("QuagsJailing:UpdateJailStat", false)
        end 
    end
end)

RegisterNetEvent("QuagsCuffing:Handcuff")
AddEventHandler("QuagsCuffing:Handcuff", function(copID, stat)
    cuffProcess = true
    RemoveAnimDict('mp_arrest_paired')
    RemoveAnimDict('mp_arresting')
    local copPed = GetPlayerPed(GetPlayerFromServerId(copID))
    if stat then
        SetPedCanRagdoll(GetPlayerPed(-1), false)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        loadAnimDict( 'mp_arrest_paired')
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        AttachEntityToEntity(GetPlayerPed(-1), copPed, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
        TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_left', 8.0, -8.0, 3800, 33, 0, false, false, false)
        Citizen.Wait(950)
        DetachEntity(GetPlayerPed(-1), true, false)
        Citizen.Wait(3000)
        SetPedConfigFlag(GetPlayerPed(-1), 120, true)
        SetPedConfigFlag(GetPlayerPed(-1), 122, true)
        TriggerEvent("QuagsJailing:UpdateJailStat", true)
        SetPedCanRagdoll(GetPlayerPed(-1), true)
    else
        SetPedCanRagdoll(GetPlayerPed(-1), false)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        loadAnimDict( 'mp_arrest_paired')
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        SetPedConfigFlag(GetPlayerPed(-1), 120, false)
        SetPedConfigFlag(GetPlayerPed(-1), 122, false)
        TriggerEvent("QuagsJailing:UpdateJailStat", false)
        AttachEntityToEntity(GetPlayerPed(-1), copPed, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
        TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8, 5500, 2, 0, 0, 0, 0)
        Citizen.Wait(950)
        DetachEntity(GetPlayerPed(-1), true, false)
        SetPedCanRagdoll(GetPlayerPed(-1), true)
    end
    cuffProcess = false
end)
RegisterNetEvent("QuagsCuffing:Handcuffing")
AddEventHandler("QuagsCuffing:Handcuffing", function(criminalID, stat)
    timer = GetGameTimer() + 100000
    RemoveAnimDict('mp_arrest_paired')
    RemoveAnimDict('mp_arresting')
    if stat then
        loadAnimDict( 'mp_arrest_paired')
        TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_left', 8.0, -16.0, 3800, 33, 0, false, false, false)
    else
        loadAnimDict( 'mp_arrest_paired')
        TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8, 5500, 2, 0, 0, 0, 0)
    end
    timer = GetGameTimer() + 1000
end)
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function Notify(text)
    TriggerEvent("QuagsNotify:Icon", "GU Cuffing", text, 5000, 'info', "mdi-handcuffs")
end



RegisterNetEvent("QuagsCuffing:DragHandling")
AddEventHandler("QuagsCuffing:DragHandling", function()
     local closestPed = 0
     if timer < GetGameTimer() then
        timer = GetGameTimer() + 3000
     if not GetPedConfigFlag(GetPlayerPed(-1), 120) and not dragProcess then
         for _, i in pairs(GetActivePlayers()) do
            local a = GetPlayerPed(i)
            local dist1 = #(GetEntityCoords(GetPlayerPed(-1)) - GetEntityCoords(a))
            local dist2 = #(GetEntityCoords(GetPlayerPed(-1)) - GetEntityCoords(closestPed))
            if dist1 < dist2 and a ~= GetPlayerPed(-1) then
                closestPed = a
            end
         end
         local dist = #(GetEntityCoords(GetPlayerPed(-1)) - GetEntityCoords(closestPed))
         if GetEntitySpeed(closestPed) > 2.0 then
            closestPed = 694206969
         end
         if dist > 2  then
            closestPed = 69420696969
         end
         if dist > 5  then
            closestPed = 0
         end
         if closestPed == 694206969 then
            Notify("Player moving too fast.")
         elseif closestPed == 69420696969 then
            Notify("Player too far away.")
         elseif closestPed ~= 0 then
            if GetPedConfigFlag(closestPed, 120) then
                if DecorGetBool(closestPed, "DragStat") then
                    TriggerServerEvent("QuagsCuffing:DragHandler", GetPlayerServerId(PlayerId()), GetPlayerServerId(NetworkGetPlayerIndexFromPed(closestPed)), false)
                    draggedPed = 0
                else
                    TriggerServerEvent("QuagsCuffing:DragHandler", GetPlayerServerId(PlayerId()), GetPlayerServerId(NetworkGetPlayerIndexFromPed(closestPed)), true)
                    draggedPed = closestPed
                end
            else
                Notify("Player not cuffed.")
            end
         else
            Notify("Player not found.")
         end
    else
        Notify("Can't drag a player while handcuffed.")
    end
    end
end, false )

RegisterNetEvent("QuagsCuffing:SeatPlayer")
AddEventHandler("QuagsCuffing:SeatPlayer", function(ped, veh, seat)
    TriggerServerEvent("QuagsCuffing:DragHandler", GetPlayerServerId(PlayerId()), GetPlayerServerId(NetworkGetPlayerIndexFromPed(draggedPed)), false, seat)
    draggedPed = 0
end)


RegisterNetEvent("QuagsCuffing:Dragged")
AddEventHandler("QuagsCuffing:Dragged", function(copID, stat, seat)
    dragProcess = true
    local copPed = GetPlayerPed(GetPlayerFromServerId(copID))
    if stat then
        ClearPedTasksImmediately(GetPlayerPed(-1))
        AttachEntityToEntity(PlayerPedId(), copPed, 4103, 0.2, 0.48, 0.00, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        DecorSetBool(GetPlayerPed(-1), "DragStat", true)
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
    else
        ClearPedTasksImmediately(GetPlayerPed(-1))
        DetachEntity(PlayerPedId(), true, false) 
        DecorSetBool(GetPlayerPed(-1), "DragStat", false)
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
    end
    dragProcess = false
    if seat then
        local vehs = surveyVehicles(5.0, GetEntityCoords(GetPlayerPed(-1)))
        local closest = 0
        if json.encode(vehs) ~= "[]" then
            for _, i in pairs(vehs) do
                local dist1 = #(GetEntityCoords(i.ent) - GetEntityCoords(GetPlayerPed(-1)))
                local dist2 = #(GetEntityCoords(closest) - GetEntityCoords(GetPlayerPed(-1)))
                if dist1 < dist2 then
                    closest = i.ent
                end
            end
            TaskEnterVehicle(GetPlayerPed(-1), closest, 5000, seat, 1.0, 1)
        end
    end
end)

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end
    
    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)
    
    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next
    
    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function surveyVehicles(radius, entcoords)
    local tbl = {}
    for i in EnumerateVehicles() do
        local c1 = GetEntityCoords(i)
        local c2 = entcoords
        local dist = #(c1 - c2)
        if dist <= radius then
            table.insert(tbl, {ent=i, dist=dist})
        end
    end
    return tbl
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

CreateThread(function()
    while true do
        Citizen.Wait(50)
        local anim = "move_m@brave"
        if IsPedWalking(GetEntityAttachedTo(GetPlayerPed(-1))) and DecorGetBool(GetPlayerPed(-1), "DragStat") then
            if not IsEntityPlayingAnim(GetPlayerPed(PlayerId()), anim, "walk", 3) then
                RemoveAnimDict(anim)
                loadAnimDict( anim)
                TaskPlayAnim(GetPlayerPed(-1), anim, 'walk', 8.0, -8.0, -1, 1, 0, false, false, false)
            end
        end
        if not IsPedSprinting(GetEntityAttachedTo(GetPlayerPed(-1))) and not IsPedWalking(GetEntityAttachedTo(GetPlayerPed(-1))) and IsEntityPlayingAnim(GetPlayerPed(PlayerId()), anim, "walk", 3) and DecorGetBool(GetPlayerPed(-1), "DragStat") then
            if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), anim, "walk", 3) then
                RemoveAnimDict(anim)
                loadAnimDict( anim)
                TaskPlayAnim(GetPlayerPed(-1), anim, 'walk', 8.0, -8.0, 1, 1, 0, false, false, false)
            end
        end
        if draggedPed ~= 0 then
            if DecorGetBool(draggedPed, "DragStat") and GetEntityAttachedTo(draggedPed) ~= GetPlayerPed(-1) then
                TriggerServerEvent("QuagsCuffing:DragHandler", GetPlayerServerId(PlayerId()), GetPlayerServerId(NetworkGetPlayerIndexFromPed(draggedPed)), true)
            end
            if IsEntityDead(draggedPed) then
               TriggerServerEvent("QuagsCuffing:DragHandler", GetPlayerServerId(PlayerId()), GetPlayerServerId(NetworkGetPlayerIndexFromPed(draggedPed)), false)
               draggedPed = 0
            end
        end
        if GetEntityAttachedTo(GetPlayerPed(-1)) ~= 0 and IsEntityDead(GetEntityAttachedTo(GetPlayerPed(-1))) and DecorGetBool(GetPlayerPed(-1), "DragStat") then
            DetachEntity(PlayerPedId(), true, false)
            TriggerServerEvent("QuagsCuffing:DragHandler", GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetEntityAttachedTo(GetPlayerPed(-1)))), GetPlayerServerId(PlayerId()), false)
        end
    end
end)
RegisterNetEvent("QuagsCuffing:Dragger")
AddEventHandler("QuagsCuffing:Dragger", function(criminalID, stat)
    timer = GetGameTimer() + 100000
    RemoveAnimDict('amb@world_human_drinking@coffee@male@base')
    if stat then
        loadAnimDict( 'amb@world_human_drinking@coffee@male@base')
        TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@base', 'base', 8.0, -8, -1, 51, 0, false, false, false)
        SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        DecorSetBool(GetPlayerPed(-1), "isDragging", true)
    else
        ClearPedTasksImmediately(GetPlayerPed(-1))
        SetPedConfigFlag(GetPlayerPed(-1), 122, false)
        DecorSetBool(GetPlayerPed(-1), "isDragging", false)
    end
    timer = GetGameTimer() + 1000
end)
Citizen.CreateThread(function()
    DecorRegister("DragStat", 2)
    DecorRegister("isDragging", 2)
    while true do
        Citizen.Wait(0)
        if draggedPed ~= 0 then
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 23, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            if IsPedArmed(GetPlayerPed(-1), 4) then
                SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
            end
            if not IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "amb@world_human_drinking@coffee@male@base", 'base', 3) then
                TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_drinking@coffee@male@base', 'base', 8.0, -8, -1, 51, 0, false, false, false)
                DecorSetBool(GetPlayerPed(-1), "isDragging", true)
            end
        end
        if IsPedInAnyVehicle(GetPlayerPed(-1), true) and GetPedConfigFlag(GetPlayerPed(-1), 120) then
                DisableControlAction(0, 63, true)
                DisableControlAction(0, 64, true)
                DisableControlAction(0, 59, true)
            if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), 1) == GetPlayerPed(-1) or GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), 2) == GetPlayerPed(-1) then
                DisableControlAction(0, 75, true)
            end
        end
    end
end)