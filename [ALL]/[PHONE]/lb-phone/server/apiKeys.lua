-- Webhook for instapic posts, recommended to be a public channel
INSTAPIC_WEBHOOK = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH"
-- Webhook for birdy posts, recommended to be a public channel
BIRDY_WEBHOOK = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH"

-- Discord webhook or API key for server logs
-- We recommend https://fivemanage.com/ for logs. Use code "LBLOGS" for 20% off the Logs Pro plan
LOGS = {
    Default = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH", -- set to false to disable
    Calls = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    Messages = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    InstaPic = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    Birdy = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    YellowPages = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    Marketplace = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    Mail = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    Wallet = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    DarkChat = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    Services = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    Crypto = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    Trendy = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH",
    Uploads = "https://discord.com/api/webhooks/1421556072010743909/8miLNe0z-X1A6L6PWX1hHMMWREe-vODm6Iot6WkamOSI0sE6lIVN_1wsfp8QiO-jSSgH" -- all camera uploads will go here
}

DISCORD_TOKEN = nil -- you can set a discord bot token here to get the players discord avatar for logs

-- Set your API keys for uploading media here.
-- Please note that the API key needs to match the correct upload method defined in Config.UploadMethod.
-- The default upload method is Fivemanage
-- You can get your API keys from https://fivemanage.com/
-- Use code LBPHONE10 for 10% off on Fivemanage
-- A video tutorial for how to set up Fivemanage can be found here: https://www.youtube.com/watch?v=y3bCaHS6Moc
API_KEYS = {
    Video = "C1jkxitNk2Ti9Bc801N52sFqLEJCpf2u",
    Image = "C1jkxitNk2Ti9Bc801N52sFqLEJCpf2u",
    Audio = "5SS1ENIuUl3XmdbnAT1l7zfJEqLQ6EyI",
}

-- Here you can set your credentials for Config.DynamicWebRTC
-- This is needed if video calls or InstaPic live streams are not working
-- You can get your credentials from https://dash.cloudflare.com/?to=/:account/realtime/turn/overview
WEBRTC = {
    TokenID = nil,
    APIToken = nil,
}
