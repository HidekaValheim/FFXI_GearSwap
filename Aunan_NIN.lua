-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()

    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')

	include('organizer-lib')
	
	send_command('wait 2;input /lockstyleset 7')	
	
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff.Migawari = buffactive.migawari or false
    
	state.Buff.Doom = buffactive.doom or false
    
	state.Buff.Yonin = buffactive.Yonin or false
    
	state.Buff.Innin = buffactive.Innin or false
    
	state.Buff.Futae = buffactive.Futae or false
	
	state.Buff.Sange = buffactive.Sange or false

    determine_haste_group()
	
	--movespeed	
	
	state.Moving = M(false, "moving")	
	
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Hybrid', 'Acc', 'DW')
	
    state.HybridMode:options('Normal', 'Evasion', 'PDT')
	
    state.WeaponskillMode:options('Normal', 'Acc', 'Mod')
	
    state.CastingMode:options('Normal', 'MagicBurst')
	
    state.PhysicalDefenseMode:options('PDT', 'Evasion')

    gear.MovementFeet = {name="Danzo Sune-ate"}
	
    gear.DayFeet = "Danzo Sune-ate"
	
    gear.NightFeet = "Hachiya Kyahan +3"
    
    select_movement_feet()
	
    select_default_macro_book()
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
	sets.precast.Enmity = {
	
    ammo="Aqreqaq Bomblet",
    body="Emet Harness +1",
    hands="Kurys Gloves",
	legs="Zoar Subligar +1",
    feet="Ahosi leggings",
    neck="Moonbeam Necklace",
    waist="Kasiri Belt",
    left_ear="Cryptic Earring",
    right_ear="Trux Earring",
    left_ring="Eihwaz Ring",
    right_ring="Supershear Ring",
	
	}
	
	sets.precast.JA['Provoke'] = sets.precast.Enmity
	
    sets.precast.JA['Mijin Gakure'] = {
	
	legs="Mochizuki Hakama +3"
	
	}
	
    sets.precast.JA['Futae'] = {
	
	legs="Iga Tekko +2"
	
	}
	
    sets.precast.JA['Sange'] = {

	ammo= "Date Shuriken",	
	body="Mochizuki Chainmail +3"
	
	}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
	
	}
        
	sets.precast.Step = {}

    sets.precast.Flourish1 = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {

    ammo="Sapience Orb",
    head={ name="Herculean Helm", augments={'"Fast Cast"+6','"Mag.Atk.Bns."+7',}},
    body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs={ name="Herculean Trousers", augments={'"Fast Cast"+6','INT+8','Mag. Acc.+11',}},
    feet={ name="Herculean Boots", augments={'"Mag.Atk.Bns."+19','"Fast Cast"+6','Mag. Acc.+8',}},
    neck="Orunmila's Torque",
    waist="Kasiri Belt",
    left_ear="Enchntr. Earring +1",
    right_ear="Loquac. Earring",
    left_ring="Rahab Ring",
    right_ring="Kishar Ring",
    back={ name="Andartia's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}}	
	
	}
    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
	
	neck="Magoraga Beads",
	body="Mochizuki Chainmail +3"
	
	})

    -- Snapshot for ranged
	
    sets.precast.RA = {}


	organizer_items = {
	feet= "Danzo Sune-ate",
	dates="Date Sh. Pouch",
	nintoolc="Chonofuda",
	nintools="Shikanofuda",
	nintooli="Inoshishinofuda",
	nintoolu="Shihei",
	food="Sublime Sushi",
	remedy="Remedy",
	}

	
    -- Weaponskill sets

    sets.precast.WS['Blade: Ten'] =  {

    ammo={ name="Seeth. Bomblet +1", augments={'Path: A',}},
    head="Hachiya Hatsu. +3",
    body={ name="Agony Jerkin +1", augments={'Path: A',}},
    hands={ name="Mochizuki Tekko +3", augments={'Enh. "Ninja Tool Expertise" effect',}},
    legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    neck={ name="Ninja Nodowa +1", augments={'Path: A',}},
    waist="Sailfi Belt +1",
    left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Gere Ring",
    right_ring="Regal Ring",
    back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
		
	}

    sets.precast.WS['Savage Blade'] = sets.precast.WS['Blade: Ten']

    sets.precast.WS['Blade: Shun'] = {

    ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Agony Jerkin +1", augments={'Path: A',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs="Jokushu Haidate",
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Gere Ring",
    right_ring="Regal Ring",
    back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
	
	}

    sets.precast.WS['Blade: Metsu'] = {

    ammo="Aurgelmir Orb +1",
    head="Hachiya Hatsu. +3",
    body="Malignance Tabard",
    hands="Ken. Tekko +1",
    legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
    feet="Ken. Sune-Ate +1",
    neck={ name="Ninja Nodowa +1", augments={'Path: A',}},
    waist={ name="Sailfi Belt +1", augments={'Path: A',}},
    left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
    right_ear="Odr Earring",
    left_ring="Gere Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
	}

    sets.precast.Hybrid = {
	
    ammo="Seeth. Bomblet +1",
    head="Hachiya Hatsu. +3",
    body={ name="Herculean Vest", augments={'MND+10','"Cure" spellcasting time -7%','Weapon skill damage +6%','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
	hands={ name="Herculean Gloves", augments={'Attack+19','"Mag.Atk.Bns."+28','Magic Damage +9','Accuracy+17 Attack+17','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
    legs="Mochizuki hakama +3",
    feet={ name="Herculean Boots", augments={'"Mag.Atk.Bns."+22','Weapon skill damage +5%','INT+2',}},
    neck="Ninja nodowa +1",
    waist="Sailfi Belt +1",
    left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Gere Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Andartia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	
	}
	
	sets.precast.WS['Blade: Chi'] = sets.precast.Hybrid
	
	sets.precast.WS['Blade: To'] = sets.precast.Hybrid
	
	sets.precast.WS['Blade: Teki'] = sets.precast.Hybrid
	

	
	sets.precast.WS['Tachi: Jinpu'] = sets.precast.Hybrid
	
  	sets.precast.WS['Blade: Yu'] = sets.precast.Hybrid
	
    sets.precast.WS['Blade: Ku'] = {

    ammo="Seething Bomblet +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Agony Jerkin +1", augments={'Path: A',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs="Tatenashi haidate +1",
    feet={ name="Ryuo Sune-Ate +1", augments={'STR+12','Attack+25','Crit. hit rate+4%',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
    right_ear="Mache Earring +1",
    left_ring="Gere Ring",
    right_ring="Regal Ring",
    back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
	
	}  
	
    sets.precast.WS['Tachi: Ageha'] = {

    ammo="Seething Bomblet +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Agony Jerkin +1", augments={'Path: A',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs="Tatenashi haidate +1",
    feet={ name="Ryuo Sune-Ate +1", augments={'STR+12','Attack+25','Crit. hit rate+4%',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Lugra Earring +1", augments={'Path: A',}},
    right_ear="Mache Earring +1",
    left_ring="Gere Ring",
    right_ring="Regal Ring",
    back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}}	
	
	} 	
	
	
    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.FastRecast = {}
        
    sets.midcast.Utsusemi = set_combine(sets.midcast.SelfNinjutsu, {
	
    body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},
	neck="Orunmila's Torque",	
	feet="Hattori Kyahan +1"
	
	})

    sets.midcast.ElementalNinjutsu = {

    ammo="Ghastly tathlum +1",
    head={ name="Mochi. Hatsuburi +3", augments={'Enhances "Yonin" and "Innin" effect',}},
    body={ name="Rawhide Vest", augments={'DEX+10','STR+7','INT+7',}},
    hands={ name="Herculean Gloves", augments={'Attack+19','"Mag.Atk.Bns."+28','Magic Damage +9','Accuracy+17 Attack+17','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
    legs="Gyve Trousers",
    feet={ name="Mochi. Kyahan +3", augments={'Enh. Ninj. Mag. Acc/Cast Time Red.',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Friomisi Earring",
    right_ear="Hecate's Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Shiva Ring +1",	
    back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}}	
	}

    sets.midcast.ElementalNinjutsu.MagicBurst = set_combine(sets.midcast.Ninjutsu, {})

    sets.midcast.NinjutsuDebuff = {
	
    ammo="Yamarang",
    head="Hachiya Hatsu. +3",
    body="Malignance Tabard",
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
    legs="Malignance Tights",
    feet="Hachiya Kyahan +3",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Hnoss Earring",
    right_ear="Digni. Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Andartia's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}}	
	}

    sets.midcast.NinjutsuBuff = {}

    sets.midcast.RA = {}


    --------------------------------------
    -- Idle/resting/defense/etc sets
    --------------------------------------
      
    -- Idle sets
    sets.idle = {
	
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Ken. Tekko +1",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Warder's Charm +1",
    waist="Engraved Belt",
    left_ear="Genmei Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Andartia's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}}	
	
	}

    
    
    -- Defense sets
    sets.defense.Evasion = {}

    sets.defense.PDT = {    
	
	ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Ken. Tekko +1",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Warder's Charm +1",
    waist="Engraved Belt",
    left_ear="Genmei Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Andartia's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}}
	
	}

    sets.defense.MDT = sets.defense.PDT


    sets.Kiting = {feet=gear.MovementFeet}

	sets.MoveSpeed = {
	
	feet=gear.MovementFeet
	
	}
    --------------------------------------
    -- Engaged sets
    --------------------------------------

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {
	
    ammo="Seki Shuriken",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck={ name="Ninja Nodowa +1", augments={'Path: A',}},
    waist="Windbuffet Belt +1",
    left_ear="Brutal Earring",
    right_ear="Telos Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	
	}
	
    sets.engaged.Hybrid = {
	
    ammo="Seki Shuriken",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Ken. Tekko +1",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Ninja Nodowa +1", augments={'Path: A',}},
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear="Brutal Earring",
    right_ear="Telos Earring",
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	
	}   
	
	sets.engaged.Acc = {
	
    ammo="Seki Shuriken",
    head="Ken. Jinpachi +1",
    body="Ken. Samue +1",
    hands="Ken. Tekko +1",
    legs="Ken. Hakama +1",
    feet="Ken. Sune-Ate +1",
    neck={ name="Ninja Nodowa +1", augments={'Path: A',}},
    waist={ name="Kentarch Belt +1", augments={'Path: A',}},
    left_ear="Mache Earring +1",
    right_ear="Telos Earring",
    left_ring="Chirich Ring +1",
    right_ring="Chirich Ring +1",
    back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	
	}

	sets.engaged.Acc.PDT = {}

	sets.engaged.DW = {
	
    ammo="Seki Shuriken",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Mochi. Hakama +3", augments={'Enhances "Mijin Gakure" effect',}},
    feet="Hiza. Sune-Ate +2",
    neck={ name="Ninja Nodowa +1", augments={'Path: A',}},
    waist="Reiki Yotai",
    left_ear="Suppanomimi",
    right_ear="Eabani Earring",
    left_ring="Gere Ring",
    right_ring="Epona's Ring",
    back={ name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	
	}
	
    --------------------------------------
    -- Custom buff sets
    --------------------------------------

    sets.buff.Migawari = {body="Iga Ningi +2"}
	
    sets.buff.Doom = {
	
	ring2="Saida Ring"
	
	}
	
    sets.buff.Yonin = {}
	
    sets.buff.Innin = {}
	
	sets.buff.Sange = {
	
	ammo= "Date Shuriken"
	
	}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.

function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.Buff.Doom then
        equip(sets.buff.Doom)
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted and spell.english == "Migawari: Ichi" then
        state.Buff.Migawari = true
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.Buff.Sange then
        equip(sets.buff.Sange)
    end
end
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.

function job_buff_change(buff, gain)
    -- If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
        determine_haste_group()
        handle_equipping_gear(player.status)
    elseif state.Buff[buff] ~= nil then
        handle_equipping_gear(player.status)
    end
end

function job_status_change(new_status, old_status)
    if new_status == 'Idle' then
        select_movement_feet()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Get custom spell maps
function job_get_spell_map(spell, default_spell_map)
    if spell.skill == "Ninjutsu" then
        if not default_spell_map then
            if spell.target.type == 'SELF' then
                return 'NinjutsuBuff'
            else
                return 'NinjutsuDebuff'
            end
        end
    end
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
    if state.Buff.Migawari then
        idleSet = set_combine(idleSet, sets.buff.Migawari)
    end
    if state.Buff.Doom then
        idleSet = set_combine(idleSet, sets.buff.Doom)
    end
	    if state.Buff.Sange then
        idleSet = set_combine(idleSet, sets.buff.Sange)
    end
    return idleSet
end


-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
    if state.Buff.Migawari then
        meleeSet = set_combine(meleeSet, sets.buff.Migawari)
    end
    if state.Buff.Doom then
        meleeSet = set_combine(meleeSet, sets.buff.Doom)
    end
	    if state.Buff.Sange then
        meleeSet = set_combine(meleeSet, sets.buff.Sange)
    end
	
    return meleeSet
end

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    select_movement_feet()
    determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
    -- We have three groups of DW in gear: Hachiya body/legs, Iga head + Patentia Sash, and DW earrings
    
    -- Standard gear set reaches near capped delay with just Haste (77%-78%, depending on HQs)

    -- For high haste, we want to be able to drop one of the 10% groups.
    -- Basic gear hits capped delay (roughly) with:
    -- 1 March + Haste
    -- 2 March
    -- Haste + Haste Samba
    -- 1 March + Haste Samba
    -- Embrava
    
    -- High haste buffs:
    -- 2x Marches + Haste Samba == 19% DW in gear
    -- 1x March + Haste + Haste Samba == 22% DW in gear
    -- Embrava + Haste or 1x March == 7% DW in gear
    
    -- For max haste (capped magic haste + 25% gear haste), we can drop all DW gear.
    -- Max haste buffs:
    -- Embrava + Haste+March or 2x March
    -- 2x Marches + Haste
    
    -- So we want four tiers:
    -- Normal DW
    -- 20% DW -- High Haste
    -- 7% DW (earrings) - Embrava Haste (specialized situation with embrava and haste, but no marches)
    -- 0 DW - Max Haste
    
    classes.CustomMeleeGroups:clear()
    
    if buffactive.embrava and (buffactive.march == 2 or (buffactive.march and buffactive.haste)) then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.march == 2 and buffactive.haste then
        classes.CustomMeleeGroups:append('MaxHaste')
    elseif buffactive.embrava and (buffactive.haste or buffactive.march) then
        classes.CustomMeleeGroups:append('EmbravaHaste')
    elseif buffactive.march == 1 and buffactive.haste and buffactive['haste samba'] then
        classes.CustomMeleeGroups:append('HighHaste')
    elseif buffactive.march == 2 then
        classes.CustomMeleeGroups:append('HighHaste')
    end
end


function select_movement_feet()
    if world.time >= 17*60 or world.time < 7*60 then
        gear.MovementFeet.name = gear.NightFeet
    else
        gear.MovementFeet.name = gear.DayFeet
    end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(4, 3)
    elseif player.sub_job == 'THF' then
        set_macro_page(5, 3)
    else
        set_macro_page(1, 3)
    end
end

--movespeed	

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