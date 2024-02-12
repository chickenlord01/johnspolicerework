RegisterServerEvent('police:spikes')
AddEventHandler('police:spikes', function(currentVeh, peeps)
        TriggerClientEvent("police:dietyres", peeps, currentVeh)
        TriggerClientEvent("police:dietyres2", peeps)
end)
spiketimer = 0
spikestatus = true
function StartSpikeTimer(time)
    spikestatus = false
    TriggerClientEvent("pmgetspikestatus", -1, spikestatus)
    spiketimer = time*1000
    while spiketimer > 0 do
        if spiketimer >= 1000 then
            spiketimer = spiketimer-1000
            Wait(1000)
        elseif spiketimer > 0 then
                Wait(spiketimer)
                spiketimer = 0
        else
            spiketimer = 0
            break
        end
    end
    spikestatus = true
    TriggerClientEvent("pmgetspikestatus", -1, spikestatus)
end
RegisterServerEvent('pmstartspiketimer')
AddEventHandler('pmstartspiketimer', StartSpikeTimer)