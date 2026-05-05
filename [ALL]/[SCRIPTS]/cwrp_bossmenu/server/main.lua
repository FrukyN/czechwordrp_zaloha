local ESX = exports['es_extended']:getSharedObject()

local StashesRegistered = false

local function logDiscord(text, src, color, title)
    local ok, err = pcall(function()
        exports.JD_logs:discord(text, src or 0, 0, color or Config.WebhookColors.Info, title or 'bossmenu')
    end)

    if not ok and Config.Debug then
        print(('[bossmenu] JD_logs failed: %s'):format(err))
    end
end

local function banForExploit(src, reason, details)
    logDiscord(('Exploit detection (%s): %s'):format(reason, details or 'no-details'), src, Config.WebhookColors.Danger, 'bossmenu_anticheat')

    if not Config.BanOnExploit then return end

    local ok, err = pcall(function()
        exports['ElectronAC']:banPlayer(src, reason, details or 'bossmenu exploit', false)
    end)

    if not ok and Config.Debug then
        print(('[bossmenu] ElectronAC ban failed: %s'):format(err))
    end
end

local function toInt(value)
    local n = tonumber(value)
    if not n then return nil end
    n = math.floor(n)
    if n < 0 then return nil end
    return n
end

local function isValidMoneyType(moneyType)
    return moneyType == 'bank' or moneyType == 'cash'
end

local function getCash(xPlayer)
    if xPlayer.getMoney then
        return xPlayer.getMoney()
    end

    local account = xPlayer.getAccount and xPlayer.getAccount('money') or nil
    return (account and account.money) or 0
end

local function removeCash(xPlayer, amount)
    if xPlayer.removeMoney then
        xPlayer.removeMoney(amount)
        return
    end

    xPlayer.removeAccountMoney('money', amount)
end

local function addCash(xPlayer, amount)
    if xPlayer.addMoney then
        xPlayer.addMoney(amount)
        return
    end

    xPlayer.addAccountMoney('money', amount)
end

local function hasLength(str, maxLen)
    return type(str) == 'string' and #str > 0 and #str <= maxLen
end

local function getJobConfig(jobName)
    return Config.Jobs[jobName]
end

local function getFullNameFromXPlayer(xPlayer)
    if not xPlayer then return 'Unknown' end

    local name = xPlayer.getName and xPlayer.getName() or nil
    if name and name ~= '' then
        return name
    end

    local fn = xPlayer.variables and xPlayer.variables.firstName or nil
    local ln = xPlayer.variables and xPlayer.variables.lastName or nil

    if fn and ln then
        return ('%s %s'):format(fn, ln)
    end

    return ('%s (%s)'):format(GetPlayerName(xPlayer.source) or 'Unknown', xPlayer.identifier or 'no-id')
end

local function getOfflineName(identifier)
    local row = MySQL.single.await('SELECT firstname, lastname, name FROM users WHERE identifier = ? LIMIT 1', { identifier })
    if not row then return 'Unknown' end

    if row.firstname and row.lastname and row.firstname ~= '' then
        return ('%s %s'):format(row.firstname, row.lastname)
    end

    if row.name and row.name ~= '' then
        return row.name
    end

    return identifier
end

local function ensureSocietyAccount(jobName)
    MySQL.insert.await('INSERT IGNORE INTO bossmenu_society_accounts (job_name, balance) VALUES (?, 0)', { jobName })
end

local function getSocietyBalance(jobName)
    ensureSocietyAccount(jobName)
    local row = MySQL.single.await('SELECT balance FROM bossmenu_society_accounts WHERE job_name = ? LIMIT 1', { jobName })
    return row and row.balance or 0
end

local function setSocietyBalance(jobName, newBalance)
    ensureSocietyAccount(jobName)
    MySQL.update.await('UPDATE bossmenu_society_accounts SET balance = ? WHERE job_name = ?', { newBalance, jobName })
end

