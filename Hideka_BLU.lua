-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--				[ CTRL+`]			Toggle TREASURE HUNTER Mode
--
--  Abilities:  [ CTRL+- ]          Chain Affinity
--              [ CTRL+= ]          Burst Affinity
--              [ CTRL+[ ]          Efflux
--              [ ALT+[ ]           Diffusion
--              [ ALT+] ]           Unbridled Learning
--              [ CTRL+Numpad/ ]    Berserk
--              [ CTRL+Numpad* ]    Warcry
--              [ CTRL+Numpad- ]    Aggressor
--
--  Spells:     [ CTRL+` ]          Blank Gaze
--              [ ALT+Q ]            Nature's Meditation/Fantod
--              [ ALT+W ]           Cocoon/Reactor Cool
--              [ ALT+E ]           Erratic Flutter
--              [ ALT+R ]           Battery Charge/Refresh
--              [ ALT+T ]           Occultation
--              [ ALT+Y ]           Barrier Tusk/Phalanx
--              [ ALT+U ]           Diamondhide/Stoneskin
--              [ ALT+P ]           Mighty Guard/Carcharian Verve
--              [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Savage Blade
--              [ CTRL+Numpad9 ]    Chant Du Cygne
--              [ CTRL+Numpad4 ]    Requiescat
--              [ CTRL+Numpad5 ]    Expiacion
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


--------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
include('organizer-lib')
include('Modes.lua')
send_command('input //send @all lua l superwarp') 


organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
    NinjaTools={"Shihei"},
	Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},
}

PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

function get_gear()
	send_command('wait 3;input //gs org')
	add_to_chat(8,'REMEMBER TO REPACK GEAR')
end

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

