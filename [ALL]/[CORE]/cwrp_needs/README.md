# cwrp_needs

ESX Legacy needs script with ox_lib, ox_inventory and ox_target.

## Features
- Hunger / thirst with server-side decay and damage.
- Stress system.
- Alcohol + drug dependency (withdrawal stress + stumble effect).
- Multi-use items (`uses`) with metadata durability updates.
- Item conversion (`giveItems`) e.g. crate -> multiple items.
- ox_textui prompt (`E` use / `H` hide) with remaining uses and freshness.
- Food/drug spoilage using metadata (`createdAt`, `spoilsAt`, `freshness`, `state`).
- Spoiled item action per config: `delete` or `replace` to another item.
- DB persistence on disconnect, periodic autosave, and resource stop.
- Anti-cheat validation with ElectronAC ban integration.

## Important
No changes are required in `ox_inventory/data/items.lua`.
Everything is handled directly by this resource via `ESX.RegisterUsableItem`.

## Anti-cheat
If exploit attempts exceed limit, script uses:
`exports["ElectronAC"]:banPlayer(source, reason, details, overrideWhitelist)`
