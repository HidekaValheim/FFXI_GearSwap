---------------------------------------
-- Last Revised: February 23rd, 2021 --
---------------------------------------
-- Added Gleti's Armor Set
---------------------------------------------
-- Gearswap Commands Specific to this File --
---------------------------------------------
-- Universal Ready Move Commands -
-- //gs c Ready one
-- //gs c Ready two
-- //gs c Ready three
-- //gs c Ready four
--
-- alt+F8 cycles through designated Jug Pets
-- ctrl+F8 cycles backwards through designated Jug Pets
-- alt+F11 toggles Monster Correlation between Neutral and Favorable
-- alt+= switches between Pet-Only (Axe Swaps) and Master (no Axe Swap) modes
-- ctrl+= switches between Reward Modes (Theta / Roborant)
-- alt+` can swap in the usage of Chaac Belt for Treasure Hunter on common subjob abilities.
-- ctrl+F11 cycles between Magical Defense Modes
--
-------------------------------
-- General Gearswap Commands --
-------------------------------
-- F9 cycles Accuracy modes
-- ctrl+F9 cycles Hybrid modes
-- F10 equips Physical Defense
-- alt+F10 toggles Kiting on or off
-- ctrl+F10 cycles Physical Defense modes
-- F11 equips Magical Defense
-- alt+F12 turns off Defense modes
-- ctrl+F12 cycles Idle modes
--
-- Keep in mind that any time you Change Jobs/Subjobs, your Pet/Correlation/etc reset to default options.
-- F12 will list your current options.
--
-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.

-- Initialization function for this job file.
--[[
send_command('input //send @all lua l superwarp') 
include('organizer-lib')
send_command('input //lua l porterpacker') 
send_command('wait 3;input //gs org') 
send_command('wait 6;input //po repack') 
send_command('wait 30;input //gs validate') 
organizer_items = {
    Consumables={"Echo Drops", "Holy Water", "Silent Oil", "Prisim Powder"},
    NinjaTools={"Shihei"},
    Other="Pet Food Theta",
	PetJugs={"Vis. Broth","Ferm. Broth","Bubbly Broth","Windy Greens"
			,"Meaty Broth","Venomous Broth","Glazed Broth","Slimy Webbing","Livid Broth"
			,"Lyrical Broth","Crumbly Soil","Dire Broth","Bug-Ridden Broth","Pungent Broth"
			,"Spumante Broth","Gassy Sap","Putrescent Broth","Feculent Broth","T. Pristine Sap"
			,"Heavenly Broth","Furious Broth"},
	Food={"Grape Daifuku"},
	Storage={"Storage Slip 16","Storage Slip 18","Storage Slip 21","Storage Slip 23","Storage Slip 24",
			"Storage Slip 25","Storage Slip 26","Storage Slip 27","Storage Slip 28"}
}
]]

send_command('wait 2; input /lockstyleset 78')

use_UI = true
hud_x_pos = 1680    --important to update these if you have a smaller screen
hud_y_pos = 300     --important to update these if you have a smaller screen
hud_draggable = true
hud_font_size = 10
hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
hud_font = 'Impact'
setupTextWindow()

function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

function job_setup()
    -- Display and Random Lockstyle Generator options
    DisplayPetBuffTimers = 'false'
    DisplayModeInfo = 'false'
    RandomLockstyleGenerator = 'false'

    PetName = '    '
	PetJob = '    '
	PetInfo = '    '
	ReadyMoveOne.Name	= '          ';	ReadyMoveOne.Cost	= ' '; ReadyMoveOne.Type	= '     '; ReadyMoveOne.Element	 = '       '; 	ReadyMoveOne.Effect	 = '       '
	ReadyMoveTwo.Name	= '          ';	ReadyMoveTwo.Cost	= ' '; ReadyMoveTwo.Type	= '     '; ReadyMoveTwo.Element	 = '       '; 	ReadyMoveTwo.Effect	 = '       '
	ReadyMoveThree.Name	= '          ';	ReadyMoveThree.Cost	= ' '; ReadyMoveThree.Type	= '     '; ReadyMoveThree.Element= '       '; 	ReadyMoveThree.Effect= '       '
	ReadyMoveFour.Name	= '          ';	ReadyMoveFour.Cost	= ' '; ReadyMoveFour.Type	= '     '; ReadyMoveFour.Element = '       '; 	ReadyMoveFour.Effect = '       '
	ReadyMoveFive.Name	= '          ';	ReadyMoveFive.Cost	= ' '; ReadyMoveFive.Type	= '     '; ReadyMoveFive.Element = '       '; 	ReadyMoveFive.Effect = '       '
	ReadyMoveSix.Name	= '          ';	ReadyMoveSix.Cost	= ' '; ReadyMoveSix.Type	= '     '; ReadyMoveSix.Element	 = '       '; 	ReadyMoveSix.Effect  = '       '
	ReadyMoveSeven.Name	= '          ';	ReadyMoveSeven.Cost	= ' '; ReadyMoveSeven.Type	= '     '; ReadyMoveSeven.Element= '       '; 	ReadyMoveSeven.Effect= '       '
	
	
    pet_info_update()
	init_HUD()
    
	-- Input Pet:TP Bonus values for Skirmish Axes used during Pet Buffs
	TP_Bonus_Main = 0
    TP_Bonus_Sub = 0

    -- 1200 Job Point Gift Bonus (Set equal to 0 if below 1200 Job Points)
    TP_Gift_Bonus = 0

    -- (Adjust Run Wild Duration based on # of Job Points)
    RunWildDuration = 340;RunWildIcon = 'abilities/00121.png'
    RewardRegenIcon = 'spells/00023.png'
    SpurIcon = 'abilities/00037.png'
    BubbleCurtainDuration = 180;BubbleCurtainIcon = 'spells/00048.png'
    ScissorGuardIcon = 'spells/00043.png'
    SecretionIcon = 'spells/00053.png'
    RageIcon = 'abilities/00002.png'
    RhinoGuardIcon = 'spells/00053.png'
    ZealousSnortIcon = 'spells/00057.png'

    -- Display Mode Info as on-screen Text
    TextBoxX = 1075
    TextBoxY = 47
    TextSize = 10

    -- List of Equipment Sets created for Random Lockstyle Generator
    -- (If you want to have the same Lockstyle every time, reduce the list to a single Equipset #)
    random_lockstyle_list = {1,2,3,4,5,6,7,8,9,10,11,12,13}

    state.Buff['Aftermath: Lv.3'] = buffactive['Aftermath: Lv.3'] or false
    state.Buff['Killer Instinct'] = buffactive['Killer Instinct'] or false

    if DisplayModeInfo == 'true' then
        DisplayTrue = 1
    end

    get_combat_form()
    get_melee_groups()
end

function user_setup()
    state.OffenseMode:options('Normal', 'MedAcc', 'HighAcc', 'MaxAcc')
    state.WeaponskillMode:options('Normal', 'WSMedAcc', 'WSHighAcc')
    state.HybridMode:options('Normal', 'SubtleBlow')
    state.CastingMode:options('Normal')
    state.IdleMode:options('Normal', 'Reraise', 'Refresh')
    state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'PetPDT')
    state.MagicalDefenseMode:options('MDT', 'PetMDT')

    -- Set up Jug Pet cycling and keybind Alt+F8/Ctrl+F8
    -- INPUT PREFERRED JUG PETS HERE
    state.JugMode = M{['description']='Jug Mode', 'Bubbly Broth','Windy Greens', 'Venomous Broth', 'Glazed Broth','Slimy Webbing', 'Dire Broth','Bug-Ridden Broth','Pungent Broth','Feculent Broth','Heavenly Broth'}
    send_command('bind !f8 gs c cycle JugMode')
    send_command('bind ^f8 gs c cycleback JugMode')

    -- Set up Monster Correlation Modes and keybind Alt+F11
    state.CorrelationMode = M{['description']='Correlation Mode', 'Neutral', 'Favorable'}
    send_command('bind !f11 gs c cycle CorrelationMode')

    -- Set up Axe Swapping Modes and keybind alt+=
    state.AxeMode = M{['description']='Axe Mode', 'NoSwaps', 'PetOnly'}
    send_command('bind != gs c cycle AxeMode')

    -- Set up Reward Modes and keybind ctrl+=
    state.RewardMode = M{['description']='Reward Mode', 'Theta', 'Roborant'}
    send_command('bind ^= gs c cycle RewardMode')

    -- Keybind Ctrl+F11 to cycle Magical Defense Modes
    send_command('bind ^f11 gs c cycle MagicalDefenseMode')

    -- Set up Treasure Modes and keybind Alt+`
    state.TreasureMode = M{['description']='Treasure Mode', 'Tag', 'Normal'}
    send_command('bind !` gs c cycle TreasureMode')

    -- 'Out of Range' distance; Melee WSs will auto-cancel
    target_distance = 8
	

-- Categorized list of Ready moves
physical_ready_moves = S{'Foot Kick','Whirl Claws','Sheep Charge','Lamb Chop','Head Butt','Wild Oats',
    'Leaf Dagger','Claw Cyclone','Razor Fang','Crossthrash','Nimble Snap','Cyclotail','Rhino Attack',
    'Power Attack','Mandibular Bite','Big Scissors','Grapple','Spinning Top','Double Claw','Frogkick',
    'Blockhead','Brain Crush','Tail Blow','Scythe Tail','Ripper Fang','Chomp Rush','Needleshot',
    'Recoil Dive','Sudden Lunge','Spiral Spin','Wing Slap','Beak Lunge','Suction','Back Heel',
    'Fantod','Tortoise Stomp','Sensilla Blades','Tegmina Buffet','Pentapeck','Sweeping Gouge',
    'Somersault','Tickling Tendrils','Pecking Flurry','Sickle Slash','Disembowel','Extirpating Salvo',
    'Mega Scissors','Rhinowrecker','Hoof Volley','Fluid Toss','Fluid Spread'}

magic_atk_ready_moves = S{'Dust Cloud','Cursed Sphere','Venom','Toxic Spit','Bubble Shower','Drainkiss',
    'Silence Gas','Dark Spore','Fireball','Plague Breath','Snow Cloud','Charged Whisker','Corrosive Ooze',
    'Aqua Breath','Stink Bomb','Nectarous Deluge','Nepenthic Plunge','Pestilent Plume','Foul Waters',
    'Acid Spray','Infected Leech','Gloom Spray','Venom Shower'}

magic_acc_ready_moves = S{'Sheep Song','Scream','Dream Flower','Roar','Predatory Glare','Gloeosuccus',
    'Palsy Pollen','Soporific','Geist Wall','Toxic Spit','Numbing Noise','Spoil','Hi-Freq Field',
    'Sandpit','Sandblast','Venom Spray','Filamented Hold','Queasyshroom','Numbshroom','Spore','Shakeshroom',
    'Infrasonics','Chaotic Eye','Blaster','Purulent Ooze','Intimidate','Noisome Powder','Acid Mist',
    'Choke Breath','Jettatura','Nihility Song','Molting Plumage','Swooping Frenzy','Spider Web'}

multi_hit_ready_moves = S{'Pentapeck','Tickling Tendrils','Sweeping Gouge','Chomp Rush','Wing Slap',
    'Pecking Flurry'}

tp_based_ready_moves = S{'Foot Kick','Dust Cloud','Snow Cloud','Sheep Song','Sheep Charge','Lamb Chop',
    'Head Butt','Scream','Dream Flower','Wild Oats','Leaf Dagger','Claw Cyclone','Razor Fang','Roar',
    'Gloeosuccus','Palsy Pollen','Soporific','Cursed Sphere','Somersault','Geist Wall','Numbing Noise',
    'Frogkick','Nimble Snap','Cyclotail','Spoil','Rhino Attack','Hi-Freq Field','Sandpit','Sandblast',
    'Mandibular Bite','Metallic Body','Bubble Shower','Grapple','Spinning Top','Double Claw','Spore',
    'Filamented Hold','Blockhead','Fireball','Tail Blow','Plague Breath','Brain Crush','Infrasonics',
    'Needleshot','Chaotic Eye','Blaster','Ripper Fang','Intimidate','Recoil Dive','Water Wall',
    'Sudden Lunge','Noisome Powder','Wing Slap','Beak Lunge','Suction','Drainkiss','Acid Mist',
    'TP Drainkiss','Back Heel','Jettatura','Choke Breath','Fantod','Charged Whisker','Purulent Ooze',
    'Corrosive Ooze','Tortoise Stomp','Aqua Breath','Sensilla Blades','Tegmina Buffet','Sweeping Gouge',
    'Tickling Tendrils','Pecking Flurry','Pestilent Plume','Foul Waters','Spider Web','Gloom Spray',
    'Disembowel','Extirpating Salvo','Rhinowrecker','Venom Shower','Fluid Toss','Fluid Spread','Digest'}

-- List of Pet Buffs and Ready moves exclusively modified by Pet TP Bonus gear.
pet_buff_moves = S{'Wild Carrot','Bubble Curtain','Scissor Guard','Secretion','Rage','Harden Shell',
    'TP Drainkiss','Fantod','Rhino Guard','Zealous Snort','Frenzied Rage','Digest'}

-- List of Jug Modes that will cancel if Call Beast is used (Bestial Loyalty-only jug pets, HQs generally).
call_beast_cancel = S{'Vis. Broth','Ferm. Broth','Bubbly Broth','Windy Greens','Bug-Ridden Broth','Tant. Broth',
    'Glazed Broth','Slimy Webbing','Deepwater Broth','Venomous Broth','Heavenly Broth'}

-- List of abilities to reference for applying Treasure Hunter gear.
abilities_to_check = S{'Feral Howl','Quickstep','Box Step','Stutter Step','Desperate Flourish',
    'Violent Flourish','Animated Flourish','Provoke','Dia','Dia II','Flash','Bio','Bio II',
    'Sleep','Sleep II','Drain','Aspir','Dispel','Stun','Steal','Mug'}

enmity_plus_moves = S{'Provoke','Berserk','Warcry','Aggressor','Holy Circle','Sentinel','Last Resort',
    'Souleater','Vallation','Swordplay'}


	send_command('@wait 5;input /lockstyleset 78')
    display_mode_info()
end

function file_unload()
    if binds_on_unload then
        binds_on_unload()
    end

    -- Unbinds the Reward, Correlation, JugMode, AxeMode and Treasure hotkeys.
    send_command('unbind !=')
    send_command('unbind ^=')
    send_command('unbind @=')
    send_command('unbind !f8')
    send_command('unbind ^f8')
    send_command('unbind @f8')
    send_command('unbind ^f11')

    -- Removes any Text Info Boxes
    send_command('text JugPetText delete')
    send_command('text CorrelationText delete')
    send_command('text AxeModeText delete')
    send_command('text AccuracyText delete')
end