--- Augmented Gear
	
	CarmineMask = {}
	-- CarmineMask.MND = { name = "Carmine Mask +1", augments = { 'Accuracy+12','DEX+12','MND+20', } }
	CarmineMask.FC = { name = "Carmine Mask +1", augments = { 'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4', }}

	AdhemarWrist = {}
    AdhemarWrist.DEX = { name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}}
	
    HerculeanHelm = {}
    HerculeanHelm.Refresh = { name="Herculean Helm", augments={'STR+7','Pet: Accuracy+12 Pet: Rng. Acc.+12','"Refresh"+2','Accuracy+7 Attack+7','Mag. Acc.+14 "Mag.Atk.Bns."+14',}}
    HerculeanHelm.WSD = { name="Herculean Helm", augments={'Weapon skill damage +5%','STR+1','Attack+13',}}
    
    HerculeanVest = {}
    HerculeanVest.TH = { name="Herculean Vest", augments={'Pet: Mag. Acc.+12','Accuracy+10 Attack+10','"Treasure Hunter"+2',}}
	-- HerculeanVest.Phalanx = { name="Herculean Vest", augments = {'Accuracy+2','DEX+8','Phalanx +2','Accuracy+1 Attack+1','Mag. Acc.+20 "Mag.Atk.Bns."+20',}}
    -- HerculeanVest.CDC  = { name="Herculean Vest", augments={'Accuracy+19 Attack+19','Crit. hit damage +3%','DEX+14','Accuracy+3',}}
    
    HerculeanGloves = {}
	HerculeanGloves.TA = { name="Herculean Gloves", augments={'Accuracy+19','"Triple Atk."+4','STR+2',}}
	HerculeanGloves.QA = { name="Herculean Gloves", augments={'Crit.hit rate+1','Enmity-2','Quadruple Attack +3',}}
    HerculeanGloves.Idle = { name="Herculean Gloves", augments={'AGI+9','"Mag.Atk.Bns."+21','"Refresh"+2',}}
    
    HerculeanLegs = {}
    HerculeanLegs.WSD = { name="Herculean Trousers", augments={'Attack+25','Weapon skill damage +4%','STR+6','Accuracy+10',}}
	HerculeanLegs.Idle = { name="Herculean Trousers", augments={'Crit. hit damage +1%','Pet: Phys. dmg. taken -4%','"Refresh"+2',}}
    -- HerculeanLegs.TH = { name = "Herculean Trousers", augments = { 'INT+5','MND+6','"Treasure Hunter"+1','Mag. Acc.+17 "Mag.Atk.Bns."+17', } }
	
    HerculeanFeet = {}
    -- HerculeanFeet.QA = { name = "Herculean Boots", augments = { 'AGI+4', '"Dbl.Atk."+2', 'Quadruple Attack +3', 'Accuracy+4 Attack+4', } }
    HerculeanFeet.TA={ name="Herculean Boots", augments={'Attack+28','"Triple Atk."+3','STR+8',}}
	HerculeanFeet.Idle = { name="Herculean Boots", augments={'Crit. hit damage +3%','Pet: INT+13','"Refresh"+2','Accuracy+20 Attack+20',}}
	HerculeanFeet.WSD={ name="Herculean Boots", augments={'STR+8','Phys. dmg. taken -2%','Weapon skill damage +5%','Accuracy+19 Attack+19','Mag. Acc.+12 "Mag.Atk.Bns."+12',}}
    HerculeanFeet.WSDATK={ name="Herculean Boots", augments={'Accuracy+16 Attack+16','Weapon skill damage +3%','DEX+4','Attack+15',}}	
	HerculeanFeet.TH = { name="Herculean Boots", augments={'Weapon skill damage +1%','CHR+14','"Treasure Hunter"+2','Accuracy+13 Attack+13','Mag. Acc.+7 "Mag.Atk.Bns."+7',}}
    
    Rosmerta = {}	
    Rosmerta.Crit = { name = "Rosmerta's Cape", augments = { 'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10', } }
    Rosmerta.WSD = { name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20', 'STR+10','Weapon skill damage +10%',}}
    Rosmerta.STP = { name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}}
    Rosmerta.DA = { name = "Rosmerta's Cape", augments = { 'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10' } }	
    -- Rosmerta.DW = { name = "Rosmerta's Cape", augments = { 'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10' } }
    Rosmerta.Nuke = { name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10', } }
    -- Rosmerta.Cure = { name = "Rosmerta's Cape", augments = { 'MND+20','Eva.+20 /Mag. Eva.+20','"Cure" potency +10%' } }
    -- Rosmerta.MagicEva = { name = "Rosmerta's Cape", augments = {'INT+20','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Haste+10' } }

    -- Load and initialize the include file.
    include('Mote-Include.lua')
	
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Chain Affinity'] = buffactive['Chain Affinity'] or false
    state.Buff.Convergence = buffactive.Convergence or false
    state.Buff.Diffusion = buffactive.Diffusion or false
    state.Buff.Efflux = buffactive.Efflux or false

    state.Buff['Unbridled Learning'] = buffactive['Unbridled Learning'] or false
    blue_magic_maps = {}

    -- Mappings for gear sets to use for various blue magic spells.
    -- While Str isn't listed for each, it's generally assumed as being at least
    -- moderately signficant, even for spells with other mods.

    -- Physical spells with no particular (or known) stat mods
    blue_magic_maps.Physical = S{'Bilgestorm'}

    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    blue_magic_maps.PhysicalAcc = S{'Heavy Strike'}

    -- Physical spells with Str stat mod
    blue_magic_maps.PhysicalStr = S{'Battle Dance','Bloodrake','Death Scissors','Dimensional Death',
        'Empty Thrash','Quadrastrike','Saurian Slide','Sinker Drill','Spinal Cleave','Sweeping Gouge',
        'Uppercut','Vertical Cleave'}

    -- Physical spells with Dex stat mod
    blue_magic_maps.PhysicalDex = S{'Amorphic Spikes','Asuran Claws','Barbed Crescent','Claw Cyclone',
        'Disseverment','Foot Kick','Frenetic Rip','Goblin Rush','Hysteric Barrage','Paralyzing Triad',
        'Seedspray','Sickle Slash','Smite of Rage','Terror Touch','Thrashing Assault','Vanity Dive'}

    -- Physical spells with Vit stat mod
    blue_magic_maps.PhysicalVit = S{'Body Slam','Cannonball','Glutinous Dart','Grand Slam',
        'Power Attack','Quad. Continuum','Sprout Smack','Sub-zero Smash'}

    -- Physical spells with Agi stat mod
    blue_magic_maps.PhysicalAgi = S{'Benthic Typhoon','Feather Storm','Helldive','Hydro Shot','Jet Stream',
        'Pinecone Bomb','Spiral Spin','Wild Oats'}

    -- Physical spells with Int stat mod
    blue_magic_maps.PhysicalInt = S{'Mandibular Bite','Queasyshroom'}

    -- Physical spells with Mnd stat mod
    blue_magic_maps.PhysicalMnd = S{'Ram Charge','Screwdriver','Tourbillion'}

    -- Physical spells with Chr stat mod
    blue_magic_maps.PhysicalChr = S{'Bludgeon'}

    -- Physical spells with HP stat mod
    blue_magic_maps.PhysicalHP = S{'Final Sting'}

    -- Magical spells with the typical Int mod
    blue_magic_maps.Magical = S{'Anvil Lightning','Blastbomb','Blazing Bound','Bomb Toss','Cursed Sphere',
        'Droning Whirlwind','Embalming Earth','Firespit','Foul Waters','Ice Break','Leafstorm',
        'Maelstrom','Molting Plumage','Nectarous Deluge','Regurgitation','Rending Deluge','Scouring Spate',
        'Silent Storm','Spectral Floe','Subduction','Tem. Upheaval','Water Bomb'}

    blue_magic_maps.MagicalDark = S{'Dark Orb','Death Ray','Eyes On Me','Evryone. Grudge','Palling Salvo',
        'Tenebral Crush'}

    blue_magic_maps.MagicalLight = S{'Blinding Fulgor','Diffusion Ray','Radiant Breath','Rail Cannon',
        'Retinal Glare'}

    -- Magical spells with a primary Mnd mod
    blue_magic_maps.MagicalMnd = S{'Acrid Stream','Magic Hammer','Mind Blast'}

    -- Magical spells with a primary Chr mod
    blue_magic_maps.MagicalChr = S{'Mysterious Light'}

    -- Magical spells with a Vit stat mod (on top of Int)
    blue_magic_maps.MagicalVit = S{'Thermal Pulse'}

    -- Magical spells with a Dex stat mod (on top of Int)
    blue_magic_maps.MagicalDex = S{'Charged Whisker','Gates of Hades'}

    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    blue_magic_maps.MagicAccuracy = S{'Entomb','Cruel Joke','1000 Needles','Absolute Terror','Actinic Burst','Atra. Libations',
        'Auroral Drape','Awful Eye', 'Blank Gaze','Blistering Roar','Blood Saber','Chaotic Eye',
        'Cimicine Discharge','Cold Wave','Corrosive Ooze','Delta Thrust','Demoralizing Roar','Digest','Dream Flower',
        'Enervation','Feather Tickle','Filamented Hold','Frightful Roar','Geist Wall','Hecatomb Wave',
        'Infrasonics','Jettatura','Light of Penance','Lowing','Mind Blast','Mortal Ray','MP Drainkiss',
        'Osmosis','Reaving Wind','Sandspin','Sandspray','Sheep Song','Soporific','Sound Blast',
        'Stinking Gas','Sub-zero Smash','Venom Shell','Voracious Trunk','Yawn'}

    -- Breath-based spells
    blue_magic_maps.Breath = S{'Bad Breath','Flying Hip Press','Frost Breath','Heat Breath','Hecatomb Wave',
        'Magnetite Cloud','Poison Breath','Self-Destruct','Thunder Breath','Vapor Spray','Wind Breath'}

    -- Stun spells
    blue_magic_maps.StunPhysical = S{'Frypan','Head Butt','Sudden Lunge','Tail slap','Whirl of Rage'}
    blue_magic_maps.StunMagical = S{'Blitzstrahl','Temporal Shift','Thunderbolt'}

    -- Healing spells
    blue_magic_maps.Healing = S{'Healing Breeze','Magic Fruit','Plenilune Embrace','Pollen','Restoral',
        'Wild Carrot'}

    -- Buffs that depend on blue magic skill
    blue_magic_maps.SkillBasedBuff = S{'Barrier Tusk','Diamondhide','Magic Barrier','Metallic Body',
        'Plasma Charge','Pyric Bulwark','Reactor Cool','Occultation'}

    -- Other general buffs
    blue_magic_maps.Buff = S{'Amplification','Animating Wail','Carcharian Verve','Cocoon',
        'Erratic Flutter','Exuviation','Fantod','Feather Barrier','Harden Shell','Memento Mori',
        'Nat. Meditation','Orcish Counterstance','Refueling','Regeneration','Saline Coat','Triumphant Roar',
        'Warm-Up','Winds of Promyvion','Zephyr Mantle'}

    blue_magic_maps.Refresh = S{'Battery Charge'}

    -- Spells that require Unbridled Learning to cast.
    unbridled_spells = S{'Absolute Terror','Bilgestorm','Blistering Roar','Bloodrake','Carcharian Verve','Cesspool',
        'Crashing Thunder','Cruel Joke','Droning Whirlwind','Gates of Hades','Harden Shell','Mighty Guard',
        'Polar Roar','Pyric Bulwark','Tearing Gust','Thunderbolt','Tourbillion','Uproot'}

    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    lockstyleset = 13
	 
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'STP')
    state.HybridMode:options('Normal', 'DT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.PhysicalDefenseMode:options('PDT', 'MDT')
    state.IdleMode:options('Normal','Regain','DT')--, 'Learning')

    state.MagicBurst = M(false, 'Magic Burst')
    state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds
    -- include('Global-Binds.lua') -- OK to remove this line
    -- include('Global-GEO-Binds.lua') -- OK to remove this line

    send_command('lua l gearinfo')
    send_command('lua l azureSets')

    send_command('bind ^` gs c cycle treasuremode')
    send_command('bind !` gs c toggle MagicBurst')
    send_command('bind ^- input /ja "Chain Affinity" <me>')
    send_command('bind ^[ input /ja "Efflux" <me>')
    send_command('bind ^= input /ja "Burst Affinity" <me>')
    send_command('bind ![ input /ja "Diffusion" <me>')
    send_command('bind !] input /ja "Unbridled Learning" <me>')
    send_command('bind !e input /ma "Erratic Flutter" <me>')
    send_command('bind !t input /ma "Occultation" <me>')

    if player.sub_job == "RDM" then
        send_command('bind !q input /ma "Fantod" <me>')
        send_command('bind !w input /ma "Reactor Cool" <me>')
        send_command('bind !r input /ma "Refresh" <stpc>')
        send_command('bind !y input /ma "Phalanx" <me>')
        send_command('bind !u input /ma "Stoneskin" <me>')
        send_command('bind !p input /ma "Carcharian Verve" <me>')
    else
        send_command('bind !q input /ma "Nat. Meditation" <me>')
        send_command('bind !w input /ma "Cocoon" <me>')
        send_command('bind !r input /ma "Battery Charge" <me>')
        send_command('bind !y input /ma "Barrier Tusk" <me>')
        send_command('bind !u input /ma "Diamondhide" <me>')
        send_command('bind !p input /ma "Mighty Guard" <me>')
    end

    send_command('bind @c gs c toggle CP')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    end

    send_command('bind ^numpad7 input /ws "Savage Blade" <t>')
    send_command('bind ^numpad9 input /ws "Chant du Cygne" <t>')
    send_command('bind ^numpad4 input /ws "Requiescat" <t>')
    send_command('bind ^numpad5 input /ws "Expiacion" <t>')
    send_command('bind ^numpad1 input /ws "Sanguine Blade" <t>')
    send_command('bind ^numpad2 input /ws "Black Halo" <t>')

    select_default_macro_book()
    set_lockstyle()

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind ^[')
    send_command('unbind ![')
    send_command('unbind !]')
    send_command('unbind !q')
    send_command('unbind !w')
    send_command('bind !e input /ma Haste <stpc>')
    send_command('bind !t input /ma Blink <me>')
    send_command('bind !r input /ma Refresh <stpc>')
    send_command('bind !y input /ma Phalanx <me>')
    send_command('bind !u input /ma Stoneskin <me>')
    send_command('unbind !p')
    send_command('unbind ^,')
    send_command('unbind @c')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad9')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad1')
    send_command('unbind ^numpad2')

    send_command('unbind #`')
    send_command('unbind #1')
    send_command('unbind #2')
    send_command('unbind #3')
    send_command('unbind #4')
    send_command('unbind #5')
    send_command('unbind #6')
    send_command('unbind #7')
    send_command('unbind #8')
    send_command('unbind #9')
    send_command('unbind #0')

    send_command('lua u gearinfo')
    send_command('lua u azureSets')

