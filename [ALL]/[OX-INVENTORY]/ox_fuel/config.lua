if not lib.checkDependency('ox_lib', '3.22.0', true) then return end
if not lib.checkDependency('ox_inventory', '2.30.0', true) then return end

return {
	-- Get notified when a new version releases
	versionCheck = false,

	-- Enable support for ox_target
	ox_target = true,

	/*
	* Show or hide gas stations blips
	* 0 - Hide all
	* 1 - Show nearest (5000ms interval check)
	* 2 - Show all
	*/
	showBlips = 2,

-- Total duration (ex. 10% missing fuel): 10 / 0.50 * 1000 = 20 seconds
	
	-- Fuel refill value (every 1000msec add 0.50%)
	refillValue = 0.50,

	-- Fuel tick time (every 1000 msec = 1 sekunda)
	refillTick = 1000,

	-- Fuel cost (Added once every tick) -> 200 ticků * 9 Kč = 1800 Kč za plnou nádrž
	priceTick = 9,

	-- Can durability loss per refillTick (navýšeno pro reálný poměr)
	durabilityTick = 2.5,

	-- Enables fuel can
	petrolCan = {
		enabled = true,
		duration = 5000,
		price = 1000,
		refillPrice = 800,
	},

	---Modifies the fuel consumption rate of all vehicles
	globalFuelConsumptionRate = 10.0,

	-- Gas pump models
	pumpModels = {
		`prop_gas_pump_old2`,
		`prop_gas_pump_1a`,
		`prop_vintage_pump`,
		`prop_gas_pump_old3`,
		`prop_gas_pump_1c`,
		`prop_gas_pump_1b`,
		`prop_gas_pump_1d`,
	}
}
