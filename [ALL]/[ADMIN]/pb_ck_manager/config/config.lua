Config = {}

-- Příkazy
Config.CKCommand = 'ckmenu'

-- Kdo smí použít CK
Config.AllowedGroups = { 'cowner', 'owner', 'dev', 'managment' }

-- Webhook vyhrazený pro CK logy
Config.DiscordWebhookCK = 'https://discord.com/api/webhooks/1458762937517998090/LfIisFvvCiSpI8p5-zRupC-qRdn6CJNShWieafuEWesmUzcTn3exRKcO2_C2lPOtQNyC' -- vyplň si URL

-- (Volitelné) další tabulky k vyčištění podle owner/identifier
-- nech prázdné, pokud nechceš zásahy mimo users/owned_vehicles
Config.ExtraOwnerTables = {
  { table = 'cwz_billing',                               column = 'target_identifier' },
  { table = 'lbtablet_ambulance_accounts',           column = 'id' },
  { table = 'lbtablet_ambulance_profile_conditions', column = 'profile_id' },
  { table = 'lbtablet_ambulance_profile_tags',       column = 'id' },
  { table = 'lbtablet_ambulance_profiles',           column = 'id' },
  { table = 'lbtablet_police_accounts',              column = 'id' },
  { table = 'lbtablet_police_profiles',              column = 'id' },
  { table = 'lbtablet_police_weapons',               column = 'owner' },
  { table = 'lbtablet_tablets',                      column = 'id' },
  { table = 'phone_phones',                          column = 'id' },
  { table = 'cd_dispatch',                           column = 'identifier' },
  { table = 'driving_school_progress',               column = 'identifier' },
  { table = 'user_licenses',                         column = 'owner' },
  { table = 'lunar_contracts_profiles',              column = 'identifier' },
  { table = 'ox_inventory',                          column = 'owner' }
}

-- Bezpečnostní pojistka – vyžádat slovíčko CONFIRM v posledním kroku
Config.RequireConfirmWord = true
Config.ConfirmWord = 'CK'

-- Texty
Config.Locale = {
  no_perm = 'Nemáš oprávnění.',
  invalid_id = 'Neplatné ID hráče.',
  not_found = 'Postava nenalezena.',
  done = 'CK proběhlo. Postava a vozidla odstraněny.',
  fail = 'Chyba databáze.',
  confirm_header = 'Potvrdit CK',
  confirm_content = 'Opravdu chceš provést CK?\nTato akce je nevratná.',
  confirm_word = 'Pro potvrzení napiš: %s',
}
