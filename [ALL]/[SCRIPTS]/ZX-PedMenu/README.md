# ZX-PedMenu

A FiveM script that allows authorized players to transform into animal peds through an ox_lib menu with ESX/QB compatibility.

## Features

- Command `/ped` to open a menu for authorized players
- Transform into different animal peds (currently Husky and Rottweiler)
- Easy configuration of allowed identifiers and ped models
- Compatible with both ESX and QB frameworks
- Integration with ox_lib for the menu system
- Compatibility with illenium-appearance

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib) - For the menu interface
- Either ESX or QB framework (script is compatible with both)
- Optional: [illenium-appearance](https://github.com/iLLeniumStudios/illenium-appearance) - For proper skin restoration

## Installation

1. Download the script
2. Place it in your server's resources folder
3. Add `ensure zx-pedmenu` to your server.cfg
4. Configure the authorized identifiers in `shared/config.lua`
5. Restart your server or start the resource

## Configuration

The script can be configured through the `shared/config.lua` file. Important configuration options include:

- `Config.AuthorizedIdentifiers`: List of identifiers that can use the ped menu
- `Config.IdentifierType`: Type of identifier to check (license, steam, discord, etc.)
- `Config.Peds`: List of available peds that can be selected from the menu
- `Config.Command`: Command to open the ped menu (default: 'ped')

## Adding New Peds

To add a new ped model to the menu, simply add a new entry to the `Config.Peds` table in the `shared/config.lua` file:

```lua
{
    label = 'Your Ped Name',
    model = 'ped_model_name',
    preview = 'preview_image_url' -- Optional
}