-- BST gearsets
function init_gear_sets()
    -------------------------------------------------
    -- AUGMENTED GEAR AND GENERAL GEAR DEFINITIONS --
    -------------------------------------------------
	main_axe = "Dolichenus"
	sub_axe= "Agwu's Axe"

    sets.Enmity = {
		ammo="Sapience Orb",
		head="Halitus Helm",
		body="Emet Harness",
		hands="Macabre Gaunt. +1",
		legs="Zoar Subligar",
		feet="Nyame Sollerets",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear="Tuisto Earring",
		right_ear="Cryptic Earring",
		left_ring="Provocare Ring",
		right_ring="Begrudging Ring",
		back="Reiki Cloak",6	
	}
    sets.EnmityNE = set_combine(sets.Enmity, {})
    sets.EnmityNEDW = set_combine(sets.Enmity, {})

    ---------------------
    -- JA PRECAST SETS --
    ---------------------
    -- Most gearsets are divided into 3 categories:
    -- 1. Default - No Axe swaps involved.
    -- 2. NE (Not engaged) - Axe/Shield swap included, for use with Pet Only mode.
    -- 3. NEDW (Not engaged; Dual-wield) - Axe swaps included, for use with Pet Only mode.

    sets.precast.JA.Familiar = {legs="Ankusa Trousers +1"}
    sets.precast.JA['Call Beast'] = {
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands={ name="Ankusa Gloves +1", augments={'Enhances "Beast Affinity" effect',}},
		legs="Nyame Flanchard",
		feet="Gleti's Boots",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Moonbeam Cape",	
	}
    sets.precast.JA['Bestial Loyalty'] = sets.precast.JA['Call Beast']

    sets.precast.JA.Tame = {head="Totemic Helm +2"}

    sets.precast.JA.Spur = {back="Artio's Mantle",feet="Nukumi Ocreae +1"}
    sets.precast.JA.SpurNE = set_combine(sets.precast.JA.Spur, {})
    sets.precast.JA.SpurNEDW = set_combine(sets.precast.JA.Spur, {})

    sets.precast.JA['Feral Howl'] = {
		ammo="Pemphredo Tathlum",
		head="Malignance Chapeau",
		body={ name="An. Jackcoat +1", augments={'Enhances "Feral Howl" effect',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Sacro Mantle",	
	}
    --sets.precast.JA['Feral Howl'] = set_combine(sets.Enmity, {body="Ankusa Jackcoat +3"})

    sets.precast.JA['Killer Instinct'] = set_combine(sets.Enmity, {head="Ankusa Helm +1"})

    sets.precast.JA.Reward = {
		head="Nyame Helm",
		body={ name="An. Jackcoat +1", augments={'Enhances "Feral Howl" effect',}},
		hands="Nyame Gauntlets",
		legs="Tot. Trousers +2",
		feet={ name="Loyalist Sabatons", augments={'STR+10','Attack+15','Phys. dmg. taken -3%','Haste+3',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Phys. dmg. taken-8%',}},      
	}
    sets.precast.JA.RewardNE = set_combine(sets.precast.JA.Reward, {})
    sets.precast.JA.RewardNEDW = set_combine(sets.precast.JA.RewardNE, {})

    sets.precast.JA.Charm = {
		ammo="Staunch Tathlum",
		head="Totemic Helm +2",
		body={ name="An. Jackcoat +1", augments={'Enhances "Feral Howl" effect',}},
		hands={ name="Ankusa Gloves +1", augments={'Enhances "Beast Affinity" effect',}},
		legs={ name="Ankusa Trousers +1", augments={'Enhances "Familiar" effect',}},
		feet={ name="Ankusa Gaiters +1", augments={'Enhances "Beast Healer" effect',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Chaac Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Moonlight Ring",
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Phys. dmg. taken-8%',}},	
	}
    sets.precast.JA.CharmNE = set_combine(sets.precast.JA.Charm, {})
    sets.precast.JA.CharmNEDW = set_combine(sets.precast.JA.CharmNE, {})

    ---------------------------
    -- PET SIC & READY MOVES --
    ---------------------------

    sets.ReadyRecast = {legs="Gleti's Greaves"}
    sets.midcast.Pet.TPBonus = {hands="Nukumi Manoplas +1"}
    sets.midcast.Pet.Neutral = {}
    sets.midcast.Pet.Favorable = {head="Nukumi Cabasset +1"}

    sets.midcast.Pet.Normal = {
		ammo="Hesperiidae",
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Nukumi Manoplas +1",
		legs="Tot. Trousers +2",
		feet="Gleti's Boots",
		neck="Loricate Torque +1",
		waist="Carrier's Sash",
		left_ear="Kyrene's Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Pastoralist's Mantle",	
	}

    sets.midcast.Pet.MedAcc = set_combine(sets.midcast.Pet.Normal, {})

    sets.midcast.Pet.HighAcc = set_combine(sets.midcast.Pet.Normal, {})

    sets.midcast.Pet.MaxAcc = set_combine(sets.midcast.Pet.Normal, {})

    sets.midcast.Pet.MagicAtkReady = {}

    sets.midcast.Pet.MagicAtkReady.Normal = {
		ammo="Hesperiidae",
		head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+21','"Dbl.Atk."+3','Pet: INT+8','Pet: Accuracy+3 Pet: Rng. Acc.+3',}},
		body={ name="Valorous Mail", augments={'Pet: "Mag.Atk.Bns."+23','Pet: INT+8','Pet: Attack+3 Pet: Rng.Atk.+3',}},
		hands="Nukumi Manoplas +1",
		legs="Gleti's Breeches",
		feet={ name="Valorous Greaves", augments={'Pet: "Mag.Atk.Bns."+27','Pet: INT+14','Pet: Accuracy+11 Pet: Rng. Acc.+11','Pet: Attack+15 Pet: Rng.Atk.+15',}},
		neck="Loricate Torque +1",
		waist="Carrier's Sash",
		left_ear="Kyrene's Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Pastoralist's Mantle",	
	}

    sets.midcast.Pet.MagicAtkReady.MedAcc = set_combine(sets.midcast.Pet.MagicAtkReady.Normal, {})

    sets.midcast.Pet.MagicAtkReady.HighAcc = set_combine(sets.midcast.Pet.MagicAtkReady.Normal, {})

    sets.midcast.Pet.MagicAtkReady.MaxAcc = set_combine(sets.midcast.Pet.MagicAtkReady.Normal, {})

    sets.midcast.Pet.MagicAccReady = set_combine(sets.midcast.Pet.Normal, {})

    sets.midcast.Pet.MultiStrike = set_combine(sets.midcast.Pet.Normal, {})

    sets.midcast.Pet.Buff = set_combine(sets.midcast.Pet.TPBonus, {})

    --------------------------------------
    -- SINGLE WIELD PET-ONLY READY SETS --
    --------------------------------------

    -- Physical Ready Attacks w/o TP Modifier for Damage (ex. Sickle Slash, Whirl Claws, Swooping Frenzy, etc.)
    sets.midcast.Pet.ReadyNE = {}
    sets.midcast.Pet.ReadyNE.Normal = set_combine(sets.midcast.Pet.Normal, {})
    sets.midcast.Pet.ReadyNE.MedAcc = set_combine(sets.midcast.Pet.MedAcc, {})
    sets.midcast.Pet.ReadyNE.HighAcc = set_combine(sets.midcast.Pet.HighAcc, {})
    sets.midcast.Pet.ReadyNE.MaxAcc = set_combine(sets.midcast.Pet.MaxAcc, {})

    -- Physical TP Bonus Ready Attacks (ex. Razor Fang, Tegmina Buffet, Tail Blow, Recoil Dive, etc.)
    sets.midcast.Pet.ReadyNE.TPBonus = {}
    sets.midcast.Pet.ReadyNE.TPBonus.Normal = set_combine(sets.midcast.Pet.ReadyNE.Normal, {})
    sets.midcast.Pet.ReadyNE.TPBonus.MedAcc = set_combine(sets.midcast.Pet.ReadyNE.MedAcc, {})
    sets.midcast.Pet.ReadyNE.TPBonus.HighAcc = set_combine(sets.midcast.Pet.ReadyNE.HighAcc, {})
    sets.midcast.Pet.ReadyNE.TPBonus.MaxAcc = set_combine(sets.midcast.Pet.ReadyNE.MaxAcc, {})

    -- Multihit Ready Attacks w/o TP Modifier for Damage (Pentapeck, Chomp Rush)
    sets.midcast.Pet.MultiStrikeNE = set_combine(sets.midcast.Pet.MultiStrike, {})

    -- Multihit TP Bonus Ready Attacks (Sweeping Gouge, Tickling Tendrils, Pecking Flurry, Wing Slap)
    sets.midcast.Pet.MultiStrikeNE.TPBonus = set_combine(sets.midcast.Pet.MultiStrike, {})

    -- Magical Ready Attacks w/o TP Modifier for Damage (ex. Molting Plumage, Venom, Stink Bomb, etc.)
    sets.midcast.Pet.MagicAtkReadyNE = {}
    sets.midcast.Pet.MagicAtkReadyNE.Normal = set_combine(sets.midcast.Pet.MagicAtkReady.Normal, {})
    sets.midcast.Pet.MagicAtkReadyNE.MedAcc = set_combine(sets.midcast.Pet.MagicAtkReady.MedAcc, {})
    sets.midcast.Pet.MagicAtkReadyNE.HighAcc = set_combine(sets.midcast.Pet.MagicAtkReady.HighAcc, {})
    sets.midcast.Pet.MagicAtkReadyNE.MaxAcc = set_combine(sets.midcast.Pet.MagicAtkReady.MaxAcc, {})

    -- Magical TP Bonus Ready Attacks (ex. Fireball, Cursed Sphere, Corrosive Ooze, etc.)
    sets.midcast.Pet.MagicAtkReadyNE.TPBonus = {}
    sets.midcast.Pet.MagicAtkReadyNE.TPBonus.Normal = set_combine(sets.midcast.Pet.MagicAtkReadyNE.Normal, {})
    sets.midcast.Pet.MagicAtkReadyNE.TPBonus.MedAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MedAcc, {})
    sets.midcast.Pet.MagicAtkReadyNE.TPBonus.HighAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.HighAcc, {})
    sets.midcast.Pet.MagicAtkReadyNE.TPBonus.MaxAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MaxAcc, {})

    -- Magical Ready Enfeebles (ex. Roar, Sheep Song, Infrasonics, etc.)
    sets.midcast.Pet.MagicAccReadyNE = set_combine(sets.midcast.Pet.MagicAccReady, {})

    -- Pet Buffs/Cures (Bubble Curtain, Scissor Guard, Secretion, Rage, Rhino Guard, Zealous Snort, Wild Carrot)
    sets.midcast.Pet.BuffNE = set_combine(sets.midcast.Pet.Buff, {})

    -- Axe Swaps for when Pet TP is above a certain value.
    sets.UnleashAtkAxeShield = {}
    sets.UnleashAtkAxeShield.Normal = {}
    sets.UnleashAtkAxeShield.MedAcc = {}
    sets.UnleashAtkAxeShield.HighAcc = {}
    sets.UnleashMultiStrikeAxeShield = {}

    sets.UnleashMABAxeShield = {}
    sets.UnleashMABAxeShield.Normal = {}
    sets.UnleashMABAxeShield.MedAcc = {}
    sets.UnleashMABAxeShield.HighAcc = {}

    ------------------------------------
    -- DUAL WIELD PET-ONLY READY SETS --
    ------------------------------------

    -- DW Axe Swaps for Physical Ready Attacks w/o TP Modifier for Damage (ex. Sickle Slash, Whirl Claws, Swooping Frenzy, etc.)
    sets.midcast.Pet.ReadyDWNE = {}
    sets.midcast.Pet.ReadyDWNE.Normal = set_combine(sets.midcast.Pet.ReadyNE.Normal, {})
    sets.midcast.Pet.ReadyDWNE.MedAcc = set_combine(sets.midcast.Pet.ReadyNE.MedAcc, {})
    sets.midcast.Pet.ReadyDWNE.HighAcc = set_combine(sets.midcast.Pet.ReadyNE.HighAcc, {})
    sets.midcast.Pet.ReadyDWNE.MaxAcc = set_combine(sets.midcast.Pet.ReadyNE.MaxAcc, {})

    -- DW Axe Swaps for Physical TP Bonus Ready Attacks (ex. Razor Fang, Tegmina Buffet, Tail Blow, Recoil Dive, etc.)
    sets.midcast.Pet.ReadyDWNE.TPBonus = {}
    sets.midcast.Pet.ReadyDWNE.TPBonus.Normal = set_combine(sets.midcast.Pet.ReadyNE.Normal, {})
    sets.midcast.Pet.ReadyDWNE.TPBonus.MedAcc = set_combine(sets.midcast.Pet.ReadyNE.MedAcc, {})
    sets.midcast.Pet.ReadyDWNE.TPBonus.HighAcc = set_combine(sets.midcast.Pet.ReadyNE.HighAcc, {})
    sets.midcast.Pet.ReadyDWNE.TPBonus.MaxAcc = set_combine(sets.midcast.Pet.ReadyNE.MaxAcc, {})

    -- DW Axe Swaps for Multihit Ready Attacks w/o TP Modifier for Damage (Pentapeck, Chomp Rush)
    sets.midcast.Pet.MultiStrikeDWNE = set_combine(sets.midcast.Pet.MultiStrikeNE, {})

    -- DW Axe Swaps for Multihit TP Bonus Ready Attacks (Sweeping Gouge, Tickling Tendrils, Pecking Flurry, Wing Slap)
    sets.midcast.Pet.MultiStrikeDWNE.TPBonus = set_combine(sets.midcast.Pet.MultiStrikeNE, {})

    -- DW Axe Swaps for Magical Ready Attacks w/o TP Modifier for Damage (ex. Molting Plumage, Stink Bomb, Venom, etc.)
    sets.midcast.Pet.MagicAtkReadyDWNE = {}
    sets.midcast.Pet.MagicAtkReadyDWNE.Normal = set_combine(sets.midcast.Pet.MagicAtkReadyNE.Normal, {})
    sets.midcast.Pet.MagicAtkReadyDWNE.MedAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MedAcc, {})
    sets.midcast.Pet.MagicAtkReadyDWNE.HighAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.HighAcc, {})
    sets.midcast.Pet.MagicAtkReadyDWNE.MaxAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MaxAcc, {})

    -- DW Axe Swaps for Magical TP Bonus Ready Attacks (ex. Fireball, Cursed Sphere, Corrosive Ooze, etc.)
    sets.midcast.Pet.MagicAtkReadyDWNE.TPBonus = {}
    sets.midcast.Pet.MagicAtkReadyDWNE.TPBonus.Normal = set_combine(sets.midcast.Pet.MagicAtkReadyNE.Normal, {})
    sets.midcast.Pet.MagicAtkReadyDWNE.TPBonus.MedAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MedAcc, {})
    sets.midcast.Pet.MagicAtkReadyDWNE.TPBonus.HighAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.HighAcc, {})
    sets.midcast.Pet.MagicAtkReadyDWNE.TPBonus.MaxAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MaxAcc, {})

    -- DW Axe Swaps for Magical Ready Enfeebles (ex. Roar, Sheep Song, Infrasonics, etc.)
    sets.midcast.Pet.MagicAccReadyDWNE = set_combine(sets.midcast.Pet.MagicAccReadyNE, {})

    -- DW Axe Swaps for Pet Buffs/Cures (Bubble Curtain, Scissor Guard, Secretion, Rage, Rhino Guard, Zealous Snort, Wild Carrot)
    sets.midcast.Pet.BuffDWNE = set_combine(sets.midcast.Pet.BuffNE, {})

    -- Axe Swaps for when Pet TP is above a certain value.
    sets.UnleashAtkAxes = {}
    sets.UnleashAtkAxes.Normal = {}
    sets.UnleashAtkAxes.MedAcc = {}
    sets.UnleashAtkAxes.HighAcc = {}
    sets.UnleashMultiStrikeAxes = {}

    sets.UnleashMABAxes = {}
    sets.UnleashMABAxes.Normal = {}
    sets.UnleashMABAxes.MedAcc = {}
    sets.UnleashMABAxes.HighAcc = {}

    ---------------
    -- IDLE SETS --
    ---------------

    sets.idle = {
		ammo="Staunch Tathlum",
		head="Gleti's Mask",
		body="Sacro Breastplate",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck="Loricate Torque +1",
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Moonbeam Cape",	
	}

    sets.idle.Refresh = set_combine(sets.idle, {head="Jumalik Helm",ring1="Stikini Ring +1",ring2="Stikini Ring +1"})
    sets.idle.Reraise = set_combine(sets.idle, {})

    sets.idle.Pet = set_combine(sets.idle, {back=Pet_Regen_back})

    --sets.idle.PetRegen = set_combine(sets.idle.Pet, {neck="Empath Necklace",feet=Pet_Regen_feet})

    sets.idle.Pet.Engaged = {
		ammo="Staunch Tathlum",
		head="Tali'ah Turban +2",
		body={ name="An. Jackcoat +1", augments={'Enhances "Feral Howl" effect',}},
		hands="Gleti's Gauntlets",
		legs="Tali'ah Sera. +2",
		feet={ name="Ankusa Gaiters +1", augments={'Enhances "Beast Healer" effect',}},
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Handler's Earring",
		right_ear="Handler's Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",	
	}
    sets.idle.Pet.Engaged.PetSBMNK = set_combine(sets.idle.Pet.Engaged, {})
    sets.idle.Pet.Engaged.PetSBNonMNK = set_combine(sets.idle.Pet.Engaged, {})
    sets.idle.Pet.Engaged.PetSTP = set_combine(sets.idle.Pet.Engaged, {})

    sets.resting = {}

    ------------------
    -- DEFENSE SETS --
    ------------------

    -- Pet PDT and MDT sets:
    sets.defense.PetPDT = {}

    sets.defense.PetMDT = {}

    -- Master PDT and MDT sets:
    sets.defense.PDT = {}

    sets.defense.Reraise = set_combine(sets.defense.PDT, {})

    sets.defense.HybridPDT = {}

    sets.defense.MDT = {}

    sets.defense.MEva = {}

    sets.defense.Killer = {}

    sets.Kiting = {}

    -------------------------------------------------------
    -- Single-wield Pet Only Mode Idle/Defense Axe Swaps --
    -------------------------------------------------------

    sets.idle.NE = {}

    sets.idle.NE.PetEngaged = {}

    --sets.idle.NE.PetRegen = {main=Pet_Regen_AxeMain,sub="Sacro Bulwark",
    --    neck="Empath Necklace",
    --    feet=Pet_Regen_feet}

    sets.defense.NE = {}
    sets.defense.NE.PDT = {}
    sets.defense.NE.MDT = {}
    sets.defense.NE.MEva = {}
    sets.defense.NE.Killer = {}
    sets.defense.NE.PetPDT = {}
    sets.defense.NE.PetMDT = {}

    -----------------------------------------------------
    -- Dual-wield Pet Only Mode Idle/Defense Axe Swaps --
    -----------------------------------------------------

    sets.idle.DWNE = {}

    sets.idle.DWNE.PetEngaged = {}

    sets.defense.DWNE = {}

    sets.defense.DWNE.PDT = {}

    sets.defense.DWNE.MDT = {}

    sets.defense.DWNE.MEva = {}

    sets.defense.DWNE.Killer = {}

    sets.defense.DWNE.PetPDT = {}

    sets.defense.DWNE.PetMDT = {}

    --------------------
    -- FAST CAST SETS --
    --------------------

    sets.precast.FC = {
		ammo="Sapience Orb",
		head="Nyame Helm",
		body="Sacro Breastplate",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Orunmila's Torque",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Rahab Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",	
	}

    sets.precast.FCNE = set_combine(sets.precast.FC, {})
    sets.precast.FC["Utsusemi: Ichi"] = set_combine(sets.precast.FC, {neck="Magoraga Beads"})
    sets.precast.FC["Utsusemi: Ni"] = set_combine(sets.precast.FC, {ammo="Impatiens",neck="Magoraga Beads"})

    ------------------
    -- MIDCAST SETS --
    ------------------

    sets.midcast.FastRecast = {
		ammo="Sapience Orb",
		head="Nyame Helm",
		body="Sacro Breastplate",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Orunmila's Torque",
		waist="Flume Belt",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Rahab Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",	
	}

    sets.midcast.Cure = {}

    sets.midcast.Curaga = sets.midcast.Cure
    sets.CurePetOnly = {}

    sets.midcast.Stoneskin = {}

    sets.midcast.Cursna = set_combine(sets.midcast.FastRecast, {waist="Gishdubar Sash"})

    sets.midcast.Protect = {ring2="Sheltered Ring"}
    sets.midcast.Protectra = sets.midcast.Protect

    sets.midcast.Shell = {ring2="Sheltered Ring"}
    sets.midcast.Shellra = sets.midcast.Shell

    sets.midcast['Enfeebling Magic'] = {}

    sets.midcast['Elemental Magic'] = {}

    sets.midcast.Flash = sets.Enmity

    --------------------------------------
    -- SINGLE-WIELD MASTER ENGAGED SETS --
    --------------------------------------

    sets.engaged = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Skormoth Mask",
		body="Tali'ah Manteel +2",
		hands="Malignance Gloves",
		legs="Meg. Chausses +2",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Brutal Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Phys. dmg. taken-8%',}},	
	}

    sets.engaged.Aftermath = {}

    sets.engaged.Hybrid = {}

    sets.engaged.SubtleBlow = {}

    sets.engaged.MaxAcc = {}

    sets.engaged.Farsha = {}

    ------------------------------------
    -- DUAL-WIELD MASTER ENGAGED SETS --
    ------------------------------------

    sets.engaged.DW = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Skormoth Mask",
		body="Tali'ah Manteel +2",
		hands="Malignance Gloves",
		legs="Meg. Chausses +2",
		feet={ name="Taeon Boots", augments={'Accuracy+17 Attack+17','"Dual Wield"+5','Crit. hit damage +3%',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Brutal Earring",
		right_ear="Sherida Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Phys. dmg. taken-8%',}},	
	}

    sets.engaged.DW.Aftermath = {}
    sets.engaged.DW.MedAcc = {
		main="Dolichenus",
		sub="Agwu's Axe",
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Skormoth Mask",
		body="Tali'ah Manteel +2",
		hands="Malignance Gloves",
		legs="Meg. Chausses +2",
		feet={ name="Taeon Boots", augments={'Accuracy+17 Attack+17','"Dual Wield"+5','Crit. hit damage +3%',}},
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Suppanomimi",
		right_ear="Eabani Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Phys. dmg. taken-8%',}},	
	}
    sets.engaged.DW.HighAcc = {}
    sets.engaged.DW.MaxAcc = {}
    sets.engaged.DW.SubtleBlow = {}

    sets.ExtraSubtleBlow = {ear1="Sherida Earring"}

    sets.engaged.DW.KrakenClub = {}

    --------------------
    -- MASTER WS SETS --
    --------------------

    -- AXE WSs --
    sets.precast.WS = {ammo="Coiste Bodhar",
        head="Gleti's Mask",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Telos Earring",
        body="Gleti's Cuirass",hands="Gleti's Gauntlets",ring1="Regal Ring",ring2="Epona's Ring",
        back="Sacro Mantle",waist="Sailfi Belt +1",legs="Gleti's Greaves",feet="Gleti's Boots"}

    sets.precast.WS['Rampage'] = {ammo="Coiste Bodhar",
        head="Blistering Sallet +1",neck="Fotia Gorget",ear1="Sherida Earring",ear2="Moonshade Earring",
        body="Gleti's Cuirass",hands="Gleti's Gauntlets",ring1="Gere Ring",ring2="Begrudging Ring",
        back="Sacro Mantle",waist="Fotia Belt",legs="Gleti's Greaves",feet="Gleti's Boots"}

    sets.precast.WS['Calamity'] = {ammo="Coiste Bodhar",
        head="Ankusa Helm +1",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Lugra Earring +1",
        body="Gleti's Cuirass",hands="Meg. Gloves +2",ring1="Regal Ring",ring2="Epaminondas's Ring",
        back="Sacro Mantle",waist="Sailfi Belt +1",legs="Gleti's Greaves",feet="Gleti's Boots"}

    sets.precast.WS['Mistral Axe'] = {ammo="Coiste Bodhar",
        head="Ankusa Helm +1",neck="Fotia Gorget",ear1="Moonshade Earring",ear2="Lugra Earring +1",
        body="Gleti's Cuirass",hands="Meg. Gloves +3",ring1="Regal Ring",ring2="Epaminondas's Ring",
        back="Sacro Mantle",waist="Sailfi Belt +1",legs="Gleti's Greaves",feet="Gleti's Boots"}

    sets.precast.WS['Decimation'] = {ammo="Coiste Bodhar",
        head="Gleti's Mask",neck="Fotia Gorget",ear1="Sherida Earring",ear2="Brutal Earring",
        body="Tali'ah Manteel +2",hands="Gleti's Gauntlets",ring1="Gere Ring",ring2="Epona's Ring",
        back="Sacro Mantle",waist="Fotia Belt",legs="Meghanada Chausses +2",feet="Gleti's Boots"}
    sets.precast.WS['Decimation'].Gavialis = set_combine(sets.precast.WS['Ruinator'], {head="Gavialis Helm"})

    sets.precast.WS['Bora Axe'] = {ammo="Coiste Bodhar",
        head="Ankusa Helm +1",neck="Fotia Gorget",ear1="Sherida Earring",ear2="Telos Earring",
        body="Gleti's Cuirass",hands="Meg. Gloves +3",ring1="Ilabrat Ring",ring2="Epona's Ring",
        back="Sacro Mantle",waist="Sailfi Belt +1",legs="Gleti's Greaves",feet="Gleti's Boots"}

    sets.precast.WS['Ruinator'] = {ammo="Coiste Bodhar",
        head="Gleti's Mask",neck="Fotia Gorget",ear1="Sherida Earring",ear2="Telos Earring",
        body="Gleti's Cuirass",hands="Gleti's Gauntlets",ring1="Gere Ring",ring2="Epona's Ring",
        back="Sacro Mantle",waist="Fotia Belt",legs="Meghanada Chausses +2",feet="Gleti's Boots"}
    sets.precast.WS['Ruinator'].Gavialis = set_combine(sets.precast.WS['Ruinator'], {head="Gavialis Helm"})

    sets.precast.WS['Onslaught'] = {ammo="Coiste Bodhar",
        head="Ankusa Helm +1",neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Lugra Earring +1",
        body="Gleti's Cuirass",hands="Meg. Gloves +3",ring1="Epaminondas's Ring",ring2="Ilabrat Ring",
        back="Sacro Mantle",waist="Sailfi Belt +1",legs="Gleti's Greaves",feet="Gleti's Boots"}

    sets.precast.WS['Primal Rend'] = {    
		ammo="Pemphredo Tathlum",
		head="Nyame Helm",
		body="Sacro Breastplate",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Karieyh Ring",
		right_ring="Epaminondas's Ring",
		back="Sacro Mantle",
	}

    sets.precast.WS['Primal Rend'].HighAcc = {
		ammo="Pemphredo Tathlum",
		head="Nyame Helm",
		body="Sacro Breastplate",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Karieyh Ring",
		right_ring="Epaminondas's Ring",
		back="Sacro Mantle",	
	}

    sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS['Primal Rend'], {back="Sacro Mantle"})

    -- DAGGER WSs --
    sets.precast.WS['Evisceration'] = {ammo="Coiste Bodhar",
        head="Blistering Sallet +1",neck="Fotia Gorget",ear1="Sherida Earring",ear2="Moonshade Earring",
        body="Gleti's Cuirass",hands="Gleti's Gauntlets",ring1="Gere Ring",ring2="Begrudging Ring",
        back="Sacro Mantle",waist="Fotia Belt",legs="Heyoka Subligar +1",feet="Gleti's Boots"}

    sets.precast.WS['Aeolian Edge'] = {
		ammo="Pemphredo Tathlum",
		head="Nyame Helm",
		body="Sacro Breastplate",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Karieyh Ring",
		right_ring="Epaminondas's Ring",
		back="Sacro Mantle",	
	}

    sets.precast.WS['Exenterator'] = {ammo="Coiste Bodhar",
        head="Gleti's Mask",neck="Fotia Gorget",ear1="Sherida Earring",ear2="Telos Earring",
        body="Gleti's Cuirass",hands="Gleti's Gauntlets",ring1="Gere Ring",ring2="Epona's Ring",
        back="Sacro Mantle",waist="Fotia Belt",legs="Meghanada Chausses +2",feet="Gleti's Boots"}
    sets.precast.WS['Exenterator'].Gavialis = set_combine(sets.precast.WS['Exenterator'], {head="Gavialis Helm"})

    -- SWORD WSs --
    sets.precast.WS['Savage Blade'] = {ammo="Coiste Bodhar",
        head="Ankusa Helm +1",neck="Caro Necklace",ear1="Ishvara Earring",ear2="Lugra Earring +1",
        body="Nzingha Cuirass",hands="Meg. Gloves +3",ring1="Epaminondas's Ring",ring2="Ilabrat Ring",
        back="Sacro Mantle",waist="Sailfi Belt +1",legs="Ankusa Trousers +3",feet="Ankusa Gaiters +3"}

    -- SCYTHE WSs --
    sets.precast.WS['Spiral Hell'] = {ammo="Coiste Bodhar",
        head="Ankusa Helm +1",neck="Caro Necklace",ear1="Moonshade Earring",ear2="Lugra Earring +1",
        body="Nzingha Cuirass",hands="Meg. Gloves +3",ring1="Epaminondas's Ring",ring2="Ilabrat Ring",
        back="Sacro Mantle",waist="Sailfi Belt +1",legs="Ankusa Trousers +3",feet="Ankusa Gaiters +3"}

    sets.precast.WS['Cross Reaper'] = {ammo="Coiste Bodhar",
        head="Ankusa Helm +1",neck="Caro Necklace",ear1="Moonshade Earring",ear2="Lugra Earring +1",
        body="Nzingha Cuirass",hands="Meg. Gloves +3",ring1="Epaminondas's Ring",ring2="Ilabrat Ring",
        back="Sacro Mantle",waist="Sailfi Belt +1",legs="Ankusa Trousers +3",feet="Ankusa Gaiters +3"}

    sets.precast.WS['Entropy'] = {ammo="Coiste Bodhar",
        head="Gleti's Mask",neck="Fotia Gorget",ear1="Sherida Earring",ear2="Telos Earring",
        body="Gleti's Cuirass",hands="Gleti's Gauntlets",ring1="Gere Ring",ring2="Epona's Ring",
        back="Sacro Mantle",waist="Fotia Belt",legs="Meghanada Chausses +2",feet="Gleti's Boots"}
    sets.precast.WS['Entropy'].Gavialis = set_combine(sets.precast.WS['Entropy'], {head="Gavialis Helm"})

    sets.midcast.ExtraMAB = {ear1="Hecate's Earring"}
    sets.midcast.ExtraWSDMG = {ear1="Ishvara Earring"}

    ----------------
    -- OTHER SETS --
    ----------------

    --Precast Gear Sets for DNC subjob abilities:
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Totemic Helm +3",neck="Unmoving Collar +1",ear1="Handler's Earring +1",ear2="Enchanter Earring +1",
        body="Gleti's Cuirass",hands="Totemic Gloves +3",ring1="Asklepian Ring",ring2="Valseur's Ring",
        back=Waltz_back,waist="Chaac Belt",legs="Dashing Subligar",feet="Totemic Gaiters +3"}
    sets.precast.Step = {ammo="Aurgelmir Orb +1",
        head="Totemic Helm +3",neck="Beastmaster Collar +2",ear1="Zennaroi Earring",ear2="Telos Earring",
        body="Totemic Jackcoat +3",hands="Totemic Gloves +3",ring1="Ilabrat Ring",ring2="Regal Ring",
        back=DW_back,waist="Klouskap Sash +1",legs="Totemic Trousers +3",feet=DW_feet}
    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Violent Flourish'] = {ammo="Pemphredo Tathlum",
        head=MAcc_head,neck="Sanctity Necklace",ear1="Hermetic Earring",ear2="Dignitary's Earring",
        body=MAcc_body,hands=MAcc_hands,ring1="Rahab Ring",ring2="Sangoma Ring",
        back=MAcc_back,waist="Eschan Stone",legs=MAcc_legs,feet=MAcc_feet}

    --Precast Gear Sets for DRG subjob abilities:
    sets.precast.JA.Jump = {hands="Crusher Gauntlets",feet="Ostro Greaves"}
    sets.precast.JA['High Jump'] = sets.precast.JA.Jump

    --Misc Gear Sets
    sets.FrenzySallet = {head="Frenzy Sallet"}
    sets.precast.LuzafRing = {ring1="Luzaf's Ring"}
    sets.buff['Killer Instinct'] = {body="Nukumi Gausape +1"}
    sets.THGear = {ammo="Perfect Lucky Egg",legs=TH_legs,waist="Chaac Belt"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------

function job_pretarget(spell)
    --checkblocking(spell)
end

function job_precast(spell, action, spellMap, eventArgs)
    if spell.type == "Monster" and not spell.interrupted then
        equip_ready_gear(spell)
        if not buffactive['Unleash'] then
            equip(sets.ReadyRecast)
        end

        eventArgs.handled = true
    end

    if spell.english == 'Reward' then
        RewardAmmo = ''
        if state.RewardMode.value == 'Theta' then
            RewardAmmo = 'Pet Food Theta'
        elseif state.RewardMode.value == 'Roborant' then
            RewardAmmo = 'Pet Roborant'
        else
            RewardAmmo = 'Pet Food Theta'
        end

        if state.AxeMode.value == 'PetOnly' then
            if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                equip({ammo=RewardAmmo}, sets.precast.JA.RewardNEDW)
            else
                equip({ammo=RewardAmmo}, sets.precast.JA.RewardNE)
            end
        else
            equip({ammo=RewardAmmo}, sets.precast.JA.Reward)
        end
    end

    if enmity_plus_moves:contains(spell.english) then
        if state.AxeMode.value == 'PetOnly' then
            if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                equip(sets.EnmityNEDW)
            else
                equip(sets.EnmityNE)
            end
        else
            equip(sets.Enmity)
        end
    end

    if spell.english == 'Spur' then
        if state.AxeMode.value == 'PetOnly' then
            if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                equip(sets.precast.JA.SpurNEDW)
            else
                equip(sets.precast.JA.SpurNE)
            end
        else
            equip(sets.precast.JA.Spur)
        end
    end

    if spell.english == 'Charm' then
        if state.AxeMode.value == 'PetOnly' then
            if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                equip(sets.precast.JA.CharmNEDW)
            else
                equip(sets.precast.JA.CharmNE)
            end
        else
            equip(sets.precast.JA.Charm)
        end
    end

    if spell.english == 'Bestial Loyalty' or spell.english == 'Call Beast' then
        jug_pet_info()
        if spell.english == "Call Beast" and call_beast_cancel:contains(JugInfo) then
            add_to_chat(123, spell.name..' Canceled: [HQ Jug Pet]')
            return
        end
        equip({ammo=JugInfo})
    end

    if player.equipment.main == 'Aymur' then
        custom_aftermath_timers_precast(spell)
    end

    if spell.type == "WeaponSkill" and spell.name ~= 'Mistral Axe' and spell.name ~= 'Bora Axe' and spell.target.distance > target_distance then
        cancel_spell()
        add_to_chat(123, spell.name..' Canceled: [Out of Range]')
        handle_equipping_gear(player.status)
        return
    end

    if spell.type == 'CorsairRoll' or spell.english == "Double-Up" then
        equip(sets.precast.LuzafRing)
    end

    if spell.prefix == '/magic' or spell.prefix == '/ninjutsu' or spell.prefix == '/song' then
        if state.AxeMode.value == 'PetOnly' then
            equip(sets.precast.FCNE)
        else
            equip(sets.precast.FC)
        end
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    --If Killer Instinct is active during WS (except for Primal/Cloudsplitter where Sacro Body is superior), equip Nukumi Gausape +1.
    if spell.type:lower() == 'weaponskill' and buffactive['Killer Instinct'] then
        if spell.english ~= "Primal Rend" and spell.english ~= "Cloudsplitter" then
            equip(sets.buff['Killer Instinct'])
        end
    end

    if spell.english == "Calamity" or spell.english == "Mistral Axe" then
        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
            if player.tp > 2750 then
                equip(sets.midcast.ExtraWSDMG)
            end
        else
            if player.tp > 2520 then
                equip(sets.midcast.ExtraWSDMG)
            end
        end
    end

    if spell.english == "Primal Rend" or spell.english == "Cloudsplitter" then
        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
            if player.tp > 2750 then
                equip(sets.midcast.ExtraMAB)
            end
        else
            if player.tp > 2520 then
                equip(sets.midcast.ExtraMAB)
            end
        end
    end

-- Equip Chaac Belt for TH+1 on common Subjob Abilities or Spells.
    if abilities_to_check:contains(spell.english) and state.TreasureMode.value == 'Tag' then
        equip(sets.THGear)
    end
end

function job_midcast(spell, action, spellMap, eventArgs)
    if state.AxeMode.value == 'PetOnly' then
        if spell.english == "Cure" or spell.english == "Cure II" or spell.english == "Cure III" or spell.english == "Cure IV" then
            equip(sets.CurePetOnly)
        end
        if spell.english == "Curaga" or spell.english == "Curaga II" or spell.english == "Curaga III" then
            equip(sets.CurePetOnly)
        end
    end
end

-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == "Monster" or spell.name == "Sic" then
        equip_ready_gear(spell)
        eventArgs.handled = true
    end

    if spell.english == 'Fight' or spell.english == 'Bestial Loyalty' or spell.english == 'Call Beast' then
        if not spell.interrupted then
            pet_info_update()
        end
    end

    if spell.english == "Leave" and not spell.interrupted then
        clear_pet_buff_timers()
        PetName = 'None';PetJob = 'None';PetInfo = 'None';ReadyMoveOne = 'None';ReadyMoveTwo = 'None';ReadyMoveThree = 'None';ReadyMoveFour = 'None'
    end

    if player.equipment.main == 'Aymur' then
        custom_aftermath_timers_aftercast(spell)
    end

    if player.status ~= 'Idle' and state.AxeMode.value == 'PetOnly' and spell.type ~= "Monster" then
        pet_only_equip_handling()
    end
end

function job_pet_midcast(spell, action, spellMap, eventArgs)
    if spell.type == "Monster" or spell.name == "Sic" then
        eventArgs.handled = true
    end
end

function job_pet_aftercast(spell, action, spellMap, eventArgs)
    pet_only_equip_handling()
end

-------------------------------------------------------------------------------------------------------------------
-- Customization hook for idle and melee sets.
-------------------------------------------------------------------------------------------------------------------

function customize_idle_set(idleSet)
    if state.AxeMode.value == 'PetOnly' then
        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
            if state.DefenseMode.value == "Physical" then
                idleSet = set_combine(idleSet, sets.defense.DWNE[state.PhysicalDefenseMode.value])
            elseif state.DefenseMode.value == "Magical" then
                idleSet = set_combine(idleSet, sets.defense.DWNE[state.MagicalDefenseMode.value])
            else
                if pet.status == "Engaged" then
                    idleSet = set_combine(idleSet, sets.idle.DWNE.PetEngaged)
                else
                    idleSet = set_combine(idleSet, sets.idle.DWNE)
                end
            end
        else
            if state.DefenseMode.value == "Physical" then
                idleSet = set_combine(idleSet, sets.defense.NE[state.PhysicalDefenseMode.value])
            elseif state.DefenseMode.value == "Magical" then
                idleSet = set_combine(idleSet, sets.defense.NE[state.MagicalDefenseMode.value])
            else
                if pet.status == "Engaged" then
                    idleSet = set_combine(idleSet, sets.idle.NE.PetEngaged)
                else
                    idleSet = set_combine(idleSet, sets.idle.NE)
                end
            end
        end
    end

    idleSet = apply_kiting(idleSet)
    return idleSet
end

function customize_melee_set(meleeSet)
    if state.AxeMode.value ~= 'PetOnly' and state.DefenseMode.value == "None" then
        if player.equipment.main == 'Farsha' then
            meleeSet = set_combine(meleeSet, sets.engaged.Farsha)
        elseif player.equipment.sub == 'Kraken Club' then
            meleeSet = set_combine(meleeSet, sets.engaged.DW.KrakenClub)
        elseif state.HybridMode.value == 'SubtleBlow' then
            if player.sub_job == 'NIN' then
                meleeSet = set_combine(meleeSet, sets.engaged.DW.SubtleBlow)
            elseif player.sub_job == 'DNC' then
                meleeSet = set_combine(meleeSet, sets.engaged.DW.SubtleBlow, sets.ExtraSubtleBlow)
            else
                meleeSet = set_combine(meleeSet, sets.engaged.SubtleBlow)
            end
        end
    end

    pet_only_equip_handling()
    meleeSet = apply_kiting(meleeSet)
    return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- Hooks for Reward, Correlation, Treasure Hunter, and Pet Mode handling.
-------------------------------------------------------------------------------------------------------------------

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Correlation Mode' then
        state.CorrelationMode:set(newValue)
    elseif stateField == 'Treasure Mode' then
        state.TreasureMode:set(newValue)
    elseif stateField == 'Reward Mode' then
        state.RewardMode:set(newValue)
    elseif stateField == 'Pet Mode' then
        state.CombatWeapon:set(newValue)
    end
end

function get_custom_wsmode(spell, spellMap, default_wsmode)
    if default_wsmode == 'Normal' then
        if spell.english == "Ruinator" and (world.day_element == 'Water' or world.day_element == 'Wind' or world.day_element == 'Ice') then
            return 'Gavialis'
        end
        if spell.english == "Rampage" and world.day_element == 'Earth' then
            return 'Gavialis'
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)

