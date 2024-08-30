RegisterNetEvent("QuagsCuffing:CuffHandler")
AddEventHandler("QuagsCuffing:CuffHandler", function(copID, crimID, stat)
    TriggerClientEvent("QuagsCuffing:Handcuff", crimID, copID, stat)
    TriggerClientEvent("QuagsCuffing:Handcuffing", copID, crimID, stat)
end)
RegisterNetEvent("QuagsCuffing:DragHandler")
AddEventHandler("QuagsCuffing:DragHandler", function(copID, crimID, stat, seat)
    TriggerClientEvent("QuagsCuffing:Dragged", crimID, copID, stat, seat)
    TriggerClientEvent("QuagsCuffing:Dragger", copID, crimID, stat, seat)
end)

RegisterCommand( "cuff", function(src, args)
    if IsPlayerAceAllowed(src, "gu.jail") then
        TriggerClientEvent("QuagsCuffing:CuffHandling", src)
    end
end)
RegisterCommand("drag", function(src, args)
    if IsPlayerAceAllowed(src, "gu.jail") then
        TriggerClientEvent("QuagsCuffing:DragHandling", src)
    end
end)