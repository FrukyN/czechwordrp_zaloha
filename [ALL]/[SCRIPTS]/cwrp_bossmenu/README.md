# Secure BossMenu (ESX Legacy)

## Requirements
- ox_lib
- oxmysql
- es_extended (ESX Legacy)
- ox_target
- ox_inventory
- ElectronAC export: `exports["ElectronAC"]:banPlayer(source, reason, details, overrideWhitelist)`
- JD_logs export: `exports.JD_logs:discord(text, source, 0, color, title)`

## Install
1. Import `sql/bossmenu.sql` into your database.
2. Configure jobs and coordinates in `config.lua`.
3. Ensure this resource after dependencies in `server.cfg`:
   - `ensure ox_lib`
   - `ensure ox_inventory`
   - `ensure es_extended`
   - `ensure bossmenu`
4. Use target zones configured in `Config.Jobs[job].target`, or command `/bossmenu`.

## Security model
- All sensitive logic is server-side and authoritative.
- Job and grade are always verified server-side.
- Invalid payloads (negative/oversized money, fake identifiers/items/grades) trigger anti-cheat handling.
- Exploit attempts are logged to Discord and can auto-ban using ElectronAC.
- Company balance is in dedicated SQL table with strict updates.

## Features delivered
- Deposit/withdraw company money with grade checks.
- Online/total employees counters.
- Employee management: hire, fire, grade change, bonus payouts.
- Activity overview for last 7 days + weekly top employee.
- Transaction history with actor/amount/date/reason.
- Employee notes.
- HR history (who promoted/fired whom).
- Attendance and worked time tracking.
- Internal announcements.
- Company stash via ox_inventory.
- Optional material ordering per job (delivery after time delay).

## Notes
- Default strings are English; you can localize in `client/main.lua` and notifications.
- Attendance is sampled every `Config.AttendanceTickMinutes`.
- Configure limits (`Config.MaxDeposit`, `Config.MaxWithdraw`, etc.) to match your economy.