local function addTransaction(jobName, action, amount, actor, targetIdentifier, targetName, reason)
    MySQL.insert.await([[
        INSERT INTO bossmenu_transactions
            (job_name, action, amount, actor_identifier, actor_name, target_identifier, target_name, reason)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        jobName,
        action,
        amount,
        actor.identifier,
        getFullNameFromXPlayer(actor),
        targetIdentifier,
        targetName,
        reason
    })
end

local function addHRHistory(jobName, action, actor, targetIdentifier, targetName, fromGrade, toGrade, amount, reason)
    MySQL.insert.await([[
        INSERT INTO bossmenu_hr_history
            (job_name, action, actor_identifier, actor_name, target_identifier, target_name, from_grade, to_grade, amount, reason)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        jobName,
        action,
        actor.identifier,
        getFullNameFromXPlayer(actor),
        targetIdentifier,
        targetName,
        fromGrade,
        toGrade,
        amount,
        reason
    })
end

local function addActivity(jobName, identifier, name, action, metadata)
    MySQL.insert.await([[
        INSERT INTO bossmenu_activity (job_name, identifier, name, action, metadata)
        VALUES (?, ?, ?, ?, ?)
    ]], {
        jobName,
        identifier,
        name,
        action,
        metadata and json.encode(metadata) or nil
    })
end

local function requireBoss(source, requiredGrade, context)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return nil, nil, 'not_loaded'
    end

    local job = xPlayer.getJob()
    if not job or not job.name then
        banForExploit(source, 'bossmenu_invalid_job', context or 'job missing')
        return nil, nil, 'invalid_job'
    end

    local jobConfig = getJobConfig(job.name)
    if not jobConfig then
        banForExploit(source, 'bossmenu_unknown_job', ('%s / %s'):format(context or 'no-context', job.name))
        return nil, nil, 'unknown_job'
    end

    local minGrade = math.max(requiredGrade or 0, jobConfig.target and jobConfig.target.minGrade or 0)
    if (job.grade or 0) < minGrade then
        return nil, nil, 'insufficient_grade'
    end

    return xPlayer, job, nil
end

local function playerInSameJobOnline(identifier, jobName)
    local players = ESX.GetExtendedPlayers()
    for i = 1, #players do
        local xTarget = players[i]
        if xTarget.identifier == identifier then
            local tJob = xTarget.getJob()
            if tJob and tJob.name == jobName then
                return xTarget
            end
            return nil
        end
    end
    return nil
end

local function getOnlineAndTotal(jobName)
    local online = 0
    local players = ESX.GetExtendedPlayers()

    for i = 1, #players do
        local playerJob = players[i].getJob()
        if playerJob and playerJob.name == jobName then
            online = online + 1
        end
    end

    local total = MySQL.scalar.await('SELECT COUNT(1) FROM users WHERE job = ?', { jobName }) or 0
    return online, total
end

local function getWeekTopEmployee(jobName)
    local row = MySQL.single.await([[
        SELECT identifier, SUM(minutes) AS total_minutes
        FROM bossmenu_attendance_log
        WHERE job_name = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
        GROUP BY identifier
        ORDER BY total_minutes DESC
        LIMIT 1
    ]], { jobName })

    if not row then return nil end

    return {
        identifier = row.identifier,
        minutes = row.total_minutes,
        name = getOfflineName(row.identifier)
    }
end

local function updateAttendance(identifier, jobName, minutes)
    MySQL.insert.await([[
        INSERT INTO bossmenu_attendance (identifier, job_name, total_minutes, last_seen)
        VALUES (?, ?, ?, NOW())
        ON DUPLICATE KEY UPDATE
            total_minutes = total_minutes + VALUES(total_minutes),
            last_seen = NOW(),
            updated_at = NOW()
    ]], { identifier, jobName, minutes })

    MySQL.insert.await('INSERT INTO bossmenu_attendance_log (identifier, job_name, minutes) VALUES (?, ?, ?)', { identifier, jobName, minutes })
end

local function processAttendanceTick()
    local tickMinutes = Config.AttendanceTickMinutes
    local players = ESX.GetExtendedPlayers()

    for i = 1, #players do
        local xPlayer = players[i]
        local job = xPlayer.getJob()

        if job and getJobConfig(job.name) then
            updateAttendance(xPlayer.identifier, job.name, tickMinutes)
        end
    end
end

local function registerStashes()
    if StashesRegistered then return end

    for jobName, cfg in pairs(Config.Jobs) do
        if cfg.stash and cfg.stash.id then
            exports.ox_inventory:RegisterStash(
                cfg.stash.id,
                cfg.stash.label or ('%s Stash'):format(jobName),
                cfg.stash.slots or 100,
                cfg.stash.weight or 500000,
                false,
                { [jobName] = cfg.target and cfg.target.minGrade or 0 }
            )
        end
    end

    StashesRegistered = true
end

local function getEmployeeRows(jobName)
    return MySQL.query.await([[
        SELECT u.identifier, u.firstname, u.lastname, u.job_grade, jg.label AS grade_label, jg.salary,
            IFNULL(a.total_minutes, 0) AS total_minutes,
            a.last_seen
        FROM users u
        LEFT JOIN job_grades jg ON jg.job_name = u.job AND jg.grade = u.job_grade
        LEFT JOIN bossmenu_attendance a ON a.identifier = u.identifier AND a.job_name = u.job
        WHERE u.job = ?
        ORDER BY u.job_grade DESC, u.firstname ASC
    ]], { jobName })
end

local function buildEmployeeName(row)
    if row.firstname and row.lastname and row.firstname ~= '' then
        return ('%s %s'):format(row.firstname, row.lastname)
    end
    return row.identifier
end

lib.callback.register('bossmenu:server:getDashboard', function(source)
    local xPlayer, job, err = requireBoss(source, Config.Grades.Finance, 'get_dashboard')
    if err then return nil end

    local online, total = getOnlineAndTotal(job.name)
    local top = getWeekTopEmployee(job.name)
    local balance = getSocietyBalance(job.name)

    local announcements = MySQL.query.await([[
        SELECT id, message, author_name, created_at
        FROM bossmenu_announcements
        WHERE job_name = ?
        ORDER BY id DESC
        LIMIT 5
    ]], { job.name })

    return {
        job = job,
        jobLabel = (Config.Jobs[job.name] and Config.Jobs[job.name].label) or job.name,
        balance = balance,
        online = online,
        total = total,
        topEmployee = top,
        announcements = announcements
    }
end)

lib.callback.register('bossmenu:server:getEmployees', function(source)
    local _, job, err = requireBoss(source, Config.Grades.Employees, 'get_employees')
    if err then return nil end

    local rows = getEmployeeRows(job.name)
    local out = {}

    for i = 1, #rows do
        local row = rows[i]
        out[#out + 1] = {
            identifier = row.identifier,
            name = buildEmployeeName(row),
            grade = row.job_grade,
            gradeLabel = row.grade_label or ('Grade %s'):format(row.job_grade),
            salary = row.salary or 0,
            minutes = row.total_minutes or 0,
            lastSeen = row.last_seen
        }
    end

    return out
end)

lib.callback.register('bossmenu:server:getEmployeeDetail', function(source, identifier)
    local _, job, err = requireBoss(source, Config.Grades.Employees, 'get_employee_detail')
    if err then return nil end

    if type(identifier) ~= 'string' or #identifier < 6 then
        banForExploit(source, 'bossmenu_bad_identifier', 'detail_identifier')
        return nil
    end

    local notes = MySQL.query.await([[
        SELECT id, note, author_name, created_at
        FROM bossmenu_employee_notes
        WHERE job_name = ? AND employee_identifier = ?
        ORDER BY id DESC
        LIMIT 20
    ]], { job.name, identifier })

    local hr = MySQL.query.await([[
        SELECT action, actor_name, from_grade, to_grade, amount, reason, created_at
        FROM bossmenu_hr_history
        WHERE job_name = ? AND target_identifier = ?
        ORDER BY id DESC
        LIMIT 20
    ]], { job.name, identifier })

    local attendance7d = MySQL.query.await([[
        SELECT DATE(created_at) AS day, SUM(minutes) AS minutes
        FROM bossmenu_attendance_log
        WHERE job_name = ? AND identifier = ? AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
        GROUP BY DATE(created_at)
        ORDER BY day DESC
    ]], { job.name, identifier })

    return {
        notes = notes,
        hrHistory = hr,
        attendance7d = attendance7d
    }
end)

lib.callback.register('bossmenu:server:getTransactions', function(source)
    local _, job, err = requireBoss(source, Config.Grades.Finance, 'get_transactions')
    if err then return nil end

    return MySQL.query.await([[
        SELECT action, amount, actor_name, target_name, reason, created_at
        FROM bossmenu_transactions
        WHERE job_name = ?
        ORDER BY id DESC
        LIMIT 100
    ]], { job.name })
end)

lib.callback.register('bossmenu:server:getHRHistory', function(source)
    local _, job, err = requireBoss(source, Config.Grades.Employees, 'get_hr_history')
    if err then return nil end

    return MySQL.query.await([[
        SELECT action, actor_name, target_name, from_grade, to_grade, amount, reason, created_at
        FROM bossmenu_hr_history
        WHERE job_name = ?
        ORDER BY id DESC
        LIMIT 100
    ]], { job.name })
end)

lib.callback.register('bossmenu:server:getAnnouncements', function(source)
    local _, job, err = requireBoss(source, Config.Grades.Employees, 'get_announcements')
    if err then return nil end

    return MySQL.query.await([[
        SELECT id, message, author_name, created_at
        FROM bossmenu_announcements
        WHERE job_name = ?
        ORDER BY id DESC
        LIMIT 20
    ]], { job.name })
end)

lib.callback.register('bossmenu:server:getPendingOrders', function(source)
    local _, job, err = requireBoss(source, Config.Grades.Employees, 'get_orders')
    if err then return nil end

    return MySQL.query.await([[
        SELECT id, item, amount, total_price, ordered_by_name, status, deliver_at, created_at
        FROM bossmenu_material_orders
        WHERE job_name = ?
        ORDER BY id DESC
        LIMIT 20
    ]], { job.name })
end)

RegisterNetEvent('bossmenu:server:deposit', function(amount, sourceType)
    local src = source
    local xPlayer, job, err = requireBoss(src, Config.Grades.Finance, 'deposit')
    if err then return end

    local value = toInt(amount)
    if not value or value <= 0 or value > Config.MaxDeposit then
        banForExploit(src, 'bossmenu_bad_amount', ('deposit:%s'):format(tostring(amount)))
        return
    end

    if not isValidMoneyType(sourceType) then
        banForExploit(src, 'bossmenu_bad_money_type', ('deposit:%s'):format(tostring(sourceType)))
        return
    end

    if sourceType == 'bank' then
        local bankMoney = xPlayer.getAccount('bank').money
        if bankMoney < value then
            TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Not enough money in bank account.' })
            return
        end

        xPlayer.removeAccountMoney('bank', value)
    else
        local cash = getCash(xPlayer)
        if cash < value then
            TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Not enough cash in inventory.' })
            return
        end

        removeCash(xPlayer, value)
    end

    local oldBalance = getSocietyBalance(job.name)
    setSocietyBalance(job.name, oldBalance + value)

    addTransaction(job.name, 'deposit', value, xPlayer, nil, nil, ('boss_deposit_%s'):format(sourceType))
    addActivity(job.name, xPlayer.identifier, getFullNameFromXPlayer(xPlayer), 'deposit', { amount = value, source = sourceType })

    logDiscord(('Player deposited %s to society %s from %s'):format(value, job.name, sourceType), src, Config.WebhookColors.Success, 'bossmenu_finance')

    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = ('Deposited $%s into company account.'):format(value) })
end)

