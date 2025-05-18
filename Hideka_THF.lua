-- Original: Motenten / Modified: Arislan
-- Haste/DW Detection Requires Gearinfo Addon

-------------------------------------------------------------------------------------------------------------------
--  Keybinds
-------------------------------------------------------------------------------------------------------------------

--  Modes:      [ F9 ]              Cycle Offense Modes
--              [ CTRL+F9 ]         Cycle Hybrid Modes
--              [ WIN+F9 ]          Cycle Weapon Skill Modes
--              [ F10 ]             Emergency -PDT Mode
--              [ ALT+F10 ]         Toggle Kiting Mode
--              [ F11 ]             Emergency -MDT Mode
--              [ F12 ]             Update Current Gear / Report Current Status
--              [ CTRL+F12 ]        Cycle Idle Modes
--              [ ALT+F12 ]         Cancel Emergency -PDT/-MDT Mode
--              [ WIN+F ]           Toggle Closed Position (Facing) Mode
--              [ WIN+C ]           Toggle Capacity Points Mode
--
--  Abilities:  [ CTRL+- ]          Primary step element cycle forward.
--              [ CTRL+= ]          Primary step element cycle backward.
--              [ ALT+- ]           Secondary step element cycle forward.
--              [ ALT+= ]           Secondary step element cycle backward.
--              [ CTRL+[ ]          Toggle step target type.
--              [ CTRL+] ]          Toggle use secondary step.
--              [ Numpad0 ]         Perform Current Step
--
--              [ CTRL+` ]          Saber Dance
--              [ ALT+` ]           Chocobo Jig II
--              [ ALT+[ ]           Contradance
--              [ CTRL+Numlock ]    Reverse Flourish
--              [ CTRL+Numpad/ ]    Berserk/Meditate
--              [ CTRL+Numpad* ]    Warcry/Sekkanoki
--              [ CTRL+Numpad- ]    Aggressor/Third Eye
--              [ CTRL+Numpad+ ]    Climactic Flourish
--              [ CTRL+NumpadEnter ]Building Flourish
--              [ CTRL+Numpad0 ]    Sneak Attack
--              [ CTRL+Numpad. ]    Trick Attack
--
--  Spells:     [ WIN+, ]           Utsusemi: Ichi
--              [ WIN+. ]           Utsusemi: Ni
--
--  WS:         [ CTRL+Numpad7 ]    Exenterator
--              [ CTRL+Numpad4 ]    Evisceration
--              [ CTRL+Numpad5 ]    Rudra's Storm
--              [ CTRL+Numpad6 ]    Pyrrhic Kleos
--              [ CTRL+Numpad1 ]    Aeolian Edge
--
--
--              (Global-Binds.lua contains additional non-job-related keybinds)


-------------------------------------------------------------------------------------------------------------------
--  Custom Commands (preface with /console to use these in macros)
-------------------------------------------------------------------------------------------------------------------

--  gs c step                       Uses the currently configured step on the target, with either <t> or
--                                  <stnpc> depending on setting.
--  gs c step t                     Uses the currently configured step on the target, but forces use of <t>.
--
--  gs c cycle mainstep             Cycles through the available steps to use as the primary step when using
--                                  one of the above commands.
--  gs c cycle altstep              Cycles through the available steps to use for alternating with the
--                                  configured main step.
--  gs c toggle usealtstep          Toggles whether or not to use an alternate step.
--  gs c toggle selectsteptarget    Toggles whether or not to use <stnpc> (as opposed to <t>) when using a step
--[[gs c cycle treasuremode (set on ctrl-numpad9 by default): Cycles through the available treasure hunter modes.
     
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime
--]]
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------
send_command('input //send @all lua l superwarp') 
include('organizer-lib')
include('Modes.lua')
include('packets.lua')
send_command('unbind ^r')
organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
    NinjaTools={"Shihei","Toolbag (Shihe)"},
	Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},
}
PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