end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    get_combat_form()
    get_melee_groups()
    pet_info_update()
    update_display_mode_info()
    pet_only_equip_handling()
	validateTextInformation()	
end

-- Updates gear based on pet status changes.
function job_pet_status_change(newStatus, oldStatus, eventArgs)
    if newStatus == 'Idle' or newStatus == 'Engaged' then
        if state.DefenseMode.value ~= "Physical" and state.DefenseMode.value ~= "Magical" then
            handle_equipping_gear(player.status)
        end
    end

    if pet.hpp == 0 then
        clear_pet_buff_timers()
        PetName = 'None';PetJob = 'None';PetInfo = 'None';ReadyMoveOne = 'None';ReadyMoveTwo = 'None';ReadyMoveThree = 'None';ReadyMoveFour = 'None'
    end

    customize_melee_set(meleeSet)
    pet_info_update()
	validateTextInformation()	
end 

function job_buff_change(status, gain, gain_or_loss)
    --Equip Frenzy Sallet if we're asleep and engaged.
    if (status == "sleep" and gain_or_loss) and player.status == 'Engaged' then
        if gain then
            equip(sets.FrenzySallet)
        else
            handle_equipping_gear(player.status)
        end
    end

   if (status == "Aftermath: Lv.3" and gain_or_loss) and player.status == 'Engaged' then
        if player.equipment.main == 'Aymur' and gain then
            job_update(cmdParams, eventArgs)
            handle_equipping_gear(player.status)
        else
            job_update(cmdParams, eventArgs)
            handle_equipping_gear(player.status)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Ready Move Presets and Pet TP Evaluation Functions - Credit to Bomberto and Verda
