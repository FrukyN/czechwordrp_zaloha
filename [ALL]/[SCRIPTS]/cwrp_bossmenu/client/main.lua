local ESX = exports['es_extended']:getSharedObject()

local function minutesToHours(minutes)
    local mins = tonumber(minutes) or 0
    local hours = mins / 60
    return string.format('%.1f h', hours)
end

local function getPlayerJob()
    local data = ESX.PlayerData
    if not data or not data.job then return nil end
    return data.job
end

local function canUseBossMenu(jobName, grade)
    local cfg = Config.Jobs[jobName]
    if not cfg then return false end
    local minGrade = (cfg.target and cfg.target.minGrade) or 0
    return (grade or 0) >= minGrade
end

local function notify(msgType, description)
    lib.notify({
        type = msgType,
        description = description
    })
end

local function inputNumber(title, label)
    local input = lib.inputDialog(title, {
        { type = 'number', label = label, required = true, min = 1 }
    })

    if not input then return nil end
    return tonumber(input[1])
end

local function inputMoneyAction(title, amountLabel)
    local input = lib.inputDialog(title, {
        {
            type = 'select',
            label = 'Zdroj/Cíl peněz',
            required = true,
            options = {
                { value = 'bank', label = 'Bankovní účet' },
                { value = 'cash', label = 'Hotovost (inventář)' }
            }
        },
        { type = 'number', label = amountLabel, required = true, min = 1 }
    })

    if not input then return nil, nil end
    return input[1], tonumber(input[2])
end

local function openTransactionsMenu()
    local rows = lib.callback.await('bossmenu:server:getTransactions', false)
    if not rows then
        notify('error', 'Unable to load transactions.')
        return
    end

    local options = {}
    for i = 1, #rows do
        local row = rows[i]
        options[#options + 1] = {
            title = ('%s | $%s'):format(row.action, row.amount),
            description = ('By: %s | Target: %s | %s'):format(row.actor_name or 'Unknown', row.target_name or 'n/a', row.created_at),
            metadata = {
                { label = 'Reason', value = row.reason or '-' }
            }
        }
    end

    if #options == 0 then
        options[1] = { title = 'No records', description = 'There are no transaction records yet.' }
    end

    lib.registerContext({
        id = 'bossmenu_transactions',
        title = 'Transaction History',
        menu = 'bossmenu_main',
        options = options
    })

    lib.showContext('bossmenu_transactions')
end

local function openHRHistoryMenu()
    local rows = lib.callback.await('bossmenu:server:getHRHistory', false)
    if not rows then
        notify('error', 'Unable to load HR history.')
        return
    end

    local options = {}
    for i = 1, #rows do
        local row = rows[i]
        options[#options + 1] = {
            title = ('%s -> %s (%s)'):format(row.actor_name or 'Unknown', row.target_name or 'Unknown', row.action),
            description = ('Date: %s'):format(row.created_at),
            metadata = {
                { label = 'From grade', value = row.from_grade or '-' },
                { label = 'To grade', value = row.to_grade or '-' },
                { label = 'Amount', value = row.amount or '-' },
                { label = 'Reason', value = row.reason or '-' }
            }
        }
    end

    if #options == 0 then
        options[1] = { title = 'No records', description = 'There are no HR logs yet.' }
    end

    lib.registerContext({
        id = 'bossmenu_hr_history',
        title = 'HR Change History',
        menu = 'bossmenu_main',
        options = options
    })

    lib.showContext('bossmenu_hr_history')
end

local function openEmployeeDetail(identifier, employeeName)
    local details = lib.callback.await('bossmenu:server:getEmployeeDetail', false, identifier)
    if not details then
        notify('error', 'Unable to load employee details.')
        return
    end

    local options = {
        {
            title = 'Change Grade',
            onSelect = function()
                local grade = inputNumber(employeeName, 'New grade')
                if not grade then return end
                TriggerServerEvent('bossmenu:server:setGrade', identifier, grade)
            end
        },
        {
            title = 'Give Bonus',
            onSelect = function()
                local input = lib.inputDialog(('Bonus: %s'):format(employeeName), {
                    { type = 'number', label = 'Amount', required = true, min = 1 },
                    { type = 'input', label = 'Reason', required = true, max = 120 }
                })
                if not input then return end
                TriggerServerEvent('bossmenu:server:bonus', identifier, tonumber(input[1]), input[2])
            end
        },
        {
            title = 'Add Employee Note',
            onSelect = function()
                local input = lib.inputDialog(('Note for %s'):format(employeeName), {
                    { type = 'textarea', label = 'Note', required = true, max = Config.MaxNoteLength }
                })
                if not input then return end
                TriggerServerEvent('bossmenu:server:addEmployeeNote', identifier, input[1])
            end
        },
        {
            title = 'Fire Employee',
            description = 'This action sets player job to unemployed.',
            onSelect = function()
                local input = lib.inputDialog(('Fire %s'):format(employeeName), {
                    { type = 'input', label = 'Reason', required = true, max = 120 }
                })
                if not input then return end
                TriggerServerEvent('bossmenu:server:fire', identifier, input[1])
            end
        }
    }

    for i = 1, #(details.attendance7d or {}) do
        local item = details.attendance7d[i]
        options[#options + 1] = {
            title = ('Attendance %s'):format(item.day),
            description = ('Worked: %s'):format(minutesToHours(item.minutes))
        }
    end

    for i = 1, #(details.notes or {}) do
        local note = details.notes[i]
        options[#options + 1] = {
            title = ('Note by %s'):format(note.author_name or 'Unknown'),
            description = ('%s | %s'):format(note.note, note.created_at)
        }
    end

    if #options == 4 then
        options[#options + 1] = {
            title = 'No extra details',
            description = 'No attendance or notes available in the last records.'
        }
    end

    lib.registerContext({
        id = 'bossmenu_employee_detail',
        title = employeeName,
        menu = 'bossmenu_employees',
        options = options
    })

    lib.showContext('bossmenu_employee_detail')