RegisterNetEvent('bossmenu:server:withdraw', function(amount, targetType)
    local src = source
    local xPlayer, job, err = requireBoss(src, Config.Grades.Finance, 'withdraw')
    if err then return end

    local value = toInt(amount)
    if not value or value <= 0 or value > Config.MaxWithdraw then
        banForExploit(src, 'bossmenu_bad_amount', ('withdraw:%s'):format(tostring(amount)))
        return
    end

    if not isValidMoneyType(targetType) then
        banForExploit(src, 'bossmenu_bad_money_type', ('withdraw:%s'):format(tostring(targetType)))
        return
    end

    local balance = getSocietyBalance(job.name)
    if balance < value then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Company account has insufficient balance.' })
        return
    end

    setSocietyBalance(job.name, balance - value)
    if targetType == 'bank' then
        xPlayer.addAccountMoney('bank', value)
    else
        addCash(xPlayer, value)
    end

    addTransaction(job.name, 'withdraw', value, xPlayer, nil, nil, ('boss_withdraw_%s'):format(targetType))
    addActivity(job.name, xPlayer.identifier, getFullNameFromXPlayer(xPlayer), 'withdraw', { amount = value, target = targetType })

    logDiscord(('Player withdrew %s from society %s to %s'):format(value, job.name, targetType), src, Config.WebhookColors.Warning, 'bossmenu_finance')

    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = ('Withdrew $%s from company account.'):format(value) })
