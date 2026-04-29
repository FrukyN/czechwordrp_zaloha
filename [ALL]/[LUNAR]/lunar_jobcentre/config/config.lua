Config = {}
Config.RenderDistance = 15.0
Config.Target = 'ox_target' --['ox_target'/'qtarget']

Config.Locations = {
	{
		Ped = `a_f_y_business_01`,
		Coords = vector4(-268.3485, -957.5411, 31.2274, 208.0320),
	}
}

--Optional fontawesome icons for jobs.
Config.JobIcons = {
	['unemployed'] = 'fa-solid fa-user',
	--['taxi'] = 'fa-solid fa-taxi',
	--['trucker'] = 'fa-solid fa-truck',
	--['busjob'] = 'fa-solid fa-bus',

}

Config.Licenses = {
	{
		Item = 'id',
		Label = 'Občanský průkaz',
		Icon = 'fa-solid fa-id-card',
		LicenseNeeded = false, --['license'/false] verify license ownership through esx_license
		Price = 100
	},
	{
		Item = 'dl',
		Label = 'Řidičský průkaz',
		Icon = 'fa-solid fa-car',
		LicenseNeeded = "drive", --['license'/false] verify license ownership through esx_license
		Price = 200
	},
--	{
--		Item = 'license_weapon',
--		Label = 'Weapon license',
--		Icon = 'fa-solid fa-gun',
--		LicenseNeeded = 'weapon', --['license'/false] verify license ownership through esx_license
--		Price = 100
--	},
}