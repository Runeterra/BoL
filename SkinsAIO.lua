require "SourceLib"

local scriptName = "SkinsAIO"

local champions = {
	["Aatrox"]			= true,
	["Ahri"]			= true,
	["Akali"]			= true,
	["Alistar"]			= true,
	["Amumu"]			= true,
	["Anivia"]			= true,
	["Annie"]			= true,
	["Ashe"]			= true,
	["Blitzcrank"]		= true,
	["Brand"]			= true,
	["Braum"]			= true,
	["Caitlyn"]			= true,
	["Cassiopeia"]		= true,
	["Chogath"]			= true,
	["Corki"]			= true,
	["Darius"]			= true,
	["Diana"]			= true,
	["Drmundo"]			= true,
	["Draven"]			= true,
	["Elise"]			= true,
	["Evelynn"]			= true,
	["Ezreal"]			= true,
	["Fiddlesticks"]	= true,
	["Fiora"]			= true,
	["Fizz"]			= true,
	["Galio"]			= true,
	["Gangplank"]		= true,
	["Garen"]			= true,
	["Gnar"]			= true,
	["Gragas"]			= true,
	["Graves"]			= true,
	["Hecarim"]			= true,
	["Heimerdinger"]	= true,
	["Irelia"]			= true,
	["Janna"]			= true,
	["JarvanIV"]		= true,
	["Jax"]				= true,
	["Jayce"]			= true,
	["Jinx"]			= true,
	["Karma"]			= true,
	["Karthus"]			= true,
	["Kassadin"]		= true,
	["Katarina"]		= true,
	["Kayle"]			= true,
	["Kennen"]			= true,
	["Khazix"]			= true,
	["Kogmaw"]			= true,
	["Leblanc"]			= true,
	["Leesin"]			= true,
	["Leona"]			= true,
	["Lissandra"]		= true,
	["Lucian"]			= true,
	["Lulu"]			= true,
	["Lux"]				= true,
	["Malphite"]		= true,
	["Malzahar"]		= true,
	["Maokai"]			= true,
	["MasterYi"]		= true,
	["MissFortune"]		= true,
	["Mordekaiser"]		= true,
	["Morgana"]			= true,
	["Nami"]			= true,
	["Nasus"]			= true,
	["Nautilus"]		= true,
	["Nidalee"]			= true,
	["Nocturne"]		= true,
	["Nunu"]			= true,
	["Olaf"]			= true,
	["Orianna"]			= true,
	["Pantheon"]		= true,
	["Poppy"]			= true,
	["Quinn"]			= true,
	["Rammus"]			= true,
	["Renekton"]		= true,
	["Rengar"]			= true,
	["Riven"]			= true,
	["Rumble"]			= true,
	["Ryze"]			= true,
	["Sejuani"]			= true,
	["Shaco"]			= true,
	["Shen"]			= true,
	["Shyvana"]			= true,
	["Singed"]			= true,
	["Sion"]			= true,
	["Sivir"]			= true,
	["Skarner"]			= true,
	["Sona"]			= true,
	["Soraka"]			= true,
	["Swain"]			= true,
	["Syndra"]			= true,
	["Talon"]			= true,
	["Taric"]			= true,
	["Teemo"]			= true,
	["Thresh"]			= true,
	["Tristana"]		= true,
	["Trundle"]			= true,
	["Tryndamere"]		= true,
	["Twistedfate"]		= true,
	["Twitch"]			= true,
	["Udyr"]			= true,
	["Urgot"]			= true,
	["Varus"]			= true,
	["Vayne"]			= true,
	["Veigar"]			= true,
	["Velkoz"]			= true,
	["Vi"]				= true,
	["Viktor"]			= true,
	["Vladimir"]		= true,
	["Volibear"]		= true,
	["Warwick"]			= true,
	["Monkeyking"]		= true,
	["Xerath"]			= true,
	["Xinzhao"]			= true,
	["Yasuo"]			= true,
	["Yorick"]			= true,
	["Zac"]				= true,
	["Zed"]				= true,
	["Ziggs"]			= true,
	["Zilean"]			= true,
	["Zyra"]			= true
}

if not champions[player.charName] then champions = nil collectgarbage() return end

for k, _ in pairs(champions) do
    local className = k:gsub("%s+", "")
    class(className)
    champions[k] = _G[className]
end