end)

RegisterNetEvent('bossmenu:server:hire', function(targetSource)
    local src = source
    local xPlayer, job, err = requireBoss(src, Config.Grades.Employees, 'hire')
    if err then return end

    local targetId = tonumber(targetSource)
    if not targetId then
        banForExploit(src, 'bossmenu_bad_target', ('hire:%s'):format(tostring(targetSource)))
        return
    end

    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Target player is not online.' })
        return
    end

    local targetJob = xTarget.getJob()
    if targetJob and targetJob.name == job.name then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Player is already in this job.' })
        return
    end

    xTarget.setJob(job.name, 0)

    local targetName = getFullNameFromXPlayer(xTarget)
    addHRHistory(job.name, 'hire', xPlayer, xTarget.identifier, targetName, nil, 0, nil, 'hired')
    addActivity(job.name, xTarget.identifier, targetName, 'hire', { actor = xPlayer.identifier })

    logDiscord(('%s hired %s to %s'):format(getFullNameFromXPlayer(xPlayer), targetName, job.name), src, Config.WebhookColors.Success, 'bossmenu_hr')

    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = ('Hired %s.'):format(targetName) })
    TriggerClientEvent('ox_lib:notify', xTarget.source, { type = 'inform', description = ('You were hired in %s.'):format(job.label or job.name) })
