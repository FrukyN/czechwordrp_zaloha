local blips = {

	{title="Vanilla Unicorn", colour=48, id=121, scale=1.0, x = 128.76, y = -1298.54, z = 30.69},
 --   {title=".PČR | Krajské ředitelství", colour=29, id=60, scale=1.0, x = 361.463746, y = -1585.015380, z = 29.279908},
    {title=".PČR | Obvodní oddělení Policie", colour=29, id=60, scale=1.0, x = 425.1, y = -979.5, z = 30.7},
    {title=".PČR | Kynologie", colour = 37, id = 273, scale = 0.8, x = -447.2953, y = 5999.2852, z = 31.4901},
    {title=".PČR | Kynologie", colour = 37, id = 273, scale = 0.8, x = 1857.1400, y = 3681.4216, z = 37.8338},
    {title=".Městská Policie", colour=4, id=60, scale=1.0, x = -353.5253, y = -249.1545, z = 36.0664},
    {title=".PČR | Dopravní Policie", colour=29, id=60, scale=1.0, x = 1536.55383, y = 819.95605, z = 77.655640},
    {title=".Celní Správa", colour=2, id=58, scale=1.0, x = 624.2435, y = 9.4025, z = 77.655640},
    {title=".Záchranný hasičský sbor", colour=1, id=60, scale=1.0, x = 1172.51, y = -1475.92, z = 34.69},
    {title=".Generální inspekce bezpečnostních sborů", colour=38, id=60, scale=1.0, x = -551.0863, y = -195.2297, z = 19.7115},
    {title=".Nemocnice", colour=52, id=61, scale=1.0, x = -1858.417602, y = -347.749450, z = 49.381714},
    --{title="Výjezdová stanice ZZS", colour=52, id=61, scale=1.0, x = -1283.4296, y = -1368.6427, z = 4.3020},
  --  {title="Split Sides Club", colour=1, id=93, scale=0.7, x = -437.5881, y = 270.3843, z = 83.4220},
  --  {title="Tequilla Club", colour=5, id=93, scale=0.7, x = -564.672546, y = 276.197814, z = 83.114990}, 
  --  {title="Zastavárna", colour=5, id=628, scale=1.0, x = 137.182418, y = -1777.503296, z = 29.734742},
    --{title="Klenotnictví", colour=3, id=617, scale=1.0, x = -631.6351, y = -237.5736, z = 38.0585},
    {title="Úřad", colour = 5, id = 407, scale = 0.8, x = -266.5450, y = -961.3186, z = 31.2175},
    {title="Česká televize", colour = 0, id = 135, scale = 0.8, x = -479.8010, y = 32.8253, z = 61.1541},
    {title="Hospůdka na rohu", colour = 3, id = 93, scale = 0.8, x = 840.7708, y = -112.8836, z = 87.1250},
    {title="Bar u Čermáků", colour = 24, id = 93, scale = 0.8, x = 411.9175, y = -1496.5125, z = 30.1553},
    --{title="[BRIGÁDA]: Řidič autobusu", colour = 83, id = 513, scale = 0.8, x = 449.3683, y = -650.8881, z = 28.2175},
    {title="Zastavárna", colour = 7, id = 500, scale = 0.8, x = 138.3274, y = -1775.6519, z = 29.5430},
    {title="Bahama Klub", colour = 8, id = 93, scale = 0.8, x = -1388.3329, y = -586.8080, z = 30.2180},
    {title="STK dílna", colour = 40, id = 784, scale = 0.8, x = 964.4149, y = -1022.6139, z = 40.8476},
    {title="Pizzerie de nostra", colour = 21, id = 889, scale = 0.8, x = -1345.5453, y = -1074.0638, z = 6.9420},


    {title="Autosalon", colour = 0, id = 227, scale = 0.8, x = -43.3738, y = -1098.2939, z = 246.341430},
   -- {title="Motokáry", colour = 30, id = 531, scale = 0.8, x = -159.3738, y = -2132.0928, z = 246.341430},
    {title="Pivovar", colour = 28, id = 478, scale = 0.8, x = -44.2420, y = 6424.7705, z = 31.5013},
    {title="Osobní sklad", colour = 81, id = 475, scale = 0.7, x = 321.4385, y = -196.9862, z = 54.2264},
    {title="CHain reastaurace", colour = 81, id = 793, scale = 0.8, x = -1230.3253, y = -284.8597, z = 37.7711},

---Nemovitosti ---
    --{title="Volná nemovitost", colour = 24, id = 374, scale = 0.8, x = 114.171432, y = -1961.327514, z = 21.3267},
    ---{title="Volna nemovitost", colour = 24, id = 374, scale = 0.8, x = -3134.742920, y = 797.103272, z = 17.484986}, -prodáno onstrtrix
    ----{title="Volna nemovitost", colour = 24, id = 374, scale = 0.8, x = -420.356048, y = 3044.479004, z = 29.785400}, PRODANO kovo 
    --{title="Volná nemovitost", colour = 24, id = 374, scale = 0.8, x = -1090.879150, y = -1485.929688, z = 5.117188},
    --{title="Volná nemovitost", colour = 24, id = 374, scale = 0.8, x = -747.389038, y = 808.193420, z = 215.150146},

}
      
Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, info.scale)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("<font face='Roboto'>"..info.title.."</font>")
    --    AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)