-------------------------------------------------------------------------------------------------------------------

pet_tp=0
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1]:lower() == 'ready' then
        if pet.status == "Engaged" then
            ready_move(cmdParams)
        else
            send_command('input /pet "Fight" <t>')
        end
        eventArgs.handled = true
    end
    if cmdParams[1]:lower() == 'gearhandle' then
        pet_only_equip_handling()
    end
    if cmdParams[1] == 'pet_tp' then
	    pet_tp = tonumber(cmdParams[2])
    end
    if cmdParams[1]:lower() == 'charges' then
        charges = 3
        ready = windower.ffxi.get_ability_recasts()[102]
	    if ready ~= 0 then
	        charges = math.floor(((30 - ready) / 10))
	    end
	    add_to_chat(28,'Ready Recast:'..ready..'   Charges Remaining:'..charges..'')
    end
end
 
function ready_move(cmdParams)
    local move = cmdParams[2]:lower()
    local ReadyMove = ''
    if move == 'one' then
        ReadyMove = ReadyMoveOne
    elseif move == 'two' then
        ReadyMove = ReadyMoveTwo
    elseif move == 'three' then
        ReadyMove = ReadyMoveThree
    else
        ReadyMove = ReadyMoveFour
    end
    send_command('input /pet "'.. ReadyMove ..'" <me>')
end

pet_tp = 0
--Fix missing Pet.TP field by getting the packets from the fields lib
packets = require('packets')
function update_pet_tp(id,data)
    if id == 0x068 then
        pet_tp = 0
        local update = packets.parse('incoming', data)
        pet_tp = update["Pet TP"]
        windower.send_command('lua c gearswap c pet_tp '..pet_tp)
    end
end
id = windower.raw_register_event('incoming chunk', update_pet_tp)

-------------------------------------------------------------------------------------------------------------------
-- Current Job State Display
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    msg = msg .. ', Corr.: '..state.CorrelationMode.value

    if state.JugMode.value ~= 'None' then
        add_to_chat(8,'-- Jug Pet: '.. PetName ..' -- (Pet Info: '.. PetInfo ..', '.. PetJob ..')')
    end

    add_to_chat(28,'Ready Moves: 1.'.. ReadyMoveOne ..'  2.'.. ReadyMoveTwo ..'  3.'.. ReadyMoveThree ..'  4.'.. ReadyMoveFour ..'')
    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function equip_ready_gear(spell)
    if physical_ready_moves:contains(spell.name) then
        if state.AxeMode.value == 'PetOnly' then
            if multi_hit_ready_moves:contains(spell.name) then
                if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                    if tp_based_ready_moves:contains(spell.name) then
                        equip(sets.midcast.Pet.MultiStrikeDWNE.TPBonus)
                    else
                        equip(sets.midcast.Pet.MultiStrikeDWNE)
                    end
                else
                    if tp_based_ready_moves:contains(spell.name) then
                        equip(sets.midcast.Pet.MultiStrikeNE.TPBonus)
                    else
                        equip(sets.midcast.Pet.MultiStrikeNE)
                    end
                end
            else
                if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                    if tp_based_ready_moves:contains(spell.name) then
                        equip(sets.midcast.Pet.ReadyDWNE.TPBonus[state.OffenseMode.value])
                    else
                        equip(sets.midcast.Pet.ReadyDWNE[state.OffenseMode.value])
                    end
                else
                    if tp_based_ready_moves:contains(spell.name) then
                        equip(sets.midcast.Pet.ReadyNE.TPBonus[state.OffenseMode.value])
                    else
                        equip(sets.midcast.Pet.ReadyNE[state.OffenseMode.value])
                    end
                end
            end
        else
            if multi_hit_ready_moves:contains(spell.name) then
                equip(sets.midcast.Pet.MultiStrike)
            else
                equip(sets.midcast.Pet[state.OffenseMode.value])
            end
        end

        -- Equip Headgear based on Neutral or Favorable Correlation Modes:
        if state.OffenseMode.value ~= 'MaxAcc' then
            equip(sets.midcast.Pet[state.CorrelationMode.value])
        end
    end

    if magic_atk_ready_moves:contains(spell.name) then
        if state.AxeMode.value == 'PetOnly' then
            if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                if tp_based_ready_moves:contains(spell.name) then
                    equip(sets.midcast.Pet.MagicAtkReadyDWNE.TPBonus[state.OffenseMode.value])
                else
                    equip(sets.midcast.Pet.MagicAtkReadyDWNE[state.OffenseMode.value])
                end
            else
                if tp_based_ready_moves:contains(spell.name) then
                    equip(sets.midcast.Pet.MagicAtkReadyNE.TPBonus[state.OffenseMode.value])
                else
                    equip(sets.midcast.Pet.MagicAtkReadyNE[state.OffenseMode.value])
                end
            end
        else
            equip(sets.midcast.Pet.MagicAtkReady[state.OffenseMode.value])
        end
    end

    if magic_acc_ready_moves:contains(spell.name) then
        if state.AxeMode.value == 'PetOnly' then
            if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                equip(sets.midcast.Pet.MagicAccReadyDWNE)
            else
                equip(sets.midcast.Pet.MagicAccReadyNE)
            end
        else
            equip(sets.midcast.Pet.MagicAccReady)
        end
    end

    if pet_buff_moves:contains(spell.name) then
        if state.AxeMode.value == 'PetOnly' then
            if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                equip(sets.midcast.Pet.BuffDWNE)
            else
                equip(sets.midcast.Pet.BuffNE)
            end
        else
            equip(sets.midcast.Pet.Buff)
        end
    end

    --If Pet TP, before bonuses, is less than a certain value then equip Nukumi Manoplas +1.
    --Or if Pet TP, before bonuses, is more than a certain value then equip Unleash-specific Axes.
    if (physical_ready_moves:contains(spell.name) or magic_atk_ready_moves:contains(spell.name)) and state.OffenseMode.value ~= 'MaxAcc' then
        if tp_based_ready_moves:contains(spell.name) and PetJob == 'Warrior' then
            if pet_tp < 1300 then
                equip(sets.midcast.Pet.TPBonus)
            elseif pet_tp > 2000 and state.AxeMode.value == 'PetOnly' then
                if multi_hit_ready_moves:contains(spell.name) then
                    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                        equip(sets.UnleashMultiStrikeAxes)
                    else
                        equip(sets.UnleashMultiStrikeAxeShield)
                    end
                elseif physical_ready_moves:contains(spell.name) then
                    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                        equip(sets.UnleashAtkAxes[state.OffenseMode.value])
                    else
                        equip(sets.UnleashAtkAxeShield[state.OffenseMode.value])
                    end
                else
                    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                        equip(sets.UnleashMABAxes[state.OffenseMode.value])
                    else
                        equip(sets.UnleashMABAxeShield[state.OffenseMode.value])
                    end
                end
            end
        elseif tp_based_ready_moves:contains(spell.name) and PetJob ~= 'Warrior' then
            if pet_tp < 1800 then
                equip(sets.midcast.Pet.TPBonus)
            elseif pet_tp > 2500 and state.AxeMode.value == 'PetOnly' then
                if multi_hit_ready_moves:contains(spell.name) then
                    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                        equip(sets.UnleashMultiStrikeAxes)
                    else
                        equip(sets.UnleashMultiStrikeAxeShield)
                    end
                elseif physical_ready_moves:contains(spell.name) then
                    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                        equip(sets.UnleashAtkAxes[state.OffenseMode.value])
                    else
                        equip(sets.UnleashAtkAxeShield[state.OffenseMode.value])
                    end
                else
                    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
                        equip(sets.UnleashMABAxes[state.OffenseMode.value])
                    else
                        equip(sets.UnleashMABAxeShield[state.OffenseMode.value])
                    end
                end
            end
        end
    end
end