end)

RegisterNetEvent('bossmenu:server:fire', function(identifier, reason)
    local src = source
    local xPlayer, job, err = requireBoss(src, Config.Grades.Employees, 'fire')
    if err then return end

    if type(identifier) ~= 'string' or #identifier < 6 then
        banForExploit(src, 'bossmenu_bad_identifier', 'fire_identifier')
        return
    end

    reason = type(reason) == 'string' and reason:sub(1, 120) or 'fired'

    local current = MySQL.single.await('SELECT job, job_grade FROM users WHERE identifier = ? LIMIT 1', { identifier })
    if not current or current.job ~= job.name then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Employee is not in your company.' })
        return
    end

    local targetName = getOfflineName(identifier)
    local onlineTarget = playerInSameJobOnline(identifier, job.name)

    if onlineTarget then
        onlineTarget.setJob('unemployed', 0)
        TriggerClientEvent('ox_lib:notify', onlineTarget.source, { type = 'error', description = ('You were fired from %s.'):format(job.label or job.name) })
    else
        MySQL.update.await('UPDATE users SET job = ?, job_grade = 0 WHERE identifier = ?', { 'unemployed', identifier })
    end

    addHRHistory(job.name, 'fire', xPlayer, identifier, targetName, current.job_grade, 0, nil, reason)
    addActivity(job.name, identifier, targetName, 'fire', { actor = xPlayer.identifier, reason = reason })

    logDiscord(('%s fired %s from %s (%s)'):format(getFullNameFromXPlayer(xPlayer), targetName, job.name, reason), src, Config.WebhookColors.Danger, 'bossmenu_hr')

    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = ('Fired %s.'):format(targetName) })