end

-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Precast sets to enhance JAs

    -- Enmity set
    sets.Enmity = {
		ammo="Sapience Orb",
		head="Malignance Chapeau",
		body="Passion Jacket",
		hands="Malignance Gloves",
		legs="Zoar Subligar +1",
		feet="Ahosi Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear="Cryptic Earring",
		right_ear="Friomisi Earring",
		left_ring="Provocare Ring",
		right_ring="Begrudging Ring",
		back="Reiki Cloak",
	}

    sets.precast.JA['Provoke'] = sets.Enmity

    sets.buff['Burst Affinity'] = {legs="Assim. Shalwar +3", feet="Hashi. Basmak +1"}
    sets.buff['Diffusion'] = {feet="Luhlaza Charuqs +1"}
    sets.buff['Efflux'] = {back=Rosmerta.Crit, legs="Hashishin Tayt +1"}

    sets.precast.JA['Azure Lore'] = {hands="Luhlaza Bazubands"}
    sets.precast.JA['Chain Affinity'] = {head = "Hashishin Kavuk +1", body = "Luhlaza Jubbah +1", feet = "Assim. Charuqs +3" }
    sets.precast.JA['Convergence'] = {head="Luhlaza Keffiyeh +1"}
    sets.precast.JA['Enchainment'] = {body="Luhlaza Jubbah +1"}

    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Orunmila's Torque",
		waist="Eschan Stone",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Rahab Ring",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
    }

    sets.precast.FC['Blue Magic'] = set_combine(sets.precast.FC, {body="Hashishin Mintan +1"})
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash"})
    sets.precast.FC.Cure = set_combine(sets.precast.FC, {ammo="Impatiens", ear1="Mendi. Earring"})

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {body="Passion Jacket"})


    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
        neck="Fotia Gorget",
        waist="Fotia Belt",
	}

    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})

    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Gleti's Cuirass",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		left_ear="Mache Earring +1",
		right_ear="Mache Earring +1",
		left_ring="Ilabrat Ring",
		right_ring="Begrudging Ring",
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
	})

    sets.precast.WS['Chant du Cygne'].Acc = set_combine(sets.precast.WS['Chant du Cygne'], {

    })

    sets.precast.WS['Vorpal Blade'] = sets.precast.WS['Chant du Cygne']
    sets.precast.WS['Vorpal Blade'].Acc = sets.precast.WS['Chant du Cygne'].Acc

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
		ammo		= "Coiste Bodhar",
		head		= "Nyame Helm",
		body		= "Nyame Mail",
		hands		= "Nyame Gauntlets",
		legs		= "Nyame Flanchard",
		feet		= "Nyame Sollerets",
		neck		= "Rep. Plat. Medal",
		waist		= "Sailfi Belt +1",
		left_ear	= {name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear	= "Ishvara Earring",
		left_ring	= "Metamor. Ring +1",
		right_ring	= "Epaminondas's Ring",	
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    })

    sets.precast.WS['Requiescat'] = {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Regal Earring",
		left_ring="Epona's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
	}

    sets.precast.WS['Requiescat'].Acc = set_combine(sets.precast.WS['Requiescat'], {})
    sets.precast.WS['Expiacion'] = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Expiacion'].Acc = set_combine(sets.precast.WS['Expiacion'], {})
    sets.precast.WS['Savage Blade'].Acc = set_combine(sets.precast.WS['Savage Blade'], {})
	
    sets.precast.WS['Sanguine Blade'] = {
		ammo="Pemphredo Tathlum",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Jhakri Cuffs +2",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
    }

    sets.precast.WS['True Strike'] = sets.precast.WS['Savage Blade']
    sets.precast.WS['True Strike'].Acc = sets.precast.WS['Savage Blade'].Acc
    sets.precast.WS['Judgment'] = sets.precast.WS['True Strike']
    sets.precast.WS['Judgment'].Acc = sets.precast.WS['True Strike'].Acc
    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS['Savage Blade'], {})
    sets.precast.WS['Black Halo'].Acc = set_combine(sets.precast.WS['Black Halo'], {})
    sets.precast.WS['Realmrazer'] = set_combine(sets.precast.WS['Requiescat'], {})
   	sets.precast.WS['Realmrazer'].Acc = sets.precast.WS['Requiescat'].Acc
    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS['Sanguine Blade'], {})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {
        ammo="Impatiens", --10
        }

    sets.midcast['Blue Magic'] = {
		ammo="Sapience Orb",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Assim. Jubbah",
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet="Malignance Boots",
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
	}
    sets.midcast['Blue Magic'].Physical = {
		ammo="Ginsen",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Incanter's Torque",
		waist="Reiki Yotai",
		left_ear="Telos Earring",
		right_ear="Mache Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10' ,}},
        }

    sets.midcast['Blue Magic'].PhysicalAcc = set_combine(sets.midcast['Blue Magic'].Physical, {})
    sets.midcast['Blue Magic'].PhysicalStr = sets.midcast['Blue Magic'].Physical
    sets.midcast['Blue Magic'].PhysicalDex = set_combine(sets.midcast['Blue Magic'].Physical, {})
    sets.midcast['Blue Magic'].PhysicalVit = sets.midcast['Blue Magic'].Physical
    sets.midcast['Blue Magic'].PhysicalAgi = set_combine(sets.midcast['Blue Magic'].Physical, {})
    sets.midcast['Blue Magic'].PhysicalInt = set_combine(sets.midcast['Blue Magic'].Physical, {})
    sets.midcast['Blue Magic'].PhysicalMnd = set_combine(sets.midcast['Blue Magic'].Physical, {})
    sets.midcast['Blue Magic'].PhysicalChr = set_combine(sets.midcast['Blue Magic'].Physical, {})

    sets.midcast['Blue Magic'].Magical = {
		ammo="Ghastly Tathlum +1",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs="Amalric Slops +1",
		feet="Amalric Nails +1",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring	= { name="Metamor. Ring +1", augments={'Path: A',}},
		right_ring="Shiva Ring +1",
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
        }

    sets.midcast['Blue Magic'].Magical.Resistant = set_combine(sets.midcast['Blue Magic'].Magical, {})
    sets.midcast['Blue Magic'].MagicalDark = set_combine(sets.midcast['Blue Magic'].Magical, {head = "Pixie Hairpin +1",right_ring="Archon Ring"})
    sets.midcast['Blue Magic'].MagicalLight = set_combine(sets.midcast['Blue Magic'].Magical, {right_ring="Weather. Ring"})
    sets.midcast['Blue Magic'].MagicalMnd = set_combine(sets.midcast['Blue Magic'].Magical, {})
    sets.midcast['Blue Magic'].MagicalDex = set_combine(sets.midcast['Blue Magic'].Magical, {})
    sets.midcast['Blue Magic'].MagicalVit = set_combine(sets.midcast['Blue Magic'].Magical, {})
    sets.midcast['Blue Magic'].MagicalChr = set_combine(sets.midcast['Blue Magic'].Magical, {})
    sets.midcast['Blue Magic'].MagicAccuracy = {
		ammo="Pemphredo Tathlum",
		head="Malignance Chapeau",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Gwati Earring",
		right_ear="Regal Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
	}
    sets.midcast['Blue Magic'].Breath = set_combine(sets.midcast['Blue Magic'].Magical, {head="Luh. Keffiyeh +1"})
    sets.midcast['Blue Magic'].StunPhysical = set_combine(sets.midcast['Blue Magic'].MagicAccuracy, {})
    sets.midcast['Blue Magic'].StunMagical = sets.midcast['Blue Magic'].MagicAccuracy

    sets.midcast['Blue Magic'].Healing = {
		ammo="Impatiens",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body="Jhakri Robe +2",
		hands={ name="Telchine Gloves", augments={'"Conserve MP"+1',}},
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet="Malignance Boots",
		neck="Incanter's Torque",
		waist="Gishdubar Sash",
		left_ear="Mendi. Earring",
		right_ear="Regal Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back="Moonbeam Cape",
        }

    sets.midcast['Blue Magic'].HealingSelf = set_combine(sets.midcast['Blue Magic'].Healing, {})

    sets.midcast['Blue Magic']['White Wind'] = set_combine(sets.midcast['Blue Magic'].Healing, {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet="Malignance Boots",
		neck="Incanter's Torque",
		waist="Gishdubar Sash",
		left_ear="Tuisto Earring",
		right_ear="Odonowa Earring +1",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back="Moonbeam Cape",
        })

    sets.midcast['Blue Magic'].Buff = sets.midcast['Blue Magic']
    sets.midcast['Blue Magic'].Refresh = set_combine(sets.midcast['Blue Magic'], {head="Amalric Coif +1", waist="Gishdubar Sash", back="Grapevine Cape"})
    sets.midcast['Blue Magic'].SkillBasedBuff = sets.midcast['Blue Magic']
    sets.midcast['Blue Magic']['Occultation'] = set_combine(sets.midcast['Blue Magic'], {}) -- 1 shadow per 50 skill
    sets.midcast['Blue Magic']['Carcharian Verve'] = set_combine(sets.midcast['Blue Magic'].Buff, {})
    sets.midcast['Enhancing Magic'] = {
		ammo="Pemphredo Tathlum",
		head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		hands="Nyame Gauntlets",
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		neck="Incanter's Torque",
		waist="Austerity Belt",
		left_ear="Calamitous Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Merciful Cape",	
	}
    sets.midcast.EnhancingDuration = {
		ammo="Pemphredo Tathlum",
		head={ name="Telchine Cap", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		neck="Incanter's Torque",
		waist="Austerity Belt",
		left_ear="Calamitous Earring",
		right_ear="Gifted Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Aurist's Cape +1",	
	}
    sets.midcast.Refresh = set_combine(sets.midcast.EnhancingDuration, {head="Amalric Coif +1", waist="Gishdubar Sash", back="Grapevine Cape"})
    sets.midcast.Stoneskin = set_combine(sets.midcast.EnhancingDuration, {hands="Stone Mufflers", ear2="Earthcry Earring", waist="Siegel Sash"})
    sets.midcast.Phalanx = set_combine(sets.midcast.EnhancingDuration, {})
    sets.midcast.Aquaveil = set_combine(sets.midcast.EnhancingDuration, {head="Amalric Coif +1", waist="Emphatikos Rope", hands="Regal Cuffs",})
    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {ring1="Sheltered Ring"})
    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect
    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt

    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Resting sets
    sets.resting = {}

    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body="Jhakri Robe +2",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Loricate Torque +1",
		waist="Carrier's Sash",
		left_ear="Eabani Earring",
		right_ear="Etiolation Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonbeam Cape",
    }