function jug_pet_info()
    JugInfo = ''
    if state.JugMode.value == 'FunguarFamiliar' or state.JugMode.value == 'Seedbed Soil' then
        JugInfo = 'Seedbed Soil'
    elseif state.JugMode.value == 'CourierCarrie' or state.JugMode.value == 'Fish Oil Broth' then
        JugInfo = 'Fish Oil Broth'
    elseif state.JugMode.value == 'AmigoSabotender' or state.JugMode.value == 'Sun Water' then
        JugInfo = 'Sun Water'
    elseif state.JugMode.value == 'NurseryNazuna' or state.JugMode.value == 'Dancing Herbal Broth' or state.JugMode.value == 'D. Herbal Broth' then
        JugInfo = 'D. Herbal Broth'
    elseif state.JugMode.value == 'CraftyClyvonne' or state.JugMode.value == 'Cunning Brain Broth' or state.JugMode.value == 'Cng. Brain Broth' then
        JugInfo = 'Cng. Brain Broth'
    elseif state.JugMode.value == 'PrestoJulio' or state.JugMode.value == 'Chirping Grasshopper Broth' or state.JugMode.value == 'C. Grass Broth' then
        JugInfo = 'C. Grass Broth'
    elseif state.JugMode.value == 'SwiftSieghard' or state.JugMode.value == 'Mellow Bird Broth' or state.JugMode.value == 'Mlw. Bird Broth' then
        JugInfo = 'Mlw. Bird Broth'
    elseif state.JugMode.value == 'MailbusterCetas' or state.JugMode.value == 'Goblin Bug Broth' or state.JugMode.value == 'Gob. Bug Broth' then
        JugInfo = 'Gob. Bug Broth'
    elseif state.JugMode.value == 'AudaciousAnna' or state.JugMode.value == 'Bubbling Carrion Broth' then
        JugInfo = 'B. Carrion Broth'
    elseif state.JugMode.value == 'TurbidToloi' or state.JugMode.value == 'Auroral Broth' then
        JugInfo = 'Auroral Broth'
    elseif state.JugMode.value == 'SlipperySilas' or state.JugMode.value == 'Wormy Broth' then
        JugInfo = 'Wormy Broth'
    elseif state.JugMode.value == 'LuckyLulush' or state.JugMode.value == 'Lucky Carrot Broth' or state.JugMode.value == 'L. Carrot Broth' then
        JugInfo = 'L. Carrot Broth'
    elseif state.JugMode.value == 'DipperYuly' or state.JugMode.value == 'Wool Grease' then
        JugInfo = 'Wool Grease'
    elseif state.JugMode.value == 'FlowerpotMerle' or state.JugMode.value == 'Vermihumus' then
        JugInfo = 'Vermihumus'
    elseif state.JugMode.value == 'DapperMac' or state.JugMode.value == 'Briny Broth' then
        JugInfo = 'Briny Broth'
    elseif state.JugMode.value == 'DiscreetLouise' or state.JugMode.value == 'Deepbed Soil' then
        JugInfo = 'Deepbed Soil'
    elseif state.JugMode.value == 'FatsoFargann' or state.JugMode.value == 'Curdled Plasma Broth' or state.JugMode.value == 'C. Plasma Broth' then
        JugInfo = 'C. Plasma Broth'
    elseif state.JugMode.value == 'FaithfulFalcorr' or state.JugMode.value == 'Lucky Broth' then
        JugInfo = 'Lucky Broth'
    elseif state.JugMode.value == 'BugeyedBroncha' or state.JugMode.value == 'Savage Mole Broth' or state.JugMode.value == 'Svg. Mole Broth' then
        JugInfo = 'Svg. Mole Broth'
    elseif state.JugMode.value == 'BloodclawShasra' or state.JugMode.value == 'Razor Brain Broth' or state.JugMode.value == 'Rzr. Brain Broth' then
        JugInfo = 'Rzr. Brain Broth'
    elseif state.JugMode.value == 'GorefangHobs' or state.JugMode.value == 'Burning Carrion Broth' then
        JugInfo = 'B. Carrion Broth'
    elseif state.JugMode.value == 'GooeyGerard' or state.JugMode.value == 'Cloudy Wheat Broth' or state.JugMode.value == 'Cl. Wheat Broth' then
        JugInfo = 'Cl. Wheat Broth'
    elseif state.JugMode.value == 'CrudeRaphie' or state.JugMode.value == 'Shadowy Broth' then
        JugInfo = 'Shadowy Broth'
    elseif state.JugMode.value == 'DroopyDortwin' or state.JugMode.value == 'Swirling Broth' then
        JugInfo = 'Swirling Broth'
    elseif state.JugMode.value == 'PonderingPeter' or state.JugMode.value == 'Viscous Broth' or state.JugMode.value == 'Vis. Broth' then
        JugInfo = 'Vis. Broth'
    elseif state.JugMode.value == 'SunburstMalfik' or state.JugMode.value == 'Shimmering Broth' then
        JugInfo = 'Shimmering Broth'
    elseif state.JugMode.value == 'AgedAngus' or state.JugMode.value == 'Fermented Broth' or state.JugMode.value == 'Ferm. Broth' then
        JugInfo = 'Ferm. Broth'
    elseif state.JugMode.value == 'WarlikePatrick' or state.JugMode.value == 'Livid Broth' then
        JugInfo = 'Livid Broth'
    elseif state.JugMode.value == 'ScissorlegXerin' or state.JugMode.value == 'Spicy Broth' then
        JugInfo = 'Spicy Broth'
    elseif state.JugMode.value == 'BouncingBertha' or state.JugMode.value == 'Bubbly Broth' then
        JugInfo = 'Bubbly Broth'
    elseif state.JugMode.value == 'RhymingShizuna' or state.JugMode.value == 'Lyrical Broth' then
        JugInfo = 'Lyrical Broth'
    elseif state.JugMode.value == 'AttentiveIbuki' or state.JugMode.value == 'Salubrious Broth' then
        JugInfo = 'Salubrious Broth'
    elseif state.JugMode.value == 'SwoopingZhivago' or state.JugMode.value == 'Windy Greens' then
        JugInfo = 'Windy Greens'
    elseif state.JugMode.value == 'AmiableRoche' or state.JugMode.value == 'Airy Broth' then
        JugInfo = 'Airy Broth'
    elseif state.JugMode.value == 'HeraldHenry' or state.JugMode.value == 'Translucent Broth' or state.JugMode.value == 'Trans. Broth' then
        JugInfo = 'Trans. Broth'
    elseif state.JugMode.value == 'BrainyWaluis' or state.JugMode.value == 'Crumbly Soil' then
        JugInfo = 'Crumbly Soil'
    elseif state.JugMode.value == 'HeadbreakerKen' or state.JugMode.value == 'Blackwater Broth' then
        JugInfo = 'Blackwater Broth'
    elseif state.JugMode.value == 'RedolentCandi' or state.JugMode.value == 'Electrified Broth' then
        JugInfo = 'Electrified Broth'
    elseif state.JugMode.value == 'AlluringHoney' or state.JugMode.value == 'Bug-Ridden Broth' then
        JugInfo = 'Bug-Ridden Broth'
    elseif state.JugMode.value == 'CaringKiyomaro' or state.JugMode.value == 'Fizzy Broth' then
        JugInfo = 'Fizzy Broth'
    elseif state.JugMode.value == 'VivaciousVickie' or state.JugMode.value == 'Tantalizing Broth' or state.JugMode.value == 'Tant. Broth' then
        JugInfo = 'Tant. Broth'
    elseif state.JugMode.value == 'HurlerPercival' or state.JugMode.value == 'Pale Sap' then
        JugInfo = 'Pale Sap'
    elseif state.JugMode.value == 'BlackbeardRandy' or state.JugMode.value == 'Meaty Broth' then
        JugInfo = 'Meaty Broth'
    elseif state.JugMode.value == 'GenerousArthur' or state.JugMode.value == 'Dire Broth' then
        JugInfo = 'Dire Broth'
    elseif state.JugMode.value == 'ThreestarLynn' or state.JugMode.value == 'Muddy Broth' then
        JugInfo = 'Muddy Broth'
    elseif state.JugMode.value == 'BraveHeroGlenn' or state.JugMode.value == 'Wispy Broth' then
        JugInfo = 'Wispy Broth'
    elseif state.JugMode.value == 'SharpwitHermes' or state.JugMode.value == 'Saline Broth' then
        JugInfo = 'Saline Broth'
    elseif state.JugMode.value == 'ColibriFamiliar' or state.JugMode.value == 'Sugary Broth' then
        JugInfo = 'Sugary Broth'
    elseif state.JugMode.value == 'ChoralLeera' or state.JugMode.value == 'Glazed Broth' then
        JugInfo = 'Glazed Broth'
    elseif state.JugMode.value == 'SpiderFamiliar' or state.JugMode.value == 'Sticky Webbing' then
        JugInfo = 'Sticky Webbing'
    elseif state.JugMode.value == 'GussyHachirobe' or state.JugMode.value == 'Slimy Webbing' then
        JugInfo = 'Slimy Webbing'
    elseif state.JugMode.value == 'AcuexFamiliar' or state.JugMode.value == 'Poisonous Broth' then
        JugInfo = 'Poisonous Broth'
    elseif state.JugMode.value == 'FluffyBredo' or state.JugMode.value == 'Venomous Broth' then
        JugInfo = 'Venomous Broth'
    elseif state.JugMode.value == 'SuspiciousAlice' or state.JugMode.value == 'Furious Broth' then
        JugInfo = 'Furious Broth'
    elseif state.JugMode.value == 'AnklebiterJedd' or state.JugMode.value == 'Crackling Broth' then
        JugInfo = 'Crackling Broth'
    elseif state.JugMode.value == 'FleetReinhard' or state.JugMode.value == 'Rapid Broth' then
        JugInfo = 'Rapid Broth'
    elseif state.JugMode.value == 'CursedAnnabelle' or state.JugMode.value == 'Creepy Broth' then
        JugInfo = 'Creepy Broth'
    elseif state.JugMode.value == 'SurgingStorm' or state.JugMode.value == 'Insipid Broth' then
        JugInfo = 'Insipid Broth'
    elseif state.JugMode.value == 'SubmergedIyo' or state.JugMode.value == 'Deepwater Broth' then
        JugInfo = 'Deepwater Broth'
    elseif state.JugMode.value == 'MosquitoFamiliar' or state.JugMode.value == 'Wetlands Broth' then
        JugInfo = 'Wetlands Broth'
    elseif state.JugMode.value == 'Left-HandedYoko' or state.JugMode.value == 'Heavenly Broth' then
        JugInfo = 'Heavenly Broth'
    elseif state.JugMode.value == 'SweetCaroline' or state.JugMode.value == 'Aged Humus' then
        JugInfo = 'Aged Humus'
    elseif state.JugMode.value == 'WeevilFamiliar' or state.JugMode.value == 'Pristine Sap' then
        JugInfo = 'Pristine Sap'
    elseif state.JugMode.value == 'StalwartAngelin' or state.JugMode.value == 'Truly Pristine Sap' or state.JugMode.value == 'T. Pristine Sap' then
        JugInfo = 'Truly Pristine Sap'
    elseif state.JugMode.value == 'P.CrabFamiliar' or state.JugMode.value == 'Rancid Broth' then
        JugInfo = 'Rancid Broth'
    elseif state.JugMode.value == 'JovialEdwin' or state.JugMode.value == 'Pungent Broth' then
        JugInfo = 'Pungent Broth'
    elseif state.JugMode.value == 'Y.BeetleFamiliar' or state.JugMode.value == 'Zestful Sap' then
        JugInfo = 'Zestful Sap'
    elseif state.JugMode.value == 'EnergeticSefina' or state.JugMode.value == 'Gassy Sap' then
        JugInfo = 'Gassy Sap'
    elseif state.JugMode.value == 'LynxFamiliar' or state.JugMode.value == 'Frizzante Broth' then
        JugInfo = 'Frizzante Broth'
    elseif state.JugMode.value == 'VivaciousGaston' or state.JugMode.value == 'Spumante Broth' then
        JugInfo = 'Spumante Broth'
    elseif state.JugMode.value == 'Hip.Familiar' or state.JugMode.value == 'Turpid Broth' then
        JugInfo = 'Turpid Broth'
    elseif state.JugMode.value == 'DaringRoland' or state.JugMode.value == 'Feculent Broth' then
        JugInfo = 'Feculent Broth'
    elseif state.JugMode.value == 'SlimeFamiliar' or state.JugMode.value == 'Decaying Broth' then
        JugInfo = 'Decaying Broth'
    elseif state.JugMode.value == 'SultryPatrice' or state.JugMode.value == 'Putrescent Broth' then
        JugInfo = 'Putrescent Broth'
    end
end

