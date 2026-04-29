# cwrp_dalnice

Bezpecny script na nakup dalnicnich znamek (ESX Legacy + ox_lib + ox_target + ox_inventory).

## Funkce
- Nakup bez NPC pres `ox_target` zony.
- 3 typy znamek: denni, 10denni, 30denni.
- Pri nakupu se zobrazi seznam vozidel hrace a vybere se konkretni SPZ.
- Metadata v itemu `dalnicni_znamka`:
  - `spz`
  - `zakoupeno`
  - `vyprsi`
  - `purchase_ts`
  - `expire_ts`
- Discord logy pres `exports.JD_logs:discord(...)`.
- Ochrana proti cheatovani:
  - server validace payloadu
  - server kontrola vzdalenosti od nakupniho bodu
  - server validace, ze SPZ patri hraci
  - cooldown proti spamu
  - ban pres `exports["ElectronAC"]:banPlayer(...)` pri manipulaci

## Instalace
1. Nahraj resource do serveru a pridej do `server.cfg`:
```cfg
ensure cwrp_dalnice
```

2. Ujisti se, ze jede poradi dependencies:
- `es_extended`
- `oxmysql`
- `ox_lib`
- `ox_inventory`
- `ox_target`
- `JD_logs`
- `ElectronAC`

3. Pridej item do `ox_inventory/data/items.lua` (pokud jeste neexistuje):
```lua
['dalnicni_znamka'] = {
    label = 'Dalnicni znamka',
    weight = 10,
    stack = false,
    close = true,
    description = 'Elektronicka dalnicni znamka'
},
```

4. Pokud mas v DB jine nazvy sloupcu/tabulky pro vozidla, uprav:
- `Config.VehicleTable`
- `Config.VehicleOwnerColumn`
- `Config.VehiclePlateColumn`

## Poznamka
Server nikdy neveri klientovi na cenu, dobu platnosti, legalitu lokaci ani vlastnictvi SPZ - vse overuje server-side.