--[[
    sets.idle.DT = set_combine(sets.idle, {
		head="Malignance Chapeau",
		feet="Malignance Boots",
		right_ring="Defending Ring",
    })
]]
    sets.idle.Regain = {
		ammo="Staunch Tathlum",
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Eabani Earring",
		right_ear="Tuisto Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonbeam Cape",
    }
    sets.idle.DT = {
		ammo="Amar Cluster",
		head="Nyame Helm",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Unmoving Collar +1",
		waist="Carrier's Sash",
		left_ear="Eabani Earring",
		right_ear="Ethereal Earring",
		left_ring="Gelatinous Ring +1",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
    }
    sets.idle.Town = set_combine(sets.idle, {})

    sets.idle.Weak = {
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Unmoving Collar +1",
		waist="Carrier's Sash",
		left_ear="Eabani Earring",
		right_ear="Tuisto Earring",
		left_ring="Gelatinous Ring +1",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
    }

    --sets.idle.Learning = set_combine(sets.idle, sets.Learning)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = set_combine(sets.idle.DT, {})
    sets.defense.MDT = set_combine(sets.idle.DT, {

	})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		ammo = "Coiste Bodhar",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Asperity Necklace",
		waist="Reiki Yotai",
		left_ear="Sherida Earring",				
		right_ear="Eabani Earring",
		left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
		right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
		back={ name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
        }

    sets.engaged.LowAcc = set_combine(sets.engaged, 									
		{left_ring="Chirich Ring +1", right_ring="Chirich Ring +1", })
    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, 								
		{left_ring="Chirich Ring +1", right_ring="Chirich Ring +1",left_ear="Mache Earring +1", right_ear="Telos Earring",  })
    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, 							
		{left_ring="Chirich Ring +1", right_ring="Chirich Ring +1",left_ear="Mache Earring +1", right_ear="Telos Earring",neck="Sanctity Necklace",waist="Grunfeld Rope",})
    sets.engaged.STP = set_combine(sets.engaged, { })

    -- Base Dual-Wield Values:
    -- * DW6: +37%
    -- * DW5: +35%
    -- * DW4: +30%
    -- * DW3: +25% (NIN Subjob)
    -- * DW2: +15% (DNC Subjob)
    -- * DW1: +10%

    -- No Magic Haste (74% DW to cap)
    sets.engaged.DW = set_combine(sets.engaged,{
	}) -- 31%

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, {})
    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, {})
    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, {})
    sets.engaged.DW.STP = set_combine(sets.engaged.DW, { })
	
    -- 15% Magic Haste (67% DW to cap)
    sets.engaged.DW.LowHaste = set_combine(sets.engaged,{}) -- 31%
    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, {})
    sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste,{})
    sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste,{})
    sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste,{})

    -- 30% Magic Haste (56% DW to cap)
    sets.engaged.DW.MidHaste = set_combine(sets.engaged,{})

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste,{})
    sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste,{})
    sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste,{})
    sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste,{})

    -- 35% Magic Haste (51% DW to cap)
    sets.engaged.DW.HighHaste = set_combine(sets.engaged,{})

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, {})
    sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste,{})
    sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste,{})
    sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste,{})

    -- 45% Magic Haste (36% DW to cap)
    sets.engaged.DW.MaxHaste = set_combine(sets.engaged,{})

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste,{})
    sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste,{})
    sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste,{})
    sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, 				
		{ })

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = { 
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
	}

    sets.engaged.DT = set_combine(sets.engaged, sets.engaged.Hybrid)
    sets.engaged.LowAcc.DT = set_combine(sets.engaged.LowAcc, sets.engaged.Hybrid)
    sets.engaged.MidAcc.DT = set_combine(sets.engaged.MidAcc, sets.engaged.Hybrid)
    sets.engaged.HighAcc.DT = set_combine(sets.engaged.HighAcc, sets.engaged.Hybrid)
    sets.engaged.STP.DT = set_combine(sets.engaged.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT = set_combine(sets.engaged.DW, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT = set_combine(sets.engaged.DW.LowAcc, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT = set_combine(sets.engaged.DW.MidAcc, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT = set_combine(sets.engaged.DW.HighAcc, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT = set_combine(sets.engaged.DW.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.LowHaste = set_combine(sets.engaged.DW.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.LowHaste = set_combine(sets.engaged.DW.HighAcc.LowHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.LowHaste = set_combine(sets.engaged.DW.STP.LowHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MidHaste = set_combine(sets.engaged.DW.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MidHaste = set_combine(sets.engaged.DW.HighAcc.MidHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MidHaste = set_combine(sets.engaged.DW.STP.MidHaste, sets.engaged.Hybrid)

    sets.engaged.DW.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.HighHaste = set_combine(sets.engaged.DW.HighAcc.HighHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.HighHaste = set_combine(sets.engaged.DW.HighHaste.STP, sets.engaged.Hybrid)

    sets.engaged.DW.DT.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.MaxHaste = set_combine(sets.engaged.DW.HighAcc.MaxHaste, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.MaxHaste = set_combine(sets.engaged.DW.STP.MaxHaste, sets.engaged.Hybrid)


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.magic_burst = set_combine(sets.midcast['Blue Magic'].Magical, {

        })

    sets.Kiting = {legs="Carmine Cuisses +1"}
    sets.Learning = {hands="Assim. Bazu. +2"}
    sets.latent_refresh = {waist="Fucho-no-obi"}

    sets.buff.Doom = {
        waist="Gishdubar Sash", --10
        }

    sets.CP = {back="Mecisto. Mantle"}
    sets.TreasureHunter = {
		body=HerculeanVest.TH,
		feet=HerculeanFeet.TH
	}
    sets.midcast.Dia = sets.TreasureHunter
    sets.midcast.Diaga = sets.TreasureHunter
    sets.midcast.Bio = sets.TreasureHunter
    --sets.Reive = {neck="Ygnas's Resolve +1"}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if unbridled_spells:contains(spell.english) and not state.Buff['Unbridled Learning'] then
        eventArgs.cancel = true
        windower.send_command('@input /ja "Unbridled Learning" <me>; wait 1.5; input /ma "'..spell.name..'" <t>')
    end
    if spellMap == 'Utsusemi' then
        if buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)'] then
            cancel_spell()
            add_to_chat(123, '**!! '..spell.english..' Canceled: [3+ IMAGES] !!**')
            eventArgs.handled = true
            return
        elseif buffactive['Copy Image'] or buffactive['Copy Image (2)'] then
            send_command('cancel 66; cancel 444; cancel Copy Image; cancel Copy Image (2)')
        end
    end
end

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Add enhancement gear for Chain Affinity, etc.
    if spell.skill == 'Blue Magic' then
        for buff,active in pairs(state.Buff) do
			if active and sets.buff[buff] then
                equip(sets.buff[buff])
            end
        end
        if spellMap == 'Healing' and spell.target.type == 'SELF' then
            equip(sets.midcast['Blue Magic'].HealingSelf)
        end
	end
    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Dream Flower" then
            send_command('@timers c "Dream Flower ['..spell.target.name..']" 90 down spells/00098.png')
        elseif spell.english == "Soporific" then
            send_command('@timers c "Sleep ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sheep Song" then
            send_command('@timers c "Sheep Song ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Yawn" then
            send_command('@timers c "Yawn ['..spell.target.name..']" 60 down spells/00098.png')
        elseif spell.english == "Entomb" then
            send_command('@timers c "Entomb ['..spell.target.name..']" 60 down spells/00547.png')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)

--    if buffactive['Reive Mark'] then
--        if gain then
--            equip(sets.Reive)
--            disable('neck')
--        else
--            enable('neck')
--        end
--    end

    if buff == "doom" then
        if gain then
            equip(sets.buff.Doom)
            send_command('@input /echo Doomed.')
            disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_handle_equipping_gear(playerStatus, eventArgs)
    update_combat_form()
    determine_haste_group()
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
    th_update(cmdParams, eventArgs)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
end

-- Custom spell mapping.
-- Return custom spellMap value that can override the default spell mapping.
-- Don't return anything to allow default spell mapping to be used.
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == 'Blue Magic' then
        for category,spell_list in pairs(blue_magic_maps) do
            if spell_list:contains(spell.english) then
                return category
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    --if state.IdleMode.value == 'Learning' then
    --    equip(sets.Learning)
    --    disable('hands')
    --else
    --    enable('hands')
    --end
    if moving then
		idleSet=set_combine(idleSet, sets.Kiting)
	end
    return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local cf_msg = ''
    if state.CombatForm.has_value then
        cf_msg = ' (' ..state.CombatForm.value.. ')'
    end

    local m_msg = state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        m_msg = m_msg .. '/' ..state.HybridMode.value
    end

    local ws_msg = state.WeaponskillMode.value

    local c_msg = state.CastingMode.value

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.TreasureMode.value == 'Tag' then
        msg = msg .. ' TH: Tag |'
    end
    if state.MagicBurst.value then
        msg = ' Burst: On |'
    end
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Magic: ' ..string.char(31,001)..c_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
        if DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 21 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 21 and DW_needed <= 27 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 27 and DW_needed <= 37 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 37 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    gearinfo(cmdParams, eventArgs)
	if cmdParams[1] == 'runspeed' then
		runspeed:toggle()
		updateRunspeedGear(runspeed.value) 
	end
end

function gearinfo(cmdParams, eventArgs)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_needed then
            DW_needed = tonumber(cmdParams[2])
            DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
                DW_needed = 0
                DW = false
              end
        end
        if type(tonumber(cmdParams[3])) == 'number' then
              if tonumber(cmdParams[3]) ~= Haste then
                  Haste = tonumber(cmdParams[3])
            end
        end
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
        if not midaction() then
            job_update()
        end
    end
end

function update_active_abilities()
    state.Buff['Burst Affinity'] = buffactive['Burst Affinity'] or false
    state.Buff['Efflux'] = buffactive['Efflux'] or false
    state.Buff['Diffusion'] = buffactive['Diffusion'] or false
end

-- State buff checks that will equip buff gear and mark the event as handled.
function apply_ability_bonuses(spell, action, spellMap)
    if state.Buff['Burst Affinity'] and (spellMap == 'Magical' or spellMap == 'MagicalLight' or spellMap == 'MagicalDark' or spellMap == 'Breath') then
        if state.MagicBurst.value then
            equip(sets.magic_burst)
        end
        equip(sets.buff['Burst Affinity'])
    end
    if state.Buff.Efflux and spellMap == 'Physical' then
        equip(sets.buff['Efflux'])
    end
    if state.Buff.Diffusion and (spellMap == 'Buffs' or spellMap == 'BlueSkill') then
        equip(sets.buff['Diffusion'])
    end

    if state.Buff['Burst Affinity'] then equip (sets.buff['Burst Affinity']) end
    if state.Buff['Efflux'] then equip (sets.buff['Efflux']) end
    if state.Buff['Diffusion'] then equip (sets.buff['Diffusion']) end
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end

windower.register_event('zone change', 
    function()
        send_command('gi ugs true')
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(3, 3)
    elseif player.sub_job == 'RDM' then
        set_macro_page(1, 3)
    else
        set_macro_page(1, 3)
    end
    add_to_chat (55, 'You are on '..('BLU '):color(5)..''..('btw. '):color(55)..''..('Macros set!'):color(121))
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset ' .. lockstyleset)
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
	if mov.counter>10 then
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