function pet_info_update()
    if pet.isvalid then
        PetName = pet.name
        if pet.name == 'DroopyDortwin' or pet.name == 'PonderingPeter' or pet.name == 'HareFamiliar' or pet.name == 'KeenearedSteffi' then
            PetInfo = "Rabbit, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Foot Kick '; 	ReadyMoveOne.Cost= '1'; 	ReadyMoveOne.Type= 'Slash'; 	ReadyMoveOne.Element= 'Reverb.'; 	ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Dust Cloud'; 	ReadyMoveTwo.Cost= '1';		ReadyMoveTwo.Type= 'Magic'; 	ReadyMoveTwo.Element= 'Earth  '; 	ReadyMoveTwo.Effect= 'BLIND  '
			ReadyMoveThree.Name= 'Whirl Claw'; 	ReadyMoveThree.Cost= '1'; 	ReadyMoveThree.Type= 'Slash'; 	ReadyMoveThree.Element= 'Impact.'; 	ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Wld. Crt. '; 	ReadyMoveFour.Cost= '2'; 	ReadyMoveFour.Type= 'Heal.'; 	ReadyMoveFour.Element= 'None   '; 	ReadyMoveFour.Effect= 'None   '
			ReadyMoveFive.Name= '          '; 	ReadyMoveFive.Cost= ' '; 	ReadyMoveFive.Type= '     '; 	ReadyMoveFive.Element= '       '; 	ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; 	ReadyMoveSix.Cost= ' '; 	ReadyMoveSix.Type= '     '; 	ReadyMoveSix.Element= '       '; 	ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; 	ReadyMoveSeven.Cost= ' '; 	ReadyMoveSeven.Type= '     '; 	ReadyMoveSeven.Element= '       '; 	ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'LuckyLulush' then
            PetInfo = "Rabbit, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Foot Kick '; 	ReadyMoveOne.Cost= '1'; 	ReadyMoveOne.Type= 'Slash'; 	ReadyMoveOne.Element= 'Reverb.'; 	ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Dust Cloud'; 	ReadyMoveTwo.Cost= '1';		ReadyMoveTwo.Type= 'Magic'; 	ReadyMoveTwo.Element= 'Earth  '; 	ReadyMoveTwo.Effect= 'BLIND  '
			ReadyMoveThree.Name= 'Whirl Claw'; 	ReadyMoveThree.Cost= '1'; 	ReadyMoveThree.Type= 'Slash'; 	ReadyMoveThree.Element= 'Impact.'; 	ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Wld. Crt. '; 	ReadyMoveFour.Cost= '2'; 	ReadyMoveFour.Type= 'Heal.'; 	ReadyMoveFour.Element= 'None   '; 	ReadyMoveFour.Effect= 'None   '
			ReadyMoveFive.Name= '          '; 	ReadyMoveFive.Cost= ' '; 	ReadyMoveFive.Type= '     '; 	ReadyMoveFive.Element= '       '; 	ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; 	ReadyMoveSix.Cost= ' '; 	ReadyMoveSix.Type= '     '; 	ReadyMoveSix.Element= '       '; 	ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; 	ReadyMoveSeven.Cost= ' '; 	ReadyMoveSeven.Type= '     '; 	ReadyMoveSeven.Element= '       '; 	ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'SunburstMalfik' or pet.name == 'AgedAngus' or pet.name == 'HeraldHenry' or pet.name == 'CrabFamiliar' or pet.name == 'CourierCarrie' then
            PetInfo = "Crab, Aquan";PetJob = 'Paladin'
			ReadyMoveOne.Name= 'Bbl. Shwr.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Magic'; ReadyMoveOne.Element= 'Water  '; ReadyMoveOne.Effect= 'STR Dwn'
			ReadyMoveTwo.Name= 'Bbl. Curt.'; ReadyMoveTwo.Cost= '3'; ReadyMoveTwo.Type= 'Enhn.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'MDT Up '
			ReadyMoveThree.Name= 'Big Sciss.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Slash'; ReadyMoveThree.Element= 'Scision'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Scis. Grd.'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'DEF UP '
			ReadyMoveFive.Name= 'Mtl. Body '; ReadyMoveFive.Cost= '1'; ReadyMoveFive.Type= 'Enhn.'; ReadyMoveFive.Element= 'None   '; ReadyMoveFive.Effect= 'S.Skin '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'P.CrabFamiliar' or pet.name == 'JovialEdwin' then
            PetInfo = "Barnacle Crab, Aquan";PetJob = 'Paladin'
			ReadyMoveOne.Name= 'Bbl. Curt.'; ReadyMoveOne.Cost= '3'; ReadyMoveOne.Type= 'Enhn.'; ReadyMoveOne.Element= '       '; ReadyMoveOne.Effect= 'MDEF UP'
			ReadyMoveTwo.Name= 'Sciss. Grd'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enhn.'; ReadyMoveTwo.Element= '       '; ReadyMoveTwo.Effect= 'DEF UP '
			ReadyMoveThree.Name= 'Metal. Bd.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Enhn.'; ReadyMoveThree.Element= '       '; ReadyMoveThree.Effect= 'S.Skin '
			ReadyMoveFour.Name= 'Ven. Shwr.'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Magic'; ReadyMoveFour.Element= 'Water  '; ReadyMoveFour.Effect= 'PSN/DEF'
			ReadyMoveFive.Name= 'Mega Scsr.'; ReadyMoveFive.Cost= '2'; ReadyMoveFive.Type= 'Slash'; ReadyMoveFive.Element= 'GRV/SCS'; ReadyMoveFive.Effect= 'None   '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'WarlikePatrick' or pet.name == 'LizardFamiliar' or pet.name == 'ColdbloodComo' or pet.name == 'AudaciousAnna' then
            PetInfo = "Lizard, Lizard";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Tail Blow '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'Stun   '
			ReadyMoveTwo.Name= 'Fireball  '; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Fire   '; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Blockhead '; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Blunt'; ReadyMoveThree.Element= 'Reverb.'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Brain Crs.'; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Blunt'; ReadyMoveFour.Element= 'Liquefa'; ReadyMoveFour.Effect= 'Silence'
			ReadyMoveFive.Name= 'Infrason. '; ReadyMoveFive.Cost= '2'; ReadyMoveFive.Type= 'Enfb.'; ReadyMoveFive.Element= 'Ice    '; ReadyMoveFive.Effect= 'EVA DWN'
			ReadyMoveSix.Name= 'Secretion '; ReadyMoveSix.Cost= '1'; ReadyMoveSix.Type= 'Enhn.'; ReadyMoveSix.Element= 'None   '; ReadyMoveSix.Effect= 'EVA UP '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '						
        elseif pet.name == 'ScissorlegXerin' or pet.name == 'BouncingBertha' then
            PetInfo = "Chapuli, Vermin";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Snsl. Bld.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Scision'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Teg. Bfft.'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Slash'; ReadyMoveTwo.Element= 'DIS/Det'; ReadyMoveTwo.Effect= 'Choke  '
			ReadyMoveThree.Name= '          '; ReadyMoveThree.Cost= ' '; ReadyMoveThree.Type= '     '; ReadyMoveThree.Element= '       '; ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'RhymingShizuna' or pet.name == 'SheepFamiliar' or pet.name == 'LullabyMelodia' or pet.name == 'NurseryNazuna' then
            PetInfo = "Sheep, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Lamb Chop '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Rage      '; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enhn.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'Berserk'
			ReadyMoveThree.Name= 'Sheep Chrg'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Blunt'; ReadyMoveThree.Element= 'Reverb.'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Sheep Song'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Enfb.'; ReadyMoveFour.Element= 'Light  '; ReadyMoveFour.Effect= 'Sleep  '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'AttentiveIbuki' or pet.name == 'SwoopingZhivago' then
            PetInfo = "Tulfaire, Bird";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Mlt. Plum.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Magic'; ReadyMoveOne.Element= 'Wind   '; ReadyMoveOne.Effect= 'Dispel '
			ReadyMoveTwo.Name= 'Swp. Frzy.'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Pier.'; ReadyMoveTwo.Element= 'FUS/REV'; ReadyMoveTwo.Effect= 'MDF/DEF'
			ReadyMoveThree.Name= 'Pentapeck '; ReadyMoveThree.Cost= '3'; ReadyMoveThree.Type= 'Pier.'; ReadyMoveThree.Element= 'LIT/DIS'; ReadyMoveThree.Effect= 'Amnesia'
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'AmiableRoche' or pet.name == 'TurbidToloi' then
            PetInfo = "Pugil, Aquan";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Intimidate'; ReadyMoveOne.Cost= '2'; ReadyMoveOne.Type= 'Enfb.'; ReadyMoveOne.Element= 'None   '; ReadyMoveOne.Effect= 'Slow   '
			ReadyMoveTwo.Name= 'Recoil Dv.'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Slash'; ReadyMoveTwo.Element= 'Trnsfx.'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Water Wall'; ReadyMoveThree.Cost= '3'; ReadyMoveThree.Type= 'Enhn.'; ReadyMoveThree.Element= 'None   '; ReadyMoveThree.Effect= 'DEF UP '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'BrainyWaluis' or pet.name == 'FunguarFamiliar' or pet.name == 'DiscreetLouise' then
            PetInfo = "Funguar, Plantoid";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Frogkick  '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Cmpres.'; ReadyMoveOne.Effect= 'Ign DEF'
			ReadyMoveTwo.Name= 'Spore     '; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Earth  '; ReadyMoveTwo.Effect= 'Para   '
			ReadyMoveThree.Name= 'Qsy.-Shrm.'; ReadyMoveThree.Cost= '2'; ReadyMoveThree.Type= 'Spec.'; ReadyMoveThree.Element= 'Dark   '; ReadyMoveThree.Effect= 'Poison '
			ReadyMoveFour.Name= 'Nmb.-Shrm.'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Spec.'; ReadyMoveFour.Element= 'Dark   '; ReadyMoveFour.Effect= 'Para   '
			ReadyMoveFive.Name= 'Shk.-Shrm.'; ReadyMoveFive.Cost= '2'; ReadyMoveFive.Type= 'Spec.'; ReadyMoveFive.Element= 'Dark   '; ReadyMoveFive.Effect= 'Disease'
			ReadyMoveSix.Name= 'Sln. Gas. '; ReadyMoveSix.Cost= '3'; ReadyMoveSix.Type= 'Spec.'; ReadyMoveSix.Element= 'Dark   '; ReadyMoveSix.Effect= 'Silence'
			ReadyMoveSeven.Name= 'Dark Spore'; ReadyMoveSeven.Cost= '3'; ReadyMoveSeven.Type= 'Spec.'; ReadyMoveSeven.Element= 'Dark   '; ReadyMoveSeven.Effect= 'Blind  '			
        elseif pet.name == 'HeadbreakerKen' or pet.name == 'MayflyFamiliar' or pet.name == 'ShellbusterOrob' or pet.name == 'MailbusterCetas' then
            PetInfo = "Fly, Vermin";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Crsd. Sph.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Spec.'; ReadyMoveOne.Element= 'Dark   '; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Venom     '; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Water  '; ReadyMoveTwo.Effect= 'Poison '
			ReadyMoveThree.Name= 'Somersault'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Blunt'; ReadyMoveThree.Element= 'Cmpres.'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'RedolentCandi' or pet.name == 'AlluringHoney' then
            PetInfo = "Snapweed, Plantoid";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Tic. Tndr.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'Stun   '
			ReadyMoveTwo.Name= 'Stink Bomb'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Earth  '; ReadyMoveTwo.Effect= 'BLN/PAR'
			ReadyMoveThree.Name= 'Nect. Dlg.'; ReadyMoveThree.Cost= '2'; ReadyMoveThree.Type= 'Magic'; ReadyMoveThree.Element= 'Water  '; ReadyMoveThree.Effect= 'Poison '
			ReadyMoveFour.Name= 'Nep. Plng.'; ReadyMoveFour.Cost= '3'; ReadyMoveFour.Type= 'Magic'; ReadyMoveFour.Element= 'Water  '; ReadyMoveFour.Effect= 'DRN/GRV'
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'CaringKiyomaro' or pet.name == 'VivaciousVickie' then
            PetInfo = "Raaz, Beast";PetJob = 'Monk'
			ReadyMoveOne.Name= 'Swp. Gouge'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Indura.'; ReadyMoveOne.Effect= 'DEF DWN'
			ReadyMoveTwo.Name= 'Zls. Snort'; ReadyMoveTwo.Cost= '3'; ReadyMoveTwo.Type= 'Enhn.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'SWOLBOI'
			ReadyMoveThree.Name= '          '; ReadyMoveThree.Cost= ' '; ReadyMoveThree.Type= '     '; ReadyMoveThree.Element= '       '; ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'HurlerPercival' or pet.name == 'BeetleFamiliar' or pet.name == 'PanzerGalahad' then
            PetInfo = "Beetle, Vermin";PetJob = 'Paladin'
			ReadyMoveOne.Name= 'Pwr. Attk.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Reverb.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'H-fr. Fld.'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'EVA DWN'
			ReadyMoveThree.Name= 'Rhn. Atk. '; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Pier.'; ReadyMoveThree.Element= 'Deton. '; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Rhn. Grd. '; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'EVA UP '
			ReadyMoveFive.Name= 'Spoil     '; ReadyMoveFive.Cost= '1'; ReadyMoveFive.Type= 'Enfb.'; ReadyMoveFive.Element= 'None   '; ReadyMoveFive.Effect= 'STR DWN'
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'Y.BeetleFamilia' or pet.name == 'EnergizedSefina' then
            PetInfo = "Beetle (Horn), Vermin";PetJob = 'Paladin'
			ReadyMoveOne.Name= 'Pwr. Atk. '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Reverb.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'H-fr. Fld.'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'Ice    '; ReadyMoveTwo.Effect= 'EVA DWN'
			ReadyMoveThree.Name= 'Rhino Atk.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Pier.'; ReadyMoveThree.Element= 'Deton. '; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Rhino Grd.'; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'EVA UP '
			ReadyMoveFive.Name= 'Spoil     '; ReadyMoveFive.Cost= '1'; ReadyMoveFive.Type= 'Enfb.'; ReadyMoveFive.Element= 'None   '; ReadyMoveFive.Effect= 'STR DWN'
			ReadyMoveSix.Name= 'Rhinowrek.'; ReadyMoveSix.Cost= '2'; ReadyMoveSix.Type= 'Pier.'; ReadyMoveSix.Element= 'FUS/TRN'; ReadyMoveSix.Effect= 'DEF DWN'
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'BlackbeardRandy' or pet.name == 'TigerFamiliar' or pet.name == 'SaberSiravarde' or pet.name == 'GorefangHobs' then
            PetInfo = "Tiger, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Roar      '; ReadyMoveOne.Cost= '2'; ReadyMoveOne.Type= 'Enfb.'; ReadyMoveOne.Element= 'Ice    '; ReadyMoveOne.Effect= 'Para   '
			ReadyMoveTwo.Name= 'Razor Fang'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Slash'; ReadyMoveTwo.Element= 'Impact.'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Claw Cycl.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Slash'; ReadyMoveThree.Element= 'Scision'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Crossthrs.'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Slash'; ReadyMoveFour.Element= 'DIS/Det'; ReadyMoveFour.Effect= 'Dispel '
			ReadyMoveFive.Name= 'Pred. Glr.'; ReadyMoveFive.Cost= '2'; ReadyMoveFive.Type= 'Enfb.'; ReadyMoveFive.Element= 'Thunder'; ReadyMoveFive.Effect= 'Stun   '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'ColibriFamiliar' or pet.name == 'ChoralLeera' then
            PetInfo = "Colibri, Bird";PetJob = 'Red Mage'
			ReadyMoveOne.Name= 'Pck. Flry.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Pier.'; ReadyMoveOne.Element= 'Trnsfx.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= '          '; ReadyMoveTwo.Cost= ' '; ReadyMoveTwo.Type= '     '; ReadyMoveTwo.Element= '       '; ReadyMoveTwo.Effect= '       '
			ReadyMoveThree.Name= '          '; ReadyMoveThree.Cost= ' '; ReadyMoveThree.Type= '     '; ReadyMoveThree.Element= '       '; ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'SpiderFamiliar' or pet.name == 'GussyHachirobe' then
            PetInfo = "Spider, Vermin";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Skl. Slash'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Trnsfx.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Acid Spray'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Water  '; ReadyMoveTwo.Effect= 'Poison '
			ReadyMoveThree.Name= 'Spider Web'; ReadyMoveThree.Cost= '2'; ReadyMoveThree.Type= 'Enfb.'; ReadyMoveThree.Element= 'Earth  '; ReadyMoveThree.Effect= 'Slow   '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '		
        elseif pet.name == 'GenerousArthur' or pet.name == 'GooeyGerard' then
            PetInfo = "Slug, Amorph";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Puru. Ooze'; ReadyMoveOne.Cost= '2'; ReadyMoveOne.Type= 'Magic'; ReadyMoveOne.Element= 'Water  '; ReadyMoveOne.Effect= 'BIO/MHP'
			ReadyMoveTwo.Name= 'Coro. Ooze'; ReadyMoveTwo.Cost= '3'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Water  '; ReadyMoveTwo.Effect= 'ATK/DEF'
			ReadyMoveThree.Name= '          '; ReadyMoveThree.Cost= ' '; ReadyMoveThree.Type= '     '; ReadyMoveThree.Element= '       '; ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'ThreestarLynn' or pet.name == 'DipperYuly' then
            PetInfo = "Ladybug, Vermin";PetJob = 'Thief'
			ReadyMoveOne.Name= 'Sud. Lunge'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'Stun   '
			ReadyMoveTwo.Name= 'Sprl. Spin'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Slash'; ReadyMoveTwo.Element= 'Scision'; ReadyMoveTwo.Effect= 'ACC DWN'
			ReadyMoveThree.Name= 'Noi. Pwdr.'; ReadyMoveThree.Cost= '2'; ReadyMoveThree.Type= 'Enfb.'; ReadyMoveThree.Element= 'None   '; ReadyMoveThree.Effect= 'ATK DWN'
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'SharpwitHermes' or pet.name == 'SweetCaroline' or pet.name == 'FlowerpotBill' or pet.name == 'FlowerpotBen' or pet.name == 'Homunculus' or pet.name == 'FlowerpotMerle' then
            PetInfo = "Mandragora, Plantoid";PetJob = 'Monk'
			ReadyMoveOne.Name= 'Head Butt '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Deton. '; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Wild Oats '; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Pier.'; ReadyMoveTwo.Element= 'Trnsfx.'; ReadyMoveTwo.Effect= 'VIT DWN'
			ReadyMoveThree.Name= 'Leaf Dggr.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Slash'; ReadyMoveThree.Element= 'Scision'; ReadyMoveThree.Effect= 'Poison '
			ReadyMoveFour.Name= 'Scream    '; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enfb.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'MND DWN'
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'AcuexFamiliar' or pet.name == 'FluffyBredo' then
            PetInfo = "Acuex, Amorph";PetJob = 'Black Mage'
			ReadyMoveOne.Name= 'Foul Wtrs.'; ReadyMoveOne.Cost= '2'; ReadyMoveOne.Type= 'Magic'; ReadyMoveOne.Element= 'Water  '; ReadyMoveOne.Effect= 'DRN/GRV'
			ReadyMoveTwo.Name= 'Pest. Plm.'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Dark   '; ReadyMoveTwo.Effect= 'AIDS   '
			ReadyMoveThree.Name= '          '; ReadyMoveThree.Cost= ' '; ReadyMoveThree.Type= '     '; ReadyMoveThree.Element= '       '; ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'FlytrapFamiliar' or pet.name == 'VoraciousAudrey' or pet.name == 'PrestoJulio' then--NEEDS CORRECTION
            PetInfo = "Flytrap, Plantoid";PetJob = 'Warrior'
			ReadyMoveOne.Name	= '          ';	ReadyMoveOne.Cost	= ' '; ReadyMoveOne.Type	= '     '; ReadyMoveOne.Element	 = '       '; 	ReadyMoveOne.Effect	 = '       '
			ReadyMoveTwo.Name	= '          ';	ReadyMoveTwo.Cost	= ' '; ReadyMoveTwo.Type	= '     '; ReadyMoveTwo.Element	 = '       '; 	ReadyMoveTwo.Effect	 = '       '
			ReadyMoveThree.Name	= '          ';	ReadyMoveThree.Cost	= ' '; ReadyMoveThree.Type	= '     '; ReadyMoveThree.Element= '       '; 	ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name	= '          ';	ReadyMoveFour.Cost	= ' '; ReadyMoveFour.Type	= '     '; ReadyMoveFour.Element = '       '; 	ReadyMoveFour.Effect = '       '
			ReadyMoveFive.Name	= '          ';	ReadyMoveFive.Cost	= ' '; ReadyMoveFive.Type	= '     '; ReadyMoveFive.Element = '       '; 	ReadyMoveFive.Effect = '       '
			ReadyMoveSix.Name	= '          ';	ReadyMoveSix.Cost	= ' '; ReadyMoveSix.Type	= '     '; ReadyMoveSix.Element	 = '       '; 	ReadyMoveSix.Effect  = '       '
			ReadyMoveSeven.Name	= '          ';	ReadyMoveSeven.Cost	= ' '; ReadyMoveSeven.Type	= '     '; ReadyMoveSeven.Element= '       '; 	ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'EftFamiliar' or pet.name == 'AmbusherAllie' or pet.name == 'BugeyedBroncha' or pet.name == 'SuspiciousAlice' then
            PetInfo = "Eft, Lizard";PetJob = 'Warrior';
			ReadyMoveOne.Name= 'Nimb. Snp.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Cyclotail '; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Blunt'; ReadyMoveTwo.Element= 'Impact.'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Geist Wall'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Enfb.'; ReadyMoveThree.Element= 'Dark   '; ReadyMoveThree.Effect= 'Dispel '
			ReadyMoveFour.Name= 'Numb. Noi.'; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enfb.'; ReadyMoveFour.Element= 'Thunder'; ReadyMoveFour.Effect= 'Stun   '
			ReadyMoveFive.Name= 'Toxic Spit'; ReadyMoveFive.Cost= '2'; ReadyMoveFive.Type= 'Magic'; ReadyMoveFive.Element= 'Water  '; ReadyMoveFive.Effect= 'Poison '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'AntlionFamiliar' or pet.name == 'ChopsueyChucky' or pet.name == 'CursedAnnabelle' then
            PetInfo = "Antlion, Vermin";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Mand. Bite'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Deton. '; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Sandblast '; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Earth  '; ReadyMoveTwo.Effect= 'Blind  '
			ReadyMoveThree.Name= 'Sandpit   '; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Magic'; ReadyMoveThree.Element= 'Earth  '; ReadyMoveThree.Effect= 'Bind   '
			ReadyMoveFour.Name= 'Venom Spr.'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Magic'; ReadyMoveFour.Element= 'Water  '; ReadyMoveFour.Effect= 'Poison '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'MiteFamiliar' or pet.name == 'LifedrinkerLars' or pet.name == 'AnklebiterJedd' then
            PetInfo = "Diremite, Vermin";PetJob = 'Dark Knight'
			ReadyMoveOne.Name= 'Dbl. Claw '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Liquefa'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Grapple   '; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Blunt'; ReadyMoveTwo.Element= 'Reverb.'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Spin. Top '; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Blunt'; ReadyMoveThree.Element= 'Impact.'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Film. Hold'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Enfb.'; ReadyMoveFour.Element= 'Earth  '; ReadyMoveFour.Effect= 'Slow   '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'AmigoSabotender' then--NEEDS CORRECTION
            PetInfo = "Cactuar, Plantoid";PetJob = 'Warrior'
			ReadyMoveOne.Name	= '          ';	ReadyMoveOne.Cost	= ' '; ReadyMoveOne.Type	= '     '; ReadyMoveOne.Element	 = '       '; 	ReadyMoveOne.Effect	 = '       '
			ReadyMoveTwo.Name	= '          ';	ReadyMoveTwo.Cost	= ' '; ReadyMoveTwo.Type	= '     '; ReadyMoveTwo.Element	 = '       '; 	ReadyMoveTwo.Effect	 = '       '
			ReadyMoveThree.Name	= '          ';	ReadyMoveThree.Cost	= ' '; ReadyMoveThree.Type	= '     '; ReadyMoveThree.Element= '       '; 	ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name	= '          ';	ReadyMoveFour.Cost	= ' '; ReadyMoveFour.Type	= '     '; ReadyMoveFour.Element = '       '; 	ReadyMoveFour.Effect = '       '
			ReadyMoveFive.Name	= '          ';	ReadyMoveFive.Cost	= ' '; ReadyMoveFive.Type	= '     '; ReadyMoveFive.Element = '       '; 	ReadyMoveFive.Effect = '       '
			ReadyMoveSix.Name	= '          ';	ReadyMoveSix.Cost	= ' '; ReadyMoveSix.Type	= '     '; ReadyMoveSix.Element	 = '       '; 	ReadyMoveSix.Effect  = '       '
			ReadyMoveSeven.Name	= '          ';	ReadyMoveSeven.Cost	= ' '; ReadyMoveSeven.Type	= '     '; ReadyMoveSeven.Element= '       '; 	ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'CraftyClyvonne' then--NEEDS CORRECTION
            PetInfo = "Coeurl, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Chao. Eye '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Enfb.'; ReadyMoveOne.Element= 'None   '; ReadyMoveOne.Effect= 'Silence'
			ReadyMoveTwo.Name= 'Blaster   '; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'Para   '
			ReadyMoveThree.Name= '          '; ReadyMoveThree.Cost= ' '; ReadyMoveThree.Type= '     '; ReadyMoveThree.Element= '       '; ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '

        elseif pet.name == 'BloodclawShasra' then--NEEDS CORRECTION
            PetInfo = "Lynx, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Chao. Eye '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Enfb.'; ReadyMoveOne.Element= 'None   '; ReadyMoveOne.Effect= 'Silence'
			ReadyMoveTwo.Name= 'Blaster   '; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'Para   '
			ReadyMoveThree.Name= 'Chrg. Wsk.'; ReadyMoveThree.Cost= '2'; ReadyMoveThree.Type= 'Magic'; ReadyMoveThree.Element= 'Thunder'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Frenz. Rg.'; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'ATK UP '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'LynxFamiliar' or pet.name == 'VivaciousGaston' then
            PetInfo = "Collared Lynx, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Chao. Eye '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Enfb.'; ReadyMoveOne.Element= 'None   '; ReadyMoveOne.Effect= 'Silence'
			ReadyMoveTwo.Name= 'Blaster   '; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'Para   '
			ReadyMoveThree.Name= 'Chrg. Wsk.'; ReadyMoveThree.Cost= '2'; ReadyMoveThree.Type= 'Magic'; ReadyMoveThree.Element= 'Thunder'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Frenz. Rg.'; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'ATK UP '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'SwiftSieghard' or pet.name == 'FleetReinhard' then
            PetInfo = "Raptor, Lizard";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Scy. Tail '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Liquefa'; ReadyMoveOne.Effect= 'Stun   '
			ReadyMoveTwo.Name= 'Ripr. Fang'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Slash'; ReadyMoveTwo.Element= 'Indura.'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Chomp Rush'; ReadyMoveThree.Cost= '3'; ReadyMoveThree.Type= 'Slash'; ReadyMoveThree.Element= 'DRK/GRV'; ReadyMoveThree.Effect= 'Slow   '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'DapperMac' or pet.name == 'SurgingStorm' or pet.name == 'SubmergedIyo' then
            PetInfo = "Apkallu, Bird";PetJob = 'Monk'
			ReadyMoveOne.Name= 'Wing Slap '; ReadyMoveOne.Cost= '2'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'GRV/LIQ'; ReadyMoveOne.Effect= 'Stun   '
			ReadyMoveTwo.Name= 'Beak Lunge'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Blunt'; ReadyMoveTwo.Element= 'Scision'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= '          '; ReadyMoveThree.Cost= ' '; ReadyMoveThree.Type= '     '; ReadyMoveThree.Element= '       '; ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'FatsoFargann' then
            PetInfo = "Leech, Amorph";PetJob = 'Warrior'
			ReadyMoveOne.Name	= '          ';	ReadyMoveOne.Cost	= ' '; ReadyMoveOne.Type	= '     '; ReadyMoveOne.Element	 = '       '; 	ReadyMoveOne.Effect	 = '       '
			ReadyMoveTwo.Name	= '          ';	ReadyMoveTwo.Cost	= ' '; ReadyMoveTwo.Type	= '     '; ReadyMoveTwo.Element	 = '       '; 	ReadyMoveTwo.Effect	 = '       '
			ReadyMoveThree.Name	= '          ';	ReadyMoveThree.Cost	= ' '; ReadyMoveThree.Type	= '     '; ReadyMoveThree.Element= '       '; 	ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name	= '          ';	ReadyMoveFour.Cost	= ' '; ReadyMoveFour.Type	= '     '; ReadyMoveFour.Element = '       '; 	ReadyMoveFour.Effect = '       '
			ReadyMoveFive.Name	= '          ';	ReadyMoveFive.Cost	= ' '; ReadyMoveFive.Type	= '     '; ReadyMoveFive.Element = '       '; 	ReadyMoveFive.Effect = '       '
			ReadyMoveSix.Name	= '          ';	ReadyMoveSix.Cost	= ' '; ReadyMoveSix.Type	= '     '; ReadyMoveSix.Element	 = '       '; 	ReadyMoveSix.Effect  = '       '
			ReadyMoveSeven.Name	= '          ';	ReadyMoveSeven.Cost	= ' '; ReadyMoveSeven.Type	= '     '; ReadyMoveSeven.Element= '       '; 	ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'Hip.Familiar' or pet.name == 'DaringRoland' or pet.name == 'FaithfulFalcorr' then
            PetInfo = "Hippogryph, Bird";PetJob = 'Thief'
			ReadyMoveOne.Name= 'Back Heel '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Reverb.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Jettatura '; ReadyMoveTwo.Cost= '3'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'TERROR '
			ReadyMoveThree.Name= 'Chk. Brth.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Slash'; ReadyMoveThree.Element= 'None   '; ReadyMoveThree.Effect= 'PAR/SLN'
			ReadyMoveFour.Name= 'Fantod    '; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'Boost  '
			ReadyMoveFive.Name= 'Hoof Voly.'; ReadyMoveFive.Cost= '3'; ReadyMoveFive.Type= 'Blunt'; ReadyMoveFive.Element= 'LIT/FRG'; ReadyMoveFive.Effect= 'None   '
			ReadyMoveSix.Name= 'Nihl. Song'; ReadyMoveSix.Cost= '1'; ReadyMoveSix.Type= 'Enfb.'; ReadyMoveSix.Element= 'None   '; ReadyMoveSix.Effect= 'Dispel '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '			
        elseif pet.name == 'CrudeRaphie' then
            PetInfo = "Adamantoise, Lizard";PetJob = 'Paladin'
			ReadyMoveOne.Name	= '          ';	ReadyMoveOne.Cost	= ' '; ReadyMoveOne.Type	= '     '; ReadyMoveOne.Element	 = '       '; 	ReadyMoveOne.Effect	 = '       '
			ReadyMoveTwo.Name	= '          ';	ReadyMoveTwo.Cost	= ' '; ReadyMoveTwo.Type	= '     '; ReadyMoveTwo.Element	 = '       '; 	ReadyMoveTwo.Effect	 = '       '
			ReadyMoveThree.Name	= '          ';	ReadyMoveThree.Cost	= ' '; ReadyMoveThree.Type	= '     '; ReadyMoveThree.Element= '       '; 	ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name	= '          ';	ReadyMoveFour.Cost	= ' '; ReadyMoveFour.Type	= '     '; ReadyMoveFour.Element = '       '; 	ReadyMoveFour.Effect = '       '
			ReadyMoveFive.Name	= '          ';	ReadyMoveFive.Cost	= ' '; ReadyMoveFive.Type	= '     '; ReadyMoveFive.Element = '       '; 	ReadyMoveFive.Effect = '       '
			ReadyMoveSix.Name	= '          ';	ReadyMoveSix.Cost	= ' '; ReadyMoveSix.Type	= '     '; ReadyMoveSix.Element	 = '       '; 	ReadyMoveSix.Effect  = '       '
			ReadyMoveSeven.Name	= '          ';	ReadyMoveSeven.Cost	= ' '; ReadyMoveSeven.Type	= '     '; ReadyMoveSeven.Element= '       '; 	ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'MosquitoFamilia' or pet.name == 'Left-HandedYoko' then
            PetInfo = "Mosquito, Vermin";PetJob = 'Dark Knight'
			ReadyMoveOne.Name= 'Inf. Leech'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Magic'; ReadyMoveOne.Element= 'None   '; ReadyMoveOne.Effect= 'Plague '
			ReadyMoveTwo.Name= 'Glm. Spray'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Dark   '; ReadyMoveTwo.Effect= 'Dispel '
			ReadyMoveThree.Name= '          '; ReadyMoveThree.Cost= ' '; ReadyMoveThree.Type= '     '; ReadyMoveThree.Element= '       '; ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'WeevilFamiliar' or pet.name == 'StalwartAngelin' then
            PetInfo = "Weevil, Vermin";PetJob = 'Thief'
			ReadyMoveOne.Name= 'Disembowel'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'ACC DWN'
			ReadyMoveTwo.Name= 'Ext. Salvo'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Blunt'; ReadyMoveTwo.Element= 'FUS/IMP'; ReadyMoveTwo.Effect= 'Stun   '
			ReadyMoveThree.Name= '          '; ReadyMoveThree.Cost= ' '; ReadyMoveThree.Type= '     '; ReadyMoveThree.Element= '       '; ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name= '          '; ReadyMoveFour.Cost= ' '; ReadyMoveFour.Type= '     '; ReadyMoveFour.Element= '       '; ReadyMoveFour.Effect= '       '
			ReadyMoveFive.Name= '          '; ReadyMoveFive.Cost= ' '; ReadyMoveFive.Type= '     '; ReadyMoveFive.Element= '       '; ReadyMoveFive.Effect= '       '
			ReadyMoveSix.Name= '          '; ReadyMoveSix.Cost= ' '; ReadyMoveSix.Type= '     '; ReadyMoveSix.Element= '       '; ReadyMoveSix.Effect= '       '
			ReadyMoveSeven.Name= '          '; ReadyMoveSeven.Cost= ' '; ReadyMoveSeven.Type= '     '; ReadyMoveSeven.Element= '       '; ReadyMoveSeven.Effect= '       '
        elseif pet.name == 'SlimeFamiliar' or pet.name == 'SultryPatrice' then
            PetInfo = "Slime, Amorph";PetJob = 'Warrior'
			ReadyMoveOne.Name	= 'Fluid Toss'; ReadyMoveOne.Cost	= '1'; ReadyMoveOne.Type	= 'Blunt'; ReadyMoveOne.Element		= 'Reverb.'; ReadyMoveOne.Effect	= 'None   '
			ReadyMoveTwo.Name	= 'Flu. Sprd.'; ReadyMoveTwo.Cost	= '2'; ReadyMoveTwo.Type	= 'Blunt'; ReadyMoveTwo.Element		= 'FRG/TRN'; ReadyMoveTwo.Effect	= 'None   '
			ReadyMoveThree.Name	= 'Digest    '; ReadyMoveThree.Cost	= '1'; ReadyMoveThree.Type	= 'Phys.'; ReadyMoveThree.Element	= 'None   '; ReadyMoveThree.Effect	= 'None   '
			ReadyMoveFour.Name	= '          '; ReadyMoveFour.Cost	= ' '; ReadyMoveFour.Type	= '     '; ReadyMoveFour.Element	= '       '; ReadyMoveFour.Effect	= '       '
			ReadyMoveFive.Name	= '          '; ReadyMoveFive.Cost	= ' '; ReadyMoveFive.Type	= '     '; ReadyMoveFive.Element	= '       '; ReadyMoveFive.Effect	= '       '
			ReadyMoveSix.Name	= '          '; ReadyMoveSix.Cost	= ' '; ReadyMoveSix.Type	= '     '; ReadyMoveSix.Element		= '       '; ReadyMoveSix.Effect	= '       '
			ReadyMoveSeven.Name	= '          '; ReadyMoveSeven.Cost	= ' '; ReadyMoveSeven.Type	= '     '; ReadyMoveSeven.Element	= '       '; ReadyMoveSeven.Effect	= '       '
        end
    else
			PetName = '    '
			PetJob 	= '    '
			PetInfo = '    '
			ReadyMoveOne.Name	= '          ';	ReadyMoveOne.Cost	= ' '; ReadyMoveOne.Type	= '     '; ReadyMoveOne.Element	 = '       '; 	ReadyMoveOne.Effect	 = '       '
			ReadyMoveTwo.Name	= '          ';	ReadyMoveTwo.Cost	= ' '; ReadyMoveTwo.Type	= '     '; ReadyMoveTwo.Element	 = '       '; 	ReadyMoveTwo.Effect	 = '       '
			ReadyMoveThree.Name	= '          ';	ReadyMoveThree.Cost	= ' '; ReadyMoveThree.Type	= '     '; ReadyMoveThree.Element= '       '; 	ReadyMoveThree.Effect= '       '
			ReadyMoveFour.Name	= '          ';	ReadyMoveFour.Cost	= ' '; ReadyMoveFour.Type	= '     '; ReadyMoveFour.Element = '       '; 	ReadyMoveFour.Effect = '       '
			ReadyMoveFive.Name	= '          ';	ReadyMoveFive.Cost	= ' '; ReadyMoveFive.Type	= '     '; ReadyMoveFive.Element = '       '; 	ReadyMoveFive.Effect = '       '
			ReadyMoveSix.Name	= '          ';	ReadyMoveSix.Cost	= ' '; ReadyMoveSix.Type	= '     '; ReadyMoveSix.Element	 = '       '; 	ReadyMoveSix.Effect  = '       '
			ReadyMoveSeven.Name	= '          ';	ReadyMoveSeven.Cost	= ' '; ReadyMoveSeven.Type	= '     '; ReadyMoveSeven.Element= '       '; 	ReadyMoveSeven.Effect= '       '
    end
