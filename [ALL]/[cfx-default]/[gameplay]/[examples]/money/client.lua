local moneyTypes = {
    cash = `MP0_WALLET_BALANCE`,
    bank = `BANK_BALANCE`,
}

RegisterNetEvent('money:displayUpdate', function(type, money)
    local stat = moneyTypes[type]
    if not stat then return end
    StatSetInt(stat, math.floor(money))
end)

-- Žádost o zobrazení při startu skriptu
TriggerServerEvent('money:requestDisplay')

local isDisplaying = false

-- Využití KeyMappingu eliminuje potřebu "while true" smyčky a drží resmon na 0.00ms
RegisterCommand('showMoneyHUD', function()
    if isDisplaying then return end
    isDisplaying = true

    CreateThread(function()
        SetMultiplayerBankCash()
        SetMultiplayerWalletCash()

        Wait(4350)

        RemoveMultiplayerBankCash()
        RemoveMultiplayerWalletCash()
        isDisplaying = false
    end)
end, false)

-- Klávesa 'Z' (odpovídá tvému původnímu control indexu 20)
RegisterKeyMapping('showMoneyHUD', 'Zobrazit stav peněz', 'keyboard', 'z')