local champ = champions[player.charName]
local menu  = nil
local champLoaded = false
local skinNumber = nil

function OnLoad()
    DM   = DrawManager()

    champ = champ()

    if not champ then print("There was an error while loading " .. player.charName .. ", please report the shown error to Runeterra, thanks!") return else champLoaded = true end

    loadMenu()
end

function OnDraw()
    if not champLoaded then return end

    if menu then
        for i = 1, skinNumber do
            if menu["skin"..i] then
                menu["skin"..i] = false
                GenModelPacket(player.charName, i - 1)
            end
        end
    end

end

function loadMenu()
    menu = MenuWrapper("[" .. scriptName .. "] " .. player.charName, "unique" .. player.charName:gsub("%s+", ""))

    -- Skin changer
    if champ.GetSkins then
        for i, name in ipairs(champ:GetSkins()) do
            menu:GetHandle():addParam("skin"..i, name, SCRIPT_PARAM_ONOFF, false)
        end
        skinNumber = #champ:GetSkins()
    end

    -- Apply menu as normal script config
    menu = menu:GetHandle()

    -- Apply champ menu values
    if champ.ApplyMenu then champ:ApplyMenu() end
end

-- Credits to shalzuth for this!
function GenModelPacket(champ, skinId)
    p = CLoLPacket(0x97)
    p:EncodeF(player.networkID)
    p.pos = 1
    t1 = p:Decode1()
    t2 = p:Decode1()
    t3 = p:Decode1()
    t4 = p:Decode1()
    p:Encode1(t1)
    p:Encode1(t2)
    p:Encode1(t3)
    p:Encode1(bit32.band(t4,0xB))
    p:Encode1(1)
    p:Encode4(skinId)
    for i = 1, #champ do
        p:Encode1(string.byte(champ:sub(i,i)))
    end
    for i = #champ + 1, 64 do
        p:Encode1(0)
    end
    p:Hide()
    RecvPacket(p)
end

function Aatrox:__init()
end

function Aatrox:GetSkins()
    return {
        "Classic",
        "Justicar",
        "Mecha"
    }
end

function Ahri:__init()
end

function Ahri:GetSkins()
	return {
		"Classic",
		"Dynasty",
		"Midnight",
		"Foxfire",
		"Popstar"
}
end

function Akali:__init()
end

function Akali:GetSkins()
	return {
		"Classic",
		"Stinger",
		"Crimson",
		"All-Star",
		"Nurse",
		"Blood Moon",
		"Silverfang"
}
end

function Alistar:__init()
end

function Alistar:GetSkins()
	return {
		"Classic",
		"Black",
		"Golden",
		"Matador",
		"Longhorn",
		"Unchained",
		"Infernal",
		"Sweeper"
}
end

function Amumu:__init()
end

function Amumu:GetSkins()
	return {
		"Classic",
		"Pharaoh",
		"Vancouver",
		"Emumu",
		"Re-Gifted",
		"Almost-Prom King",
		"Little Knight",
		"Sad Robot"
}
end

function Anivia:__init()
end

function Anivia:GetSkins()
	return {
		"Classic",
		"Team Spirit",
		"Bird of Prey",
		"Noxus Hunter",
		"Hextech",
		"Blackfrost"
}
end

function Annie:__init()
end

function Annie:GetSkins()
	return {
		"Classic",
		"Goth",
		"Red Riding",
		"Annie in Wonderland",
		"Prom Queen",
		"Frostfire",
		"Reverse",
		"FrankenTibbers",
		"Panda"
}
end

function Ashe:__init()
end

function Ashe:GetSkins()
	return {
		"Classic",
		"Freljord",
		"Sherwood Forest",
		"Woad",
		"Queen",
		"Amethyst",
		"Heartseeker"
}
end

function Blitzcrank:__init()
end

function Blitzcrank:GetSkins()
	return {
		"Classic",
		"Rusty",
		"Goalkeeper",
		"Boom Boom",
		"Piltover Customs",
		"Definitely Not Blitzcrank",
		"iBlitzcrank",
		"Riot"
}
end

function Brand:__init()
end

function Brand:GetSkins()
	return {
		"Classic",
		"Apocalyptic",
		"Vandal",
		"Cryocore",
		"Zombie"
}
end

function Braum:__init()
end

function Braum:GetSkins()
	return {
		"Classic",
		"Dragonslayer"
}
end