function get_gear()
	send_command('wait 3;input //gs org')
	add_to_chat(8,'REMEMBER TO REPACK GEAR')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    lockstyleset = 7
    include('Mote-TreasureHunter')
	
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false

	state.Buff['Aftermath: Lv.3'] = buffactive['Aftermath: Lv.3'] or false
	
    state.MainStep = M{['description']='Main Step', 'Box Step', 'Quickstep', 'Feather Step', 'Stutter Step'}
    state.AltStep = M{['description']='Alt Step', 'Quickstep', 'Feather Step', 'Stutter Step', 'Box Step'}
    state.UseAltStep = M(false, 'Use Alt Step')
    state.SelectStepTarget = M(false, 'Select Step Target')
    state.IgnoreTargetting = M(true, 'Ignore Targetting')

    state.ClosedPosition = M(false, 'Closed Position')

    state.CurrentStep = M{['description']='Current Step', 'Main', 'Alt'}
--  state.SkillchainPending = M(false, 'Skillchain Pending')

    state.CP = M(false, "Capacity Points Mode")


    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
     

 
    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('STP', 'Normal', 'LowAcc', 'MidAcc', 'HighAcc')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.IdleMode:options('Normal', 'DT')

    -- Additional local binds

    send_command('lua l gearinfo')

    send_command('bind ^- gs c cycleback mainstep')
    send_command('bind ^= gs c cycle mainstep')
    send_command('bind !- gs c cycleback altstep')
    send_command('bind != gs c cycle altstep')
    send_command('bind ^] gs c toggle usealtstep')
    send_command('bind ![ input /ja "Contradance" <me>')
    send_command('bind ^` input /ja "Saber Dance" <me>')
    send_command('bind !` input /ja "Chocobo Jig II" <me>')
    send_command('bind @f gs c toggle ClosedPosition')
    send_command('bind ^numlock input /ja "Reverse Flourish" <me>')

    send_command('bind @c gs c toggle CP')

    if player.sub_job == 'WAR' then
        send_command('bind ^numpad/ input /ja "Berserk" <me>')
        send_command('bind ^numpad* input /ja "Warcry" <me>')
        send_command('bind ^numpad- input /ja "Aggressor" <me>')
    elseif player.sub_job == 'SAM' then
        send_command('bind ^numpad/ input /ja "Meditate" <me>')
        send_command('bind ^numpad* input /ja "Sekkanoki" <me>')
        send_command('bind ^numpad- input /ja "Third Eye" <me>') 

    elseif player.sub_job == 'THF' then
        send_command('bind ^numpad0 input /ja "Sneak Attack" <me>') 
        send_command('bind ^numpad. input /ja "Trick Attack" <me>')
    end

    send_command('bind ^numpad+ input /ja "Climactic Flourish" <me>')
    send_command('bind ^numpadenter input /ja "Building Flourish" <me>')

    send_command('bind ^numpad7 input /ws "Exenterator" <t>')
    send_command('bind ^numpad4 input /ws "Evisceration" <t>')
    send_command('bind ^numpad5 input /ws "Rudra\'s Storm" <t>')
    send_command('bind ^numpad6 input /ws "Pyrrhic Kleos" <t>')
    send_command('bind ^numpad1 input /ws "Aeolian Edge" <t>')
	send_command('bind numpad9 gs c cycle treasuremode')

    send_command('bind numpad0 gs c step t')

    select_default_macro_book()
    set_lockstyle()
	get_gear()

    Haste = 0
    DW_needed = 0
    DW = false
    moving = false
    update_combat_form()
    determine_haste_group()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^-')
    send_command('unbind ^=')
    send_command('unbind !-')
    send_command('unbind !=')
    send_command('unbind ^]')
    send_command('unbind ^[')
    send_command('unbind ^]')
    send_command('unbind ![')
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^,')
    send_command('unbind @f')
    send_command('unbind @c')
    send_command('unbind ^numlock')
    send_command('unbind ^numpad/')
    send_command('unbind ^numpad*')
    send_command('unbind ^numpad-')
    send_command('unbind ^numpad+')
    send_command('unbind ^numpadenter')
    send_command('unbind ^numpad7')
    send_command('unbind ^numpad4')
    send_command('unbind ^numpad5')
    send_command('unbind ^numpad6')
    send_command('unbind ^numpad1')
    send_command('unbind numpad0')
    send_command('unbind ^numpad0')
    send_command('unbind ^numpad.')
	send_command('unbind ^numpad9')
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

end


