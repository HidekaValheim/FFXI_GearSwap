include('organizer-lib')
include('Modes.lua')
require('logger')
require('coroutine')
--Basic hud Settings - styles are full or lite; 
hud_style = 'full'
use_UI = true
hud_x_pos = 1595
hud_x_pos_lite = 1737 
hud_y_pos = 300     
hud_draggable = true
hud_font_size = 9
hud_transparency = 200 
--Must use true fixed-width text formats any other text format will misalign horridly
hud_font = 'Lucida Sans Typewriter'

function get_sets()
    mote_include_version = 2
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

function job_setup()
--Collection of towns where you want to process Porter packer and Organizer when loading the file
	PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}
--Collection of all items you want to include in your inventory when processing the //gs org command
	organizer_items = {
	Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
		NinjaTools={"Shihei"},
		Other="Pet Food Theta",
		PetJugs={"Bubbly Broth","Windy Greens","Meaty Broth","Venomous Broth","Livid Broth"
				,"Lyrical Broth","Dire Broth","Bug-Ridden Broth","Gassy Sap"
				,"Spicy Broth","Tant. Broth", "C. Plasma Broth"},
		Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},

	}
--Load dependent addons that user might not have included in their default load out
	send_command('input //lua l porterpacker') 
	send_command('input //lua l PetProject') 
	send_command('input //send @all lua l superwarp') 
--initializing variables for Pet HUD
	ReadyMoveOne={}
	ReadyMoveTwo={}
	ReadyMoveThree={}
	ReadyMoveFour={}
	ReadyMoveFive={}
	ReadyMoveSix={}
	ReadyMoveSeven={}
	
    PetName = '    '
	PetJob 	= '    '
	PetInfo = '    '
	ReadyMoveOne.Name	= '__________';	ReadyMoveOne.Cost	= '_'; ReadyMoveOne.Type	= '_____'; ReadyMoveOne.Element	 = '_______'; 	ReadyMoveOne.Effect	 = '_______'
	ReadyMoveTwo.Name	= '__________';	ReadyMoveTwo.Cost	= '_'; ReadyMoveTwo.Type	= '_____'; ReadyMoveTwo.Element	 = '_______'; 	ReadyMoveTwo.Effect	 = '_______'
	ReadyMoveThree.Name	= '__________';	ReadyMoveThree.Cost	= '_'; ReadyMoveThree.Type	= '_____'; ReadyMoveThree.Element= '_______'; 	ReadyMoveThree.Effect= '_______'
	ReadyMoveFour.Name	= '__________';	ReadyMoveFour.Cost	= '_'; ReadyMoveFour.Type	= '_____'; ReadyMoveFour.Element = '_______'; 	ReadyMoveFour.Effect = '_______'
	ReadyMoveFive.Name	= '__________';	ReadyMoveFive.Cost	= '_'; ReadyMoveFive.Type	= '_____'; ReadyMoveFive.Element = '_______'; 	ReadyMoveFive.Effect = '_______'
	ReadyMoveSix.Name	= '__________';	ReadyMoveSix.Cost	= '_'; ReadyMoveSix.Type	= '_____'; ReadyMoveSix.Element	 = '_______'; 	ReadyMoveSix.Effect  = '_______'
	ReadyMoveSeven.Name	= '__________';	ReadyMoveSeven.Cost	= '_'; ReadyMoveSeven.Type	= '_____'; ReadyMoveSeven.Element= '_______'; 	ReadyMoveSeven.Effect= '_______'
	
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

--setting up custom states to apply to engaged sets when specific buffs are applied to the character. 
    state.Buff['Aftermath: Lv.3'] = buffactive['Aftermath: Lv.3'] or false
    state.Buff['Killer Instinct'] = buffactive['Killer Instinct'] or false
--Call additional functions to finalize setting up the user file
    pet_info_update()
	init_HUD()
    get_combat_form()
    get_melee_groups()
	get_gear()
end


function user_setup()
--Mote-include modes/states. These are default bound to F9-12 and their CTRL ALT WIN variants. 
    state.OffenseMode:options('Normal','MedAcc','HighAcc','MaxAcc')
    state.WeaponskillMode:options('Normal','MAXBUFFS')
    state.HybridMode:options('Normal','Hybrid','Hybrid2','SubtleBlow','Counter')
    state.CastingMode:options('Normal')
    state.IdleMode:options('Normal', 'Reraise','Regen','Refresh')
    state.RestingMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'PetPDT')
    state.MagicalDefenseMode:options('MDT', 'PetMDT')
    state.CorrelationMode = M{['description']='Correlation Mode', 'Neutral', 'Favorable'}
    state.AxeMode = M{['description']='Axe Mode', 'NoSwaps', 'PetOnly'}
    state.RewardMode = M{['description']='Reward Mode', 'Theta', 'Roborant'}
    state.TreasureMode = M{['description']='Treasure Mode', 'Tag', 'Normal'}
	state.AutoFight=M{'On','Off'}


--Setup Commands for binds, lockstyles and 
	send_command('@wait 8;input /lockstyleset 78')
	
	send_command('bind numpad0 gs c petfight')
	send_command('bind PAGEUP gs c togglehud')
	send_command('bind numpad. gs c cycle AutoFight')
	send_command('bind numpad1 input /bstpet 1')
	send_command('bind numpad2 input /bstpet 2')
	send_command('bind numpad3 input /bstpet 3')
	send_command('bind numpad4 input /bstpet 4')
	send_command('bind numpad5 input /bstpet 5')
	send_command('bind numpad6 input /bstpet 6')
	send_command('bind numpad7 input /bstpet 7')
	
	send_command('bind numpad8 gs c cycle AxeMode')
	send_command('bind numpad9 gs c cycle CorrelationMode')

	send_command('bind numpad/ gs c cycle OffenseMode')
	send_command('bind numpad* gs c cycle WeaponskillMode')
	send_command('bind numpad- gs c cycle HybridMode')
	send_command('bind numpad+ gs c cycle IdleMode')	
--need to implement toggle defense mode sub to allow for one button cycling of defense modes.
--default cycle order is PDT > PETPDT > MDT > PETMDT 	
--	send_command('bind PAGEDOWN gs c toggledefensemode')
	send_command('bind END gs reset DefenseMode')
	send_command('unbind ^r')
	
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

-- List of abilities to reference for applying Treasure Hunter gear.
abilities_to_check = S{'Stutter Step'}

enmity_plus_moves = S{'Provoke','Berserk','Warcry','Aggressor','Holy Circle','Sentinel','Last Resort',
    'Souleater','Vallation','Swordplay'}

	setupTextWindow()
	select_default_macro_book()
end
--[[
function cycle_defense_mode()
	if state.defensemode.value == 'None' then
		state.defensemode ='Physical'	
	elseif state.defensemode.value == 'Physical' and state.PhysicalDefenseMode.value ='PDT'
		state
		
    state.PhysicalDefenseMode:options('PDT', 'PetPDT')
    state.MagicalDefenseMode:options('MDT', 'PetMDT')	
	

end
]]
function select_default_macro_book()
    -- Default macro set/book: (set, book)
    if player.sub_job == 'WAR' then
        set_macro_page(4, 15)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 15)
    elseif player.sub_job == 'DNC' then
        set_macro_page(2, 15)
    else
        set_macro_page(2, 15)
    end
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
	send_command('unbind PAGEUP')
	send_command('unbind END')
	
	send_command('unbind numpad0')
	send_command('unbind numpad.')
	send_command('unbind numpad1')
	send_command('unbind numpad2')
	send_command('unbind numpad3')
	send_command('unbind numpad4')
	send_command('unbind numpad5')
	send_command('unbind numpad6')
	send_command('unbind numpad7')
	
	send_command('unbind numpad8')
	send_command('unbind numpad9')

	send_command('unbind numpad/')
	send_command('unbind numpad*')
	send_command('unbind numpad-')
	send_command('unbind numpad+')

    -- Removes any Text Info Boxes
    send_command('text JugPetText delete')
    send_command('text CorrelationText delete')
    send_command('text AxeModeText delete')
    send_command('text AccuracyText delete')
	send_command('input //lua u PetProject') 
end

