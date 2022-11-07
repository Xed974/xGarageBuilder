xGarage = xGarage or {}

xGarage = {
    MarkerType = 21, -- https://docs.fivem.net/docs/game-references/markers/
    MarkerColorR = 0, -- https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerColorG = 0, -- https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerColorB = 0, -- https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerOpacite = 200, 
    MarkerSizeLargeur = 0.3,
    MarkerSizeEpaisseur = 0.3,
    MarkerSizeHauteur = 0.3,
    MarkerDistance = 4.0,
    OpenMenuDistance = 2.0,
    MarkerSaute = false, 
    MarkerTourne = false,

    RankAcces = {"superadmin", "admin"},
    ColorMenu =  "img_red", --Couleur de la banière : img_red, img_bleu, img_vert, img_jaune, img_violet, img_gris, img_grisf, img_orange
    ColorGlobal = "r",  -- "r" = rouge, "b" = bleu, "g" = vert, "y" = jaune, "p" = violet, "c" = gris, "m" = gris foncé, "u" = noir, "o" = orange
    Diviser = 20, -- Prix diviser par X pour les locations
    CommandCreator = "creatorGarage", -- Commande pour créer les garages

    Garage = {
        [2] = {
            posIn = vector3(172.78, -1006.53, -98.99), -- Position du joueur quand il entre
            posCar = {vector3(170.87, -1002.44, -98.99), vector3(174.86, -1002.94, -98.99)}, -- Position des véhicules dans le garage
            heading = 200.0 -- Heading des véhicules
        },
        [6] = {
            posIn = vector3(194.69, -1005.43, -98.99), -- Position du joueur quand il entre
            posCar = {vector3(192.74, -996.44, -98.99), vector3(198.83, -996.56, -98.99), vector3(203.97, -997.10, -98.99), vector3(203.42, -1002.32, -98.99), vector3(197.97, -1003.03, -98.99), vector3(193.41, -1003.57, -98.99)}, -- Position des véhicules dans le garage
            heading = 182.0 -- Heading des véhicules
        },
        [10] = {
            posIn = vector3(231.85, -1004.92, -98.99), -- Position du joueur quand il entre
            posCar = {vector3(223.58, -978.28, -98.99), vector3(223.37, -983.03, -98.99), vector3(223.39, -988.58, -98.99), vector3(222.73, -1000.43, -98.99), vector3(224.31, -993.11, -98.99), vector3(233.30, -982.49, -98.99), vector3(233.30, -987.28, -98.99), vector3(233.62, -992.12, -98.99), vector3(233.83, -996.94, -98.99), vector3(234.06, -1001.66, -98.99)}, -- Position des véhicules dans le garage
            heading = 176.0 -- Heading des véhicules
        }
    }
    
}

--- Xed#1188 | https://discord.gg/HvfAsbgVpM