end)

RegisterNetEvent('bossmenu:server:setGrade', function(identifier, newGrade)
    local src = source
    local xPlayer, job, err = requireBoss(src, Config.Grades.Employees, 'set_grade')
    if err then return end

    if type(identifier) ~= 'string' or #identifier < 6 then
        banForExploit(src, 'bossmenu_bad_identifier', 'grade_identifier')
        return
    end

    local grade = tonumber(newGrade)
    if not grade or grade < 0 or grade > 20 then
        banForExploit(src, 'bossmenu_bad_grade', tostring(newGrade))
        return
    end

    local gradeExists = MySQL.scalar.await('SELECT COUNT(1) FROM job_grades WHERE job_name = ? AND grade = ?', { job.name, grade })
    if not gradeExists or gradeExists < 1 then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Requested grade does not exist.' })
        return
    end

    local current = MySQL.single.await('SELECT job, job_grade FROM users WHERE identifier = ? LIMIT 1', { identifier })
    if not current or current.job ~= job.name then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Employee is not in your company.' })
        return
    end

    local targetName = getOfflineName(identifier)
    local onlineTarget = playerInSameJobOnline(identifier, job.name)

    if onlineTarget then
        onlineTarget.setJob(job.name, grade)
        TriggerClientEvent('ox_lib:notify', onlineTarget.source, { type = 'inform', description = ('Your grade was changed to %s.'):format(grade) })
    else
        MySQL.update.await('UPDATE users SET job_grade = ? WHERE identifier = ?', { grade, identifier })
    end

    addHRHistory(job.name, 'grade_change', xPlayer, identifier, targetName, current.job_grade, grade, nil, 'manual_grade_change')
    addActivity(job.name, identifier, targetName, 'grade_change', { actor = xPlayer.identifier, from = current.job_grade, to = grade })

    logDiscord(('%s changed grade for %s from %s to %s (%s)'):format(getFullNameFromXPlayer(xPlayer), targetName, current.job_grade, grade, job.name), src, Config.WebhookColors.Info, 'bossmenu_hr')

    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = ('Updated grade for %s.'):format(targetName) })
end)

RegisterNetEvent('bossmenu:server:bonus', function(identifier, amount, reason)
    local src = source
    local xPlayer, job, err = requireBoss(src, Config.Grades.Employees, 'bonus')
    if err then return end

    if type(identifier) ~= 'string' or #identifier < 6 then
        banForExploit(src, 'bossmenu_bad_identifier', 'bonus_identifier')
        return
    end

    local value = toInt(amount)
    if not value or value <= 0 or value > Config.MaxBonus then
        banForExploit(src, 'bossmenu_bad_bonus', tostring(amount))
        return
    end

    reason = type(reason) == 'string' and reason:sub(1, 120) or 'bonus'

    local current = MySQL.single.await('SELECT job FROM users WHERE identifier = ? LIMIT 1', { identifier })
    if not current or current.job ~= job.name then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Employee is not in your company.' })
        return
    end

    local balance = getSocietyBalance(job.name)
    if balance < value then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Insufficient company funds for bonus.' })
        return
    end

    local onlineTarget = playerInSameJobOnline(identifier, job.name)
    local targetName = getOfflineName(identifier)

    if Config.PayrollOnlineOnly and not onlineTarget then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Target employee must be online for bonus payout.' })
        return
    end

    setSocietyBalance(job.name, balance - value)

    if onlineTarget then
        onlineTarget.addAccountMoney('bank', value)
        TriggerClientEvent('ox_lib:notify', onlineTarget.source, { type = 'success', description = ('You received a bonus: $%s.'):format(value) })
    end

    addTransaction(job.name, 'bonus', value, xPlayer, identifier, targetName, reason)
    addHRHistory(job.name, 'bonus', xPlayer, identifier, targetName, nil, nil, value, reason)
    addActivity(job.name, identifier, targetName, 'bonus', { actor = xPlayer.identifier, amount = value, reason = reason })

    logDiscord(('%s gave bonus %s to %s (%s)'):format(getFullNameFromXPlayer(xPlayer), value, targetName, reason), src, Config.WebhookColors.Success, 'bossmenu_finance')

    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = ('Bonus paid to %s.'):format(targetName) })