function Caitlyn:__init()
end

function Caitlyn:GetSkins()
	return {
		"Classic",
		"Resistance",
		"Sheriff",
		"Safari",
		"Arctic Warfare",
		"Officer"
}
end

function Cassiopeia:__init()
end

function Cassiopeia:GetSkins()
	return {
		"Classic",
		"Desperada",
		"Siren",
		"Mythic",
		"Jade Fang"
}
end

function Chogath:__init()
end

function Chogath:GetSkins()
	return {
		"Classic",
		"Nightmare",
		"Gentleman",
		"Loch Ness",
		"Jurassic",
		"Battlecast"
}
end

function Corki:__init()
end

function Corki:GetSkins()
	return {
		"Classic",
		"UFO",
		"Ice Toboggan",
		"Red Baron",
		"Hot Rod",
		"Urfrider",
		"Dragonwing"
}
end

function Darius:__init()
end

function Darius:GetSkins()
	return {
		"Classic",
		"Lord",
		"Direforge",
		"Woad King"
}
end

function Diana:__init()
end

function Diana:GetSkins()
	return {
		"Classic",
		"Dark Valkyrie",
		"Lunar Goddess"
}
end

function Drmundo:__init()
end

function Drmundo:GetSkins()
	return {
		"Classic",
		"Toxic",
		"Mr. Mundoverse",
		"Corporate",
		"Mundo Mundo",
		"Executioner",
		"Rageborn",
		"TPA"
}
end

function Draven:__init()
end

function Draven:GetSkins()
	return {
		"Classic",
		"Soul Reaver",
		"Gladiator",
		"Primetime"
}
end

function Elise:__init()
end

function Elise:GetSkins()
	return {
		"Classic",
		"Death Blossom",
		"Victorious"
}
end

function Evelynn:__init()
end

function Evelynn:GetSkins()
	return {
		"Classic",
		"Shadow",
		"Masquerade",
		"Tango"
}
end

function Ezreal:__init()
end

function Ezreal:GetSkins()
	return {
		"Classic",
		"Nottingham",
		"Striker",
		"Frosted",
		"Explorer",
		"Pulsefire",
		"TPA"
}
end

function Fiddlesticks:__init()
end

function Fiddlesticks:GetSkins()
	return {
		"Classic",
		"Spectral",
		"Union Jack",
		"Bandito",
		"Pumpkinhead",
		"Fiddle Me Timbers",
		"Surprise Party",
		"Dark Candy"
}
end

function Fiora:__init()
end

function Fiora:GetSkins()
	return {
		"Classic",
		"Royal Guard",
		"Nightraven",
		"Headmistress"
}
end

function Fizz:__init()
end

function Fizz:GetSkins()
	return {
		"Classic",
		"Atlantean",
		"Tundra",
		"Fisherman",
		"Void"
}
end

function Galio:__init()
end

function Galio:GetSkins()
	return {
		"Classic",
		"Enchanted",
		"Hextech",
		"Commando",
		"Gatekeeper"
}
end

function Gangplank:__init()
end

function Gangplank:GetSkins()
	return {
		"Classic",
		"Spooky",
		"Minuteman",
		"Sailor",
		"Toy Soldier",
		"Special Forces",
		"Sultan"
}
end

function Garen:__init()
end

function Garen:GetSkins()
	return {
		"Classic",
		"Sanguine",
		"Desert Trooper",
		"Commando",
		"Dreadknight",
		"Rugged",
		"Steel Legion"
}
end

function Gragas:__init()
end

function Gragas:GetSkins()
	return {
		"Classic",
		"Scuba",
		"Hillbilly",
		"Santa",
		"Gragas, Esq",
		"Vandal",
		"Oktoberfest",
		"Superfan"
}
end

function Graves:__init()
end

function Graves:GetSkins()
	return {
		"Classic",
		"Hired Gun",
		"Jailbreak",
		"Mafia",
		"Riot",
		"Pool Party"
}
end

function Hecarim:__init()
end

function Hecarim:GetSkins()
	return {
		"Classic",
		"Blood Knight",
		"Reaper",
		"Headless",
		"Arcade"
}
end

function Heimerdinger:__init()
end

function Heimerdinger:GetSkins()
	return {
		"Classic",
		"Alien Invader",
		"Blast Zone",
		"Piltover Customs",
		"Snowmerdinger",
		"Hazmat"
}
end

