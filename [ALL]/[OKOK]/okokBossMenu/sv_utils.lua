ESX = exports.es_extended:getSharedObject()
Webhook = ''

function getCoreObject()
	return exports.es_extended:getSharedObject()
end

function MySQLfetchAll(query, values, func)
	return MySQL.Sync.fetchAll(query, values, func)
end

function MySQLexecute(query, values, func)
    return MySQL.Async.execute(query, values, func)
end

function MySQLfetchScalar(query, values, func)
    return MySQL.Async.fetchScalar(query, values, func)
end

function getPlayerMoney(source)
	local Player = getPlayer(source)
	return Player.getMoney()
end

function removePlayerMoney(source, amount)
	local Player = getPlayer(source)
	Player.removeMoney(amount)
end

function addPlayerMoney(source, amount)
	local Player = getPlayer(source)
	Player.addMoney(amount)
end

function afterFiringPlayer(source, job)
	-- Add your logic here to remove job from multijob for online players
end

function afterFiringOfflinePlayer(identifier, job)
	-- Add your logic here to remove job from multijob for offline players
end

function afterHiringPlayer(citizenid, job)
	-- Add your logic here to give job to multijob
end

function AddBankingTransaction(targetName, targetCitizenID, jobLabel, jobName, amount, description)
	TriggerEvent('okokBanking:AddNewTransaction', targetName, targetCitizenID, jobLabel, jobName, amount, description)
end

lib.callback.register(Config.EventPrefix..':isOnDuty', function(source)
	local source = source
	local citizenID = getPlayerCitizenID(source)
	local xPlayer = getPlayer(source)
	if Config.UseNewESXDutySystem then
		return xPlayer.getJob().onDuty
	else
		local onDuty = MySQLfetchAll('SELECT isOnDuty FROM users WHERE identifier = @citizenid', { ['@citizenid'] = citizenID })
		if onDuty[1] and onDuty[1].isOnDuty then
			return onDuty[1].isOnDuty
		else
			return false
		end
	end
end)

function setNewJobDuty(xPlayer, PlayerJob, PlayerGrade, duty)
	xPlayer.setJob(PlayerJob, PlayerGrade, duty)
end

function getGradesInfo(job)
	debugPrint("Getting grades for job: "..tostring(job))
	local result = MySQLfetchAll('SELECT * FROM job_grades WHERE job_name = @job', { ['@job'] = job })
	local grades = {}
	for k,v in pairs(result) do
		grades[v.grade] = v.label
	end
	return grades
end

function getPlayerJob(source)
	debugPrint("Getting job for source: "..tostring(source))
	local Player = getPlayer(source)
	if not Player then return nil end
	return Player.getJob().name
end

function getPlayerJobLabel(source)
	debugPrint("Getting job label for source: "..tostring(source))
	local Player = getPlayer(source)
	return Player.getJob().label
end

function getPlayerGradeLabel(source)
	debugPrint("Getting grade label for source: "..tostring(source))
	local Player = getPlayer(source)
	return Player.getJob().grade_label
end

function setPlayerJob(Player, grade, job)
	return Player.setJob(job, grade)
end

RegisterNetEvent(Config.EventPrefix..':setJob')
AddEventHandler(Config.EventPrefix..':setJob', function(status, job)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if status == true then
            xPlayer.setJob(job, xPlayer.job.grade)
			savePlayer(xPlayer)
        else
            xPlayer.setJob(Config.OffDutyPrefix..job, xPlayer.job.grade)
			savePlayer(xPlayer)
        end
    end
end)

function customGetSocietyMoney(job, source, societyType)
	-- Implement your custom logic for another society system here
	return 0, true
end

function setSocietyMoney(job, amount, type)
	if Config.SocietySystem == "addon-account" then
		if type == 'deposit' then
			TriggerEvent('esx_addonaccount:getSharedAccount', "society_"..job, function(account)
				account.addMoney(amount)
			end)
		else
			TriggerEvent('esx_addonaccount:getSharedAccount', "society_"..job, function(account)
				account.removeMoney(amount)
			end)
		end
	else
		if type == 'deposit' then
			exports[Config.SocietySystem]:AddMoney(job, amount) -- If you set Config.SocietySystem to custom, make sure to change the export to the correct one
		else
			exports[Config.SocietySystem]:RemoveMoney(job, amount) -- If you set Config.SocietySystem to custom, make sure to change the export to the correct one
		end
	end
end

-- Webhooks
function discordWebhook(data)
	local information = {}

    if data.type == 'deposit' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Deposited:** '..data.price..' ' .. Config.Currency .. '\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'withdraw' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Withdrawn:** '..data.price..' ' .. Config.Currency .. '\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'hire' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee name:** '..data.employee_name..'\n**Employee identifier:** '..data.employee_id..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'fire' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee name:** '..data.employee_name..'\n**Employee identifier:** '..data.employee_id..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'changeRank' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee Name:** '..data.employee_name..'\n**Employee Identifier:** '..data.employee_id..'\n**Rank:** '..data.rank..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'givenBonus' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Business:** '..data.item..'\n**Employee name:** '..data.employee_name..'\n**Employee identifier:** '..data.employee_id..'\n**Amount:** '..data.amount..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'onduty' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Player Name:** '..data.player..'\n**Business:** '..data.item.. '\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	elseif data.type == 'offduty' then
		information = {
			{
				["color"] = data.color,
				["author"] = {
					["icon_url"] = Config.IconURL,
					["name"] = Config.ServerName..' - Logs',
				},
				["title"] = data.title,
				["description"] = '**Action:** '..data.action..'\n**Player Name:** '..data.player..'\n**Business:** '..data.item.. '\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
				["footer"] = {
					["text"] = os.date(Config.DateFormat),
				}
			}
		}
	end
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, embeds = information}), {['Content-Type'] = 'application/json'})
end