end

function pet_only_equip_handling()
    if player.status == 'Engaged' and state.AxeMode.value == 'PetOnly' then
        if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
            if state.DefenseMode.value == "Physical" then
                equip(sets.defense.DWNE[state.PhysicalDefenseMode.value])
            elseif state.DefenseMode.value == "Magical" then
                equip(sets.defense.DWNE[state.MagicalDefenseMode.value])
            else
                if pet.status == "Engaged" then
                    equip(sets.idle.DWNE.PetEngaged)
                else
                    equip(sets.idle.DWNE)
                end
            end
        else
            if state.DefenseMode.value == "Physical" then
                equip(sets.defense.NE[state.PhysicalDefenseMode.value])
            elseif state.DefenseMode.value == "Magical" then
                equip(sets.defense.NE[state.MagicalDefenseMode.value])
            else
                if pet.status == "Engaged" then
                    equip(sets.idle.NE.PetEngaged)
                else
                    equip(sets.idle.NE)
                end
            end
        end
    end
end

function pet_buff_timer(spell)
    if spell.english == 'Reward' then
        send_command('timers c "Pet: Regen" 180 down '..RewardRegenIcon..'')
    elseif spell.english == 'Spur' then
        send_command('timers c "Pet: Spur" 90 down '..SpurIcon..'')
    elseif spell.english == 'Run Wild' then
        send_command('timers c "'..spell.english..'" '..RunWildDuration..' down '..RunWildIcon..'')
    end