function Irelia:__init()
end

function Irelia:GetSkins()
	return {
		"Classic",
		"Nightblade",
		"Aviator",
		"Infiltrator",
		"Frostblade"
}
end

function Janna:__init()
end

function Janna:GetSkins()
	return {
		"Classic",
		"Tempest",
		"Hextech",
		"Frost Queen",
		"Victorious",
		"Forecast"
}
end

function JarvanIV:__init()
end

function JarvanIV:GetSkins()
	return {
		"Classic",
		"Commando",
		"Dragonslayer",
		"Darkforge",
		"Victorious",
		"Warring Kingdoms"
}
end

function Jax:__init()
end

function Jax:GetSkins()
	return {
		"Classic",
		"The Mighty",
		"Vandal",
		"Angler",
		"PAX",
		"Jaximus",
		"Temple",
		"Nemesis",
		"SKT T1"
}
end

function Jayce:__init()
end

function Jayce:GetSkins()
	return {
		"Classic",
		"Full Metal",
		"Debonair"
}
end

function Jinx:__init()
end

function Jinx:GetSkins()
	return {
		"Classic",
		"Mafia"
}
end

function Karma:__init()
end

function Karma:GetSkins()
	return {
		"Classic",
		"Sun Goddess",
		"Sakura",
		"Traditional"
}
end

function Karthus:__init()
end

function Karthus:GetSkins()
	return {
		"Classic",
		"Phantom",
		"Statue of Karthus",
		"Grim Reaper",
		"Pentakill"
}
end

function Kassadin:__init()
end

function Kassadin:GetSkins()
	return {
		"Classic",
		"Festival",
		"Deep One",
		"Pre-Void",
		"Harbinger"
}
end

function Katarina:__init()
end

function Katarina:GetSkins()
	return {
		"Classic",
		"Mercenary",
		"Red Card",
		"Bilgewater",
		"Kitty Cat",
		"High Command",
		"Sandstorm",
		"Slay Belle"
}
end

function Kayle:__init()
end

function Kayle:GetSkins()
	return {
		"Classic",
		"Silver",
		"Viridian",
		"Unmasked",
		"Battleborn",
		"Judgment",
		"Aether Wing",
		"Riot"
}
end

function Kennen:__init()
end

function Kennen:GetSkins()
	return {
		"Classic",
		"Deadly",
		"Swamp Master",
		"Karate",
		"Kennen M.D.",
		"Arctic Ops"
}
end

function Khazix:__init()
end

function Khazix:GetSkins()
	return {
		"Classic",
		"Mecha"
}
end

function Kogmaw:__init()
end

function Kogmaw:GetSkins()
	return {
		"Classic",
		"Caterpillar",
		"Sonoran",
		"Monarch",
		"Reindeer",
		"Lion Dance",
		"Deep Sea",
		"Jurassic"
}
end

function Leblanc:__init()
end

function Leblanc:GetSkins()
	return {
		"Classic",
		"Wicked",
		"Prestigious",
		"Mistletoe"
}
end

function Leesin:__init()
end

function Leesin:GetSkins()
	return {
		"Classic",
		"Traditional",
		"Acolyte",
		"Dragon Fist",
		"Muay Thai",
		"Pool Party",
		"SKT T1"
}
end

function Leona:__init()
end

function Leona:GetSkins()
	return {
		"Classic",
		"Valkyrie",
		"Defender",
		"Iron Solari",
		"Pool Party"
}
end

function Lissandra:__init()
end

function Lissandra:GetSkins()
	return {
		"Classic",
		"Bloodstone",
		"Blade Queen"
}
end

function Lucian:__init()
end

function Lucian:GetSkins()
	return {
		"Classic",
		"Hired Gun",
		"Striker"
}
end

function Lulu:__init()
end

function Lulu:GetSkins()
	return {
		"Classic",
		"Bittersweet",
		"Wicked",
		"Dragon Trainer",
		"Winter Wonder"
}
end

function Lux:__init()
end

function Lux:GetSkins()
	return {
		"Classic",
		"Sorceress",
		"Spellthief",
		"Commando",
		"Imperial",
		"Steel Legion"
}
end

function Malphite:__init()
end

function Malphite:GetSkins()
	return {
		"Classic",
		"Shamrock",
		"Coral Reef",
		"Marble",
		"Obsidian",
		"Glacial",
		"Mecha"
}
end

