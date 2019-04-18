COLOUR_MAPPING = {
    ["red"] = Vector(255, 150, 150),
    ["blue"] = Vector(150, 150, 255),
    ["green"] = Vector(150, 255, 150),
    ["yellow"] = Vector(255, 255, 150),
    ["cyan"] = Vector(150, 255, 255),
    ["pink"] = Vector(255, 150, 255),
    ["black"] = Vector(100, 100, 100),
    ["white"] = Vector(255, 255, 255)
}

HERO = "npc_dota_hero_wisp"
if string.match(GetMapName(), "timelapse") then
    HERO = "npc_dota_hero_rubick"
elseif string.match(GetMapName(), "polarity") then
    HERO = "npc_dota_hero_magnataur"
end