end

local function openEmployeesMenu()
    local employees = lib.callback.await('bossmenu:server:getEmployees', false)
    if not employees then
        notify('error', 'Unable to load employees.')
        return
    end

    local options = {
        {
            title = 'Hire Online Player',
            icon = 'user-plus',
            onSelect = function()
                local nearby = {}
                local players = GetActivePlayers()

                for i = 1, #players do
                    local playerId = players[i]
                    local serverId = GetPlayerServerId(playerId)

                    if serverId ~= GetPlayerServerId(PlayerId()) then
                        nearby[#nearby + 1] = {
                            value = serverId,
                            label = ('%s [%s]'):format(GetPlayerName(playerId), serverId)
                        }
                    end
                end

                if #nearby == 0 then
                    notify('error', 'No online players found to hire.')
                    return
                end

                local input = lib.inputDialog('Hire Player', {
                    {
                        type = 'select',
                        label = 'Select player',
                        options = nearby,
                        required = true
                    }
                })

                if not input then return end
                TriggerServerEvent('bossmenu:server:hire', tonumber(input[1]))
            end
        }
    }

    for i = 1, #employees do
        local e = employees[i]
        options[#options + 1] = {
            title = ('%s | %s'):format(e.name, e.gradeLabel),
            description = ('Salary: $%s | Worked: %s'):format(e.salary, minutesToHours(e.minutes)),
            metadata = {
                { label = 'Identifier', value = e.identifier },
                { label = 'Last seen', value = e.lastSeen or 'n/a' }
            },
            onSelect = function()
                openEmployeeDetail(e.identifier, e.name)
            end
        }
    end

    lib.registerContext({
        id = 'bossmenu_employees',
        title = 'Employee Management',
        menu = 'bossmenu_main',
        options = options
    })

    lib.showContext('bossmenu_employees')
end

local function openAnnouncementsMenu()
    local rows = lib.callback.await('bossmenu:server:getAnnouncements', false)
    if not rows then
        notify('error', 'Unable to load announcements.')
        return
    end

    local options = {
        {
            title = 'Create Announcement',
            onSelect = function()
                local input = lib.inputDialog('Internal Announcement', {
                    { type = 'textarea', label = 'Message', required = true, max = Config.MaxAnnouncementLength }
                })
                if not input then return end
                TriggerServerEvent('bossmenu:server:addAnnouncement', input[1])
            end
        }
    }

    for i = 1, #rows do
        local row = rows[i]
        options[#options + 1] = {
            title = row.message,
            description = ('By %s | %s'):format(row.author_name or 'Unknown', row.created_at)
        }
    end

    lib.registerContext({
        id = 'bossmenu_announcements',
        title = 'Internal Announcements',
        menu = 'bossmenu_main',
        options = options
    })

    lib.showContext('bossmenu_announcements')
end