end)

RegisterNetEvent('bossmenu:server:addEmployeeNote', function(identifier, note)
    local src = source
    local xPlayer, job, err = requireBoss(src, Config.Grades.Employees, 'note_add')
    if err then return end

    if type(identifier) ~= 'string' or #identifier < 6 then
        banForExploit(src, 'bossmenu_bad_identifier', 'note_identifier')
        return
    end

    if not hasLength(note, Config.MaxNoteLength) then
        banForExploit(src, 'bossmenu_bad_note', tostring(note and #note or 'nil'))
        return
    end

    local current = MySQL.single.await('SELECT job FROM users WHERE identifier = ? LIMIT 1', { identifier })
    if not current or current.job ~= job.name then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Employee is not in your company.' })
        return
    end

    MySQL.insert.await([[
        INSERT INTO bossmenu_employee_notes (job_name, employee_identifier, note, author_identifier, author_name)
        VALUES (?, ?, ?, ?, ?)
    ]], { job.name, identifier, note, xPlayer.identifier, getFullNameFromXPlayer(xPlayer) })

    addActivity(job.name, identifier, getOfflineName(identifier), 'note_add', { actor = xPlayer.identifier })

    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'Employee note added.' })
end)

RegisterNetEvent('bossmenu:server:addAnnouncement', function(message)
    local src = source
    local xPlayer, job, err = requireBoss(src, Config.Grades.Employees, 'announcement_add')
    if err then return end

    if not hasLength(message, Config.MaxAnnouncementLength) then
        banForExploit(src, 'bossmenu_bad_announcement', tostring(message and #message or 'nil'))
        return
    end

    MySQL.insert.await([[
        INSERT INTO bossmenu_announcements (job_name, message, author_identifier, author_name)
        VALUES (?, ?, ?, ?)
    ]], { job.name, message, xPlayer.identifier, getFullNameFromXPlayer(xPlayer) })

    addActivity(job.name, xPlayer.identifier, getFullNameFromXPlayer(xPlayer), 'announcement_add', { message = message })

    local players = ESX.GetExtendedPlayers()
    for i = 1, #players do
        local p = players[i]
        local pJob = p.getJob()

        if pJob and pJob.name == job.name then
            TriggerClientEvent('ox_lib:notify', p.source, {
                type = 'inform',
                title = 'Company announcement',
                description = message
            })
        end
    end

    logDiscord(('%s posted company announcement for %s: %s'):format(getFullNameFromXPlayer(xPlayer), job.name, message), src, Config.WebhookColors.Info, 'bossmenu_announcement')

    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'Announcement published.' })
end)

RegisterNetEvent('bossmenu:server:openStash', function()
    local src = source
    local _, job, err = requireBoss(src, Config.Grades.Employees, 'open_stash')
    if err then return end

    local cfg = getJobConfig(job.name)
    if not cfg or not cfg.stash then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'No company stash configured for this job.' })
        return
    end

    TriggerClientEvent('ox_inventory:openInventory', src, 'stash', cfg.stash.id)
end)