function Malzahar:__init()
end

function Malzahar:GetSkins()
	return {
		"Classic",
		"Vizier",
		"Shadow Prince",
		"Djinn",
		"Overlord"
}
end

function Maokai:__init()
end

function Maokai:GetSkins()
	return {
		"Classic",
		"Charred",
		"Totemic",
		"Festive",
		"Haunted",
		"Goalkeeper"
}
end

function MasterYi:__init()
end

function MasterYi:GetSkins()
	return {
		"Classic",
		"Assassin",
		"Chosen",
		"Ionia",
		"Samurai",
		"Headhunter"
}
end

function MissFortune:__init()
end

function MissFortune:GetSkins()
	return {
		"Classic",
		"Cowgirl",
		"Waterloo",
		"Secret Agent",
		"Candy Cane",
		"Road Warrior",
		"Mafia",
		"Arcade"
}
end

function Mordekaiser:__init()
end

function Mordekaiser:GetSkins()
	return {
		"Classic",
		"Dragon Knight",
		"Infernal",
		"Pentakill",
		"Lord"
}
end

function Morgana:__init()
end

function Morgana:GetSkins()
	return {
		"Classic",
		"Exiled",
		"Sinful Succulence",
		"Blade Mistress",
		"Blackthorn",
		"Ghost Bride"
}
end

function Nami:__init()
end

function Nami:GetSkins()
	return {
		"Classic",
		"Koi",
		"River Spirit"
}
end

function Nasus:__init()
end

function Nasus:GetSkins()
	return {
		"Classic",
		"Galactic",
		"Pharaoh",
		"Dreadknight",
		"Riot K-9",
		"Infernal"
}
end

function Nautilus:__init()
end

function Nautilus:GetSkins()
	return {
		"Classic",
		"Abyssal",
		"Subterranean",
		"AstroNautilus"
}
end

function Nidalee:__init()
end

function Nidalee:GetSkins()
	return {
		"Classic",
		"Snow Bunny",
		"Leopard",
		"French Maid",
		"Pharaoh",
		"Bewitching",
		"Headhunter"
}
end

function Nocturne:__init()
end

function Nocturne:GetSkins()
	return {
		"Classic",
		"Frozen Terror",
		"Void",
		"Ravager",
		"Haunting",
		"Eternum"
}
end

function Nunu:__init()
end

function Nunu:GetSkins()
	return {
		"Classic",
		"Sasquatch",
		"Workshop",
		"Grungy",
		"Nunu Bot",
		"Demolisher",
		"TPA"
}
end

function Olaf:__init()
end

function Olaf:GetSkins()
	return {
		"Classic",
		"Forsaken",
		"Glacial",
		"Brolaf",
		"Pentakill"
}
end

function Orianna:__init()
end

function Orianna:GetSkins()
	return {
		"Classic",
		"Gothic",
		"Sewn Chaos",
		"Bladecraft",
		"TPA"
}
end

function Pantheon:__init()
end

function Pantheon:GetSkins()
	return {
		"Classic",
		"Myrmidon",
		"Ruthless",
		"Perseus",
		"Full Metal",
		"Glaive Warrior",
		"Dragonslayer"
}
end

function Poppy:__init()
end

function Poppy:GetSkins()
	return {
		"Classic",
		"Noxus",
		"Lollipoppy",
		"Blacksmith",
		"Ragdoll",
		"Battle Regalia",
		"Scarlet Hammer"
}
end

function Quinn:__init()
end

function Quinn:GetSkins()
	return {
		"Classic",
		"Phoenix",
		"Woad Scout"
}
end

function Rammus:__init()
end

function Rammus:GetSkins()
	return {
		"Classic",
		"King",
		"Chrome",
		"Molten",
		"Freljord",
		"Ninja",
		"Full Metal"
}
end

function Renekton:__init()
end

function Renekton:GetSkins()
	return {
		"Classic",
		"Galactic",
		"Outback",
		"Bloodfury",
		"Rune Wars",
		"Pool Party",
		"Scorched Earth"
}
end

function Rengar:__init()
end

function Rengar:GetSkins()
	return {
		"Classic",
		"Headhunter",
		"Night Hunter"
}
end

function Riven:__init()
end