-- BST gearsets
function init_gear_sets()
    -------------------------------------------------
    -- AUGMENTED GEAR AND GENERAL GEAR DEFINITIONS --
    -------------------------------------------------
	JSE={}
	JSE.Cape={}
	JSE.Cape.STRWSD={}
	JSE.Cape.STRDA={ name="Artio's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}}
	JSE.Cape.CHRWSD={ name="Artio's Mantle", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','CHR+10','Weapon skill damage +10%',}}
	JSE.Cape.STP={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Phys. dmg. taken-10%',}}
	JSE.Cape.PHYSPET={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Accuracy+3 Pet: Rng. Acc.+3','Pet: Haste+10','System: 1 ID: 1246 Val: 4',}}
	JSE.Cape.MAGPET={ name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Accuracy+3 Pet: Rng. Acc.+3','Pet: Haste+10','System: 1 ID: 1246 Val: 4',}}
	
    Pet_Idle_AxeMain= "Aymur"
    Pet_Idle_AxeSub = "Agwu's Axe"
    Pet_PDT_AxeMain = "Aymur"
    Pet_PDT_AxeSub 	= "Agwu's Axe"
    Pet_MDT_AxeMain = "Aymur"
    Pet_MDT_AxeSub 	= "Agwu's Axe"
    Pet_TP_AxeMain 	= {name="Skullrender", bag="wardrobe1"}
    Pet_TP_AxeSub 	= {name="Skullrender", bag="wardrobe2"}
    Pet_Regen_AxeMain = "Aymur"
    Pet_Regen_AxeSub= "Agwu's Axe"
    Ready_Atk_Axe 	= "Aymur"
    Ready_Atk_Axe2 	= "Agwu's Axe"
    Ready_Atk_TPBonus_Axe 	= "Aymur"
    Ready_Atk_TPBonus_Axe2 	= { name="Kumbhakarna", augments={'Pet: "Mag.Atk.Bns."+20','Pet: Damage taken -4%','Pet: TP Bonus+200',}}
    Ready_Acc_Axe 	= "Arktoi"
    Ready_Acc_Axe2 	= "Agwu's Axe"
    Ready_MAB_Axe	= { name="Kumbhakarna", augments={'Pet: "Mag.Atk.Bns."+20','Pet: Damage taken -4%','Pet: TP Bonus+200',}}
    Ready_MAB_Axe2 	= "Agwu's Axe"
    Ready_MAB_TPBonus_Axe 	= { name="Kumbhakarna", augments={'Pet: "Mag.Atk.Bns."+20','Pet: Damage taken -4%','Pet: TP Bonus+200',}}
    Ready_MAB_TPBonus_Axe2 	= "Agwu's Axe"
    Ready_MAcc_Axe 	= "Aymur"
    Ready_MAcc_Axe2 = "Agwu's Axe"
    Reward_Axe 		= "Aymur"
    Reward_Axe2 	= "Agwu's Axe"
    Ready_DA_Axe 	= "Aymur"
    Ready_DA_Axe2 	= {name="Skullrender", bag="wardrobe2"}
    CB_body 		= "Mirke Wardecors"
    CB_hands 		= "Ankusa Gloves +3"
	
    sets.Enmity = {
		ammo="Sapience Orb",
		head="Halitus Helm",
		body="Emet Harness",
		hands="Macabre Gaunt. +1",
		legs="Zoar Subligar",
		feet="Malignance Boots",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Provocare Ring",
		right_ring="Begrudging Ring",
		back="Reiki Cloak",	
	}

    ---------------------
    -- JA PRECAST SETS --
    ---------------------
    -- Most gearsets are divided into 3 categories:
    -- 1. Default - No Axe swaps involved.
    -- 2. NE (Not engaged) - Axe/Shield swap included, for use with Pet Only mode.
    -- 3. NEDW (Not engaged; Dual-wield) - Axe swaps included, for use with Pet Only mode.

    sets.precast.JA.Familiar = {legs="Ankusa Trousers +3"}
    
	sets.precast.JA['Call Beast']= {head=CB_head,
        body=CB_body,hands=CB_hands,
        legs=CB_legs,feet=CB_feet}
    sets.precast.JA['Bestial Loyalty'] = sets.precast.JA['Call Beast']

    sets.precast.JA.Tame = {head="Totemic Helm +2"}

    sets.precast.JA.Spur = {back="Artio's Mantle",feet="Nukumi Ocreae +1"}
    sets.precast.JA.SpurNE = set_combine(sets.precast.JA.Spur, {main={name="Skullrender", bag="wardrobe1"}})
    sets.precast.JA.SpurNEDW = set_combine(sets.precast.JA.Spur, {main={name="Skullrender", bag="wardrobe1"},sub={name="Skullrender", bag="wardrobe2"}})

    sets.precast.JA['Feral Howl'] = {
		range="Ullr",
		head="Malignance Chapeau",
		body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Chaac Belt",
		left_ear="Handler's Earring",
		right_ear="Handler's Earring +1",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back=JSE.Cape.CHRWSD,	
	}

    sets.precast.JA['Killer Instinct'] = set_combine(sets.Enmity, {head="Ankusa Helm +3"})

    sets.precast.JA.Reward = {
		ammo="Pet Food Theta",
		head="Khimaira Bonnet",--need recast helm
		body="Tot. Jackcoat +2",
		hands="Malignance Gloves",
		legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
		feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear="Handler's Earring",
		right_ear="Handler's Earring +1",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back=JSE.Cape.CHRWSD,	
	}
    
	sets.precast.JA.RewardNE = set_combine(sets.precast.JA.Reward, {main=Reward_Axe,sub="Adapa Shield"})
    sets.precast.JA.RewardNEDW = set_combine(sets.precast.JA.RewardNE, {sub=Reward_Axe2})

    sets.precast.JA.Charm = {
		range="Ullr",
		head="Totemic Helm +2",
		body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
		hands={ name="Ankusa Gloves +3", augments={'Enhances "Beast Affinity" effect',}},
		legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
		feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear="Handler's Earring",
		right_ear="Handler's Earring +1",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Stikini Ring +1",
		back=JSE.Cape.CHRWSD,	
	}
    sets.precast.JA.CharmNE = set_combine(sets.precast.JA.Charm, {main="Dolichenus",sub="Adapa Shield"})
    sets.precast.JA.CharmNEDW = set_combine(sets.precast.JA.CharmNE, {sub="Agwu's Axe"})

    ---------------------------
    -- PET SIC & READY MOVES --
    ---------------------------

    sets.ReadyRecast = {legs="Gleti's Breeches"}
    sets.midcast.Pet.TPBonus = {hands="Nukumi Manoplas +1"}
    sets.midcast.Pet.Neutral = {head=Ready_Atk_head}
    sets.midcast.Pet.Favorable = {head="Nukumi Cabasset +1"}

    sets.midcast.Pet.Normal = {
		ammo="Hesperiidae",
		head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Dbl. Atk."+5','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Attack+11 Pet: Rng.Atk.+11',}},
		body={ name="Valorous Mail", augments={'Pet: Attack+29 Pet: Rng.Atk.+29','Pet: "Dbl.Atk."+2 Pet: Crit.hit rate +2','Pet: STR+7','Pet: Accuracy+14 Pet: Rng. Acc.+14',}},
		hands={ name="Emicho Gauntlets", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
		legs="Tot. Trousers +2",
		feet="Gleti's Boots",
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear="Kyrene's Earring",
		right_ear="Hija Earring",
		left_ring="Varar Ring +1",
		right_ring="C. Palug Ring",
		back=JSE.Cape.MAGPET
	}

    sets.midcast.Pet.MedAcc = set_combine(sets.midcast.Pet.Normal, {})
    sets.midcast.Pet.HighAcc = set_combine(sets.midcast.Pet.Normal, {})
    sets.midcast.Pet.MaxAcc = set_combine(sets.midcast.Pet.Normal, {})

    sets.midcast.Pet.MagicAtkReady = {}

    sets.midcast.Pet.MagicAtkReady.Normal = {
		ammo="Hesperiidae",
		head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+21','"Dbl.Atk."+3','Pet: INT+8','Pet: Accuracy+3 Pet: Rng. Acc.+3',}},
		body={ name="Valorous Mail", augments={'Pet: "Mag.Atk.Bns."+23','Pet: INT+8','Pet: Attack+3 Pet: Rng.Atk.+3',}},
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet={ name="Valorous Greaves", augments={'Pet: "Mag.Atk.Bns."+27','Pet: INT+14','Pet: Accuracy+11 Pet: Rng. Acc.+11','Pet: Attack+15 Pet: Rng.Atk.+15',}},
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear="Kyrene's Earring",
		right_ear="Hija Earring",
		left_ring="Tali'ah Ring",
		right_ring="C. Palug Ring",
		back=JSE.Cape.MAGPET
	}

    sets.midcast.Pet.MagicAtkReady.MedAcc = set_combine(sets.midcast.Pet.MagicAtkReady.Normal, {})
    sets.midcast.Pet.MagicAtkReady.HighAcc = set_combine(sets.midcast.Pet.MagicAtkReady.Normal, {})
    sets.midcast.Pet.MagicAtkReady.MaxAcc = set_combine(sets.midcast.Pet.MagicAtkReady.Normal, {})

    sets.midcast.Pet.MagicAccReady = {
		ammo="Hesperiidae",
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear="Kyrene's Earring",
		right_ear="Handler's Earring +1",
		left_ring="Tali'ah Ring",
		right_ring="C. Palug Ring",
		back=JSE.Cape.MAGPET
	}

    sets.midcast.Pet.MultiStrike = set_combine(sets.midcast.Pet.Normal, {})
    sets.midcast.Pet.Buff = set_combine(sets.midcast.Pet.TPBonus, {})

    --------------------------------------
    -- SINGLE WIELD PET-ONLY READY SETS --
    --------------------------------------

    -- Physical Ready Attacks w/o TP Modifier for Damage (ex. Sickle Slash, Whirl Claws, Swooping Frenzy, etc.)
    sets.midcast.Pet.ReadyNE = {}
    sets.midcast.Pet.ReadyNE.Normal = set_combine(sets.midcast.Pet.Normal, {main=Ready_Atk_Axe})
    sets.midcast.Pet.ReadyNE.MedAcc = set_combine(sets.midcast.Pet.MedAcc, {main=Ready_Atk_Axe})
    sets.midcast.Pet.ReadyNE.HighAcc = set_combine(sets.midcast.Pet.HighAcc, {main=Ready_Atk_Axe})
    sets.midcast.Pet.ReadyNE.MaxAcc = set_combine(sets.midcast.Pet.MaxAcc, {main=Ready_Acc_Axe})

    -- Physical TP Bonus Ready Attacks (ex. Razor Fang, Tegmina Buffet, Tail Blow, Recoil Dive, etc.)
    sets.midcast.Pet.ReadyNE.TPBonus = {}
    sets.midcast.Pet.ReadyNE.TPBonus.Normal = set_combine(sets.midcast.Pet.ReadyNE.Normal, {main=Ready_Atk_TPBonus_Axe})
    sets.midcast.Pet.ReadyNE.TPBonus.MedAcc = set_combine(sets.midcast.Pet.ReadyNE.MedAcc, {main=Ready_Atk_TPBonus_Axe})
    sets.midcast.Pet.ReadyNE.TPBonus.HighAcc = set_combine(sets.midcast.Pet.ReadyNE.HighAcc, {main=Ready_Atk_TPBonus_Axe})
    sets.midcast.Pet.ReadyNE.TPBonus.MaxAcc = set_combine(sets.midcast.Pet.ReadyNE.MaxAcc, {main=Ready_Acc_Axe})

    -- Multihit Ready Attacks w/o TP Modifier for Damage (Pentapeck, Chomp Rush)
    sets.midcast.Pet.MultiStrikeNE = set_combine(sets.midcast.Pet.MultiStrike, {main=Ready_Atk_Axe2})

    -- Multihit TP Bonus Ready Attacks (Sweeping Gouge, Tickling Tendrils, Pecking Flurry, Wing Slap)
    sets.midcast.Pet.MultiStrikeNE.TPBonus = set_combine(sets.midcast.Pet.MultiStrike, {main=Ready_Atk_TPBonus_Axe})

    -- Magical Ready Attacks w/o TP Modifier for Damage (ex. Molting Plumage, Venom, Stink Bomb, etc.)
    sets.midcast.Pet.MagicAtkReadyNE = {}
    sets.midcast.Pet.MagicAtkReadyNE.Normal = set_combine(sets.midcast.Pet.MagicAtkReady.Normal, {main=Ready_MAB_Axe})
    sets.midcast.Pet.MagicAtkReadyNE.MedAcc = set_combine(sets.midcast.Pet.MagicAtkReady.MedAcc, {main=Ready_MAB_Axe})
    sets.midcast.Pet.MagicAtkReadyNE.HighAcc = set_combine(sets.midcast.Pet.MagicAtkReady.HighAcc, {main=Ready_MAB_Axe})
    sets.midcast.Pet.MagicAtkReadyNE.MaxAcc = set_combine(sets.midcast.Pet.MagicAtkReady.MaxAcc, {main=Ready_MAcc_Axe2})

    -- Magical TP Bonus Ready Attacks (ex. Fireball, Cursed Sphere, Corrosive Ooze, etc.)
    sets.midcast.Pet.MagicAtkReadyNE.TPBonus = {}
    sets.midcast.Pet.MagicAtkReadyNE.TPBonus.Normal = set_combine(sets.midcast.Pet.MagicAtkReadyNE.Normal, {main=Ready_MAB_TPBonus_Axe})
    sets.midcast.Pet.MagicAtkReadyNE.TPBonus.MedAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MedAcc, {main=Ready_MAB_TPBonus_Axe})
    sets.midcast.Pet.MagicAtkReadyNE.TPBonus.HighAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.HighAcc, {main=Ready_MAB_TPBonus_Axe})
    sets.midcast.Pet.MagicAtkReadyNE.TPBonus.MaxAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MaxAcc, {main=Ready_MAcc_Axe2})

    -- Magical Ready Enfeebles (ex. Roar, Sheep Song, Infrasonics, etc.)
    sets.midcast.Pet.MagicAccReadyNE = set_combine(sets.midcast.Pet.MagicAccReady, {main="Agwu's Axe"})

    -- Pet Buffs/Cures (Bubble Curtain, Scissor Guard, Secretion, Rage, Rhino Guard, Zealous Snort, Wild Carrot)
    sets.midcast.Pet.BuffNE = set_combine(sets.midcast.Pet.Buff, {main=Ready_Atk_TPBonus_Axe})

    -- Axe Swaps for when Pet TP is above a certain value.
    sets.UnleashAtkAxeShield = {}
    sets.UnleashAtkAxeShield.Normal = {main=Ready_Atk_Axe}
    sets.UnleashAtkAxeShield.MedAcc = {main=Ready_Atk_Axe}
    sets.UnleashAtkAxeShield.HighAcc = {main=Ready_Atk_Axe}
    sets.UnleashMultiStrikeAxeShield = {main=Ready_DA_Axe}

    sets.UnleashMABAxeShield = {}
    sets.UnleashMABAxeShield.Normal = {main=Ready_MAB_Axe}
    sets.UnleashMABAxeShield.MedAcc = {main=Ready_MAB_Axe}
    sets.UnleashMABAxeShield.HighAcc = {main=Ready_MAB_Axe}

    ------------------------------------
    -- DUAL WIELD PET-ONLY READY SETS --
    ------------------------------------

    -- DW Axe Swaps for Physical Ready Attacks w/o TP Modifier for Damage (ex. Sickle Slash, Whirl Claws, Swooping Frenzy, etc.)
    sets.midcast.Pet.ReadyDWNE = {}
    sets.midcast.Pet.ReadyDWNE.Normal = set_combine(sets.midcast.Pet.ReadyNE.Normal, {main=Ready_Atk_Axe,sub=Ready_Atk_Axe2})
    sets.midcast.Pet.ReadyDWNE.MedAcc = set_combine(sets.midcast.Pet.ReadyNE.MedAcc, {main=Ready_Atk_Axe,sub=Ready_Acc_Axe})
    sets.midcast.Pet.ReadyDWNE.HighAcc = set_combine(sets.midcast.Pet.ReadyNE.HighAcc, {main=Ready_Atk_Axe,sub=Ready_Acc_Axe})
    sets.midcast.Pet.ReadyDWNE.MaxAcc = set_combine(sets.midcast.Pet.ReadyNE.MaxAcc, {main=Ready_Acc_Axe,sub=Ready_Acc_Axe2})

    -- DW Axe Swaps for Physical TP Bonus Ready Attacks (ex. Razor Fang, Tegmina Buffet, Tail Blow, Recoil Dive, etc.)
    sets.midcast.Pet.ReadyDWNE.TPBonus = {}
    sets.midcast.Pet.ReadyDWNE.TPBonus.Normal = set_combine(sets.midcast.Pet.ReadyNE.Normal, {main=Ready_Atk_TPBonus_Axe,sub=Ready_Atk_Axe2})
    sets.midcast.Pet.ReadyDWNE.TPBonus.MedAcc = set_combine(sets.midcast.Pet.ReadyNE.MedAcc, {main=Ready_Atk_TPBonus_Axe,sub=Ready_Acc_Axe2})
    sets.midcast.Pet.ReadyDWNE.TPBonus.HighAcc = set_combine(sets.midcast.Pet.ReadyNE.HighAcc, {main=Ready_Atk_TPBonus_Axe,sub=Ready_Acc_Axe2})
    sets.midcast.Pet.ReadyDWNE.TPBonus.MaxAcc = set_combine(sets.midcast.Pet.ReadyNE.MaxAcc, {main=Ready_Acc_Axe,sub=Ready_Acc_Axe2})

    -- DW Axe Swaps for Multihit Ready Attacks w/o TP Modifier for Damage (Pentapeck, Chomp Rush)
    sets.midcast.Pet.MultiStrikeDWNE = set_combine(sets.midcast.Pet.MultiStrikeNE, {main=Ready_Atk_Axe,sub=Ready_Atk_Axe2})

    -- DW Axe Swaps for Multihit TP Bonus Ready Attacks (Sweeping Gouge, Tickling Tendrils, Pecking Flurry, Wing Slap)
    sets.midcast.Pet.MultiStrikeDWNE.TPBonus = set_combine(sets.midcast.Pet.MultiStrikeNE, {main=Ready_Atk_TPBonus_Axe,sub=Ready_Atk_TPBonus_Axe2})

    -- DW Axe Swaps for Magical Ready Attacks w/o TP Modifier for Damage (ex. Molting Plumage, Stink Bomb, Venom, etc.)
    sets.midcast.Pet.MagicAtkReadyDWNE = {}
    sets.midcast.Pet.MagicAtkReadyDWNE.Normal = set_combine(sets.midcast.Pet.MagicAtkReadyNE.Normal, {main=Ready_MAB_Axe,sub=Ready_MAB_Axe2})
    sets.midcast.Pet.MagicAtkReadyDWNE.MedAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MedAcc, {main=Ready_MAB_Axe,sub=Ready_MAB_Axe2})
    sets.midcast.Pet.MagicAtkReadyDWNE.HighAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.HighAcc, {main=Ready_MAB_Axe,sub=Ready_MAcc_Axe})
    sets.midcast.Pet.MagicAtkReadyDWNE.MaxAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MaxAcc, {main=Ready_MAB_Axe,sub=Ready_MAcc_Axe})

    -- DW Axe Swaps for Magical TP Bonus Ready Attacks (ex. Fireball, Cursed Sphere, Corrosive Ooze, etc.)
    sets.midcast.Pet.MagicAtkReadyDWNE.TPBonus = {}
    sets.midcast.Pet.MagicAtkReadyDWNE.TPBonus.Normal = set_combine(sets.midcast.Pet.MagicAtkReadyNE.Normal, {main=Ready_MAB_TPBonus_Axe,sub=Ready_MAB_TPBonus_Axe2})
    sets.midcast.Pet.MagicAtkReadyDWNE.TPBonus.MedAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MedAcc, {main=Ready_MAB_TPBonus_Axe,sub=Ready_MAB_TPBonus_Axe2})
    sets.midcast.Pet.MagicAtkReadyDWNE.TPBonus.HighAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.HighAcc, {main=Ready_MAB_TPBonus_Axe,sub=Ready_MAB_TPBonus_Axe2})
    sets.midcast.Pet.MagicAtkReadyDWNE.TPBonus.MaxAcc = set_combine(sets.midcast.Pet.MagicAtkReadyNE.MaxAcc, {main=Ready_MAB_Axe,sub=Ready_MAcc_Axe})

    -- DW Axe Swaps for Magical Ready Enfeebles (ex. Roar, Sheep Song, Infrasonics, etc.)
    sets.midcast.Pet.MagicAccReadyDWNE = set_combine(sets.midcast.Pet.MagicAccReadyNE, {main="Dolichenus",sub="Agwu's Axe"})

    -- DW Axe Swaps for Pet Buffs/Cures (Bubble Curtain, Scissor Guard, Secretion, Rage, Rhino Guard, Zealous Snort, Wild Carrot)
    sets.midcast.Pet.BuffDWNE = set_combine(sets.midcast.Pet.BuffNE, {main=Ready_Atk_TPBonus_Axe,sub=Ready_MAB_TPBonus_Axe})

    -- Axe Swaps for when Pet TP is above a certain value.
    sets.UnleashAtkAxes = {}
    sets.UnleashAtkAxes.Normal = {main=Ready_Atk_Axe,sub=Ready_Atk_Axe2}
    sets.UnleashAtkAxes.MedAcc = {main=Ready_Atk_Axe,sub=Ready_Atk_Axe2}
    sets.UnleashAtkAxes.HighAcc = {main=Ready_Atk_Axe,sub=Ready_Atk_Axe2}
    sets.UnleashMultiStrikeAxes = {main=Ready_DA_Axe,sub=Ready_DA_Axe2}

    sets.UnleashMABAxes = {}
    sets.UnleashMABAxes.Normal = {main=Ready_MAB_Axe,sub=Ready_MAB_Axe2}
    sets.UnleashMABAxes.MedAcc = {main=Ready_MAB_Axe,sub=Ready_MAB_Axe2}
    sets.UnleashMABAxes.HighAcc = {main=Ready_MAB_Axe,sub=Ready_MAB_Axe2}

    ---------------
    -- IDLE SETS --
    ---------------

    sets.idle = {
		ammo="Staunch Tathlum",
		head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Dbl. Atk."+5','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Attack+11 Pet: Rng.Atk.+11',}},
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck="Loricate Torque +1",
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring", bag="wardrobe2"},
		right_ring={name="Moonlight Ring", bag="wardrobe7"},
		back=JSE.Cape.STP,	
	}

    sets.idle.Refresh = set_combine(sets.idle, {head="Jumalik Helm",ring1="Stikini Ring +1",ring2="Stikini Ring +1"})
	sets.idle.Regen={
		ammo="Staunch Tathlum",
		head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Dbl. Atk."+5','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Attack+11 Pet: Rng.Atk.+11',}},
		body="Sacro Breastplate",
		hands="Meg. Gloves +2",
		legs="Meg. Chausses +2",
		feet="Gleti's Boots",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring={name="Chirich Ring +1", bag="wardrobe2"},
		right_ring={name="Chirich Ring +1", bag="wardrobe7"},
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Phys. dmg. taken-10%',}},	
	}
    sets.idle.Reraise = set_combine(sets.idle, {})

    sets.idle.Pet = set_combine(sets.idle, {back=Pet_Regen_back})

    sets.idle.Pet.Engaged = {    
		ammo="Hesperiidae",
		head="Tali'ah Turban +2",
		body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
		hands={ name="Emicho Gauntlets", augments={'Pet: Accuracy+15','Pet: Attack+15','Pet: "Dbl. Atk."+3',}},
		legs={ name="Ankusa Trousers +3", augments={'Enhances "Familiar" effect',}},
		feet="Gleti's Boots",
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Asklepian Belt",
		left_ear="Hija Earring",
		right_ear="Enmerkar Earring",
		left_ring={name="Varar Ring +1", bag="wardrobe2"},
		right_ring={name="Varar Ring +1", bag="wardrobe7"},
		back=JSE.Cape.MAGPET
	}

    sets.idle.Pet.Engaged.PetSBMNK = set_combine(sets.idle.Pet.Engaged, {
        --ear1="Gelai Earring",body=Pet_SB_body,
        waist="Isa Belt"})

    sets.idle.Pet.Engaged.PetSBNonMNK = set_combine(sets.idle.Pet.Engaged, {
        --ear1="Gelai Earring",body=Pet_SB_body,
        waist="Isa Belt"})

    sets.idle.Pet.Engaged.PetSTP = set_combine(sets.idle.Pet.Engaged, {})
    sets.resting = {}

    ------------------
    -- DEFENSE SETS --
    ------------------

    -- Pet PDT and MDT sets:
    sets.defense.PetPDT = {
		ammo="Hesperiidae",
		head="Anwig Salade",
		body="Tot. Jackcoat +2",
		hands="Gleti's Gauntlets",
		legs="Tali'ah Sera. +2",
		feet={ name="Ankusa Gaiters +3", augments={'Enhances "Beast Healer" effect',}},
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Isa Belt",
		left_ear="Handler's Earring +1",
		right_ear="Enmerkar Earring",
		left_ring="Varar Ring +1",
		right_ring="Varar Ring +1",
		back=JSE.Cape.PHYSPET,	
	}

    sets.defense.PetMDT = set_combine(sets.defense.PetPDT,{})

    -- Master PDT and MDT sets:
    sets.defense.PDT = {
		ammo="Staunch Tathlum",
        head="Gleti's Mask",
		neck="Loricate Torque +1",
		ear1="Tuisto Earring",
		ear2="Odnowa Earring +1",
        body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		ring1="Moonlight Ring",
		ring2="Warden's Ring",
        back="Moonbeam Cape",
		waist="Flume Belt",
		legs="Gleti's Breeches",
		feet="Gleti's Boots"}

    sets.defense.Reraise = set_combine(sets.defense.PDT, {})

    sets.defense.HybridPDT = {
		ammo="Staunch Tathlum",
		head="Anwig Salade",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Tali'ah Sera. +2",
		feet="Gleti's Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Tuisto Earring",
		right_ear="Handler's Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Defending Ring",
		back=JSE.Cape.MAGPET,
	}

    sets.defense.MDT = {
		ammo="Staunch Tathlum",
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck="Loricate Torque +1",
		waist="Asklepian Belt",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Defending Ring",
		back=JSE.Cape.MAGPET,
	}

    sets.defense.MEva = {
		ammo="Staunch Tathlum",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Gleti's Gauntlets",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Defending Ring",
		back=JSE.Cape.MAGPET,
		
	}
	
    sets.defense.Killer = {
		ammo="Staunch Tathlum",
        head="Ankusa Helm +3",
		neck="Loricate Torque +1",
		ear1="Tuisto Earring",
		ear2="Odnowa Earring +1",
        body="Nukumi Gausape +1",
		hands="Malignance Gloves",
		ring1="Moonlight Ring",
		ring2="Defending Ring",
        back=JSE.Cape.STP ,
		waist="Flume Belt",
		legs="Malignance Tights",
		feet="Malignance Boots"
	}

    sets.Kiting = {feet="Skadi's Jambeaux +1"}

    -------------------------------------------------------
    -- Single-wield Pet Only Mode Idle/Defense Axe Swaps --
    -------------------------------------------------------

    sets.idle.NE = set_combine(sets.idle,{main="Dolichenus",sub="Adapa Shield"})

    sets.idle.NE.PetEngaged = set_combine(sets.idle.PetEngaged,{main="Skullrender",sub="Adapa Shield"})

    --sets.idle.NE.PetRegen = {main=Pet_Regen_AxeMain,sub="Sacro Bulwark",
    --    neck="Empath Necklace",
    --    feet=Pet_Regen_feet}

    sets.defense.NE = {}

    sets.defense.NE.PDT = set_combine(sets.defense.PDT,{main="Dolichenus",sub="Adapa Shield"})
    sets.defense.NE.MDT = set_combine(sets.defense.MDT,{main="Dolichenus",sub="Adapa Shield"})
    sets.defense.NE.MEva = set_combine(sets.defense.MEva,{main="Dolichenus",sub="Adapa Shield"})
    sets.defense.NE.Killer = set_combine(sets.defense.Killer,{main="Arktoi",sub="Adapa Shield"})
    sets.defense.NE.PetPDT = set_combine(sets.defense.PetPDT,{main="Kumbhakarna",sub="Adapa Shield"})
    sets.defense.NE.PetMDT = set_combine(sets.defense.PetMDT,{main="Kumbhakarna",sub="Adapa Shield"})

    -----------------------------------------------------
    -- Dual-wield Pet Only Mode Idle/Defense Axe Swaps --
    -----------------------------------------------------

    sets.idle.DWNE = set_combine(sets.idle,{main="Aymur",sub="Agwu's Axe"})

    sets.idle.DWNE.PetEngaged = set_combine(sets.idle.PetEngaged,{main={name="Skullrender",bag="wardrobe1"},sub={name="Skullrender",bag="wardrobe2"}})
	
	sets.defense.DWNE = {}

    sets.defense.DWNE.PDT = set_combine(sets.defense.PDT,{main="Dolichenus",sub="Agwu's Axe"})
    sets.defense.DWNE.MDT = set_combine(sets.defense.MDT ,{main="Dolichenus",sub="Agwu's Axe"})
    sets.defense.DWNE.MEva = set_combine(sets.defense.MEva,{main="Dolichenus",sub="Agwu's Axe"})
    sets.defense.DWNE.Killer = set_combine(sets.defense.Killer,{main="Arktoi",sub="Agwu's Axe"})
    sets.defense.DWNE.PetPDT = set_combine(sets.defense.PetPDT ,{main="Kumbhakarna",sub="Agwu's Axe"})
    sets.defense.DWNE.PetMDT = set_combine(sets.defense.PetMDT ,{main="Kumbhakarna",sub="Agwu's Axe"})

    --------------------
    -- FAST CAST SETS --
    --------------------

    sets.precast.FC = {
		ammo="Sapience Orb",
		head="Malignance Chapeau",
		body={ name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Orunmila's Torque",
		waist="Asklepian Belt",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Rahab Ring",
		right_ring="Defending Ring",
		back=JSE.Cape.STP,	
	}

    sets.precast.FCNE = set_combine(sets.precast.FC, {})
    sets.precast.FC["Utsusemi: Ichi"] = set_combine(sets.precast.FC, {neck="Magoraga Beads"})
    sets.precast.FC["Utsusemi: Ni"] = set_combine(sets.precast.FC, {ammo="Impatiens",neck="Magoraga Beads",ring1="Lebeche Ring"})

    ------------------
    -- MIDCAST SETS --
    ------------------

    sets.midcast.FastRecast = set_combine(sets.precast.FC,{})
    sets.midcast.Cure = {}
    sets.midcast.Curaga = sets.midcast.Cure
    sets.CurePetOnly = {}
    sets.midcast.Stoneskin = {}
    sets.midcast.Cursna = set_combine(sets.midcast.FastRecast, {ring1="Purity Ring",waist="Gishdubar Sash"})
    sets.midcast.Protect = {ring2="Sheltered Ring"}
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = {ring2="Sheltered Ring"}
    sets.midcast.Shellra = sets.midcast.Shell
    sets.midcast['Enfeebling Magic'] = {}
    sets.midcast['Elemental Magic'] = {}

    sets.midcast.Flash = sets.Enmity

    -------------------------------
    -- Master Engaged Melee Sets --
    -------------------------------
	
	sets.dw11 = {ear2="Eabani Earring",waist="Reiki Yotai"}

    sets.engaged = {    
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Skormoth Mask",
		body="Tali'ah Manteel +2",
		hands="Malignance Gloves",
		legs="Meg. Chausses +2",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Petrov Ring",
		right_ring="Epona's Ring",
		back=JSE.Cape.STP,
	}
	
    sets.engaged.MedAcc		= set_combine(sets.engaged,{left_ring={name="Chirich Ring +1",bag="wardrobe2"},right_ring={name="Chirich Ring +1",bag="wardrobe7"}})
    sets.engaged.HighAcc 	= set_combine(sets.engaged.MedAcc,{neck="Bst. Collar +2",})
    sets.engaged.MaxAcc	 	= set_combine(sets.engaged.HighAcc,{})
	sets.engaged.DW			= set_combine(sets.engaged, sets.dw11, 		  {})
    sets.engaged.DW.MedAcc 	= set_combine(sets.engaged.MedAcc ,sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.HighAcc = set_combine(sets.engaged.HighAcc,sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.MaxAcc 	= set_combine(sets.engaged.MaxAcc,sets.dw11,  {neck="Bst. Collar +2",})
 
    sets.engaged.Hybrid = set_combine(sets.engaged,{
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		left_ring={name="Moonlight Ring", bag="wardrobe2"},
		right_ring={name="Moonlight Ring", bag="wardrobe7"},
	})
	
	sets.engaged.MedAcc.Hybrid 		= set_combine(sets.engaged.Hybrid,{neck="Bst. Collar +2",})
    sets.engaged.HighAcc.Hybrid 	= set_combine(sets.engaged.MedAcc.Hybrid,{})
    sets.engaged.MaxAcc.Hybrid 		= set_combine(sets.engaged.HighAcc.Hybrid,{})
	sets.engaged.DW.Hybrid			= set_combine(sets.engaged.Hybrid,sets.dw11, 	{})
    sets.engaged.DW.MedAcc.Hybrid 	= set_combine(sets.engaged.DW.Hybrid,sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.HighAcc.Hybrid 	= set_combine(sets.engaged.DW.Hybrid,sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.MaxAcc.Hybrid 	= set_combine(sets.engaged.DW.Hybrid,sets.dw11, {neck="Bst. Collar +2",})	
	
    sets.engaged.Hybrid2 = {    
		ammo="Staunch Tathlum",
		head="Anwig Salade",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Tali'ah Sera. +2",
		feet="Gleti's Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Sherida Earring",
		right_ear="Enmerkar Earring",
		left_ring="Moonlight Ring",
		right_ring="Defending Ring",
		back=JSE.Cape.MAGPET,
	}
	sets.engaged.MedAcc.Hybrid2 	= set_combine(sets.engaged.Hybrid2,{neck="Bst. Collar +2",})
    sets.engaged.HighAcc.Hybrid2	= set_combine(sets.engaged.MedAcc.Hybrid2,{})
    sets.engaged.MaxAcc.Hybrid2		= set_combine(sets.engaged.HighAcc.Hybrid2,{})
	sets.engaged.DW.Hybrid2			= set_combine(sets.engaged.Hybrid2,sets.dw11,    {})
    sets.engaged.DW.MedAcc.Hybrid2 	= set_combine(sets.engaged.DW.Hybrid2,sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.HighAcc.Hybrid2	= set_combine(sets.engaged.DW.Hybrid2,sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.MaxAcc.Hybrid2 	= set_combine(sets.engaged.DW.Hybrid2,sets.dw11, {neck="Bst. Collar +2",})
	
    sets.engaged.SubtleBlow = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Malignance Chapeau",
		body="Sacro Breastplate",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Brutal Earring",
		left_ring={name="Chirich Ring +1", bag="wardrobe2"},
		right_ring={name="Chirich Ring +1", bag="wardrobe7"},
		back=JSE.Cape.STP,	
	}
	sets.engaged.MedAcc.SubtleBlow 		= set_combine(sets.engaged.SubtleBlow,{neck="Bst. Collar +2",})
    sets.engaged.HighAcc.SubtleBlow 	= set_combine(sets.engaged.MedAcc.SubtleBlow,{})
    sets.engaged.MaxAcc.SubtleBlow 		= set_combine(sets.engaged.HighAcc.SubtleBlow,{})
    sets.engaged.DW.SubtleBlow 			= set_combine(sets.engaged.SubtleBlow,sets.dw11, 	{})
    sets.engaged.DW.MedAcc.SubtleBlow 	= set_combine(sets.engaged.DW.SubtleBlow,sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.HighAcc.SubtleBlow 	= set_combine(sets.engaged.DW.SubtleBlow,sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.MaxAcc.SubtleBlow 	= set_combine(sets.engaged.DW.SubtleBlow,sets.dw11, {neck="Bst. Collar +2",})	
	
    sets.engaged.Counter = {
		ammo="Amar Cluster",
		head="Malignance Chapeau",
		body="Sacro Breastplate",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Windbuffet Belt +1",
		left_ear="Genmei Earring",
		right_ear="Cryptic Earring",
		left_ring="Defending Ring",
		right_ring="Epona's Ring",
		back=JSE.Cape.STP,	
	}
	sets.engaged.MedAcc.Counter 	= set_combine(sets.engaged.Counter,{})
    sets.engaged.HighAcc.Counter 	= set_combine(sets.engaged.MedAcc.Counter,{})
    sets.engaged.MaxAcc.Counter 	= set_combine(sets.engaged.HighAcc.Counter,	{})
    sets.engaged.DW.Counter 		= set_combine(sets.engaged.Counter,sets.dw11, {left_ring={name="Moonlight Ring", bag="wardrobe2"},right_ring={name="Moonlight Ring", bag="wardrobe7"},})
    sets.engaged.DW.MedAcc.Counter 	= set_combine(sets.engaged.DW.Counter,sets.dw11, {})
    sets.engaged.DW.HighAcc.Counter = set_combine(sets.engaged.DW.Counter,sets.dw11, {})
    sets.engaged.DW.MaxAcc.Counter 	= set_combine(sets.engaged.DW.Counter,sets.dw11, {})
	
    sets.engaged.Farsha = {}
    sets.engaged.MedAcc.Farsha 		= set_combine(sets.engaged.Farsha, {neck="Bst. Collar +2",})
    sets.engaged.HighAcc.Farsha		= set_combine(sets.engaged.Farsha, {neck="Bst. Collar +2",})
    sets.engaged.MaxAcc.Farsha 		= set_combine(sets.engaged.Farsha, {neck="Bst. Collar +2",})	
    sets.engaged.DW.Farsha 		 	= set_combine(sets.engaged.Farsha, sets.dw11, {})
    sets.engaged.DW.MedAcc.Farsha 	= set_combine(sets.engaged.DW.Farsha, sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.HighAcc.Farsha	= set_combine(sets.engaged.DW.Farsha, sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.MaxAcc.Farsha 	= set_combine(sets.engaged.DW.Farsha, sets.dw11, {neck="Bst. Collar +2",})
	
	sets.engaged.Aftermath = {    
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Anu Torque",
		waist="Reiki Yotai",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring={name="Moonlight Ring", bag="wardrobe2"},
		right_ring={name="Moonlight Ring", bag="wardrobe7"},
		back=JSE.Cape.STP,
	}
	
    sets.engaged.MedAcc.Aftermath 		= set_combine(sets.engaged.Aftermath, {neck="Bst. Collar +2",})
    sets.engaged.HighAcc.Aftermath		= set_combine(sets.engaged.Aftermath, {neck="Bst. Collar +2",})
    sets.engaged.MaxAcc.Aftermath 		= set_combine(sets.engaged.Aftermath, {neck="Bst. Collar +2",})	
    sets.engaged.DW.Aftermath 		 	= set_combine(sets.engaged.Aftermath,sets.dw11,    {})
    sets.engaged.DW.MedAcc.Aftermath 	= set_combine(sets.engaged.DW.Aftermath,sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.HighAcc.Aftermath	= set_combine(sets.engaged.DW.Aftermath,sets.dw11, {neck="Bst. Collar +2",})
    sets.engaged.DW.MaxAcc.Aftermath 	= set_combine(sets.engaged.DW.Aftermath,sets.dw11, {neck="Bst. Collar +2",})
	
    sets.engaged.DW.KrakenClub = {}

    --------------------
    -- MASTER WS SETS --
    --------------------

    -- AXE WSs --
    sets.precast.WS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Totemic Gloves +2",
		legs="Nyame Flanchard",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back=JSE.Cape.STRDA,	
	}

    sets.precast.WS['Rampage'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
		hands={ name="Lustr. Mittens +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back=JSE.Cape.STRDA,	
	}
	sets.precast.WS['Rampage'].MAXBUFFS={
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Brutal Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back=JSE.Cape.STRDA,	
	}
    sets.precast.WS['Calamity'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Totemic Gloves +2",
		legs="Gleti's Breeches",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back=JSE.Cape.STRDA,	
	}
    sets.precast.WS['Mistral Axe'] = set_combine(sets.precast.WS['Calamity'] ,{})
    sets.precast.WS['Bora Axe'] = set_combine(sets.precast.WS['Calamity'] ,{})
    sets.precast.WS['Decimation'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
		hands={ name="Lustr. Mittens +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back=JSE.Cape.STRDA,	
	}
    sets.precast.WS['Decimation'].MAXBUFFS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Brutal Earring",
		left_ring="Epona's Ring",
		right_ring="Gere Ring",
		back=JSE.Cape.STRDA,	
	}
    sets.precast.WS['Ruinator'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="An. Jackcoat +3", augments={'Enhances "Feral Howl" effect',}},
		hands={ name="Lustr. Mittens +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
		feet={ name="Lustra. Leggings +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Lugra Earring +1", augments={'Path: A',}},
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back=JSE.Cape.STRDA,
	}
    sets.precast.WS['Ruinator'].MAXBUFFS = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Brutal Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Gere Ring",
		back=JSE.Cape.STRDA,	
	}
    sets.precast.WS['Ruinator'].Gavialis = set_combine(sets.precast.WS['Ruinator'], {head="Gavialis Helm"})
    sets.precast.WS['Onslaught'] = {}
    sets.precast.WS['Primal Rend'] = {
		ammo="Pemphredo Tathlum",
		head={ name="Ankusa Helm +3", augments={'Enhances "Killer Instinct" effect',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Friomisi Earring",
		left_ring="Weather. Ring",
		right_ring="Epaminondas's Ring",
		back=JSE.Cape.CHRWSD,	
	}

    sets.precast.WS['Cloudsplitter'] = set_combine(sets.precast.WS['Primal Rend'],{head="Nyame Helm", left_ring="Shiva Ring +1"})
	
    -- DAGGER WSs --
    sets.precast.WS['Evisceration'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Thereoid Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Mache Earring +1",
		left_ring="Regal Ring",
		right_ring="Ilabrat Ring",
		back=JSE.Cape.STP,	
	}

    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS['Primal Rend'],{})

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS['Decimation'],{})
    sets.precast.WS['Exenterator'].Gavialis = set_combine(sets.precast.WS['Exenterator'], {head="Gavialis Helm"})

    -- SWORD WSs --
    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS['Calamity'] ,{})

    -- SCYTHE WSs --
    sets.precast.WS['Spiral Hell'] = {}

    sets.precast.WS['Cross Reaper'] = {}

    sets.precast.WS['Entropy'] = {}

    sets.midcast.ExtraMAB = {ear1="Hecate's Earring"}
    sets.midcast.ExtraWSDMG = {ear1="Ishvara Earring"}

    ----------------
    -- OTHER SETS --
    ----------------

    --Precast Gear Sets for DNC subjob abilities:
    sets.precast.Waltz = {
		ammo="Staunch Tathlum",
		head={ name="Anwig Salade", augments={'Attack+3','Pet: Damage taken -10%','CHR+4','"Waltz" ability delay -2',}},
		body="Gleti's Cuirass",
		hands={ name="Ankusa Gloves +3", augments={'Enhances "Beast Affinity" effect',}},
		legs="Dashing Subligar",
		feet="Malignance Boots",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Chaac Belt",
		left_ear="Handler's Earring",
		right_ear="Handler's Earring +1",
		left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Moonlight Ring",
		back={ name="Artio's Mantle", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','CHR+10','Weapon skill damage +10%',}},	
	}
    sets.precast.Step = {
		ammo="Hesperiidae",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Mache Earring +1",
		right_ear="Mache Earring +1",
		left_ring={name="Chirich Ring +1", bag="wardrobe2"},
		right_ring={name="Chirich Ring +1", bag="wardrobe7"},
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Phys. dmg. taken-10%',}},	
	}
    sets.precast.Flourish1 = {}
    sets.precast.Flourish1['Violent Flourish'] = {
		ammo="Hesperiidae",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear="Hermetic Earring",
		right_ear="Gwati Earring",
		left_ring={name="Stikini Ring +1", bag="wardrobe2"},
		right_ring={name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Phys. dmg. taken-10%',}},		
	}

    --Precast Gear Sets for DRG subjob abilities:
    sets.precast.JA.Jump = {
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck={ name="Bst. Collar +2", augments={'Path: A',}},
		waist="Reiki Yotai",
		left_ear="Mache Earring +1",
		right_ear="Mache Earring +1",
		left_ring={name="Chirich Ring +1", bag="wardrobe2"},
		right_ring={name="Chirich Ring +1", bag="wardrobe7"},
		back={ name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Phys. dmg. taken-10%',}},		
	}
    sets.precast.JA['High Jump'] = sets.precast.JA.Jump

    --Misc Gear Sets
    sets.FrenzySallet = {}
    sets.precast.LuzafRing = {left_ring="Luzaf's Ring"}
    sets.buff['Killer Instinct'] = {body="Nukumi Gausape +1"}
    sets.THGear = {legs=TH_legs,waist="Chaac Belt", head="Wh. Rarab Cap +1"}
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
		add_to_chat(8,'Ready: ['.. spell.name .. '] @ Pet TP: ' .. pet.tp)
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
--validateTextInformation()
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
--validateTextInformation()
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
--validateTextInformation()
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
    end

    if player.equipment.main == 'Aymur' then
        custom_aftermath_timers_aftercast(spell)
    end

    if player.status ~= 'Idle' and state.AxeMode.value == 'PetOnly' and spell.type ~= "Monster" then
        pet_only_equip_handling()
    end
--validateTextInformation()
end

function job_pet_midcast(spell, action, spellMap, eventArgs)
    if spell.type == "Monster" or spell.name == "Sic" then
        eventArgs.handled = true
    end
--validateTextInformation()
end

function job_pet_aftercast(spell, action, spellMap, eventArgs)
    pet_only_equip_handling()
--validateTextInformation()
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

    if moving then
		idleSet=set_combine(idleSet, sets.Kiting)
	end
    return idleSet
end

function customize_melee_set(meleeSet)
    if state.AxeMode.value ~= 'PetOnly' and state.DefenseMode.value == "None" then
        if player.equipment.main == 'Farsha' then
            meleeSet = set_combine(meleeSet, sets.engaged.Farsha)
        elseif player.equipment.sub == 'Kraken Club' then
            meleeSet = set_combine(meleeSet, sets.engaged.DW.KrakenClub)
        end
    end

    pet_only_equip_handling()
    if moving then
		meleeSet=set_combine(meleeSet, sets.Kiting)
	end
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
--validateTextInformation()
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
	auto_fight()
	validateTextInformation()
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    get_combat_form()
    get_melee_groups()
    pet_info_update()
    pet_only_equip_handling()
	pet_info_update()
	validateTextInformation()
	auto_fight()
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
		PetName = '    '
		PetJob 	= '    '
		PetInfo = '    '
		ReadyMoveOne.Name	= '__________';	ReadyMoveOne.Cost	= '_'; ReadyMoveOne.Type	= '_____'; ReadyMoveOne.Element	 = '_______'; 	ReadyMoveOne.Effect	 = '_______'
		ReadyMoveTwo.Name	= '__________';	ReadyMoveTwo.Cost	= '_'; ReadyMoveTwo.Type	= '_____'; ReadyMoveTwo.Element	 = '_______'; 	ReadyMoveTwo.Effect	 = '_______'
		ReadyMoveThree.Name	= '__________';	ReadyMoveThree.Cost	= '_'; ReadyMoveThree.Type	= '_____'; ReadyMoveThree.Element= '_______'; 	ReadyMoveThree.Effect= '_______'
		ReadyMoveFour.Name	= '__________';	ReadyMoveFour.Cost	= '_'; ReadyMoveFour.Type	= '_____'; ReadyMoveFour.Element = '_______'; 	ReadyMoveFour.Effect = '_______'
		ReadyMoveFive.Name	= '__________';	ReadyMoveFive.Cost	= '_'; ReadyMoveFive.Type	= '_____'; ReadyMoveFive.Element = '_______'; 	ReadyMoveFive.Effect = '_______'
		ReadyMoveSix.Name	= '__________';	ReadyMoveSix.Cost	= '_'; ReadyMoveSix.Type	= '_____'; ReadyMoveSix.Element	 = '_______'; 	ReadyMoveSix.Effect  = '_______'
		ReadyMoveSeven.Name	= '__________';	ReadyMoveSeven.Cost	= '_'; ReadyMoveSeven.Type	= '_____'; ReadyMoveSeven.Element= '_______'; 	ReadyMoveSeven.Effect= '_______'
    end

    customize_melee_set(meleeSet)
    pet_info_update()
	--validateTextInformation()	
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
	if cmdParams[1] =="getgear" then 
		get_gear()
	end
	if cmdParams[1] =="petfight" then 
		toggle_PetMelee()
	end
	if cmdParams[1]=="togglehud" then
		hud_toggle()
	end
	if cmdParams[1] == 'runspeed' then
		runspeed:toggle()
		updateRunspeedGear(runspeed.value) 
	end
	if cmdParams[1] == 'BeastialFury' or cmdParams[1]== 'BF' then
		add_to_chat(8, 'Beastial Fury Command Recieved')
		Bestial_Fury()
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


function pet_info_update()
    if pet.isvalid then
        PetName = pet.name
        if pet.name == 'DroopyDortwin' or pet.name == 'PonderingPeter' or pet.name == 'HareFamiliar' or pet.name == 'KeenearedSteffi' then
			PetInfo = "Rabbit, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Foot Kick '; 	ReadyMoveOne.Cost= '1'; 	ReadyMoveOne.Type= 'Slash'; 	ReadyMoveOne.Element= 'Reverb.'; 	ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Dust Cloud'; 	ReadyMoveTwo.Cost= '1';		ReadyMoveTwo.Type= 'Magic'; 	ReadyMoveTwo.Element= 'Earth  '; 	ReadyMoveTwo.Effect= 'BLIND  '
			ReadyMoveThree.Name= 'Whirl Claw'; 	ReadyMoveThree.Cost= '1'; 	ReadyMoveThree.Type= 'Slash'; 	ReadyMoveThree.Element= 'Impact.'; 	ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Wld. Crt. '; 	ReadyMoveFour.Cost= '2'; 	ReadyMoveFour.Type= 'Heal.'; 	ReadyMoveFour.Element= 'None   '; 	ReadyMoveFour.Effect= 'None   '
			ReadyMoveFive.Name= '__________'; 	ReadyMoveFive.Cost= '_'; 	ReadyMoveFive.Type= '_____'; 	ReadyMoveFive.Element= '_______'; 	ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; 	ReadyMoveSix.Cost= '_'; 	ReadyMoveSix.Type= '_____'; 	ReadyMoveSix.Element= '_______'; 	ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; 	ReadyMoveSeven.Cost= '_'; 	ReadyMoveSeven.Type= '_____'; 	ReadyMoveSeven.Element= '_______'; 	ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'LuckyLulush' then
			PetInfo = "Rabbit, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Foot Kick '; 	ReadyMoveOne.Cost= '1'; 	ReadyMoveOne.Type= 'Slash'; 	ReadyMoveOne.Element= 'Reverb.'; 	ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Dust Cloud'; 	ReadyMoveTwo.Cost= '1';		ReadyMoveTwo.Type= 'Magic'; 	ReadyMoveTwo.Element= 'Earth  '; 	ReadyMoveTwo.Effect= 'BLIND  '
			ReadyMoveThree.Name= 'Whirl Claw'; 	ReadyMoveThree.Cost= '1'; 	ReadyMoveThree.Type= 'Slash'; 	ReadyMoveThree.Element= 'Impact.'; 	ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Wld. Crt. '; 	ReadyMoveFour.Cost= '2'; 	ReadyMoveFour.Type= 'Heal.'; 	ReadyMoveFour.Element= 'None   '; 	ReadyMoveFour.Effect= 'None   '
			ReadyMoveFive.Name= '__________'; 	ReadyMoveFive.Cost= '_'; 	ReadyMoveFive.Type= '_____'; 	ReadyMoveFive.Element= '_______'; 	ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; 	ReadyMoveSix.Cost= '_'; 	ReadyMoveSix.Type= '_____'; 	ReadyMoveSix.Element= '_______'; 	ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; 	ReadyMoveSeven.Cost= '_'; 	ReadyMoveSeven.Type= '_____'; 	ReadyMoveSeven.Element= '_______'; 	ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'SunburstMalfik' or pet.name == 'AgedAngus' or pet.name == 'HeraldHenry' or pet.name == 'CrabFamiliar' or pet.name == 'CourierCarrie' then
			PetInfo = "Crab, Aquan";PetJob = 'Paladin'
			ReadyMoveOne.Name= 'Bbl. Shwr.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Magic'; ReadyMoveOne.Element= 'Water  '; ReadyMoveOne.Effect= 'STR Dwn'
			ReadyMoveTwo.Name= 'Bbl. Curt.'; ReadyMoveTwo.Cost= '3'; ReadyMoveTwo.Type= 'Enhn.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'MDT Up '
			ReadyMoveThree.Name= 'Big Sciss.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Slash'; ReadyMoveThree.Element= 'Scision'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Scis. Grd.'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'DEF UP '
			ReadyMoveFive.Name= 'Mtl. Body '; ReadyMoveFive.Cost= '1'; ReadyMoveFive.Type= 'Enhn.'; ReadyMoveFive.Element= 'None   '; ReadyMoveFive.Effect= 'S.Skin '
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'P.CrabFamiliar' or pet.name == 'JovialEdwin' then
			PetInfo = "Barnacle Crab, Aquan";PetJob = 'Paladin'
			ReadyMoveOne.Name= 'Bbl. Curt.'; ReadyMoveOne.Cost= '3'; ReadyMoveOne.Type= 'Enhn.'; ReadyMoveOne.Element= '_______'; ReadyMoveOne.Effect= 'MDEF UP'
			ReadyMoveTwo.Name= 'Sciss. Grd'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enhn.'; ReadyMoveTwo.Element= '_______'; ReadyMoveTwo.Effect= 'DEF UP '
			ReadyMoveThree.Name= 'Metal. Bd.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Enhn.'; ReadyMoveThree.Element= '_______'; ReadyMoveThree.Effect= 'S.Skin '
			ReadyMoveFour.Name= 'Ven. Shwr.'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Magic'; ReadyMoveFour.Element= 'Water  '; ReadyMoveFour.Effect= 'PSN/DEF'
			ReadyMoveFive.Name= 'Mega Scsr.'; ReadyMoveFive.Cost= '2'; ReadyMoveFive.Type= 'Slash'; ReadyMoveFive.Element= 'GRV/SCS'; ReadyMoveFive.Effect= 'None   '
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'WarlikePatrick' or pet.name == 'LizardFamiliar' or pet.name == 'ColdbloodComo' or pet.name == 'AudaciousAnna' then
			PetInfo = "Lizard, Lizard";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Tail Blow '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'Stun   '
			ReadyMoveTwo.Name= 'Fireball  '; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Fire   '; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Blockhead '; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Blunt'; ReadyMoveThree.Element= 'Reverb.'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Brain Crs.'; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Blunt'; ReadyMoveFour.Element= 'Liquefa'; ReadyMoveFour.Effect= 'Silence'
			ReadyMoveFive.Name= 'Infrason. '; ReadyMoveFive.Cost= '2'; ReadyMoveFive.Type= 'Enfb.'; ReadyMoveFive.Element= 'Ice    '; ReadyMoveFive.Effect= 'EVA DWN'
			ReadyMoveSix.Name= 'Secretion '; ReadyMoveSix.Cost= '1'; ReadyMoveSix.Type= 'Enhn.'; ReadyMoveSix.Element= 'None   '; ReadyMoveSix.Effect= 'EVA UP '
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'						
        elseif pet.name == 'ScissorlegXerin' or pet.name == 'BouncingBertha' then
			PetInfo = "Chapuli, Vermin";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Snsl. Bld.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Scision'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Teg. Bfft.'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Slash'; ReadyMoveTwo.Element= 'DIS/Det'; ReadyMoveTwo.Effect= 'Choke  '
			ReadyMoveThree.Name= '__________'; ReadyMoveThree.Cost= '_'; ReadyMoveThree.Type= '_____'; ReadyMoveThree.Element= '_______'; ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'RhymingShizuna' or pet.name == 'SheepFamiliar' or pet.name == 'LullabyMelodia' or pet.name == 'NurseryNazuna' then
			PetInfo = "Sheep, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Lamb Chop '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Rage      '; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enhn.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'Berserk'
			ReadyMoveThree.Name= 'Sheep Chrg'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Blunt'; ReadyMoveThree.Element= 'Reverb.'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Sheep Song'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Enfb.'; ReadyMoveFour.Element= 'Light  '; ReadyMoveFour.Effect= 'Sleep  '
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'AttentiveIbuki' or pet.name == 'SwoopingZhivago' then
			PetInfo = "Tulfaire, Bird";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Mlt. Plum.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Magic'; ReadyMoveOne.Element= 'Wind   '; ReadyMoveOne.Effect= 'Dispel '
			ReadyMoveTwo.Name= 'Swp. Frzy.'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Pier.'; ReadyMoveTwo.Element= 'FUS/REV'; ReadyMoveTwo.Effect= 'MDF/DEF'
			ReadyMoveThree.Name= 'Pentapeck '; ReadyMoveThree.Cost= '3'; ReadyMoveThree.Type= 'Pier.'; ReadyMoveThree.Element= 'LIT/DIS'; ReadyMoveThree.Effect= 'Amnesia'
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'AmiableRoche' or pet.name == 'TurbidToloi' then
			PetInfo = "Pugil, Aquan";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Intimidate'; ReadyMoveOne.Cost= '2'; ReadyMoveOne.Type= 'Enfb.'; ReadyMoveOne.Element= 'None   '; ReadyMoveOne.Effect= 'Slow   '
			ReadyMoveTwo.Name= 'Recoil Dv.'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Slash'; ReadyMoveTwo.Element= 'Trnsfx.'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Water Wall'; ReadyMoveThree.Cost= '3'; ReadyMoveThree.Type= 'Enhn.'; ReadyMoveThree.Element= 'None   '; ReadyMoveThree.Effect= 'DEF UP '
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'			
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
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'RedolentCandi' or pet.name == 'AlluringHoney' then
			PetInfo = "Snapweed, Plantoid";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Tic. Tndr.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'Stun   '
			ReadyMoveTwo.Name= 'Stink Bomb'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Earth  '; ReadyMoveTwo.Effect= 'BLN/PAR'
			ReadyMoveThree.Name= 'Nect. Dlg.'; ReadyMoveThree.Cost= '2'; ReadyMoveThree.Type= 'Magic'; ReadyMoveThree.Element= 'Water  '; ReadyMoveThree.Effect= 'Poison '
			ReadyMoveFour.Name= 'Nep. Plng.'; ReadyMoveFour.Cost= '3'; ReadyMoveFour.Type= 'Magic'; ReadyMoveFour.Element= 'Water  '; ReadyMoveFour.Effect= 'DRN/GRV'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'CaringKiyomaro' or pet.name == 'VivaciousVickie' then
			PetInfo = "Raaz, Beast";PetJob = 'Monk'
			ReadyMoveOne.Name= 'Swp. Gouge'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Indura.'; ReadyMoveOne.Effect= 'DEF DWN'
			ReadyMoveTwo.Name= 'Zls. Snort'; ReadyMoveTwo.Cost= '3'; ReadyMoveTwo.Type= 'Enhn.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'SWOLBOI'
			ReadyMoveThree.Name= '__________'; ReadyMoveThree.Cost= '_'; ReadyMoveThree.Type= '_____'; ReadyMoveThree.Element= '_______'; ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'HurlerPercival' or pet.name == 'BeetleFamiliar' or pet.name == 'PanzerGalahad' then
			PetInfo = "Beetle, Vermin";PetJob = 'Paladin'
			ReadyMoveOne.Name= 'Pwr. Attk.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Reverb.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'H-fr. Fld.'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'EVA DWN'
			ReadyMoveThree.Name= 'Rhn. Atk. '; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Pier.'; ReadyMoveThree.Element= 'Deton. '; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Rhn. Grd. '; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'EVA UP '
			ReadyMoveFive.Name= 'Spoil     '; ReadyMoveFive.Cost= '1'; ReadyMoveFive.Type= 'Enfb.'; ReadyMoveFive.Element= 'None   '; ReadyMoveFive.Effect= 'STR DWN'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'Y.BeetleFamilia' or pet.name == 'EnergizedSefina' then
			PetInfo = "Beetle (Horn), Vermin";PetJob = 'Paladin'
			ReadyMoveOne.Name= 'Pwr. Atk. '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Reverb.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'H-fr. Fld.'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'Ice    '; ReadyMoveTwo.Effect= 'EVA DWN'
			ReadyMoveThree.Name= 'Rhino Atk.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Pier.'; ReadyMoveThree.Element= 'Deton. '; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Rhino Grd.'; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'EVA UP '
			ReadyMoveFive.Name= 'Spoil     '; ReadyMoveFive.Cost= '1'; ReadyMoveFive.Type= 'Enfb.'; ReadyMoveFive.Element= 'None   '; ReadyMoveFive.Effect= 'STR DWN'
			ReadyMoveSix.Name= 'Rhinowrek.'; ReadyMoveSix.Cost= '2'; ReadyMoveSix.Type= 'Pier.'; ReadyMoveSix.Element= 'FUS/TRN'; ReadyMoveSix.Effect= 'DEF DWN'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'BlackbeardRandy' or pet.name == 'TigerFamiliar' or pet.name == 'SaberSiravarde' or pet.name == 'GorefangHobs' then
			PetInfo = "Tiger, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Roar      '; ReadyMoveOne.Cost= '2'; ReadyMoveOne.Type= 'Enfb.'; ReadyMoveOne.Element= 'Ice    '; ReadyMoveOne.Effect= 'Para   '
			ReadyMoveTwo.Name= 'Razor Fang'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Slash'; ReadyMoveTwo.Element= 'Impact.'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Claw Cycl.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Slash'; ReadyMoveThree.Element= 'Scision'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Crossthrs.'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Slash'; ReadyMoveFour.Element= 'DIS/Det'; ReadyMoveFour.Effect= 'Dispel '
			ReadyMoveFive.Name= 'Pred. Glr.'; ReadyMoveFive.Cost= '2'; ReadyMoveFive.Type= 'Enfb.'; ReadyMoveFive.Element= 'Thunder'; ReadyMoveFive.Effect= 'Stun   '
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'ColibriFamiliar' or pet.name == 'ChoralLeera' then
			PetInfo = "Colibri, Bird";PetJob = 'Red Mage'
			ReadyMoveOne.Name= 'Pck. Flry.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Pier.'; ReadyMoveOne.Element= 'Trnsfx.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= '__________'; ReadyMoveTwo.Cost= '_'; ReadyMoveTwo.Type= '_____'; ReadyMoveTwo.Element= '_______'; ReadyMoveTwo.Effect= '_______'
			ReadyMoveThree.Name= '__________'; ReadyMoveThree.Cost= '_'; ReadyMoveThree.Type= '_____'; ReadyMoveThree.Element= '_______'; ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'SpiderFamiliar' or pet.name == 'GussyHachirobe' then
			PetInfo = "Spider, Vermin";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Skl. Slash'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Trnsfx.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Acid Spray'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Water  '; ReadyMoveTwo.Effect= 'Poison '
			ReadyMoveThree.Name= 'Spider Web'; ReadyMoveThree.Cost= '2'; ReadyMoveThree.Type= 'Enfb.'; ReadyMoveThree.Element= 'Earth  '; ReadyMoveThree.Effect= 'Slow   '
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'		
        elseif pet.name == 'GenerousArthur' or pet.name == 'GooeyGerard' then
			PetInfo = "Slug, Amorph";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Puru. Ooze'; ReadyMoveOne.Cost= '2'; ReadyMoveOne.Type= 'Magic'; ReadyMoveOne.Element= 'Water  '; ReadyMoveOne.Effect= 'BIO/MHP'
			ReadyMoveTwo.Name= 'Coro. Ooze'; ReadyMoveTwo.Cost= '3'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Water  '; ReadyMoveTwo.Effect= 'ATK/DEF'
			ReadyMoveThree.Name= '__________'; ReadyMoveThree.Cost= '_'; ReadyMoveThree.Type= '_____'; ReadyMoveThree.Element= '_______'; ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'ThreestarLynn' or pet.name == 'DipperYuly' then
			PetInfo = "Ladybug, Vermin";PetJob = 'Thief'
			ReadyMoveOne.Name= 'Sud. Lunge'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'Stun   '
			ReadyMoveTwo.Name= 'Sprl. Spin'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Slash'; ReadyMoveTwo.Element= 'Scision'; ReadyMoveTwo.Effect= 'ACC DWN'
			ReadyMoveThree.Name= 'Noi. Pwdr.'; ReadyMoveThree.Cost= '2'; ReadyMoveThree.Type= 'Enfb.'; ReadyMoveThree.Element= 'None   '; ReadyMoveThree.Effect= 'ATK DWN'
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'SharpwitHermes' or pet.name == 'SweetCaroline' or pet.name == 'FlowerpotBill' or pet.name == 'FlowerpotBen' or pet.name == 'Homunculus' or pet.name == 'FlowerpotMerle' then
			PetInfo = "Mandragora, Plantoid";PetJob = 'Monk'
			ReadyMoveOne.Name= 'Head Butt '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Deton. '; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Wild Oats '; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Pier.'; ReadyMoveTwo.Element= 'Trnsfx.'; ReadyMoveTwo.Effect= 'VIT DWN'
			ReadyMoveThree.Name= 'Leaf Dggr.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Slash'; ReadyMoveThree.Element= 'Scision'; ReadyMoveThree.Effect= 'Poison '
			ReadyMoveFour.Name= 'Scream    '; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enfb.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'MND DWN'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'AcuexFamiliar' or pet.name == 'FluffyBredo' then
			PetInfo = "Acuex, Amorph";PetJob = 'Black Mage'
			ReadyMoveOne.Name= 'Foul Wtrs.'; ReadyMoveOne.Cost= '2'; ReadyMoveOne.Type= 'Magic'; ReadyMoveOne.Element= 'Water  '; ReadyMoveOne.Effect= 'DRN/GRV'
			ReadyMoveTwo.Name= 'Pest. Plm.'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Dark   '; ReadyMoveTwo.Effect= 'AIDS   '
			ReadyMoveThree.Name= '__________'; ReadyMoveThree.Cost= '_'; ReadyMoveThree.Type= '_____'; ReadyMoveThree.Element= '_______'; ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'FlytrapFamiliar' or pet.name == 'VoraciousAudrey' or pet.name == 'PrestoJulio' then--NEEDS CORRECTION
			PetInfo = "Flytrap, Plantoid";PetJob = 'Warrior'
			ReadyMoveOne.Name	= '__________';	ReadyMoveOne.Cost	= '_'; ReadyMoveOne.Type	= '_____'; ReadyMoveOne.Element	 = '_______'; 	ReadyMoveOne.Effect	 = '_______'
			ReadyMoveTwo.Name	= '__________';	ReadyMoveTwo.Cost	= '_'; ReadyMoveTwo.Type	= '_____'; ReadyMoveTwo.Element	 = '_______'; 	ReadyMoveTwo.Effect	 = '_______'
			ReadyMoveThree.Name	= '__________';	ReadyMoveThree.Cost	= '_'; ReadyMoveThree.Type	= '_____'; ReadyMoveThree.Element= '_______'; 	ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name	= '__________';	ReadyMoveFour.Cost	= '_'; ReadyMoveFour.Type	= '_____'; ReadyMoveFour.Element = '_______'; 	ReadyMoveFour.Effect = '_______'
			ReadyMoveFive.Name	= '__________';	ReadyMoveFive.Cost	= '_'; ReadyMoveFive.Type	= '_____'; ReadyMoveFive.Element = '_______'; 	ReadyMoveFive.Effect = '_______'
			ReadyMoveSix.Name	= '__________';	ReadyMoveSix.Cost	= '_'; ReadyMoveSix.Type	= '_____'; ReadyMoveSix.Element	 = '_______'; 	ReadyMoveSix.Effect  = '_______'
			ReadyMoveSeven.Name	= '__________';	ReadyMoveSeven.Cost	= '_'; ReadyMoveSeven.Type	= '_____'; ReadyMoveSeven.Element= '_______'; 	ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'EftFamiliar' or pet.name == 'AmbusherAllie' or pet.name == 'BugeyedBroncha' or pet.name == 'SuspiciousAlice' then
			PetInfo = "Eft, Lizard";PetJob = 'Warrior';
			ReadyMoveOne.Name= 'Nimb. Snp.'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Cyclotail '; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Blunt'; ReadyMoveTwo.Element= 'Impact.'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Geist Wall'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Enfb.'; ReadyMoveThree.Element= 'Dark   '; ReadyMoveThree.Effect= 'Dispel '
			ReadyMoveFour.Name= 'Numb. Noi.'; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enfb.'; ReadyMoveFour.Element= 'Thunder'; ReadyMoveFour.Effect= 'Stun   '
			ReadyMoveFive.Name= 'Toxic Spit'; ReadyMoveFive.Cost= '2'; ReadyMoveFive.Type= 'Magic'; ReadyMoveFive.Element= 'Water  '; ReadyMoveFive.Effect= 'Poison '
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'AntlionFamiliar' or pet.name == 'ChopsueyChucky' or pet.name == 'CursedAnnabelle' then
			PetInfo = "Antlion, Vermin";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Mand. Bite'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Deton. '; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Sandblast '; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Earth  '; ReadyMoveTwo.Effect= 'Blind  '
			ReadyMoveThree.Name= 'Sandpit   '; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Magic'; ReadyMoveThree.Element= 'Earth  '; ReadyMoveThree.Effect= 'Bind   '
			ReadyMoveFour.Name= 'Venom Spr.'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Magic'; ReadyMoveFour.Element= 'Water  '; ReadyMoveFour.Effect= 'Poison '
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'MiteFamiliar' or pet.name == 'LifedrinkerLars' or pet.name == 'AnklebiterJedd' then
			PetInfo = "Diremite, Vermin";PetJob = 'Dark Knight'
			ReadyMoveOne.Name= 'Dbl. Claw '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Liquefa'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Grapple   '; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Blunt'; ReadyMoveTwo.Element= 'Reverb.'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Spin. Top '; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Blunt'; ReadyMoveThree.Element= 'Impact.'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Film. Hold'; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Enfb.'; ReadyMoveFour.Element= 'Earth  '; ReadyMoveFour.Effect= 'Slow   '
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'AmigoSabotender' then--NEEDS CORRECTION
			PetInfo = "Cactuar, Plantoid";PetJob = 'Warrior'
			ReadyMoveOne.Name	= '__________';	ReadyMoveOne.Cost	= '_'; ReadyMoveOne.Type	= '_____'; ReadyMoveOne.Element	 = '_______'; 	ReadyMoveOne.Effect	 = '_______'
			ReadyMoveTwo.Name	= '__________';	ReadyMoveTwo.Cost	= '_'; ReadyMoveTwo.Type	= '_____'; ReadyMoveTwo.Element	 = '_______'; 	ReadyMoveTwo.Effect	 = '_______'
			ReadyMoveThree.Name	= '__________';	ReadyMoveThree.Cost	= '_'; ReadyMoveThree.Type	= '_____'; ReadyMoveThree.Element= '_______'; 	ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name	= '__________';	ReadyMoveFour.Cost	= '_'; ReadyMoveFour.Type	= '_____'; ReadyMoveFour.Element = '_______'; 	ReadyMoveFour.Effect = '_______'
			ReadyMoveFive.Name	= '__________';	ReadyMoveFive.Cost	= '_'; ReadyMoveFive.Type	= '_____'; ReadyMoveFive.Element = '_______'; 	ReadyMoveFive.Effect = '_______'
			ReadyMoveSix.Name	= '__________';	ReadyMoveSix.Cost	= '_'; ReadyMoveSix.Type	= '_____'; ReadyMoveSix.Element	 = '_______'; 	ReadyMoveSix.Effect  = '_______'
			ReadyMoveSeven.Name	= '__________';	ReadyMoveSeven.Cost	= '_'; ReadyMoveSeven.Type	= '_____'; ReadyMoveSeven.Element= '_______'; 	ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'CraftyClyvonne' then--NEEDS CORRECTION
			PetInfo = "Coeurl, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Chao. Eye '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Enfb.'; ReadyMoveOne.Element= 'None   '; ReadyMoveOne.Effect= 'Silence'
			ReadyMoveTwo.Name= 'Blaster   '; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'Para   '
			ReadyMoveThree.Name= '__________'; ReadyMoveThree.Cost= '_'; ReadyMoveThree.Type= '_____'; ReadyMoveThree.Element= '_______'; ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'

        elseif pet.name == 'BloodclawShasra' then--NEEDS CORRECTION
			PetInfo = "Lynx, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Chao. Eye '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Enfb.'; ReadyMoveOne.Element= 'None   '; ReadyMoveOne.Effect= 'Silence'
			ReadyMoveTwo.Name= 'Blaster   '; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'Para   '
			ReadyMoveThree.Name= 'Chrg. Wsk.'; ReadyMoveThree.Cost= '2'; ReadyMoveThree.Type= 'Magic'; ReadyMoveThree.Element= 'Thunder'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Frenz. Rg.'; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'ATK UP '
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'LynxFamiliar' or pet.name == 'VivaciousGaston' then
			PetInfo = "Collared Lynx, Beast";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Chao. Eye '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Enfb.'; ReadyMoveOne.Element= 'None   '; ReadyMoveOne.Effect= 'Silence'
			ReadyMoveTwo.Name= 'Blaster   '; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'Para   '
			ReadyMoveThree.Name= 'Chrg. Wsk.'; ReadyMoveThree.Cost= '2'; ReadyMoveThree.Type= 'Magic'; ReadyMoveThree.Element= 'Thunder'; ReadyMoveThree.Effect= 'None   '
			ReadyMoveFour.Name= 'Frenz. Rg.'; ReadyMoveFour.Cost= '1'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'ATK UP '
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'SwiftSieghard' or pet.name == 'FleetReinhard' then
			PetInfo = "Raptor, Lizard";PetJob = 'Warrior'
			ReadyMoveOne.Name= 'Scy. Tail '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Liquefa'; ReadyMoveOne.Effect= 'Stun   '
			ReadyMoveTwo.Name= 'Ripr. Fang'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Slash'; ReadyMoveTwo.Element= 'Indura.'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= 'Chomp Rush'; ReadyMoveThree.Cost= '3'; ReadyMoveThree.Type= 'Slash'; ReadyMoveThree.Element= 'DRK/GRV'; ReadyMoveThree.Effect= 'Slow   '
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'DapperMac' or pet.name == 'SurgingStorm' or pet.name == 'SubmergedIyo' then
			PetInfo = "Apkallu, Bird";PetJob = 'Monk'
			ReadyMoveOne.Name= 'Wing Slap '; ReadyMoveOne.Cost= '2'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'GRV/LIQ'; ReadyMoveOne.Effect= 'Stun   '
			ReadyMoveTwo.Name= 'Beak Lunge'; ReadyMoveTwo.Cost= '1'; ReadyMoveTwo.Type= 'Blunt'; ReadyMoveTwo.Element= 'Scision'; ReadyMoveTwo.Effect= 'None   '
			ReadyMoveThree.Name= '__________'; ReadyMoveThree.Cost= '_'; ReadyMoveThree.Type= '_____'; ReadyMoveThree.Element= '_______'; ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'FatsoFargann' then
			PetInfo = "Leech, Amorph";PetJob = 'Warrior'
			ReadyMoveOne.Name	= 'Suction   ';	ReadyMoveOne.Cost	= '1'; ReadyMoveOne.Type	= 'Blunt'; ReadyMoveOne.Element	 = 'Compres'; 	ReadyMoveOne.Effect	 = 'Stun   '
			ReadyMoveTwo.Name	= 'Drainkiss ';	ReadyMoveTwo.Cost	= '1'; ReadyMoveTwo.Type	= 'Magic'; ReadyMoveTwo.Element	 = '_______'; 	ReadyMoveTwo.Effect	 = 'Drain  '
			ReadyMoveThree.Name	= 'Acid Mist ';	ReadyMoveThree.Cost	= '2'; ReadyMoveThree.Type	= 'Magic'; ReadyMoveThree.Element= '_______'; 	ReadyMoveThree.Effect= 'ATK.DWN'
			ReadyMoveFour.Name	= 'TP Drnkiss';	ReadyMoveFour.Cost	= '3'; ReadyMoveFour.Type	= 'Magic'; ReadyMoveFour.Element = '_______'; 	ReadyMoveFour.Effect = 'TPDrain'
			ReadyMoveFive.Name	= '__________';	ReadyMoveFive.Cost	= '_'; ReadyMoveFive.Type	= '_____'; ReadyMoveFive.Element = '_______'; 	ReadyMoveFive.Effect = '_______'
			ReadyMoveSix.Name	= '__________';	ReadyMoveSix.Cost	= '_'; ReadyMoveSix.Type	= '_____'; ReadyMoveSix.Element	 = '_______'; 	ReadyMoveSix.Effect  = '_______'
			ReadyMoveSeven.Name	= '__________';	ReadyMoveSeven.Cost	= '_'; ReadyMoveSeven.Type	= '_____'; ReadyMoveSeven.Element= '_______'; 	ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'Hip.Familiar' or pet.name == 'DaringRoland' or pet.name == 'FaithfulFalcorr' then
			PetInfo = "Hippogryph, Bird";PetJob = 'Thief'
			ReadyMoveOne.Name= 'Back Heel '; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Blunt'; ReadyMoveOne.Element= 'Reverb.'; ReadyMoveOne.Effect= 'None   '
			ReadyMoveTwo.Name= 'Jettatura '; ReadyMoveTwo.Cost= '3'; ReadyMoveTwo.Type= 'Enfb.'; ReadyMoveTwo.Element= 'None   '; ReadyMoveTwo.Effect= 'TERROR '
			ReadyMoveThree.Name= 'Chk. Brth.'; ReadyMoveThree.Cost= '1'; ReadyMoveThree.Type= 'Slash'; ReadyMoveThree.Element= 'None   '; ReadyMoveThree.Effect= 'PAR/SLN'
			ReadyMoveFour.Name= 'Fantod    '; ReadyMoveFour.Cost= '2'; ReadyMoveFour.Type= 'Enhn.'; ReadyMoveFour.Element= 'None   '; ReadyMoveFour.Effect= 'Boost  '
			ReadyMoveFive.Name= 'Hoof Voly.'; ReadyMoveFive.Cost= '3'; ReadyMoveFive.Type= 'Blunt'; ReadyMoveFive.Element= 'LIT/FRG'; ReadyMoveFive.Effect= 'None   '
			ReadyMoveSix.Name= 'Nihl. Song'; ReadyMoveSix.Cost= '1'; ReadyMoveSix.Type= 'Enfb.'; ReadyMoveSix.Element= 'None   '; ReadyMoveSix.Effect= 'Dispel '
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'			
        elseif pet.name == 'CrudeRaphie' then
			PetInfo = "Adamantoise, Lizard";PetJob = 'Paladin'
			ReadyMoveOne.Name	= '__________';	ReadyMoveOne.Cost	= '_'; ReadyMoveOne.Type	= '_____'; ReadyMoveOne.Element	 = '_______'; 	ReadyMoveOne.Effect	 = '_______'
			ReadyMoveTwo.Name	= '__________';	ReadyMoveTwo.Cost	= '_'; ReadyMoveTwo.Type	= '_____'; ReadyMoveTwo.Element	 = '_______'; 	ReadyMoveTwo.Effect	 = '_______'
			ReadyMoveThree.Name	= '__________';	ReadyMoveThree.Cost	= '_'; ReadyMoveThree.Type	= '_____'; ReadyMoveThree.Element= '_______'; 	ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name	= '__________';	ReadyMoveFour.Cost	= '_'; ReadyMoveFour.Type	= '_____'; ReadyMoveFour.Element = '_______'; 	ReadyMoveFour.Effect = '_______'
			ReadyMoveFive.Name	= '__________';	ReadyMoveFive.Cost	= '_'; ReadyMoveFive.Type	= '_____'; ReadyMoveFive.Element = '_______'; 	ReadyMoveFive.Effect = '_______'
			ReadyMoveSix.Name	= '__________';	ReadyMoveSix.Cost	= '_'; ReadyMoveSix.Type	= '_____'; ReadyMoveSix.Element	 = '_______'; 	ReadyMoveSix.Effect  = '_______'
			ReadyMoveSeven.Name	= '__________';	ReadyMoveSeven.Cost	= '_'; ReadyMoveSeven.Type	= '_____'; ReadyMoveSeven.Element= '_______'; 	ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'MosquitoFamilia' or pet.name == 'Left-HandedYoko' then
			PetInfo = "Mosquito, Vermin";PetJob = 'Dark Knight'
			ReadyMoveOne.Name= 'Inf. Leech'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Magic'; ReadyMoveOne.Element= 'None   '; ReadyMoveOne.Effect= 'Plague '
			ReadyMoveTwo.Name= 'Glm. Spray'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Magic'; ReadyMoveTwo.Element= 'Dark   '; ReadyMoveTwo.Effect= 'Dispel '
			ReadyMoveThree.Name= '__________'; ReadyMoveThree.Cost= '_'; ReadyMoveThree.Type= '_____'; ReadyMoveThree.Element= '_______'; ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'WeevilFamiliar' or pet.name == 'StalwartAngelin' then
			PetInfo = "Weevil, Vermin";PetJob = 'Thief'
			ReadyMoveOne.Name= 'Disembowel'; ReadyMoveOne.Cost= '1'; ReadyMoveOne.Type= 'Slash'; ReadyMoveOne.Element= 'Impact.'; ReadyMoveOne.Effect= 'ACC DWN'
			ReadyMoveTwo.Name= 'Ext. Salvo'; ReadyMoveTwo.Cost= '2'; ReadyMoveTwo.Type= 'Blunt'; ReadyMoveTwo.Element= 'FUS/IMP'; ReadyMoveTwo.Effect= 'Stun   '
			ReadyMoveThree.Name= '__________'; ReadyMoveThree.Cost= '_'; ReadyMoveThree.Type= '_____'; ReadyMoveThree.Element= '_______'; ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name= '__________'; ReadyMoveFour.Cost= '_'; ReadyMoveFour.Type= '_____'; ReadyMoveFour.Element= '_______'; ReadyMoveFour.Effect= '_______'
			ReadyMoveFive.Name= '__________'; ReadyMoveFive.Cost= '_'; ReadyMoveFive.Type= '_____'; ReadyMoveFive.Element= '_______'; ReadyMoveFive.Effect= '_______'
			ReadyMoveSix.Name= '__________'; ReadyMoveSix.Cost= '_'; ReadyMoveSix.Type= '_____'; ReadyMoveSix.Element= '_______'; ReadyMoveSix.Effect= '_______'
			ReadyMoveSeven.Name= '__________'; ReadyMoveSeven.Cost= '_'; ReadyMoveSeven.Type= '_____'; ReadyMoveSeven.Element= '_______'; ReadyMoveSeven.Effect= '_______'
        elseif pet.name == 'SlimeFamiliar' or pet.name == 'SultryPatrice' then
			PetInfo = "Slime, Amorph";PetJob = 'Warrior'
			ReadyMoveOne.Name	= 'Fluid Toss'; ReadyMoveOne.Cost	= '1'; ReadyMoveOne.Type	= 'Blunt'; ReadyMoveOne.Element		= 'Reverb.'; ReadyMoveOne.Effect	= 'None   '
			ReadyMoveTwo.Name	= 'Flu. Sprd.'; ReadyMoveTwo.Cost	= '2'; ReadyMoveTwo.Type	= 'Blunt'; ReadyMoveTwo.Element		= 'FRG/TRN'; ReadyMoveTwo.Effect	= 'None   '
			ReadyMoveThree.Name	= 'Digest    '; ReadyMoveThree.Cost	= '1'; ReadyMoveThree.Type	= 'Phys.'; ReadyMoveThree.Element	= 'None   '; ReadyMoveThree.Effect	= 'None   '
			ReadyMoveFour.Name	= '__________'; ReadyMoveFour.Cost	= '_'; ReadyMoveFour.Type	= '_____'; ReadyMoveFour.Element	= '_______'; ReadyMoveFour.Effect	= '_______'
			ReadyMoveFive.Name	= '__________'; ReadyMoveFive.Cost	= '_'; ReadyMoveFive.Type	= '_____'; ReadyMoveFive.Element	= '_______'; ReadyMoveFive.Effect	= '_______'
			ReadyMoveSix.Name	= '__________'; ReadyMoveSix.Cost	= '_'; ReadyMoveSix.Type	= '_____'; ReadyMoveSix.Element		= '_______'; ReadyMoveSix.Effect	= '_______'
			ReadyMoveSeven.Name	= '__________'; ReadyMoveSeven.Cost	= '_'; ReadyMoveSeven.Type	= '_____'; ReadyMoveSeven.Element	= '_______'; ReadyMoveSeven.Effect	= '_______'
        end
    else
			PetName = '    '
			PetJob 	= '    '
			PetInfo = '    '
			ReadyMoveOne.Name	= '__________';	ReadyMoveOne.Cost	= '_'; ReadyMoveOne.Type	= '_____'; ReadyMoveOne.Element	 = '_______'; 	ReadyMoveOne.Effect	 = '_______'
			ReadyMoveTwo.Name	= '__________';	ReadyMoveTwo.Cost	= '_'; ReadyMoveTwo.Type	= '_____'; ReadyMoveTwo.Element	 = '_______'; 	ReadyMoveTwo.Effect	 = '_______'
			ReadyMoveThree.Name	= '__________';	ReadyMoveThree.Cost	= '_'; ReadyMoveThree.Type	= '_____'; ReadyMoveThree.Element= '_______'; 	ReadyMoveThree.Effect= '_______'
			ReadyMoveFour.Name	= '__________';	ReadyMoveFour.Cost	= '_'; ReadyMoveFour.Type	= '_____'; ReadyMoveFour.Element = '_______'; 	ReadyMoveFour.Effect = '_______'
			ReadyMoveFive.Name	= '__________';	ReadyMoveFive.Cost	= '_'; ReadyMoveFive.Type	= '_____'; ReadyMoveFive.Element = '_______'; 	ReadyMoveFive.Effect = '_______'
			ReadyMoveSix.Name	= '__________';	ReadyMoveSix.Cost	= '_'; ReadyMoveSix.Type	= '_____'; ReadyMoveSix.Element	 = '_______'; 	ReadyMoveSix.Effect  = '_______'
			ReadyMoveSeven.Name	= '__________';	ReadyMoveSeven.Cost	= '_'; ReadyMoveSeven.Type	= '_____'; ReadyMoveSeven.Element= '_______'; 	ReadyMoveSeven.Effect= '_______'
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
--validateTextInformation()
end

function pet_buff_timer(spell)
    if spell.english == 'Reward' then
        send_command('timers c "Pet: Regen" 180 down '..RewardRegenIcon..'')
    elseif spell.english == 'Spur' then
        send_command('timers c "Pet: Spur" 90 down '..SpurIcon..'')
    elseif spell.english == 'Run Wild' then
        send_command('timers c "'..spell.english..'" '..RunWildDuration..' down '..RunWildIcon..'')
    end
--validateTextInformation()
end

function clear_pet_buff_timers()
    send_command('timers c "Pet: Regen" 0 down '..RewardRegenIcon..'')
    send_command('timers c "Pet: Spur" 0 down '..SpurIcon..'')
    send_command('timers c "Run Wild" 0 down '..RunWildIcon..'')
	--validateTextInformation()
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

function get_gear()
	--[[Disable code in this sub if you dont have organizer or porter packer]]
    -- send_command('wait 3;input //gs org')
	-- if PortTowns:contains(world.area) then
		-- send_command('wait 3;input //gs org') 
		-- send_command('wait 6;input //po repack') 
    -- else
		-- add_to_chat(8,'User Not in Town - Utilize GS ORG and PO Repack Functions in Rabao, Norg, Mhaura, or Selbina')
    -- end
end

windower.register_event('target change', function(target_index)
	local target = nil
	if 	windower.ffxi.get_mob_by_index(target_index) ~=nil then 
		target = windower.ffxi.get_mob_by_index(target_index)
	else
		return
	end
	local TargetType = target.spawn_type
	if target.is_npc and TargetType ~= 2 then
		auto_fight()
	end
end)

function auto_fight()
	if pet.isvalid then
		if state.AutoFight.value == "On" then
			if player.status == "Engaged" and pet.status ~= "Engaged"  then
				send_command('input /pet Fight <t>')
			end
		end
	end
end

function toggle_PetMelee()
	if pet.isvalid then 
		if pet.status~="Engaged" then
			send_command('input /pet Fight <t>')
		elseif pet.status =="Engaged" then
			send_command('input /pet Heel <me>')
		end
	else
		add_to_chat(8, 'You need to summon a pet first')
	end
end

function Bestial_Fury()
	local ReadyRecast = windower.ffxi.get_ability_recasts()[102]
	local unleashRecast = windower.ffxi.get_ability_recasts()[331]
	local unleashed=false
	local target = windower.ffxi.get_mob_by_target('t') or windower.ffxi.get_mob_by_target('st')
	
	if unleashrecast ~= nil then 
		if UnleashRecast >0 and UnleashRecast < (45*60)-60 then
			add_to_chat(8,"Unleash is on Cooldown for " .. tostring(unleashrecast) .. " Seconds. Aborting Beastial Fury")
			return
		elseif UnleashRecast >0 and UnleashRecast > (45*60)-60 then
			unleashed=true
			add_to_chat(8,"Initiating Bestial Fury. Halt all WS, JA, and Magic. Remaining unleash time: " .. tostring((45*60) -unleashRecast))
		else
			add_to_chat(8,"Initiating Bestial Fury. Halt all WS, JA, and Magic")
		end
			
		if not target.is_npc or TargetType == 2 then 
			add_to_chat(8,"Cannot Execute without a target. currently targeting: " .. tostring(target.name))
			return
		end
	end
	windower.chat.input("//gs disable ammo")
	coroutine.sleep(1)
	windower.chat.input("//gs disable range")
	coroutine.sleep(0.5)	
	
	windower.add_to_chat(8,'test line 1')	
	
	if pet.isvalid then
		return
		-- if pet.name~="HeraldHenry" or pet.name ~="Jovial Edwin" then
			-- add_to_chat(8,"Dismissing Current Pet")
			-- windower.chat.input("/pet \"Leave\" <me>")
        -- coroutine.sleep(0.5)
        -- windower.chat.input("/equip ammo \"Trans. Broth\"")
        -- coroutine.sleep(0.5)
        -- windower.chat.input("/ja \"Call Beast\" <me>")
			-- coroutine.sleep(2)
		-- end
	else
		windower.chat.input("/equip ammo \"Trans. Broth\"")
        coroutine.sleep(0.5)
        windower.chat.input("/ja \"Call Beast\" <me>")
			coroutine.sleep(2)
	end
	
	if pet.status ~= "Engaged"  then
		windower.chat.input("/pet \"Fight\"" .. target.name)
		coroutine.sleep(2)
	end
	
	if unleashed==false then 
		unleashed=true
		windower.chat.input("/ja \"Unleash\" <me>")
		coroutine.sleep(2)	
	end
		
	windower.chat.input("/pet \"Metallic Body\" <me>")
	coroutine.sleep(3)
	windower.chat.input("/pet \"Scissor Guard\" <me>")
	coroutine.sleep(3)
	windower.chat.input("/pet \"Bubble Guard\" <me>")
	coroutine.sleep(3)
	windower.chat.input("/pet \"Leave\" <me>")
	coroutine.sleep(0.5)
	
	windower.chat.input("/equip ammo \"Airy Broth\"")
	coroutine.sleep(0.5)
	windower.chat.input("/ja \"Call Beast\" <me>")
		coroutine.sleep(2)
	windower.chat.input("/pet \"Water Wall\" <me>")
	coroutine.sleep(3)
	windower.chat.input("/pet \"Leave\" <me>")
	coroutine.sleep(0.5)
	
	windower.chat.input("/equip ammo \"Fizzy Broth\"")
	coroutine.sleep(0.5)
	windower.chat.input("/ja \"Call Beast\" <me>")
		coroutine.sleep(2)
	windower.chat.input("/pet \"Zealous Snort\" <me>")
	coroutine.sleep(3)
	windower.chat.input("/pet \"Leave\" <me>")
	coroutine.sleep(0.5)

	windower.chat.input("/equip ammo \"Lyrical Broth\"")
	coroutine.sleep(0.5)
	windower.chat.input("/ja \"Call Beast\" <me>")
		coroutine.sleep(2)
	windower.chat.input("/pet \"Rage\" <me>")
	coroutine.sleep(3)
	windower.chat.input("/pet \"Leave\" <me>")
	coroutine.sleep(0.5)

	windower.chat.input("/equip ammo \"Frizzante Broth\"")
	coroutine.sleep(0.5)
	windower.chat.input("/ja \"Call Beast\" <me>")
		coroutine.sleep(2)
	windower.chat.input("/pet \"Frenzied Rage\" <me>")
	coroutine.sleep(3)
	windower.chat.input("/pet \"Leave\" <me>")
	coroutine.sleep(0.5)
	
	windower.add_to_chat(8,"Beastial Fury Completed - Summon New Pet!!!")
	
end


--BST_HUD--
--------------------------------------------------------------------------------------------------------------
-- HUD STUFF
--------------------------------------------------------------------------------------------------------------
function hud_toggle()

	if hud_style == 'full' then
		hud_style='lite'
		init_HUD()
		setupTextWindow()
	elseif hud_style == 'lite' then
		hud_style='full'
		init_HUD()
		setupTextWindow()
	end
end
require('logger')
require('tables')
require('strings')
function init_HUD()

	hud_y_pos_og = hud_y_pos
	hud_font_size_og = hud_font_size
	hud_padding_og = hud_padding
	hud_transparency_og = hud_transparency	
	hud_y_pos_og = hud_y_pos
	hud_font_size_og = hud_font_size
	hud_padding_og = hud_padding
	hud_transparency_og = hud_transparency

	MB_Window = 0
	time_start = 0
	hud_padding = 10

	-- Standard Mode
	if hud_style =='full' then
	hud_x_pos_og = hud_x_pos
	
	hub_mode_std = [[\cs${Header3}KeyBinds  \cs${Header1}Mode:             \cs${Header1}Status:
			\cs${Hotkey} ${KB_ML_M} \cs${Header2} Melee Mode:      \cs${Body1} ${player_current_melee}
			\cs${Hotkey} ${KB_WS_M} \cs${Header2} WS Mode:         \cs${Body1} ${player_current_ws}
			\cs${Hotkey} ${KB_PD_M} \cs${Header2} Hybrid Mode:     \cs${Body1} ${player_current_Hybrid}
			\cs${Hotkey} ${KB_ID_M} \cs${Header2} Idle Mode:       \cs${Body1} ${player_current_Idle}
			\cs${Hotkey} ${KB_AX_M} \cs${Header2} Weapon Mode:     \cs${Body1} ${player_current_AxeMode}
			\cs${Hotkey} ${KB_MC_M} \cs${Header2} Correlation Mode:\cs${Body1} ${player_current_CorrelationMode}
			\cs${Hotkey} ${KB_AF_M} \cs${Header2} Auto Fight Mode: \cs${Body1} ${player_current_AutoFightMode}			
			
			\cs${Header1}Familiar Information
			\cs${Header2} Pet Name: \cs${Body2}${PI_NM}
			\cs${Header2} Pet Job:  \cs${Body2}${PI_PJ} 
			\cs${Header2} Pet Info: \cs${Body2}${PI_PI}
				 			   
			\cs${Header3}KeyBinds   \cs${Header1}WS Name   \cs${Header1}crg \cs${Header1}Type   \cs${Header1}Element \cs${Header1}Effect
			\cs${Hotkey} ${KB_RD_1}  \cs${Info}${PI_R1_N} \cs${Info} ${PI_R1_C} \cs${Info} ${PI_R1_T}  \cs${Info}${PI_R1_L}\cs${Info} ${PI_R1_E}
			\cs${Hotkey} ${KB_RD_2}  \cs${Info}${PI_R2_N} \cs${Info} ${PI_R2_C} \cs${Info} ${PI_R2_T}  \cs${Info}${PI_R2_L}\cs${Info} ${PI_R2_E}
			\cs${Hotkey} ${KB_RD_3}  \cs${Info}${PI_R3_N} \cs${Info} ${PI_R3_C} \cs${Info} ${PI_R3_T}  \cs${Info}${PI_R3_L}\cs${Info} ${PI_R3_E}
			\cs${Hotkey} ${KB_RD_4}  \cs${Info}${PI_R4_N} \cs${Info} ${PI_R4_C} \cs${Info} ${PI_R4_T}  \cs${Info}${PI_R4_L}\cs${Info} ${PI_R4_E}
			\cs${Hotkey} ${KB_RD_5}  \cs${Info}${PI_R5_N} \cs${Info} ${PI_R5_C} \cs${Info} ${PI_R5_T}  \cs${Info}${PI_R5_L}\cs${Info} ${PI_R5_E}
			\cs${Hotkey} ${KB_RD_6}  \cs${Info}${PI_R6_N} \cs${Info} ${PI_R6_C} \cs${Info} ${PI_R6_T}  \cs${Info}${PI_R6_L}\cs${Info} ${PI_R6_E}
			\cs${Hotkey} ${KB_RD_7}  \cs${Info}${PI_R7_N} \cs${Info} ${PI_R7_C} \cs${Info} ${PI_R7_T}  \cs${Info}${PI_R7_L}\cs${Info} ${PI_R7_E}			
	]]
	elseif hud_style=='lite' then
	hud_x_pos_og = hud_x_pos_lite
	
		hub_mode_std = [[\cs${Header3}KeyBinds   \cs${Header1}Mode   \cs${Header1}Status
			\cs${Hotkey} ${KB_ML_M} \cs${Header2} Ml Md: \cs${Body1} ${player_current_melee}
			\cs${Hotkey} ${KB_WS_M} \cs${Header2} WS Md: \cs${Body1} ${player_current_ws}
			\cs${Hotkey} ${KB_PD_M} \cs${Header2} Hy Md: \cs${Body1} ${player_current_Hybrid}
			\cs${Hotkey} ${KB_ID_M} \cs${Header2} Id Md: \cs${Body1} ${player_current_Idle}
			\cs${Hotkey} ${KB_AX_M} \cs${Header2} WP Md: \cs${Body1} ${player_current_AxeMode}
			\cs${Hotkey} ${KB_MC_M} \cs${Header2} CO Md: \cs${Body1} ${player_current_CorrelationMode}
			\cs${Hotkey} ${KB_AF_M} \cs${Header2} AF Md: \cs${Body1} ${player_current_AutoFightMode}
					   
			\cs${Header3}KeyBinds   \cs${Header1}WS Name   \cs${Header1}Element
			\cs${Hotkey} ${KB_RD_1}  \cs${Info}${PI_R1_N} \cs${Info}${PI_R1_L}
			\cs${Hotkey} ${KB_RD_2}  \cs${Info}${PI_R2_N} \cs${Info}${PI_R2_L}
			\cs${Hotkey} ${KB_RD_3}  \cs${Info}${PI_R3_N} \cs${Info}${PI_R3_L}
			\cs${Hotkey} ${KB_RD_4}  \cs${Info}${PI_R4_N} \cs${Info}${PI_R4_L}
			\cs${Hotkey} ${KB_RD_5}  \cs${Info}${PI_R5_N} \cs${Info}${PI_R5_L}
			\cs${Hotkey} ${KB_RD_6}  \cs${Info}${PI_R6_N} \cs${Info}${PI_R6_L}
			\cs${Hotkey} ${KB_RD_7}  \cs${Info}${PI_R7_N} \cs${Info}${PI_R7_L}	
		]]	
	end

	-- init style
	hub_mode = hub_mode_std


	KB = {}
	KB['KB_AF_M'] = '(NUM .)'
	KB['KB_ML_M'] = '(NUM /)'
	KB['KB_WS_M'] = '(NUM *)'
	KB['KB_PD_M'] = '(NUM -)'
	KB['KB_ID_M'] = '(NUM +)'
	KB['KB_MC_M'] = '(NUM 9)'
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
	pet_info_update()
    --Mode Information
    main_text_hub.player_current_melee =  state.OffenseMode.current
	main_text_hub.player_current_ws =  state.WeaponskillMode.current
	main_text_hub.player_current_Hybrid = state.HybridMode.current
	main_text_hub.player_current_Idle = state.IdleMode.current	
	main_text_hub.player_current_AxeMode = state.AxeMode.current	
	main_text_hub.player_current_CorrelationMode = state.CorrelationMode.current	
	main_text_hub.player_current_AutoFightMode = state.AutoFight.current
	
	main_text_hub.Header1= '(202,109,87)'
	main_text_hub.Header2= '(177,169,5)'
	main_text_hub.Header3= '(202,109,87)'
	main_text_hub.Body1	= '(175,212,204)'
	main_text_hub.Body2	= '(242,242,208)'
	main_text_hub.Hotkey	= '(94,213,123)'
	main_text_hub.Info	= '(220,220,220)'

	
	main_text_hub.PI_NM = PetName
	main_text_hub.PI_PJ = PetJob
	main_text_hub.PI_PI = PetInfo
	if hud_style=='full' then
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
		main_text_hub.PI_R6_C = ReadyMoveSix.Cost
		main_text_hub.PI_R6_T = ReadyMoveSix.Type
		main_text_hub.PI_R6_L = ReadyMoveSix.Element
		main_text_hub.PI_R6_E = ReadyMoveSix.Effect

		main_text_hub.PI_R7_N = ReadyMoveSeven.Name
		main_text_hub.PI_R7_C = ReadyMoveSeven.Cost
		main_text_hub.PI_R7_T = ReadyMoveSeven.Type 
		main_text_hub.PI_R7_L = ReadyMoveSeven.Element
		main_text_hub.PI_R7_E = ReadyMoveSeven.Effect	
    elseif hud_style=='lite' then
		main_text_hub.PI_R1_N = ReadyMoveOne.Name
		main_text_hub.PI_R1_L = ReadyMoveOne.Element

		main_text_hub.PI_R2_N = ReadyMoveTwo.Name
		main_text_hub.PI_R2_L = ReadyMoveTwo.Element

		main_text_hub.PI_R3_N = ReadyMoveThree.Name	
		main_text_hub.PI_R3_L = ReadyMoveThree.Element

		main_text_hub.PI_R4_N = ReadyMoveFour.Name
		main_text_hub.PI_R4_L = ReadyMoveFour.Element

		main_text_hub.PI_R5_N = ReadyMoveFive.Name
		main_text_hub.PI_R5_L = ReadyMoveFive.Element


		main_text_hub.PI_R6_N = ReadyMoveSix.Name
		main_text_hub.PI_R6_L = ReadyMoveSix.Element


		main_text_hub.PI_R7_N = ReadyMoveSeven.Name
		main_text_hub.PI_R7_L = ReadyMoveSeven.Element

	end 	
	
end

function setupTextWindow()

    local default_settings = {}
    default_settings.pos = {}
	if hud_style == "full" then
		default_settings.pos.x = hud_x_pos
	elseif hud_style == "lite" then
	    default_settings.pos.x = hud_x_pos_lite
	end
    default_settings.pos.y = hud_y_pos
	
    default_settings.bg = {}
    default_settings.bg.alpha = hud_transparency
    default_settings.bg.red = 75
    default_settings.bg.green = 62
    default_settings.bg.blue = 67
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
	
    if not (main_text_hub == nil) then
		texts.destroy(main_text_hub)
    end
    main_text_hub = texts.new('', default_settings, default_settings)

    texts.append(main_text_hub, hub_mode)
	texts.update(main_text_hub, KB)

    validateTextInformation()

    --Finally we show this to the user
    main_text_hub:show()
    
end



--[AUTO MOVEMENT SPEED LOGIC]

runspeed = M(false)
mov = {counter=0}
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
	mov.x = windower.ffxi.get_mob_by_index(player.index).x
	mov.y = windower.ffxi.get_mob_by_index(player.index).y
	mov.z = windower.ffxi.get_mob_by_index(player.index).z
end
moving = false

windower.raw_register_event('prerender',function()
	mov.counter = mov.counter + 1;
	if mov.counter>30 then
		local pl = windower.ffxi.get_mob_by_index(player.index)
		if pl and pl.x and mov.x then
			local movement = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 ) > 0.1
			if movement and not moving then
				send_command('gs c runspeed')

				moving = true
			elseif not movement and moving then
				send_command('gs c runspeed')

				moving = false
			end
		end

		if pl and pl.x then
			mov.x = pl.x
			mov.y = pl.y
			mov.z = pl.z
		end
		mov.counter = 0
	end
end)

function updateRunspeedGear()   
	handle_equipping_gear(player.status, pet.status)
end