-- Define sets and vars used by this job file.
function init_gear_sets()

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Precast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------
	sets.TreasureHunter = {
		hands={ name="Plun. Armlets +1", augments={'Enhances "Perfect Dodge" effect',}},	--+3
		feet="Skulk. Poulaines +1",															--+3
	}
	
    -- Enmity set
    sets.Enmity = {
		ammo="Sapience Orb",			--+2	
		head="Halitus Helm",			--+8
		body="Emet Harness +1",			--+9
		hands="Kurys Gloves",			--+9
		legs="Zoar Subligar +1",		--+5	
		feet="Ahosi leggings",			--+7	
		neck="Unmoving Collar +1",			--+8
		waist="Carrier's Sash",			--+0
		left_ear="Friomisi Earring",	--+2
		right_ear="Cryptic Earring",	--+4
		left_ring="Supershear Ring",		--+5
		right_ring="Eihwaz Ring",	--+5
		back="Reiki Cloak",				--+6
    }
    sets.precast.Waltz 	= {
		ammo="Yamarang",
		head="Mummu Bonnet +2",
		body="Passion Jacket",
		hands="Malignance Gloves",
		legs="Dashing Subligar",
		feet="Malignance Boots",
		neck="Unmoving Collar +1",
		waist="Carrier's Sash",
		left_ear="Roundel Earring",
		right_ear="Handler's Earring +1",
		left_ring="Regal Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",	
	} -- Waltz Potency/CHR
	
    sets.precast.JA['Provoke'] 						= sets.Enmity
    sets.precast.WaltzSelf 							= set_combine(sets.precast.Waltz, {head="Mummu Bonnet +2", ring1="Asklepian Ring", ear1="Roundel Earring",})
    sets.precast.Waltz['Healing Waltz'] 			= {}
    sets.precast.Samba 								= {}
    sets.precast.Jig 								= {}
    sets.precast.Step 								= {
		ammo="Yamarang",
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		neck="Sanctity Necklace",
		waist="Reiki Yotai",
		left_ear="Mache Earring +1",
		right_ear="Mache Earring +1",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Sacro Mantle",
	}
    sets.precast.Step['Stutter Step'] 				= set_combine(sets.precast.Step,sets.TreasureHunter ,{head = "Wh. Rarab Cap +1", waist="Chaac Belt"})
    sets.precast.Flourish1						 	= {}
    sets.precast.Flourish1['Animated Flourish']		= sets.Enmity
    sets.precast.Flourish1['Violent Flourish'] 		= set_combine(sets.precast.Step,{}) -- Magic Accuracy
    sets.precast.Flourish1['Desperate Flourish'] 	= set_combine(sets.precast.Step,{}) -- Accuracy
    sets.precast.Flourish2 							= {}
    sets.precast.Flourish2['Reverse Flourish'] 		= {}

    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Mag. Acc.+11','"Fast Cast"+5','MND+8','"Mag.Atk.Bns."+14',}},
		body={ name="Taeon Tabard", augments={'Accuracy+5','"Fast Cast"+3','Phalanx +3',}},
		hands={ name="Leyline Gloves", augments={'Accuracy+14','Mag. Acc.+13','"Mag.Atk.Bns."+13','"Fast Cast"+2',}},
		legs={ name="Herculean Trousers", augments={'"Fast Cast"+5','INT+1','"Mag.Atk.Bns."+8',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sanctity Necklace",
		waist="Carrier's Sash",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Rahab Ring",
		right_ring="Weather. Ring",
		back="Moonbeam Cape",
        }
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		neck="Magoraga Beads",
        body="Passion Jacket",
        })
    ------------------------------------------------------------------------------------------------
    ------------------------------------- Weapon Skill Sets ----------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.precast.WS = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},
	} -- default set
	
    sets.precast.WS['Mandalic Stab'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},
	}
    sets.precast.WS['Shark Bite'] = {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},	
	}
    sets.precast.WS['Rudra\'s Storm'] = set_combine(sets.precast.WS, {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Rep. Plat. Medal",
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back="Sacro Mantle",
	})
	
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
		ammo="C. Palug Stone",
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Meg. Gloves +2",
		legs="Meg. Chausses +2",
		feet={ name="Lustra. Leggings +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back={ name="Toutatis's Cape", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},
	})

    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {
		ammo="C. Palug Stone",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Ilabrat Ring",
		right_ring="Mujin Band",
		back="Sacro Mantle",
	})

    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
		ammo="Yetshila +1",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Gleti's Cuirass",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs="Gleti's Breeches",
		feet="Mummu Gamash. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Mache Earring +1",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Dingir Ring",
		right_ring="Epaminondas's Ring",
		back="Sacro Mantle",
	})

    sets.precast.WS['Aeolian Edge'] =  set_combine(sets.precast.WS, {
		ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Sibyl Scarf",
		waist="Orpheus's Sash",
		left_ear="Hermetic Earring",
		right_ear="Friomisi Earring",
		left_ring="Dingir Ring",
		right_ring="Epaminondas's Ring",
		back="Sacro Mantle",
	})
		
    sets.precast.WS['Rudra\'s Storm'].Acc = set_combine(sets.precast.WS['Rudra\'s Storm'],{})
	sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS['Rudra\'s Storm'],{})
	sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS['Aeolian Edge'],{})
	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {})
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {})
    sets.precast.WS.Critical = {body="Meg. Cuirie +2"}
    
	sets.precast.Skillchain = {}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Midcast Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.midcast.FastRecast = sets.precast.FC

    sets.midcast.SpellInterrupt = {}

    sets.midcast.Utsusemi = sets.midcast.SpellInterrupt


    ------------------------------------------------------------------------------------------------
    ----------------------------------------- Idle Sets --------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.resting = {
		ammo="Staunch Tathlum +1",
		head="Meghanada Visor +2",
		body="Meg. Cuirie +2",
		hands="Meg. Gloves +2",
		legs="Meg. Chausses +2",
		feet="Meg. Jam. +2",
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Etiolation Earring",
		left_ring	= {name="Chirich Ring +1", bag="wardrobe2"},
		right_ring	= {name="Chirich Ring +1", bag="wardrobe7"},
		back="Moonbeam Cape",
	}

    sets.idle = {
		ammo="Staunch Tathlum +1",
		head="Gleti's Mask",
		body="Gleti's Cuirass",
		hands="Gleti's Gauntlets",
		legs="Gleti's Breeches",
		feet="Gleti's Boots",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Etiolation Earring",
		left_ring="Moonlight Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
    }

    sets.idle.DT = {
		ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Moonbeam Cape",
	}
	
    sets.idle.Town = set_combine(sets.idle, {
		ammo="Staunch Tathlum +1",
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonlight Ring",
		right_ring="Moonlight Ring",
		back="Moonbeam Cape",
	})
    sets.idle.Weak = sets.idle.DT

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Defense Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {feet="Jute Boots +1"}


    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Engaged Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion

    sets.engaged = {
		ammo="Coiste Bodhar",
		head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
		body="Malignance Tabard",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'Accuracy+14','"Triple Atk."+4','Attack+15',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		left_ear="Sherida Earring",
		right_ear="Telos Earring",
		left_ring="Gere Ring",
		right_ring="Epona's Ring",
		back={ name="Toutatis's Cape", augments={'HP+60','Accuracy+20 Attack+20','HP+20','"Store TP"+10','Phys. dmg. taken-10%',}},
	}

    sets.engaged.LowAcc = set_combine(sets.engaged, 
		{ammo="Yamarang",})
    sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, 
		{ammo="Yamarang", waist="Sailfi Belt +1", left_ear="Mache Earring +1", back="Sacro Mantle",})
    sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc,
		{ammo="Yamarang", neck="Sanctity Necklace",waist="Sailfi Belt +1", left_ear="Mache Earring +1", left_ring="Chirich Ring +1", right_ring="Chirich Ring +1", back="Sacro Mantle",})
    sets.engaged.STP = set_combine(sets.engaged,{})
		
	--SET YOUR DW VALUES TO MATCH THIS TABLE. ALSO ADJUST DW SETTINGS IN determine_haste_group SUB
	---------------------------------------------------------------------------------------------------------------------------------
	---------[MAGIC HASTE RECIEVED]-------------|---------------------[HASTE TIER BY JOB]-------------------|-----[INFORMATION]-----|
	--DW Tier|  0%  |  10% |  15% |  30% |  Cap	|      NIN  |   DNC  |	THF	  |	  BLU   | BLU(J1) | BLU(JM) |-----------------------|
	---------|------|------|------|------|------| ----------|--------|--------|---------|---------|---------| [(SJ)=Support job]	|
	--T1(10) |  64  |  60  |  57  |  46  |  26	| -- 		|		 |		  | BLU(8)	|		  |			| [(J1) = 100  JP Gift] |
	--T2(15) |  59  |  55  |  52  |  41  |  21	| -- 		| DNC(SJ)| 		  | BLU(16)	| BLU(8)  |			| [(J2) = 550  JP Gift] |	
	--T3(25) |  49  |  45  |  42  |  31  |  11	| -- NIN(SJ)| 		 | THF	  | BLU(24)	| BLU(16) | BLU(8)	| [(JM) = 1200 JP Gift] |
	--T4(30) |  44  |  40  |  37  |  26  |  6	| --		| DNC	 | THF(JM)| BLU(32)	| BLU(24) | BLU(16)	| [BLU  = 8 pts per DW] |
	--T5(35) |  39  |  35  |  32  |  21  |  1	| -- NIN 	| DNC(JM)| 		  |			| BLU(32) | BLU(24)	|						|
	--T6(37) |  37  |  33  |  30  |  19  |  0	| -- 	 	|		 |	      | 		|		  | BLU(32)	|						|	
	---------------------------------------------------------------------------------------------------------------------------------
	
    -- No Magic Haste 
    sets.engaged.DW = set_combine(sets.engaged,  {
		body="Malignance Tabard", 							--+6
		feet={ name="Taeon Boots", augments={'Accuracy+17 Attack+17','"Dual Wield"+5','Crit. hit damage +3%',}},--+9
		waist="Reiki Yotai",																					--+7
		left_ear="Eabani Earring",																				--+4
		right_ear="Suppanomimi",																				--+5
    })

    sets.engaged.DW.LowAcc = set_combine(sets.engaged.DW, 
		{ammo="Yamarang",})
    sets.engaged.DW.MidAcc = set_combine(sets.engaged.DW.LowAcc, 
		{ammo="Yamarang", waist="Sailfi Belt +1", left_ear="Mache Earring +1", back="Sacro Mantle",})
    sets.engaged.DW.HighAcc = set_combine(sets.engaged.DW.MidAcc, 
		{ammo="Yamarang", neck="Sanctity Necklace",waist="Sailfi Belt +1", left_ear="Mache Earring +1", left_ring="Chirich Ring +1", right_ring="Chirich Ring +1", back="Sacro Mantle",})
	sets.engaged.DW.STP = set_combine(sets.engaged.DW, {})

    -- 15% Magic Haste 
    sets.engaged.DW.LowHaste = set_combine(sets.engaged, {
		body="Malignance Tabard", 							--+6
		feet={ name="Taeon Boots", augments={'Accuracy+17 Attack+17','"Dual Wield"+5','Crit. hit damage +3%',}},--+9
		waist="Reiki Yotai",																					--+7
		left_ear="Eabani Earring",																				--+4
		right_ear="Suppanomimi",																				--+5
    })

    sets.engaged.DW.LowAcc.LowHaste = set_combine(sets.engaged.DW.LowHaste, 
		{ammo="Yamarang"})
	sets.engaged.DW.MidAcc.LowHaste = set_combine(sets.engaged.DW.LowAcc.LowHaste, 
		{ammo="Yamarang", waist="Sailfi Belt +1", left_ear="Mache Earring +1",  back="Sacro Mantle",})
	sets.engaged.DW.HighAcc.LowHaste = set_combine(sets.engaged.DW.MidAcc.LowHaste, 
		{ammo="Yamarang", neck="Sanctity Necklace",waist="Sailfi Belt +1", left_ear="Mache Earring +1", left_ring="Chirich Ring +1", right_ring="Chirich Ring +1", back="Sacro Mantle",})
	sets.engaged.DW.STP.LowHaste = set_combine(sets.engaged.DW.LowHaste, {})

    -- 30% Magic Haste
    sets.engaged.DW.MidHaste = set_combine(sets.engaged, {
		body="Malignance Tabard", 							--+6
		feet={ name="Taeon Boots", augments={'Accuracy+17 Attack+17','"Dual Wield"+5','Crit. hit damage +3%',}},--+9
		waist="Reiki Yotai",																					--+7
		left_ear="Eabani Earring",																				--+4
		right_ear="Suppanomimi",																				--+5
    })

    sets.engaged.DW.LowAcc.MidHaste = set_combine(sets.engaged.DW.MidHaste, 
		{ammo="Yamarang"})
	sets.engaged.DW.MidAcc.MidHaste = set_combine(sets.engaged.DW.LowAcc.MidHaste, 
		{ammo="Yamarang", waist="Sailfi Belt +1", left_ear="Mache Earring +1",  back="Sacro Mantle",})
	sets.engaged.DW.HighAcc.MidHaste = set_combine(sets.engaged.DW.MidAcc.MidHaste, 
		{ammo="Yamarang", neck="Sanctity Necklace",waist="Sailfi Belt +1", left_ear="Mache Earring +1", left_ring="Chirich Ring +1", right_ring="Chirich Ring +1", back="Sacro Mantle",})
	sets.engaged.DW.STP.MidHaste = set_combine(sets.engaged.DW.MidHaste, {})

    -- 35% Magic Haste
    sets.engaged.DW.HighHaste = set_combine(sets.engaged, {
		body="Malignance Tabard", 							--+6
		waist="Reiki Yotai",																					--+7
		right_ear="Suppanomimi",																				--+5
	})

    sets.engaged.DW.LowAcc.HighHaste = set_combine(sets.engaged.DW.HighHaste, 
		{ammo="Yamarang"})
	sets.engaged.DW.MidAcc.HighHaste = set_combine(sets.engaged.DW.LowAcc.HighHaste, 
		{ammo="Yamarang", waist="Sailfi Belt +1", left_ear="Mache Earring +1",  back="Sacro Mantle",})
	sets.engaged.DW.HighAcc.HighHaste = set_combine(sets.engaged.DW.MidAcc.HighHaste, 
		{ammo="Yamarang", neck="Sanctity Necklace",waist="Sailfi Belt +1", left_ear="Mache Earring +1", left_ring="Chirich Ring +1", right_ring="Chirich Ring +1", back="Sacro Mantle",})
	sets.engaged.DW.STP.HighHaste = set_combine(sets.engaged.DW.HighHaste, {})

    -- 45% Magic Haste
    sets.engaged.DW.MaxHaste = set_combine(sets.engaged, {
		body="Malignance Tabard", 							--+6
		waist="Reiki Yotai",																					--+7
	})

    sets.engaged.DW.LowAcc.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, 
		{ammo="Yamarang"})
	sets.engaged.DW.MidAcc.MaxHaste = set_combine(sets.engaged.DW.LowAcc.MaxHaste, 
		{ammo="Yamarang", waist="Sailfi Belt +1", left_ear="Mache Earring +1",  back="Sacro Mantle",})
	sets.engaged.DW.HighAcc.MaxHaste = set_combine(sets.engaged.DW.MidAcc.MaxHaste, 
		{ammo="Yamarang", neck="Sanctity Necklace",waist="Sailfi Belt +1", left_ear="Mache Earring +1", left_ring="Chirich Ring +1", right_ring="Chirich Ring +1", back="Sacro Mantle",})
	sets.engaged.DW.STP.MaxHaste = set_combine(sets.engaged.DW.MaxHaste, {})

    sets.engaged.DW.Aftermath = {

	} -- 0%

    sets.engaged.DW.LowAcc.Aftermath = set_combine(sets.engaged.DW.Aftermath, 
		{ammo="Yamarang"})
    sets.engaged.DW.MidAcc.Aftermath = set_combine(sets.engaged.DW.LowAcc.Aftermath, 
		{ammo="Yamarang", waist="Sailfi Belt +1", left_ear="Mache Earring +1",  back="Sacro Mantle",})
    sets.engaged.DW.HighAcc.Aftermath = set_combine(sets.engaged.DW.MidAcc.Aftermath, 
		{ammo="Yamarang", neck="Sanctity Necklace",waist="Sailfi Belt +1", left_ear="Mache Earring +1", left_ring="Chirich Ring +1", right_ring="Chirich Ring +1", back="Sacro Mantle",})
    sets.engaged.DW.STP.Aftermath = set_combine(sets.engaged.DW.Aftermath, {})

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Hybrid Sets -------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.engaged.Hybrid = {
		head="Malignance Chapeau",
		body="Malignance Tabard",
		hands="Malignance Gloves",
		legs="Malignance Tights",
		feet="Malignance Boots",
		left_ring={name="Moonlight Ring", bag="wardrobe2"},
		right_ring={name="Moonlight Ring", bag="wardrobe7"},
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

    sets.engaged.DW.DT.Aftermath = set_combine(sets.engaged.DW.Aftermath, sets.engaged.Hybrid)
    sets.engaged.DW.LowAcc.DT.Aftermath = set_combine(sets.engaged.DW.LowAcc.Aftermath, sets.engaged.Hybrid)
    sets.engaged.DW.MidAcc.DT.Aftermath = set_combine(sets.engaged.DW.MidAcc.Aftermath, sets.engaged.Hybrid)
    sets.engaged.DW.HighAcc.DT.Aftermath = set_combine(sets.engaged.DW.HighAcc.Aftermath, sets.engaged.Hybrid)
    sets.engaged.DW.STP.DT.Aftermath = set_combine(sets.engaged.DW.STP.Aftermath, sets.engaged.Hybrid)

    ------------------------------------------------------------------------------------------------
    ---------------------------------------- Special Sets ------------------------------------------
    ------------------------------------------------------------------------------------------------

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1="Purity Ring",	--7
        ring2="Blenmot's Ring +1", --10
        waist="Gishdubar Sash", --10
        }

    sets.CP = {back="Mecisto. Mantle"}
	sets.Reive = {}

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    --auto_presto(spell)
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

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end	
	elseif spell.type == "WeaponSkill" then
        if state.Buff['Sneak Attack'] == true or state.Buff['Trick Attack'] == true then
            equip(sets.precast.WS.Critical)
        end
    end
    if spell.type=='Waltz' and spell.english:startswith('Curing') and spell.target.type == 'SELF' then
        equip(sets.precast.WaltzSelf)
    end