function Riven:GetSkins()
	return {
		"Classic",
		"Redeemed",
		"Crimson Elite",
		"Battle Bunny",
		"Championship",
		"Dragonblade"
}
end

function Rumble:__init()
end

function Rumble:GetSkins()
	return {
		"Classic",
		"Rumble in the Jungle",
		"Bilgerat",
		"Supergalactic"
}
end

function Ryze:__init()
end

function Ryze:GetSkins()
	return {
		"Classic",
		"Human",
		"Tribal",
		"Uncle",
		"Triumphant",
		"Professor",
		"Zombie",
		"Dark Crystal",
		"Pirate"
}
end

function Sejuani:__init()
end

function Sejuani:GetSkins()
	return {
		"Classic",
		"Sabretusk",
		"Darkrider",
		"Traditional",
		"Bear Cavalry"
}
end

function Shaco:__init()
end

function Shaco:GetSkins()
	return {
		"Classic",
		"Mad Hatter",
		"Royal",
		"Nutcracko",
		"Workshop",
		"Asylum",
		"Masked"
}
end

function Shen:__init()
end

function Shen:GetSkins()
	return {
		"Classic",
		"Frozen",
		"Yellow Jacket",
		"Surgeon",
		"Blood Moon",
		"Warlord",
		"TPA"
}
end

function Shyvana:__init()
end

function Shyvana:GetSkins()
	return {
		"Classic",
		"Ironscale",
		"Boneclaw",
		"Darkflame",
		"Ice Drake"
}
end

function Singed:__init()
end

function Singed:GetSkins()
	return {
		"Classic",
		"Riot Squad",
		"Hextech",
		"Surfer",
		"Mad Scientist",
		"Augmented",
		"Snow Day"
}
end

function Sion:__init()
end

function Sion:GetSkins()
	return {
		"Classic",
		"Hextech",
		"Barbarian",
		"Lumberjack",
		"Warmonger"
}
end

function Sivir:__init()
end

function Sivir:GetSkins()
	return {
		"Classic",
		"Warrior Princess",
		"Spectacular",
		"Huntress",
		"Bandit",
		"PAX",
		"Snowstorm"
}
end

function Skarner:__init()
end

function Skarner:GetSkins()
	return {
		"Classic",
		"Sandscourge",
		"Earthrune"
}
end

function Sona:__init()
end

function Sona:GetSkins()
	return {
		"Classic",
		"Muse",
		"Pentakill",
		"Silent Night",
		"Guqin",
		"Arcade"
}
end

function Soraka:__init()
end

function Soraka:GetSkins()
	return {
		"Classic",
		"Dryad",
		"Divine",
		"Celestine"
}
end

function Swain:__init()
end

function Swain:GetSkins()
	return {
		"Classic",
		"Northern Front",
		"Bilgewater",
		"Tyrant"
}
end

function Syndra:__init()
end

function Syndra:GetSkins()
	return {
		"Classic",
		"Justicar",
		"Atlantean"
}
end

function Talon:__init()
end

function Talon:GetSkins()
	return {
		"Classic",
		"Renegade",
		"Crimson Elite",
		"Dragonblade"
}
end

function Taric:__init()
end

function Taric:GetSkins()
	return {
		"Classic",
		"Emerald",
		"Armor of the Fifth Age",
		"Bloodstone"
}
end

function Teemo:__init()
end

function Teemo:GetSkins()
	return {
		"Classic",
		"Happy Elf",
		"Recon",
		"Badger",
		"Astronaut",
		"Cottontail",
		"Super",
		"Panda"
}
end

function Thresh:__init()
end

function Thresh:GetSkins()
	return {
		"Classic",
		"Deep Terror",
		"Championship"
}
end

function Tristana:__init()
end

function Tristana:GetSkins()
	return {
		"Classic",
		"Riot Girl",
		"Earnest Elf",
		"Firefighter",
		"Guerrilla",
		"Buccaneer",
		"Rocketeer"
}
end

function Trundle:__init()
end

function Trundle:GetSkins()
	return {
		"Classic",
		"Lil' Slugger",
		"Junkyard",
		"Traditional"
}
end

function Tryndamere:__init()
end

function Tryndamere:GetSkins()
	return {
		"Classic",
		"Highland",
		"King",
		"Viking",
		"Demonblade",
		"Sultan",
		"Warring Kingdoms"
}
end

function Twistedfate:__init()
end

