Config = {}

--- Common settings ---
Config.Debug = true -- If you want debug in console
Config.DefaultVolume = 0.1 -- Accepted values are 0.01 - 1
Config.Distance = 5.0 -- Dont touch this

--- Target system ---
Config.ox_target = true -- If you want to use qtarget you need also polyzone script

--- Locations ---
Config.Locations = {
    {
        onlyJob = true, -- If false then everyone can access the location
        job = 'bratva', -- if onJob true, you have to write the name of that job here like 'vanilla'
        name = 'Bratva', -- Name of zone
        coords = vec3(120.5638, -1280.9021, 29.4805), -- Coordinates where menu will appear if you are nearby
        radius = 30, -- Playing music distance (radius)
        distance = 2.5, -- Menu appear distance
        isPlaying = false -- Dont touch this!!!!
    },
    {
        onlyJob = true,
        job = 'bratva',
        name = 'Cayo',
        coords = vec3(4893.6592, -4902.5635, 3.4797),
        radius = 30,
        distance = 2.5,
        isPlaying = false
    },
    {
        onlyJob = true,
        job = 'bratva',
        name = 'Villa',
        coords = vec3(1219.3949, -873.5006, 70.8068),
        radius = 30,
        distance = 2.5,
        isPlaying = false
    },
    {
        onlyJob = false,
        job = 'nil',
        name = 'Galaxy',
        coords = vec3(376.19, 275.45, 92.39),
        radius = 30,
        distance = 2.5,
        isPlaying = false
    },
    {
        onlyJob = false,
        job = 'nil',
        name = 'Tequila',
        coords = vec3(-562.11, 281.66, 85.6764),
        radius = 30,
        distance = 2.5,
        isPlaying = false
    },
    {
        onlyJob = true,
        job = 'splitsides',
        name = 'SpliteSides',
        coords = vec3(-456.843964, 273.916474, 84.210206),
        radius = 30,
        distance = 2.5,
        isPlaying = false
    },
    {
        onlyJob = true,
        job = 'hospudka',
        name = 'Hospudka na rohu',
        coords = vec3(831.7606, -112.5444, 79.7747),
        radius = 30,
        distance = 2.5,
        isPlaying = false
    },
    {
        onlyJob = true,
        job = 'vanilla',
        name = 'Vanilla',
        coords = vec3(106.3371, -1284.0010, 28.2602),
        radius = 30,
        distance = 2.5,
        isPlaying = false
    },
    {
        onlyJob = true,
        job = 'bahama',
        name = 'bahama',
        coords = vec3(-1381.4541, -616.3028, 31.4980),
        radius = 30,
        distance = 2.5,
        isPlaying = false
    },
    {
        onlyJob = true,
        job = 'pizza',
        name = 'pizza',
        coords = vec3(-1344.31, -1061.53, 7.61),
        radius = 30,
        distance = 2.5,
        isPlaying = false
    }
    
    
}

Config.Language = {
    ['openMenu'] = '[E] - Open a DJ Menu',
    ['titleMenu'] = '💿 | DJ Pult',
    ['playSong'] = '🎶 | Play a song',
    ['playSongDesc'] = 'Enter a youtube URL',
    ['pauseMusic'] = '⏸️ | Pause Music',
    ['pauseMusicDesc'] = 'Pause a currently playing music',
    ['resumeMusic'] = '▶️ | Resume Music',
    ['resumeMusicDesc'] = 'Resume playing paused music',
    ['changeVolume'] = '🔈 | Change Volume',
    ['changeVolumeDesc'] = 'Change volume of song',
    ['stopMusic'] = '❌ | Turn off music',
    ['stopMusicDesc'] = 'Stop the music & choose a new song',
    ['songSel'] = 'Song Selection',
    ['url'] = 'Youtube URL',
    ['musicVolume'] = 'Music Volume',
    ['musicVolumeNm'] = 'Min: 0.01 - Max: 1', -- Pls dont change numbers (0.01 - 1)

    --- Playlist ---
    ['playlistMenu'] = '🎶 | DJ Pult Playlist',
    ['playlistDesc'] = 'Play a song from playlist',
    ['playlistMenuTitle'] = '🎶 | Play a song'
}

Config.Playlist = {
    --- First Song
    ['first'] = '💿 | Mess', -- Name of first song
    ['desc_first'] = 'Description of the song', -- Description of the song
    ['music_first_id'] = 'https://www.youtube.com/watch?v=-Kjrf-pxQc4', -- Url from YT

    --- Second Song ---
    ['second'] = '💿 | Shiver', -- Name of second song
    ['desc_second'] = 'Description of the song',
    ['music_second_id'] = 'https://www.youtube.com/watch?v=NdUNtHqY5r8',

    --- Third Song ---
    ['third'] = '💿 | Good With It', -- Name of third song
    ['desc_third'] = 'Description of the song',
    ['music_third_id'] = 'https://www.youtube.com/watch?v=RInypZYiiDM',

    --- Fourth Song ---
    ['fourth'] = '💿 | Back To You',
    ['desc_fourth'] = 'Description of the song',
    ['music_fourth_id'] = 'https://www.youtube.com/watch?v=rrzHAoA-oRI',

    --- Fifth Song ---
    ['fifth'] = '💿 | Curse',
    ['desc_fifth'] = 'Description of the song',
    ['music_fifth_id'] = 'https://www.youtube.com/watch?v=XsmuiDRKbDk'
}