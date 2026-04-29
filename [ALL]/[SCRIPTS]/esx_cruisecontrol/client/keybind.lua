RegisterCommand('cruise_toggle', function()
	if not Utils.vehicle then return end

    if CC.cruiseActive then
        print("cruise reset")
        CC:Reset()
    else
        print("cruise enable")
        CC:Enable()
    end
end, false)

RegisterKeyMapping('cruise_toggle', 'Tempomat zapnout/vypnout', 'keyboard', 'I')

RegisterCommand('cruise_up', function()
    if not Utils.vehicle then return end
    CC:ChangeSpeed(true)
end, false)

RegisterKeyMapping('cruise_up', 'Tempomat rychlost +', 'keyboard', 'NUMPAD+')

RegisterCommand('cruise_down', function()
    if not Utils.vehicle then return end
    CC:ChangeSpeed(false)
end, false)

RegisterKeyMapping('cruise_down', 'Tempomat rychlost -', 'keyboard', 'NUMPAD-')