function Twistedfate:GetSkins()
	return {
		"Classic",
		"PAX",
		"Jack of Hearts",
		"The Magnificent",
		"Tango",
		"High Noon",
		"Musketeer",
		"Underworld",
		"Red Card"
}
end

function Twitch:__init()
end

function Twitch:GetSkins()
	return {
		"Classic",
		"Kingpin",
		"Whistler Village",
		"Medieval",
		"Gangster",
		"Vandal"
}
end

function Udyr:__init()
end

function Udyr:GetSkins()
	return {
		"Classic",
		"Black Belt",
		"Primal",
		"Spirit Guard"
}
end

function Urgot:__init()
end

function Urgot:GetSkins()
	return {
		"Classic",
		"Giant Enemy Crabgot",
		"Butcher",
		"Battlecast"
}
end

function Varus:__init()
end

function Varus:GetSkins()
	return {
		"Classic",
		"Blight Crystal",
		"Arclight",
		"Arctic Ops"
}
end

function Vayne:__init()
end

function Vayne:GetSkins()
	return {
		"Classic",
		"Vindicator",
		"Aristocrat",
		"Dragonslayer",
		"Heartseeker",
		"SKT T1"
}
end

function Veigar:__init()
end

function Veigar:GetSkins()
	return {
		"Classic",
		"White Mage",
		"Curling",
		"Veigar Greybeard",
		"Leprechaun",
		"Baron Von Veigar",
		"Superb Villain",
		"Bad Santa",
		"Final Boss"
}
end

function Velkoz:__init()
end

function Velkoz:GetSkins()
	return {
		"Classic",
		"Battlecast"
}
end

function Vi:__init()
end

function Vi:GetSkins()
	return {
		"Classic",
		"Neon Strike",
		"Officer",
		"Debonair"
}
end

function Viktor:__init()
end

function Viktor:GetSkins()
	return {
		"Classic",
		"Full Machine",
		"Prototype",
		"Creator"
}
end

function Vladimir:__init()
end

function Vladimir:GetSkins()
	return {
		"Classic",
		"Count",
		"Marquis",
		"Nosferatu",
		"Vandal",
		"Blood Lord",
		"Soulstealer"
}
end

function Volibear:__init()
end

function Volibear:GetSkins()
	return {
		"Classic",
		"Thunder Lord",
		"Northern Storm",
		"Runeguard"
}
end

function Warwick:__init()
end

function Warwick:GetSkins()
	return {
		"Classic",
		"Grey",
		"Urf the Manatee",
		"Big Bad",
		"Tundra Hunter",
		"Feral",
		"Firefang",
		"Hyena"
}
end

function Monkeyking:__init()
end

function Monkeyking:GetSkins()
	return {
		"Classic",
		"Volcanic",
		"General",
		"Jade Dragon"
}
end

function Xerath:__init()
end

function Xerath:GetSkins()
	return {
		"Classic",
		"Runeborn",
		"Battlecast",
		"Scorched Earth"
}
end

function Xinzhao:__init()
end

function Xinzhao:GetSkins()
	return {
		"Classic",
		"Commando",
		"Imperial",
		"Viscero",
		"Winged Hussar",
		"Warring Kingdoms"
}
end

function Yasuo:__init()
end

function Yasuo:GetSkins()
	return {
		"Classic",
		"High Noon",
		"PROJECT: Yasuo"
}
end

function Yorick:__init()
end

function Yorick:GetSkins()
	return {
		"Classic",
		"Undertaker",
		"Pentakill"
}
end

function Zac:__init()
end

function Zac:GetSkins()
	return {
		"Classic",
		"Special Weapon"
}
end

function Zed:__init()
end

function Zed:GetSkins()
	return {
		"Classic",
		"Bladestorm",
		"SKT T1"
}
end

function Ziggs:__init()
end

function Ziggs:GetSkins()
	return {
		"Classic",
		"Mad Scientist",
		"Major",
		"Pool Party",
		"Snow Day"
}
end

function Zilean:__init()
end

function Zilean:GetSkins()
	return {
		"Classic",
		"Old Saint",
		"Groovy",
		"Shurima Desert",
		"Time Machine"
}
end

function Zyra:__init()
end

function Zyra:GetSkins()
	return {
		"Classic",
		"Wildfire",
		"Haunted",
		"SKT T1"
}
end