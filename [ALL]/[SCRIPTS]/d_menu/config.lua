Config = {}

Config.Menu = {
    ['pizza'] = {
        label = "Pizzerie De Nostra",
        food = {
            { label = "Pizza Margherita", price = 2600, description = "Rajčata, mozzarella, bazalka" },
            { label = "Pizza Marinara", price = 2400, description = "Česnek, oregáno, olivový olej" },
            { label = "Pizza Quattro Formaggi", price = 3000, description = "Čtyři druhy sýra" },
            { label = "Pizza Capricciosa", price = 2800, description = "Šunka, žampiony, artyčoky, olivy" },
            { label = "Pizza Quattro Stagioni", price = 2800, description = "Šunka, žampiony, olivy, artyčoky" },
            { label = "Pizza Diavola", price = 2200, description = "Pikantní salám, chilli papričky" },
            { label = "Kousek Margherity", price = 1200, description = "Jeden dílek čerstvé Margherity" },
            { label = "Kousek Marinary", price = 1100, description = "Lehký dílek s chutí česneku" },
            { label = "Kousek Quattro Formaggi", price = 1200, description = "Sýrová bomba do ruky" },
            { label = "Kousek Capricciosy", price = 1150, description = "Dílek se šunkou a žampiony" },
            { label = "Kousek Quattro Stagioni", price = 1500, description = "Výběr z jedné části pizzy" },
            { label = "Kousek Diavoly", price = 1100, description = "Pálivý dílek s pikantním salámem" },
        },
        drinks = {
            { label = "Voda", price = 150, description = "Pramenitá voda 0.5l" },
            { label = "Becherovka", price = 200, description = "Tradiční bylinný likér" },
            { label = "Jägermeister", price = 350, description = "Ledově namražený panák" },
            { label = "Víno", price = 2700, description = "Výběrová láhev z archivu" },
            { label = "Burčák", price = 850, description = "Sezónní moravský burčák" },
            { label = "Monster", price = 400, description = "Energetický nápoj" },
        }
    },
    
    ['burgershot'] = {
        label = "Burger Shot",
        items = {
            { label = "Bleeder Burger", price = 120, description = "Šťavnaté hovězí, sýr, tajná omáčka" },
        }
    }
}

Config.Locations = {
    {
        job = 'pizza',
        coords = vec3(-1346.84, -1066.54, 7.31), -- Místo, kde se otevírá lístek
    },
}