end

 
-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
        equip(sets.TreasureHunter)
    end
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end
 
-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
    -- If Feint is active, put that gear set on on top of regular gear.
    -- This includes overlaying SATA gear.
    check_buff('Feint', eventArgs)
end
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
    if buff == 'Saber Dance' or buff == 'Climactic Flourish' or buff == 'Fan Dance' then
        handle_equipping_gear(player.status)
    end

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
            send_command('@input /p Doomed.')
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
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
    check_buff('Feint', eventArgs)
end

function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
end

function job_update(cmdParams, eventArgs)
    handle_equipping_gear(player.status)
end

function update_combat_form()
    if DW == true then
        state.CombatForm:set('DW')
    elseif DW == false then
        state.CombatForm:reset()
    end
	if state.Buff['Aftermath: Lv.3'] == true then
		classes.CustomMeleeGroups:append('Aftermath')
	end
end

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end

    return wsmode
end

function customize_idle_set(idleSet)
    if state.CP.current == 'on' then
        equip(sets.CP)
        disable('back')
    else
        enable('back')
    end
    if moving then
		idleSet=set_combine(idleSet, sets.Kiting)
	end
    return idleSet
end

function customize_melee_set(meleeSet)
    if state.Buff['Climactic Flourish'] then
        meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
    end
	if state.Buff['Aftermath: Lv.3'] then
		 meleeSet = set_combine(meleeSet, sets.buff['Aftermath: Lv.3'])
	end
    if state.ClosedPosition.value == true then
        meleeSet = set_combine(meleeSet, sets.buff['Closed Position'])
    end

    return meleeSet