local function openOrdersMenu()
    local orders = lib.callback.await('bossmenu:server:getPendingOrders', false)
    if not orders then
        notify('error', 'Unable to load orders.')
        return
    end

    local job = getPlayerJob()
    if not job then return end
    local cfg = Config.Jobs[job.name]

    local options = {}

    if cfg and cfg.materialsOrder and cfg.materialsOrder.enabled then
        options[#options + 1] = {
            title = 'Create Material Order',
            onSelect = function()
                local catalog = {}
                for i = 1, #(cfg.materialsOrder.items or {}) do
                    local item = cfg.materialsOrder.items[i]
                    catalog[#catalog + 1] = {
                        value = item.item,
                        label = ('%s ($%s)'):format(item.label or item.item, item.price)
                    }
                end

                local input = lib.inputDialog('Material Order', {
                    { type = 'select', label = 'Item', options = catalog, required = true },
                    { type = 'number', label = 'Amount', required = true, min = 1, max = Config.MaxOrderAmount }
                })

                if not input then return end
                TriggerServerEvent('bossmenu:server:createMaterialOrder', input[1], tonumber(input[2]))
            end
        }
    else
        options[#options + 1] = {
            title = 'Order system disabled for this job'
        }
    end

    for i = 1, #orders do
        local o = orders[i]
        options[#options + 1] = {
            title = ('%s x%s [%s]'):format(o.item, o.amount, o.status),
            description = ('By %s | Cost $%s | Delivery %s'):format(o.ordered_by_name or 'Unknown', o.total_price or 0, o.deliver_at or '-')
        }
    end

    lib.registerContext({
        id = 'bossmenu_orders',
        title = 'Material Orders',
        menu = 'bossmenu_main',
        options = options
    })

    lib.showContext('bossmenu_orders')
end

function OpenBossMenu()
    local dashboard = lib.callback.await('bossmenu:server:getDashboard', false)
    if not dashboard then
        notify('error', 'You do not have access to this boss menu.')
        return
    end

    local options = {
        {
            title = ('Company Balance: $%s'):format(dashboard.balance),
            description = ('Online: %s / Total: %s'):format(dashboard.online, dashboard.total)
        },
        {
            title = 'Deposit Money',
            icon = 'money-bill-transfer',
            onSelect = function()
                local sourceType, amount = inputMoneyAction('Company Deposit', 'Amount to deposit')
                if not sourceType or not amount then return end
                TriggerServerEvent('bossmenu:server:deposit', amount, sourceType)
            end
        },
        {
            title = 'Withdraw Money',
            icon = 'money-bill-wave',
            onSelect = function()
                local targetType, amount = inputMoneyAction('Company Withdrawal', 'Amount to withdraw')
                if not targetType or not amount then return end
                TriggerServerEvent('bossmenu:server:withdraw', amount, targetType)
            end
        },
        {
            title = 'Employee Management',
            icon = 'users',
            onSelect = openEmployeesMenu
        },
        {
            title = 'Internal Announcements',
            icon = 'bullhorn',
            onSelect = openAnnouncementsMenu
        },
        {
            title = 'Material Orders',
            icon = 'truck-fast',
            onSelect = openOrdersMenu
        },
        {
            title = 'Open Company Storage',
            icon = 'warehouse',
            onSelect = function()
                TriggerServerEvent('bossmenu:server:openStash')
            end
        },
        {
            title = 'Transaction History',
            icon = 'clock-rotate-left',
            onSelect = openTransactionsMenu
        },
        {
            title = 'HR History',
            icon = 'book',
            onSelect = openHRHistoryMenu
        }
    }

    if dashboard.topEmployee then
        options[#options + 1] = {
            title = 'Most Active Employee (7d)',
            description = ('%s | %s'):format(dashboard.topEmployee.name, minutesToHours(dashboard.topEmployee.minutes))
        }
    else
        options[#options + 1] = {
            title = 'Most Active Employee (7d)',
            description = 'No attendance data yet.'
        }
    end

    for i = 1, #(dashboard.announcements or {}) do
        local row = dashboard.announcements[i]
        options[#options + 1] = {
            title = ('Announcement: %s'):format(row.message),
            description = ('By %s | %s'):format(row.author_name or 'Unknown', row.created_at)
        }
    end

    lib.registerContext({
        id = 'bossmenu_main',
        title = ('Boss Menu - %s'):format(dashboard.jobLabel),
        options = options
    })

    lib.showContext('bossmenu_main')
end

RegisterCommand('bossmenu', function()
    local job = getPlayerJob()
    if not job then return end

    if canUseBossMenu(job.name, job.grade) then
        OpenBossMenu()
    else
        notify('error', 'Your grade cannot access boss menu.')
    end
end, false)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Wait(250)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    for jobName, cfg in pairs(Config.Jobs) do
        local target = cfg.target

        if target and target.coords then
            exports.ox_target:addBoxZone({
                coords = target.coords,
                size = target.size or vec3(1.3, 1.0, 1.8),
                rotation = target.rotation or 0.0,
                debug = target.debug or false,
                options = {
                    {
                        name = ('bossmenu_%s'):format(jobName),
                        icon = 'fa-solid fa-briefcase',
                        label = ('Open %s Boss Menu'):format(cfg.label or jobName),
                        groups = {
                            [jobName] = target.minGrade or 0
                        },
                        onSelect = function()
                            OpenBossMenu()
                        end
                    }
                }
            })
        end
    end
end)
