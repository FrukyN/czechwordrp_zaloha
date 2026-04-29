globalConfig = {

  language = 'cz', --change with 'en' for english, 'fr' for french, 'cz' for czech, 'de' for german




      --Set up new line to add a table, xyz are the coordinate, model is the props used as table. The 3 tables for armwrestling are 

                                                    -- 'prop_arm_wrestle_01' --
                                              -- 'bkr_prop_clubhouse_arm_wrestle_01a' --
                                              -- 'bkr_prop_clubhouse_arm_wrestle_02a' --

  props = {
   -- {x = 455.090118, y = -998.465942, z = 30.678344, model = 'prop_arm_wrestle_01', blip = false}, 
    {x = 236.927474, y = -816.817566, z = 30.206542, model = 'prop_arm_wrestle_01', blip = false}, --hlavní 
   -- {x = 636.606568, y = -2896.298828, z = 6.060792, model = 'prop_arm_wrestle_01', blip = false},
   -- {x = 707.802186, y = -965.578002, z = 30.408814, model = 'prop_arm_wrestle_01', blip = false},
   -- {x = -1556.87, y = 91.2659, z = 53.863, model = 'bkr_prop_clubhouse_arm_wrestle_01a', blip = false},
   -- {x = 0, y = 0, z = 0, model = 'bkr_prop_clubhouse_arm_wrestle_02a', blip = false},
},

  showBlipOnMap = true, -- Set to true to show blip for each table

  blip = { --Blip info

    title="Paka",  
    colour=0, -- 
    id=311 

  }

}

text = { 
  ['en'] = {
    ['win'] = "You win !",
    ['lose'] = "You lost",
    ['full'] = "A wrestling match is already in progress",
    ['tuto'] = "To win, quickly press ",
    ['wait'] = "Waiting for an opponent",
  },
  ['fr'] = {
    ['win'] = "Vous avez gagné !",
    ['lose'] = "Vous avez perdu",
    ['full'] = "Un bras de fer est déjà en cours",
    ['tuto'] = "Pour gagner, appuyez rapidement sur ",
    ['wait'] = "En attente d'un adversaire",
  },
  ['cz'] = {
    ['win'] = "Vyhrál jsi !",
    ['lose'] = "Prohrál jsi",
    ['full'] = "Zápasový zápas již probíhá",
    ['tuto'] = "Chcete-li vyhrát, rychle stiskněte ",
    ['wait'] = "Čekání na protivníka",
  },
  ['de'] = {
    ['win'] = "Du hast gewinnen !",
    ['lose'] = "Du hast verloren",
    ['full'] = "Ein Wrestling Match ist bereits im Gange",
    ['tuto'] = "Um zu gewinnen, drücken Sie schnell ",
    ['wait'] = "Warten auf einen Gegner",
  },

}