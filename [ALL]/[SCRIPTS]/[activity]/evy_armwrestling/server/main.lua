local sessions = {}

RegisterNetEvent('evy_arm:check_sv')
AddEventHandler('evy_arm:check_sv', function(tIndex, coords, model)
    local src = source
    if not tIndex then return end

    -- Vytvoření dynamické session, pokud na tomto stole ještě nikdo nehraje
    if not sessions[tIndex] then
        sessions[tIndex] = {
            place1 = 0, 
            place2 = 0, 
            started = false, 
            grade = 0.5, 
            coords = coords, 
            model = model
        }
    end

    local session = sessions[tIndex]

    if session.place1 == 0 and not session.started then
        session.place1 = src
        TriggerClientEvent('evy_arm:check_cl', src, 'place1', tIndex, session.coords, session.model)
    elseif session.place2 == 0 and session.place1 ~= 0 then
        session.place2 = src
        TriggerClientEvent('evy_arm:check_cl', src, 'place2', tIndex, session.coords, session.model)
    else
        TriggerClientEvent('evy_arm:check_cl', src, 'noplace')
        return
    end

    -- Pokud jsou stoly obsazené oběma hráči
    if session.place1 ~= 0 and session.place2 ~= 0 and not session.started then
        TriggerClientEvent('evy_arm:start_cl', session.place1)
        TriggerClientEvent('evy_arm:start_cl', session.place2)
    end
end)

RegisterNetEvent('evy_arm:updategrade_sv')
AddEventHandler('evy_arm:updategrade_sv', function(gradeUpValue)
    local src = source
    
    for _, props in pairs(sessions) do
        if props.place1 == src or props.place2 == src then
            props.grade = props.grade + gradeUpValue
            
            if props.grade <= 0.10 then
                props.grade = -999
            elseif props.grade >= 0.90 then
                props.grade = 999
            end
            
            TriggerClientEvent('evy_arm:updategrade_cl', props.place1, props.grade)
            TriggerClientEvent('evy_arm:updategrade_cl', props.place2, props.grade)
            break
        end
    end
end)

RegisterNetEvent('evy_arm:disband_sv')
AddEventHandler('evy_arm:disband_sv', function(tIndex)
    local src = source
    if not tIndex or not sessions[tIndex] then return end

    local session = sessions[tIndex]
    
    if session.place1 == src or session.place2 == src then
        if session.place1 ~= 0 then
            TriggerClientEvent('evy_arm:reset_cl', session.place1, session.coords, session.model)
        end
        if session.place2 ~= 0 then
            TriggerClientEvent('evy_arm:reset_cl', session.place2, session.coords, session.model)
        end
        
        -- Reset session, ale ponecháme údaje o stole (můžeme klidně zničit celý index ať nezabírá RAM)
        sessions[tIndex] = nil 
    end
end)