end

-- Handle auto-targetting based on local setup.
function job_auto_change_target(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
        if state.IgnoreTargetting.value == true then
            state.IgnoreTargetting:reset()
            eventArgs.handled = true
        end

        eventArgs.SelectNPCTargets = state.SelectStepTarget.value
    end
end


-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
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

    local s_msg = state.MainStep.current
    if state.UseAltStep.value == true then
        s_msg = s_msg .. '/'..state.AltStep.current
    end

    local d_msg = 'None'
    if state.DefenseMode.value ~= 'None' then
        d_msg = state.DefenseMode.value .. state[state.DefenseMode.value .. 'DefenseMode'].value
    end

    local i_msg = state.IdleMode.value

    local msg = ''
    if state.Kiting.value then
        msg = msg .. ' Kiting: On |'
    end

    add_to_chat(002, '| ' ..string.char(31,210).. 'Melee' ..cf_msg.. ': ' ..string.char(31,001)..m_msg.. string.char(31,002)..  ' |'
        ..string.char(31,207).. ' WS: ' ..string.char(31,001)..ws_msg.. string.char(31,002)..  ' |'
        ..string.char(31,060).. ' Step: '  ..string.char(31,001)..s_msg.. string.char(31,002)..  ' |'
        ..string.char(31,004).. ' Defense: ' ..string.char(31,001)..d_msg.. string.char(31,002)..  ' |'
        ..string.char(31,008).. ' Idle: ' ..string.char(31,001)..i_msg.. string.char(31,002)..  ' |'
        ..string.char(31,002)..msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------------------------------------
	---------[MAGIC HASTE RECIEVED]-------------|---------------------[HASTE TIER BY JOB]-------------------|-----[INFORMATION]-----|
	--DW Tier|  0%  |  10% |  15% |  30% |  Cap	|      NIN  |   DNC  |	THF	  |	  BLU   | BLU(J1) | BLU(JM) |-----------------------|
	---------|------|------|------|------|------| ----------|--------|--------|---------|---------|---------| [(SJ)=Support job]	|
	--T1(10) |  64  |  60  |  57  |  46  |  26	| -- 		|		 |		  | BLU(8)	|		  |			| [(J1) = 100  JP Gift] |
	--T2(15) |  59  |  55  |  52  |  41  |  21	| -- 		| DNC(SJ)| 		  | BLU(16)	| BLU(8)  |			| [(J2) = 550  JP Gift] |	
	--T3(25) |  49  |  45  |  42  |  31  |  11	| -- NIN(SJ)| 		 | THF	  | BLU(24)	| BLU(16) | BLU(8)	| [(JM) = 1200 JP Gift] |
	--T4(30) |  44  |  40  |  37  |  26  |  6	| --		| DNC	 | THF(JM)| BLU(32)	| BLU(24) | BLU(16)	| [BLU  = 8 pts per DW] |
	--T5(35) |  39  |  35  |  32  |  21  |  1	| -- NIN 	| DNC(JM)| 		  |			| BLU(32) | BLU(24)	|						|
	--T6(37) |  37  |  33  |  30  |  19  |  0	| -- 	 	|		 |	      | 		|		  | BLU(32)	|						|	
	---------------------------------------------------------------------------------------------------------------------------------
	
function determine_haste_group()
    classes.CustomMeleeGroups:clear()
    if DW == true then
		if state.Buff['Aftermath: Lv.3'] == true then
			classes.CustomMeleeGroups:append('Aftermath')
        elseif DW_needed <= 11 then
            classes.CustomMeleeGroups:append('MaxHaste')
        elseif DW_needed > 11 and DW_needed <= 20 then
            classes.CustomMeleeGroups:append('HighHaste')
        elseif DW_needed > 20 and DW_needed <= 31 then
            classes.CustomMeleeGroups:append('MidHaste')
        elseif DW_needed > 31 and DW_needed <= 42 then
            classes.CustomMeleeGroups:append('LowHaste')
        elseif DW_needed > 42 then
            classes.CustomMeleeGroups:append('')
        end
    end
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'step' then
        if cmdParams[2] == 't' then
            state.IgnoreTargetting:set()
        end

        local doStep = ''
        if state.UseAltStep.value == true then
            doStep = state[state.CurrentStep.current..'Step'].current
            state.CurrentStep:cycle()
        else
            doStep = state.MainStep.current
        end

        send_command('@input /ja "'..doStep..'" <t>')
    end
	if cmdParams[1] == 'runspeed' then
		runspeed:toggle()
		updateRunspeedGear(runspeed.value) 
	end
    gearinfo(cmdParams, eventArgs)
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


-- Automatically use Presto for steps when it's available and we have less than 3 finishing moves
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'Step' then
		equip(sets.TreasureHunter)		
    end
end

windower.register_event('zone change', 
    function()
        send_command('gi ugs true')
    end
)

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book: (set, book)
    if player.sub_job == 'WAR' then
        set_macro_page(1, 2)
    elseif player.sub_job == 'THF' then
        set_macro_page(1, 2)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 2)
    elseif player.sub_job == 'RUN' then
        set_macro_page(1, 2)
    elseif player.sub_job == 'SAM' then
        set_macro_page(1, 2)
    else
        set_macro_page(1, 2)
    end
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