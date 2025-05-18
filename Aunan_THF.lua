-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('organizer-lib')
	send_command('wait 2;input /lockstyleset 19')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    
    include('Mote-TreasureHunter')

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}
	state.Moving = M(false, "moving")
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Mod')
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
    state.PhysicalDefenseMode:options('Evasion', 'PDT')


    gear.default.weaponskill_neck = "Asperity Necklace"
    gear.default.weaponskill_waist = "Caudata Belt"
    gear.AugQuiahuiz = {name="Quiahuiz Trousers", augments={'Haste+2','"Snapshot"+2','STR+8'}}

    -- Additional local binds
    send_command('bind ^` input /ja "Flee" <me>')
    send_command('bind ^= gs c cycle treasuremode')
    send_command('bind !- gs c cycle targetmode')

    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !-')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = {
	hands="Plunderer's Armlets +1" ,
	feet="Skulker's Poulaines +1"
	}
	
    sets.ExtraRegen = {
	}
	
    sets.Kiting = {
	feet="Pillager's Poulaines +1"
	}

    sets.buff['Sneak Attack'] = {
    ammo="Yetshila +1",
    head="Skulker's Bonnet +1",
    body="Meg. Cuirie +2",
    hands="Meg. Gloves +2",
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet="Mummu Gamash. +2",
    neck="Caro Necklace",
    waist="Kentarch Belt +1",
    left_ear="Mache Earring",
    right_ear="Mache Earring",
    left_ring="Ramuh Ring +1",
    right_ring="Ramuh Ring +1",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}
		}

    sets.buff['Trick Attack'] = {
    ammo="Yetshila +1",
    head="Turms Cap",
    body="Meg. Cuirie +2",
    hands="Meg. Gloves +2",
    legs="Meg. Chausses +2",
    feet="Mummu Gamash. +2",
    neck="Caro Necklace",
    waist="Kentarch Belt +1",
    left_ear="Mache Earring",
    right_ear="Mache Earring",
    left_ring="Ramuh Ring +1",
    right_ring="Ramuh Ring +1",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}	
	}

    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter


    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Collaborator'] = {head="Raider's Bonnet +2"}
	
    sets.precast.JA['Accomplice'] = {head="Raider's Bonnet +2"}
	
    sets.precast.JA['Flee'] = {feet="Pillager's Poulaines +1"}
	
    sets.precast.JA['Hide'] = {body="Pillager's Vest +2"}
	
    sets.precast.JA['Conspirator'] = {} -- {body="Raider's Vest +2"}
	
    sets.precast.JA['Steal'] = {
	ammo="Barathrum",
	head="Plunderer's Bonnet",
	hands="Pillager's Armlets +1",
	legs="Pillager's Culottes +1",
	feet="Pillager's Poulaines +1"
	}
	
    sets.precast.JA['Despoil'] = {
	ammo="Barathrum",
	legs="Raider's Culottes +2",
	feet="Raider's Poulaines +2"}
	
    sets.precast.JA['Perfect Dodge'] = {hands="Plunderer's Armlets +1"}
	
    sets.precast.JA['Feint'] = {} -- {legs="Assassin's Culottes +2"}

    sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
	
    sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']


    -- Waltz set (chr and vit)
    sets.precast.Waltz = {ammo="Sonia's Plectrum",
        head="Whirlpool Mask",
        body="Pillager's Vest +2",hands="Pillager's Armlets +1",ring1="Asklepian Ring",
        back="Iximulew Cape",waist="Caudata Belt",legs="Pillager's Culottes +1",feet="Plunderer's Poulaines +1"}

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}


    -- Fast cast sets for spells
    sets.precast.FC = {
    ammo="Sapience Orb",
    head={ name="Herculean Helm", augments={'Accuracy+29','"Triple Atk."+4','STR+6',}},
    body={ name="Taeon Tabard", augments={'"Fast Cast"+5','Phalanx +3',}},
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Taeon Boots", augments={'"Fast Cast"+1','Phalanx +3',}},
    neck="Orunmila's Torque",
    waist="Kasiri Belt",
    left_ear="Etiolation earring",
    right_ear="Loquac. Earring",
    left_ring="Prolix Ring",
    right_ring="Weather. Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}	
	}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})


    -- Ranged snapshot gear
    sets.precast.RA = {}


    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
    ammo="Seething bomblet +1",
    head="Plunderer's Bonnet +3",
    body="Plunderer's vest +3",
    hands="Meg. Gloves +2",
    legs="Lustratio Subligar +1",
    feet="Lustratio Leggings +1",
    neck="Combatant's Torque",
    waist="Kentarch Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Ramuh Ring +1",
    right_ring="Karieyh Ring +1",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}
	}
	
    sets.precast.WS.Acc = set_combine(sets.precast.WS, {
    ammo="Seeth. Bomblet +1",
    head={ name="Adhemar Bonnet", augments={'DEX+10','AGI+10','Accuracy+15',}},
    body="Plunderer's vest +3",
    hands="Meg. Gloves +2",
    legs="Meg. Chausses +2",
    feet="Mummu Gamash. +2",
    neck="Caro Necklace",
    waist="Kentarch Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Ramuh Ring +1",
    right_ring="Karieyh Ring +1",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}	
	})

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
    ammo="Seeth. Bomblet +1",
    head={ name="Plun. Bonnet +3", augments={'Enhances "Aura Steal" effect',}},
    body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
    hands="Mummu Wrists +2",
    legs="Meg. Chausses +2",
    feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear="Brutal Earring",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}	
	})
	
    sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].Mod = set_combine(sets.precast.WS['Exenterator'], {})
    sets.precast.WS['Exenterator'].SA = set_combine(sets.precast.WS['Exenterator'].Mod, {})
    sets.precast.WS['Exenterator'].TA = set_combine(sets.precast.WS['Exenterator'].Mod, {})
    sets.precast.WS['Exenterator'].SATA = set_combine(sets.precast.WS['Exenterator'].Mod, {})

    sets.precast.WS['Dancing Edge'] = set_combine(sets.precast.WS, {})
    sets.precast.WS['Dancing Edge'].Acc = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].Mod = set_combine(sets.precast.WS['Dancing Edge'], {})
    sets.precast.WS['Dancing Edge'].SA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {})
    sets.precast.WS['Dancing Edge'].TA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {})
    sets.precast.WS['Dancing Edge'].SATA = set_combine(sets.precast.WS['Dancing Edge'].Mod, {})
	
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {    
    ammo="Yetshila +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
    hands="Mummu Wrists +2",
    legs="Pill. Culottes +3",
    feet="Mummu Gamash. +2",
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Begrudging Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}}
	})
	
    sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {})
	
    sets.precast.WS['Evisceration'].Mod = set_combine(sets.precast.WS['Evisceration'], {})
	
    sets.precast.WS['Evisceration'].SA = set_combine(sets.precast.WS['Evisceration'].Mod, {})
	
    sets.precast.WS['Evisceration'].TA = set_combine(sets.precast.WS['Evisceration'].Mod, {})
	
    sets.precast.WS['Evisceration'].SATA = set_combine(sets.precast.WS['Evisceration'].Mod, {})

    sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {})
	
    sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {})
	
    sets.precast.WS["Rudra's Storm"].Mod = set_combine(sets.precast.WS["Rudra's Storm"], {})
	
    sets.precast.WS["Rudra's Storm"].SA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {
	head="Pill. Bonnet +3",	
	ammo="Yetshila +1",
	nack="Caro Necklace"
	})
	
    sets.precast.WS["Rudra's Storm"].TA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {})
	
    sets.precast.WS["Rudra's Storm"].SATA = set_combine(sets.precast.WS["Rudra's Storm"].Mod, {})

    sets.precast.WS["Shark Bite"] = set_combine(sets.precast.WS, {})
	
    sets.precast.WS['Shark Bite'].Acc = set_combine(sets.precast.WS['Shark Bite'], {})
	
    sets.precast.WS['Shark Bite'].Mod = set_combine(sets.precast.WS['Shark Bite'], {})
	
    sets.precast.WS['Shark Bite'].SA = set_combine(sets.precast.WS['Shark Bite'].Mod, {})
	
    sets.precast.WS['Shark Bite'].TA = set_combine(sets.precast.WS['Shark Bite'].Mod, {})
	
    sets.precast.WS['Shark Bite'].SATA = set_combine(sets.precast.WS['Shark Bite'].Mod, {})

    sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS, {})
	
    sets.precast.WS['Mandalic Stab'].Acc = set_combine(sets.precast.WS['Mandalic Stab'], {})
	
    sets.precast.WS['Mandalic Stab'].Mod = set_combine(sets.precast.WS['Mandalic Stab'], {})
	
    sets.precast.WS['Mandalic Stab'].SA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {
	ammo="Yetshila +1",
	nack="Caro Necklace"	
	})
	
    sets.precast.WS['Mandalic Stab'].TA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {})
	
    sets.precast.WS['Mandalic Stab'].SATA = set_combine(sets.precast.WS['Mandalic Stab'].Mod, {})

    sets.precast.WS['Aeolian Edge'] = {
    ammo="Seeth. Bomblet +1",
    head={ name="Herculean Helm", augments={'DEX+5','"Mag.Atk.Bns."+29','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
    body="Samnuha Coat",
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs="Shned. Tights +1",
    feet={ name="Adhemar Gamashes", augments={'STR+10','DEX+10','Attack+15',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Friomisi Earring",
    left_ring="Shiva Ring +1",
    right_ring="Karieyh Ring +1",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}	
	}

    sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)

	sets.precast.WS['Tachi: Koki'] = set_combine(sets.precast.WS, {
	head="Kengo hachimaki",
	neck="Combatant's Torque"
	
	
	})
	
	sets.precast.WS['Blade: Ei'] = set_combine(sets.precast.WS, {
	head="Kengo hachimaki",
	neck="Combatant's Torque"
	
	
	})	
    
	sets.precast.WS["Shadowstitch"] = set_combine(sets.precast.WS, {

	})
    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {
	}

    -- Specific spells
    sets.midcast.Utsusemi = {
	}

    -- Ranged gear
    sets.midcast.RA = {
	}

    sets.midcast.RA.Acc = {
	}


    --------------------------------------
    -- Idle/resting/defense sets
    --------------------------------------

    -- Resting sets
    sets.resting = {
    ring1="Sheltered Ring",
	ring2="Karieyh Ring +1"}


    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

    sets.idle = {
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands={ name="Herculean Gloves", augments={'Accuracy+17 Attack+17','"Triple Atk."+4','STR+9','Accuracy+14','Attack+9',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Warder's Charm +1",
    waist="Engraved Belt",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    left_ring="Defending Ring",
    right_ring="Gelatinous Ring +1",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}

    sets.idle.Town = {
	ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
	body="Plunderer's Vest +3",
    --body={ name="Plunderer's Vest +3", augments={'Enhances "Ambush" effect',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet="Plunderer's poulaines +3",
    neck="Iskur Gorget",
    waist="Reiki yotai",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10',}}
	
	}

    sets.idle.Weak = sets.idle


    -- Defense sets

    sets.defense.Evasion = {
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands={ name="Herculean Gloves", augments={'Accuracy+17 Attack+17','"Triple Atk."+4','STR+9','Accuracy+14','Attack+9',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Warder's Charm +1",
    waist="Engraved Belt",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    left_ring="Defending Ring",
    right_ring="Gelatinous Ring +1",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}	
	}

    sets.defense.PDT = {
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands={ name="Herculean Gloves", augments={'Accuracy+17 Attack+17','"Triple Atk."+4','STR+9','Accuracy+14','Attack+9',}},
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Warder's Charm +1",
    waist="Engraved Belt",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    left_ring="Defending Ring",
    right_ring="Gelatinous Ring +1",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}

    sets.defense.MDT = {
	
	}


    --------------------------------------
    -- Melee sets
    --------------------------------------

    -- Normal melee group
    sets.engaged = {
    ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Plunderer's Vest +3",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Plun. Poulaines +3", augments={'Enhances "Assassin\'s Charge" effect',}},
    neck="Combatant's Torque",
    waist="Reiki yotai",
    left_ear="Dedition Earring",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
   
	}
	
    sets.engaged.Acc = {
    ammo="Yamarang",
    head="Mummu Bonnet +2",
    body="Mummu Jacket +2",
    hands="Mummu Wrists +2",
    legs="Mummu Kecks +2",
    feet="Mummu Gamash. +2",
    neck="Combatant's Torque",
    waist="Reiki yotai",
    left_ear="Sherida Earring",
    right_ear="Telos Earring",
    left_ring="Begrudging Ring",
    right_ring="Hetairoi Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	
	}
        

    sets.engaged.PDT = {
    ammo="Yamarang",
    head="Turms Cap",
    body="Meg. Cuirie +2",
    hands="Meg. Gloves +2",
    legs="Meg. Chausses +2",
    feet="Jute Boots +1",
    neck="Loricate Torque +1",
    waist="Flume Belt",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    left_ring="Defending Ring",
    right_ring="Moonbeam Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}	
	}
    
	sets.engaged.Acc.PDT = {
    ammo="Yamarang",
    head="Turms Cap",
    body="Meg. Cuirie +2",
    hands="Meg. Gloves +2",
    legs="Meg. Chausses +2",
    feet="Jute Boots +1",
    neck="Loricate Torque +1",
    waist="Flume Belt",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    left_ring="Defending Ring",
    right_ring="Moonbeam Ring",
    back={ name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}	
	
	}

	sets.MoveSpeed = {
	feet = "Jute boots +1"
	}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
        equip(sets.TreasureHunter)
    elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
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
function job_buff_change(buff, gain)
    if state.Buff[buff] ~= nil then
        if not midaction() then
            handle_equipping_gear(player.status)
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Sneak Attack'] then
        wsmode = 'SA'
    end
    if state.Buff['Trick Attack'] then
        wsmode = (wsmode or '') .. 'TA'
    end

    return wsmode
end


-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
    -- Check that ranged slot is locked, if necessary
    check_range_lock()

    -- Check for SATA when equipping gear.  If either is active, equip
    -- that gear specifically, and block equipping default gear.
    check_buff('Sneak Attack', eventArgs)
    check_buff('Trick Attack', eventArgs)
end


function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end


function customize_melee_set(meleeSet)
    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    th_update(cmdParams, eventArgs)
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
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
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
    if state.Buff[buff_name] then
        equip(sets.buff[buff_name] or {})
        if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
            equip(sets.TreasureHunter)
        end
        eventArgs.handled = true
    end
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


-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
    if player.equipment.range ~= 'empty' then
        disable('range', 'ammo')
    else
        enable('range', 'ammo')
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 5)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 5)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 5)
    else
        set_macro_page(1, 5)
    end
end
mov = {counter=0}
if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
mov.x = windower.ffxi.get_mob_by_index(player.index).x
mov.y = windower.ffxi.get_mob_by_index(player.index).y
mov.z = windower.ffxi.get_mob_by_index(player.index).z
end

moving = false
windower.raw_register_event('prerender',function()
mov.counter = mov.counter + 1;
if mov.counter>15 then
local pl = windower.ffxi.get_mob_by_index(player.index)
if pl and pl.x and mov.x then
dist = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 )
if dist > 1 and not moving and player.status ~= "Engaged" then
state.Moving.value = true
send_command('gs c update')
send_command('gs equip sets.MoveSpeed')
moving = true

elseif dist < 1 and moving then
state.Moving.value = false
send_command('gs c update')
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