end

function clear_pet_buff_timers()
    send_command('timers c "Pet: Regen" 0 down '..RewardRegenIcon..'')
    send_command('timers c "Pet: Spur" 0 down '..SpurIcon..'')
    send_command('timers c "Run Wild" 0 down '..RunWildIcon..'')
end

function display_mode_info()
    if DisplayModeInfo == 'true' and DisplayTrue == 1 then
        local x = TextBoxX
        local y = TextBoxY
        send_command('text AccuracyText create Acc. Mode: '..state.OffenseMode.value..'')
        send_command('text AccuracyText pos '..x..' '..y..'')
        send_command('text AccuracyText size '..TextSize..'')
        y = y + (TextSize + 6)
        send_command('text CorrelationText create Corr. Mode: '..state.CorrelationMode.value..'')
        send_command('text CorrelationText pos '..x..' '..y..'')
        send_command('text CorrelationText size '..TextSize..'')
        y = y + (TextSize + 6)
        send_command('text AxeModeText create Axe Mode: '..state.AxeMode.value..'')
        send_command('text AxeModeText pos '..x..' '..y..'')
        send_command('text AxeModeText size '..TextSize..'')
        y = y + (TextSize + 6)
        send_command('text JugPetText create Jug Mode: '..state.JugMode.value..'')
        send_command('text JugPetText pos '..x..' '..y..'')
        send_command('text JugPetText size '..TextSize..'')
        DisplayTrue = DisplayTrue - 1
    end
end

function update_display_mode_info()
    if DisplayModeInfo == 'true' then
        send_command('text AccuracyText text Acc. Mode: '..state.OffenseMode.value..'')
        send_command('text CorrelationText text Corr. Mode: '..state.CorrelationMode.value..'')
        send_command('text AxeModeText text Axe Mode: '..state.AxeMode.value..'')
        send_command('text JugPetText text Jug Mode: '..state.JugMode.value..'')
    end
end

function checkblocking(spell)
    if buffactive.sleep or buffactive.petrification or buffactive.terror then 
        --add_to_chat(3,'Canceling Action - Asleep/Petrified/Terror!')
        cancel_spell()
        return
    end 
    if spell.english == "Double-Up" then
        if not buffactive["Double-Up Chance"] then 
            add_to_chat(3,'Canceling Action - No ability to Double Up')
            cancel_spell()
            return
        end
    end
    if spell.name ~= 'Ranged' and spell.type ~= 'WeaponSkill' and spell.type ~= 'Scholar' and spell.type ~= 'Monster' then
        if spell.action_type == 'Ability' then
            if buffactive.Amnesia then
                cancel_spell()
                add_to_chat(3,'Canceling Ability - Currently have Amnesia')
                return
            else
                recasttime = windower.ffxi.get_ability_recasts()[spell.recast_id] 
                if spell and (recasttime >= 1) then
                    --add_to_chat(3,'Ability Canceled:'..spell.name..' - Waiting on Recast:(seconds) '..recasttime..'')
                    cancel_spell()
                    return
                end
            end
        end
    end
    --if spell.type == 'WeaponSkill' and player.tp < 1000 then
    --    cancel_spell()
    --    add_to_chat(3,'Canceled WS:'..spell.name..' - Current TP is less than 1000.')
    --    return
    --end
    --if spell.type == 'WeaponSkill' and buffactive.Amnesia then
    --    cancel_spell()
    --    add_to_chat(3,'Canceling Ability - Currently have Amnesia.')
    --    return	  
    --end
    --if spell.name == 'Utsusemi: Ichi' and (buffactive['Copy Image (3)'] or buffactive ['Copy Image (4+)']) then
    --    cancel_spell()
    --    add_to_chat(3,'Canceling Utsusemi - Already have maximum shadows (3).')
    --    return
    --end
    if spell.type == 'Monster' or spell.name == 'Reward' then
        if pet.isvalid then
            if spell.name == 'Fireball' and pet.status ~= "Engaged" then
                cancel_spell()
                send_command('input /pet Fight <t>')
                return
            end
            local s = windower.ffxi.get_mob_by_target('me')
            local pet = windower.ffxi.get_mob_by_target('pet')
            local PetMaxDistance = 4
            local pettargetdistance = PetMaxDistance + pet.model_size + s.model_size
            if pet.model_size > 1.6 then 
                pettargetdistance = PetMaxDistance + pet.model_size + s.model_size + 0.1
            end
            if pet.distance:sqrt() >= pettargetdistance then
                --add_to_chat(3,'Canceling: '..spell.name..' - Outside valid JA Distance.')
                cancel_spell()
                return
            end
        else
            add_to_chat(3,'Canceling: '..spell.name..' - That action requires a pet.')
            cancel_spell()
            return
        end
    end
    if spell.name == 'Fight' then
        if pet.isvalid then 
            local t = windower.ffxi.get_mob_by_target('t') or windower.ffxi.get_mob_by_target('st')
            local pet = windower.ffxi.get_mob_by_target('pet')
            local PetMaxDistance = 32 
            local DistanceBetween = ((t.x - pet.x)*(t.x-pet.x) + (t.y-pet.y)*(t.y-pet.y)):sqrt()
            if DistanceBetween > PetMaxDistance then 
                --add_to_chat(3,'Canceling: Fight - Replacing with Heel since target is 30 yalms away from pet.')
                cancel_spell()
                send_command('@wait .5; input /pet Heel <me>')
                return
            end
        end
    end
end

function get_melee_groups()
    classes.CustomMeleeGroups:clear()

    if buffactive['Aftermath: Lv.3'] then
        classes.CustomMeleeGroups:append('Aftermath')
    end
end

function get_combat_form()
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
end

--BST_HUD--
--------------------------------------------------------------------------------------------------------------
-- HUD STUFF
--------------------------------------------------------------------------------------------------------------
require('logger')
require('tables')
require('strings')

color={}
color.red		='(255,0,0)'
color.yellow 	='(0,255,0)'
color.blue		='(0,0,255)'
color.white		='(255,255,255)'
color.black		='(0,0,0)'
color.grey		='(175,175,175)'
color.ltred		='(255,125,125)'
color.ltblue	='(125,125,255)'
color.ltyellow	='(125,255,125)'

function init_HUD()
	const_on = "\\cs(32, 255, 32)ON\\cr"
	const_off = "\\cs(255, 32, 32)OFF\\cr"

	hud_x_pos_og = hud_x_pos
	hud_y_pos_og = hud_y_pos
	hud_font_size_og = hud_font_size
	hud_padding_og = hud_padding
	hud_transparency_og = hud_transparency

	MB_Window = 0
	time_start = 0
	hud_padding = 10

	-- Standard Mode
	hub_mode_std = [[\cs(204, 0, 0)KeyBinds    \cs(255, 115, 0)GS Info: \cr              
			\cs(175, 125, 225)${KB_ML_M}\cs(0, 150, 175)Melee Mode:\cr     ${player_current_melee}
			\cs(175, 125, 225)${KB_WS_M}\cs(0, 150, 175)WS Mode:\cr            ${player_current_ws}
			\cs(175, 125, 225)${KB_PD_M}\cs(0, 150, 175)Hybrid Mode:\cr    ${player_current_Hybrid}
			\cs(175, 125, 225)${KB_ID_M}\cs(0, 150, 175)Idle Mode:\cr    ${player_current_Idle}
			\cs(175, 125, 225)${KB_AX_M}\cs(0, 150, 175)Idle Mode:\cr    ${player_current_AxeMode}
			\cs(175, 125, 225)${KB_MC_M}\cs(0, 150, 175)Idle Mode:\cr    ${player_current_CorrelationMode}
			\cs(0, 150, 175)Pet Name:\cr  ${PI_NM}
			\cs(0, 150, 175)Pet Job:\cr  ${PI_PJ} \cs(0, 150, 175) Pet_Info:\cr ${PI_PI}
			\cs(0, 150, 175)Hotkey\cs(0, 150, 175)WS Name\cs(0, 150, 175)cost\cs(0, 150, 175)Type\cs(0, 150, 175)Element\cs(0, 150, 175)Effect\cr
			\cs(175, 125, 225)${KB_RD_1}\cr${PI_R1_N}\cr${PI_R1_C}\cr${PI_R1_T}\cr${PI_R1_L}\cr${PI_R1_E}
			\cs(175, 125, 225)${KB_RD_2}\cr${PI_R2_N}\cr${PI_R2_C}\cr${PI_R2_T}\cr${PI_R2_L}\cr${PI_R2_E}
			\cs(175, 125, 225)${KB_RD_3}\cr${PI_R3_N}\cr${PI_R3_C}\cr${PI_R3_T}\cr${PI_R3_L}\cr${PI_R3_E}
			\cs(175, 125, 225)${KB_RD_4}\cr${PI_R4_N}\cr${PI_R4_C}\cr${PI_R4_T}\cr${PI_R4_L}\cr${PI_R4_E}
			\cs(175, 125, 225)${KB_RD_5}\cr${PI_R5_N}\cr${PI_R5_C}\cr${PI_R5_T}\cr${PI_R5_L}\cr${PI_R5_E}
			\cs(175, 125, 225)${KB_RD_6}\cr${PI_R6_N}\cr${PI_R6_C}\cr${PI_R6_T}\cr${PI_R6_L}\cr${PI_R6_E}
			\cs(175, 125, 225)${KB_RD_7}\cr${PI_R7_N}\cr${PI_R7_C}\cr${PI_R7_T}\cr${PI_R7_L}\cr${PI_R7_E}			
	]]
	
	-- init style
	hub_mode = hub_mode_std
	hub_options = hub_options_std
	hub_job = hub_job_std
	hub_battle = hub_battle_std

	KB = {}
	KB['KB_ML_M'] = '(NUM /)'
	KB['KB_WS_M'] = '(NUM *)'
	KB['KB_PD_M'] = '(NUM -)'
	KB['KB_ID_M'] = '(NUM +)'
	KB['KB_MC_M'] = '(NUM 0)'
	KB['KB_RD_1'] = '(NUM 1)'
	KB['KB_RD_2'] = '(NUM 2)'
	KB['KB_RD_3'] = '(NUM 3)'
	KB['KB_RD_4'] = '(NUM 4)'
	KB['KB_RD_5'] = '(NUM 5)'
	KB['KB_RD_6'] = '(NUM 6)'
	KB['KB_RD_7'] = '(NUM 7)'
	KB['KB_AX_M'] = '(NUM 8)'



end

function validateTextInformation()
    --Mode Information
    main_text_hub.player_current_melee =  state.OffenseMode.current
	main_text_hub.player_current_ws =  state.WeaponskillMode.current
	main_text_hub.player_current_Hybrid = state.HybridMode.current
	main_text_hub.player_current_Idle = state.IdleMode.current	
	main_text_hub.player_current_AxeMode = state.AxeMode.current	
	main_text_hub.player_current_CorrelationMode = state.CorrelationMode.current	
	
	main_text_hub.PI_NM = PetName
	main_text_hub.PI_PJ = PetJob
	main_text_hub.PI_PI = PetInfo

	main_text_hub.PI_R1_N = ReadyMoveOne.Name
	main_text_hub.PI_R1_C = ReadyMoveOne.Cost
	main_text_hub.PI_R1_T = ReadyMoveOne.Type
	main_text_hub.PI_R1_L = ReadyMoveOne.Element
	main_text_hub.PI_R1_E = ReadyMoveOne.Effect

	main_text_hub.PI_R2_N = ReadyMoveTwo.Name
	main_text_hub.PI_R2_C = ReadyMoveTwo.Cost
	main_text_hub.PI_R2_T = ReadyMoveTwo.Type
	main_text_hub.PI_R2_L = ReadyMoveTwo.Element
	main_text_hub.PI_R2_E = ReadyMoveTwo.Effect

	main_text_hub.PI_R3_N = ReadyMoveThree.Name	
	main_text_hub.PI_R3_C = ReadyMoveThree.Cost
	main_text_hub.PI_R3_T = ReadyMoveThree.Type
	main_text_hub.PI_R3_L = ReadyMoveThree.Element
	main_text_hub.PI_R3_E = ReadyMoveThree.Effect

	main_text_hub.PI_R4_N = ReadyMoveFour.Name
	main_text_hub.PI_R4_C = ReadyMoveFour.Cost
	main_text_hub.PI_R4_T = ReadyMoveFour.Type
	main_text_hub.PI_R4_L = ReadyMoveFour.Element
	main_text_hub.PI_R4_E = ReadyMoveFour.Effect

	main_text_hub.PI_R5_N = ReadyMoveFive.Name
	main_text_hub.PI_R5_C = ReadyMoveFive.Cost
	main_text_hub.PI_R5_T = ReadyMoveFive.Type
	main_text_hub.PI_R5_L = ReadyMoveFive.Element
	main_text_hub.PI_R5_E = ReadyMoveFive.Effect

	main_text_hub.PI_R6_N = ReadyMoveSix.Name
	main_text_hub.PI_R6_T = ReadyMoveSix.Cost
	main_text_hub.PI_R6_C = ReadyMoveSix.Type
	main_text_hub.PI_R6_L = ReadyMoveSix.Element
	main_text_hub.PI_R6_E = ReadyMoveSix.Effect

	main_text_hub.PI_R7_N = ReadyMoveSeven.Name
	main_text_hub.PI_R7_T = ReadyMoveSeven.Cost
	main_text_hub.PI_R7_C = ReadyMoveSeven.Type 
	main_text_hub.PI_R7_L = ReadyMoveSeven.Element
	main_text_hub.PI_R7_E = ReadyMoveSeven.Effect		
	
end

function setupTextWindow()

    local default_settings = {}
    default_settings.pos = {}
    default_settings.pos.x = hud_x_pos
    default_settings.pos.y = hud_y_pos
	
    default_settings.bg = {}
    default_settings.bg.alpha = hud_transparency
    default_settings.bg.red = 30
    default_settings.bg.green = 20
    default_settings.bg.blue = 55
    default_settings.bg.visible = true
    
	default_settings.flags = {}
    default_settings.flags.right = false
    default_settings.flags.bottom = false
    default_settings.flags.bold = true
    default_settings.flags.draggable = hud_draggable
    default_settings.flags.italic = false
    
	default_settings.padding = hud_padding
    
	default_settings.text = {}
    default_settings.text.size = hud_font_size
    default_settings.text.font = hud_font
    default_settings.text.fonts = {}
    default_settings.text.alpha = 255
    default_settings.text.red = 147
    default_settings.text.green = 161
    default_settings.text.blue = 161
    
	default_settings.text.stroke = {}
    default_settings.text.stroke.width = 1
    default_settings.text.stroke.alpha = 255
    default_settings.text.stroke.red = 0
    default_settings.text.stroke.green = 0
    default_settings.text.stroke.blue = 0

    --Creates the initial Text Object will use to create the different sections in
    if not (main_text_hub == nil) then
        texts.destroy(main_text_hub)
    end
    main_text_hub = texts.new('', default_settings, default_settings)

    --Appends the different sections to the main_text_hub
    texts.append(main_text_hub, hub_mode)
	texts.update(main_text_hub, KB)
    --We then do a quick validation
    validateTextInformation()

    --Finally we show this to the user
    main_text_hub:show()
    
end