RegisterNetEvent('bossmenu:server:createMaterialOrder', function(itemName, amount)
    local src = source
    local xPlayer, job, err = requireBoss(src, Config.Grades.Employees, 'create_order')
    if err then return end

    local cfg = getJobConfig(job.name)
    local orderCfg = cfg and cfg.materialsOrder

    if not (Config.OrderSystem.Enabled and orderCfg and orderCfg.enabled) then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Material orders are disabled for this job.' })
        return
    end

    local qty = toInt(amount)
    if not qty or qty <= 0 or qty > Config.MaxOrderAmount then
        banForExploit(src, 'bossmenu_bad_order_amount', tostring(amount))
        return
    end

    if type(itemName) ~= 'string' or #itemName < 1 or #itemName > 64 then
        banForExploit(src, 'bossmenu_bad_order_item', tostring(itemName))
        return
    end

    local catalogItem
    for i = 1, #orderCfg.items do
        if orderCfg.items[i].item == itemName then
            catalogItem = orderCfg.items[i]
            break
        end
    end

    if not catalogItem then
        banForExploit(src, 'bossmenu_unknown_order_item', tostring(itemName))
        return
    end

    local total = qty * catalogItem.price
    local balance = getSocietyBalance(job.name)

    if balance < total then
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Company account balance is too low for this order.' })
        return
    end

    setSocietyBalance(job.name, balance - total)

    local deliverySeconds = orderCfg.deliverySeconds or Config.OrderSystem.DefaultDeliverySeconds
    MySQL.insert.await([[
        INSERT INTO bossmenu_material_orders
            (job_name, item, amount, total_price, ordered_by_identifier, ordered_by_name, status, deliver_at)
        VALUES (?, ?, ?, ?, ?, ?, 'pending', DATE_ADD(NOW(), INTERVAL ? SECOND))
    ]], { job.name, itemName, qty, total, xPlayer.identifier, getFullNameFromXPlayer(xPlayer), deliverySeconds })

    addTransaction(job.name, 'material_order', total, xPlayer, nil, nil, ('order:%s x%s'):format(itemName, qty))
    addActivity(job.name, xPlayer.identifier, getFullNameFromXPlayer(xPlayer), 'material_order', { item = itemName, amount = qty, price = total })

    logDiscord(('%s ordered %sx %s for %s (cost %s)'):format(getFullNameFromXPlayer(xPlayer), qty, itemName, job.name, total), src, Config.WebhookColors.Warning, 'bossmenu_orders')

    TriggerClientEvent('ox_lib:notify', src, {
        type = 'success',
        description = ('Order placed: %sx %s. Delivery in %s minutes.'):format(qty, itemName, math.floor(deliverySeconds / 60))
    })
end)

CreateThread(function()
    Wait(1500)
    registerStashes()

    for jobName, _ in pairs(Config.Jobs) do
        ensureSocietyAccount(jobName)
    end

    while true do
        Wait((Config.AttendanceTickMinutes or 5) * 60000)
        processAttendanceTick()
    end
end)

CreateThread(function()
    while true do
        Wait(60000)

        local orders = MySQL.query.await([[
            SELECT id, job_name, item, amount
            FROM bossmenu_material_orders
            WHERE status = 'pending' AND deliver_at <= NOW()
            LIMIT 30
        ]])

        for i = 1, #orders do
            local order = orders[i]
            local cfg = getJobConfig(order.job_name)

            if cfg and cfg.stash then
                local success = exports.ox_inventory:AddItem(cfg.stash.id, order.item, order.amount)

                if success then
                    MySQL.update.await('UPDATE bossmenu_material_orders SET status = ?, delivered_at = NOW() WHERE id = ?', { 'delivered', order.id })
                else
                    MySQL.update.await('UPDATE bossmenu_material_orders SET status = ? WHERE id = ?', { 'failed', order.id })
                end
            else
                MySQL.update.await('UPDATE bossmenu_material_orders SET status = ? WHERE id = ?', { 'failed', order.id })
            end
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    Wait(500)
    registerStashes()
end)
