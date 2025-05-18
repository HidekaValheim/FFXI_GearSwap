-- NOTE: I do not play run, so this will not be maintained for 'active' use. 
-- It is added to the repository to allow people to have a baseline to build from,
-- and make sure it is up-to-date with the library API.


-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
	include('organizer-lib')
	send_command('wait 2;input /lockstyleset 25')
end


-- Setup vars that are user-independent.+
function job_setup()
    -- Table of entries
    rune_timers = T{}
    -- entry = rune, index, expires
    
    if player.main_job_level >= 65 then
        max_runes = 3
    elseif player.main_job_level >= 35 then
        max_runes = 2
    elseif player.main_job_level >= 5 then
        max_runes = 1
    else
        max_runes = 0
    end
	
--movespeed	
state.Moving = M(false, "moving")	
	
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Hybrid', 'DD', 'DWHybrid', 'DW', 'QuadDD')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.PhysicalDefenseMode:options('PDT')
    state.IdleMode:options('Normal', 'Regen', 'Refresh')

	select_default_macro_book()
end


function init_gear_sets()
    sets.enmity = {
    ammo="Aqreaqa Bomblet",
    head="Halitus Helm",
    body="Emet Harness +1",
    hands="Kurys Gloves",
    legs="Eri. Leg Guards +1",
    feet="Ahosi leggings",
    neck="Unmoving Collar +1",
    waist="Kasiri Belt",
    left_ear="Cryptic Earring",
    right_ear="Trux Earring",
    left_ring="Eihwaz Ring",
    right_ring="Supershear Ring",
    back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}}
	}
	
	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
    sets.precast.JA['Vallation'] = set_combine(sets.enmity, {
	body="Runeist's coat +3", 
	legs="Futhark Trousers +3"
	})
	
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
	
    sets.precast.JA['Pflug'] = set_combine(sets.enmity, {
	feet="Runeist boots +2"
	})
	
    sets.precast.JA['Battuta'] = set_combine(sets.enmity,{
	head="Fu. Bandeau +3"
	})
	
    sets.precast.JA['Liement'] = set_combine(sets.enmity, {
	body="Futhark Coat +3"
	})
	
    sets.precast.JA['Lunge'] = {
    ammo="Seething Bomblet",
    head={ name="Herculean Helm", augments={'DEX+5','"Mag.Atk.Bns."+29','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
    body={ name="Rawhide Vest", augments={'DEX+10','STR+7','INT+7',}},
 hands={ name="Herculean Gloves", augments={'Attack+19','"Mag.Atk.Bns."+28','Magic Damage +9','Accuracy+17 Attack+17','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
    legs="Shned. Tights +1",
    feet={ name="Adhemar Gamashes", augments={'STR+10','DEX+10','Attack+15',}},
    neck="Sanctity necklace",
    waist="Eschan Stone",
    left_ear="Friomisi Earring",
    right_ear="Hecate's Earring",
    left_ring="Shiva Ring +1",
    right_ring="Shiva Ring +1"	
	}
	
    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
	
    sets.precast.JA['Gambit'] = {
	hands="Runeist Mitons +3"
	}
	
    sets.precast.JA['Rayke'] = {
	feet="Futhark Boots +1"
	}
	
    sets.precast.JA['Elemental Sforzo'] = set_combine(sets.enmity, {
	body="Futhark Coat +3"
	})
	
    sets.precast.JA['Swordplay'] = set_combine(sets.enmity, {
	hands="Futhark Mitons +3"
	})
	
    sets.precast.JA['Embolden'] = sets.enmity
	
    sets.precast.JA['Vivacious Pulse'] = set_combine(sets.enmity, {
    head="Erilaz Galea +1",
	legs="Rune. Trousers +2",
    neck="Incanter's Torque",
    left_ear="Beatific Earring",
    right_ear="Saxnot Earring",
    left_ring="Stikini Ring +1 +1",
	right_ring="Stikini Ring +1 +1"
	})
	
    sets.precast.JA['One For All'] = set_combine(sets.enmity, {
    head="Rune. Bandeau +3",
    body="Runeist's Coat +3",
    hands="Regal Gauntlets",
    legs={ name="Carmine Cuisses +1", augments={'HP+80','STR+12','INT+12',}},
    feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
    neck="Sanctity Necklace",
    right_ear="Etiolation Earring",
	right_ring="Moonbeam ring"
	})
	
	-- Fast cast sets for spells
    sets.precast.FC = {																					--FastCast total:    73%  
    ammo="Sapience Orb",																									--2%
    head="Rune. Bandeau +3",							--14%
    body={ name="Adhemar Jacket +1", augments={'HP+105','"Fast Cast"+10','Magic dmg. taken -4',}},							--10%
    hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},			--8%
    legs="Aya. Cosciales +2",																								--6%
    feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},									--8%
    neck="Orunmila's Torque",																								--5%
    waist="Kasiri Belt",																							
    left_ear="Loquac. Earring",																								--2%					
    right_ear="Enchanter Earring +1",																							--2%
    left_ring="Rahab Ring",																									--2%
    right_ring="Kishar Ring",																								--4%	
    back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}} --10%
	}
    
	sets.precast.FC['Enhancing Magic'] = sets.precast.FC
	
    sets.precast.FC['Utsusemi: Ichi'] = set_combine(sets.precast.FC, {})
	
    sets.precast.FC['Utsusemi: Ni'] = set_combine(sets.precast.FC['Utsusemi: Ichi'], {})

	-- Weaponskill sets
	
    sets.precast.WS['Resolution'] = {
    ammo="Knobkierrie",
    head={ name="Lustratio Cap +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
    body={ name="Lustr. Harness +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
    hands={ name="Herculean Gloves", augments={'Accuracy+17 Attack+17','"Triple Atk."+4','STR+9','Accuracy+14','Attack+9',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
    neck="Fotia Gorget",
    waist="Kentarch Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Epona's Ring",
    back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}}
	}

    sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'].Normal, {})

    sets.precast.WS['Dimidiation'] = {
    ammo="Knobkierrie",
    head={ name="Lustratio Cap +1", augments={'Attack+20','STR+8','"Dbl.Atk."+3',}},
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands="Meg. Gloves +2",
    legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    feet={ name="Lustra. Leggings +1", augments={'HP+65','STR+15','DEX+15',}},
    neck="Fotia Gorget",
    waist="Kentarch Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Epona's Ring",
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	}
    
	sets.precast.WS['Dimidiation'].Acc = set_combine(sets.precast.WS['Dimidiation'].Normal, {})	


    sets.precast.WS['Herculean Slash'] = set_combine(sets.precast['Lunge'], {})
	
    sets.precast.WS['Herculean Slash'].Acc = set_combine(sets.precast.WS['Herculean Slash'].Normal, {})	
	
	sets.precast.WS['Savage Blade'] = {
    ammo="Knobkierrie",
    head="Adhemar bonnet +1",
    body="Lustratio Harness +1",
    hands="Meg. Gloves +2",
    legs={ name="Herculean Trousers", augments={'Accuracy+21 Attack+21','Weapon skill damage +2%','STR+10',}},
    feet="Lustratio Leggings +1",
    neck="Fotia Gorget",
    waist="Kentarch Belt +1",
    left_ear="Ishvara Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Rufescent ring",
    right_ring="Karieyh Ring +1",
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	}    
	
	sets.precast.WS['Requiescat'] = {
    ammo="Seeth. Bomblet +1",
    head="Lustratio Cap +1",
    body="Lustratio Harness +1",
    hands={ name="Herculean Gloves", augments={'Accuracy+24 Attack+24','STR+15','Attack+3',}},
	legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ear="Cessance Earring",
    left_ring="Karieyh Ring +1",
    right_ring="Epona's Ring",
    back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}	
	}
	
    sets.precast.WS['Decimation'] = {
    ammo="Knobkierrie",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands={ name="Herculean Gloves", augments={'Accuracy+17 Attack+17','"Triple Atk."+4','STR+9','Accuracy+14','Attack+9',}},
    legs="Meg. Chausses +2",
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck="Fotia Gorget",
    waist="Kentarch Belt +1",
    left_ear="Brutal Earring",
    right_ear="Sherida Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Epona's Ring",
    back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}}
	}
		
	--------------------------------------
	-- Midcast sets
	--------------------------------------
	
    sets.midcast.FastRecast = {}
	
	sets.midcast.SIRD = {																		--104% Merited Sird (49 PDT)
    ammo="Staunch Tathlum +1", 																	--11%
    head="Futhark bandeau +3", 
    body="Futhark coat +3",
    hands={ name="Rawhide Gloves", augments={'HP+50','Accuracy+15','Evasion+20',}},             --15%
    legs={ name="Carmine Cuisses +1", augments={'HP+80','STR+12','INT+12',}},                   --20%
    feet="Karasutengu kogake",                                                                  --15%
    neck="Moonbeam Necklace",																	--10%
    waist="Audumbla Sash",																	    --10%
    left_ear="Halasz Earring",																	--5%
    right_ear="Magnetic Earring",																--8%
    left_ring="Defending Ring",
    right_ring="Gelatinous ring +1",
    back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}}
	}	
	
	sets.midcast['Flash'] = sets.enmity
	
	sets.midcast['Foil'] = sets.enmity
	
	sets.midcast['Stun'] = sets.enmity
	
	sets.midcast['Poisonga'] = sets.midcast.SIRD
	
	sets.midcast['Jettatura'] = sets.enmity
	
	sets.midcast['Geist Wall'] = sets.enmity
	
	sets.midcast['Blank Gaze'] = sets.enmity 
	
	sets.midcast['Sandspin'] = sets.enmity
	
    sets.midcast['Enhancing Magic'] = {
    ammo="Aqreaqa bomblet",
    head="Erilaz Galea +1",
    body="Manasa Chasuble",
    hands="Runeist's Mitons +3",
    legs="Futhark Trousers +3",
    feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
    right_ear="Mimir Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back="Merciful Cape"
	}
	
    sets.midcast['Phalanx'] = {
    ammo="Aqreqaq Bomblet",
    head={ name="Fu. Bandeau +3", augments={'Enhances "Battuta" effect',}},
    body={ name="Taeon Tabard", augments={'"Fast Cast"+5','Phalanx +3',}},
    hands={ name="Herculean Gloves", augments={'Accuracy+17','Pet: Accuracy+3 Pet: Rng. Acc.+3','Phalanx +4','Mag. Acc.+12 "Mag.Atk.Bns."+12',}},
    legs={ name="Herculean Trousers", augments={'DEX+10','Crit. hit damage +1%','Phalanx +3','Accuracy+3 Attack+3','Mag. Acc.+7 "Mag.Atk.Bns."+7',}},
    feet={ name="Herculean Boots", augments={'DEX+11','MND+1','Phalanx +3','Accuracy+1 Attack+1','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
    neck="Incanter's Torque",
    waist="Olympus Sash",
    left_ear="Andoaa Earring",
    right_ear="Saxnot Earring",
    left_ring="Stikini Ring +1",
    right_ring="Moonbeam Ring",
    back="Merciful Cape"
	}

    sets.midcast['Regen IV'] = {
    ammo="Aqreqaq Bomblet",
    head="Runeist's bandeau +3",
    body={ name="Futhark Coat +3", augments={'Enhances "Elemental Sforzo" effect',}},
    hands="Regal Gauntlets",
    legs="Futhark Trousers +3",
    feet="Erilaz Greaves +1",
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Telos Earring",
    right_ear="Dedition Earring",
    left_ring="Defending Ring",
    right_ring="Moonbeam Ring",
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}
	
	sets.midcast['Aquaveil'] = sets.midcast.SIRD
	
	sets.midcast['Temper'] = set_combine(sets.midcast['Enhancing Magic'], {
	head="Carmine mask +1",
	legs="Carmine Cuisses +1"
	})
	
	sets.midcast['Crusade'] = {
    ammo="Aqreqaq Bomblet",
    head="Erilaz Galea +1",
    body={ name="Futhark Coat +3", augments={'Enhances "Elemental Sforzo" effect',}},
    hands="Regal Gauntlets",
    legs={ name="Futhark Trousers +3", augments={'Enhances "Inspire" effect',}},
    feet="Erilaz Greaves +1",
    neck="Loricate Torque +1",
    waist="Flume Belt +1",
    left_ear="Genmei Earring",
    right_ear="Cryptic Earring",
    left_ring="Defending Ring",
    right_ring="Moonbeam Ring",
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}
	
	sets.buff['Embolden'] =  set_combine(sets.midcast['Enhancing Magic'], {
    hands="Regal Gauntlets",	
	})
	
	function job_midcast(spell, action, spellMap, eventArgs)
		if string.find(spell.english,'Temper') and buffactive['Embolden'] then
			equip(sets.buff['Embolden'])
			eventArgs.handled = true
		end
	end	

	sets.midcast['Refresh'] = {
	head="Erilaz galea +1", 
	hands="Regal Gauntlets",
	legs="Futhark Trousers +3",
	waist="Gishdubar Sash"
	}
	
	sets.midcast['Regen'] = {
	head="Erilaz galea +1", 
	legs="Futhark Trousers +3"
	}
	
	sets.midcast['Protect'] = set_combine(sets.midcast['Enhancing Magic'], {
    left_ring="Sheltered Ring"	
	})
	
	sets.midcast['Shell'] = set_combine(sets.midcast['Enhancing Magic'], {
    left_ring="Sheltered Ring"
	})
	
    sets.midcast['Stoneskin'] = {
    head="Erilaz Galea +1",
    body="Manasa Chasuble",
    hands="Stone Mufflers",
    legs="Haven Hose",
    neck="Stone Gorget",
    waist="Siegel Sash",
    left_ear="Andoaa Earring",
    right_ear="Earthcry Earring",
    left_ring="Stikini Ring +1",
    back="Merciful Cape"	
	}
	
	sets.midcast['Wild Carrot'] = set_combine(sets.enmity, {
    hands="Buremte Gloves",
    left_ear="Roundel Earring",
    right_ear="Mendi. Earring",
    left_ring="Asklepian Ring",
    right_ring="Kunaji Ring",
    back="Solemnity Cape"
	})
	
	sets.midcast['Healing Breeze'] = set_combine(sets.enmity, {
    hands="Buremte Gloves",
    left_ear="Roundel Earring",
    right_ear="Mendi. Earring",
    left_ring="Asklepian Ring",
    right_ring="Kunaji Ring",
    back="Solemnity Cape"
	})	
	
    sets.midcast.Cure = {}

	--------------------------------------
	-- Idle/resting/defense/etc sets
	--------------------------------------

    sets.idle = {
    ammo="Staunch Tathlum +1",
    head={ name="Fu. Bandeau +3", augments={'Enhances "Battuta" effect',}},
    body="Ashera Harness",
    hands="Turms Mittens +1",
    legs={ name="Carmine Cuisses +1", augments={'HP+80','STR+12','INT+12',}},
    feet="Erilaz Greaves +1",
    neck="Warder's Charm +1",
    waist="Flume Belt +1",
    left_ear="Sanare Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring="Gelatinous Ring +1",
    back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}}
	}
    
	sets.idle.Refresh = set_combine(sets.idle, {
	ammo="Homiliary",
    head={ name="Herculean Helm", augments={'INT+10','STR+15','"Refresh"+2',}},
    body="Runeist's coat +3",
    hands="Regal Gauntlets",
    legs="Futhark Trousers +3",
    feet="Turms Leggings",
    neck="Bathy Choker +1",
    waist="Flume Belt +1",
    left_ear="Ethereal Earring",
    right_ear="Odnowa Earring +1",
    left_ring="Sheltered Ring",
    right_ring="Paguroidea Ring",
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	})
	
	sets.idle.Regen = set_combine(sets.idle, {
	ammo="Staunch Tathlum +1",
    head="Turms Cap",
    body="Futhark coat +3",
    hands="Regal Gauntlets",
    legs="Futhark Trousers +3",
    feet="Turms Leggings",
    neck="Bathy Choker +1",
    waist="Flume Belt +1",
    left_ear="Infused Earring",
    right_ear="Odnowa Earring +1",
    left_ring="Sheltered Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	})
           
	sets.defense.PDT = sets.idle

	sets.defense.MDT = {
    ammo="Aqreqaq Bomblet",
    head={ name="Fu. Bandeau +3", augments={'Enhances "Battuta" effect',}},
    body={ name="Futhark Coat +3", augments={'Enhances "Elemental Sforzo" effect',}},
    hands="Turms Mittens +1",
    legs="Eri. Leg Guards +1",
    feet="Erilaz Greaves +1",
    neck="Warder's Charm +1",
    waist="Engraved Belt",
    left_ear="Sanare Earring",
    right_ear="Etiolation Earring",
    left_ring="Defending Ring",
    right_ring={ name="Dark Ring", augments={'Breath dmg. taken -5%','Phys. dmg. taken -5%','Magic dmg. taken -3%',}},
    back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}}
	}

	sets.Kiting = {
    ammo="Staunch Tathlum +1",
    head="Fu. Bandeau +3",
    body={ name="Futhark Coat +3", augments={'Enhances "Elemental Sforzo" effect',}},
    hands="Runeist's Mitons +3",
    legs={ name="Carmine Cuisses +1", augments={'HP+80','STR+12','INT+12',}},
    feet="Erilaz Greaves +1",
    neck="Warder's Charm +1",
    waist="Engraved Belt",
    left_ear="Cryptic Earring",
    right_ear="Odnowa Earring +1",
    left_ring="Defending Ring",
    right_ring="Gelatinous Ring +1",
    back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','Enmity+10','Phys. dmg. taken-10%',}}
	}

	--movespeed	
	
	sets.MoveSpeed = {
    legs={ name="Carmine Cuisses +1", augments={'HP+80','STR+12','INT+12',}}
	}

	sets.idle.Town = {
    ammo="Aurgelmir Orb +1",
    head="Aya. Zucchetto +2",
    body="Ashera Harness",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs="Meg. Chausses +2",
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck={ name="Futhark Torque +1", augments={'Path: A',}},
    waist="Ioskeha Belt",
    left_ear="Genmei Earring",
    right_ear="Sherida Earring",
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}
	--------------------------------------
	-- Engaged sets
	--------------------------------------
	
    sets.engaged.Hybrid  = {
    ammo="Aurgelmir Orb +1",
    head="Aya. Zucchetto +2",
    body="Ashera Harness",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs="Meg. Chausses +2",
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck={ name="Futhark Torque +1", augments={'Path: A',}},
    waist="Ioskeha Belt",
    left_ear="Genmei Earring",
    right_ear="Sherida Earring",
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}
    
	sets.engaged.DD = {
    ammo="Aurgelmir Orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Epona's Ring",
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}
	
    sets.engaged.DW = {
    ammo="Yamarang",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck="Combatant's Torque",
    waist="Reiki yotai",
    left_ear="Sherida Earring",
    right_ear="Telos Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Epona's Ring",
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
	}
	
	
    sets.engaged.DWHybrid = {
	ammo="Hasty Pinion +1",
    head={ name="Herculean Helm", augments={'Accuracy+29','"Triple Atk."+4','STR+6',}},
    body={ name="Futhark Coat +3", augments={'Enhances "Elemental Sforzo" effect',}},
    hands={ name="Herculean Gloves", augments={'Accuracy+17 Attack+17','"Triple Atk."+4','STR+9','Accuracy+14','Attack+9',}},
    legs="Meg. Chausses +2",
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck="Futhark Torque +1",
    waist="Reiki yotai",
    left_ear="Suppanomimi",
    right_ear="Genmei Earring",
    left_ring="Defending Ring",
    right_ring="Moonbeam Ring",
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}	
	}
	
    sets.engaged.QuadDD = {
    ammo="Aurgelmir Orb +1",
    head="Dampening Tam",
    body={ name="Herculean Vest", augments={'Weapon skill damage +1%','MND+5','Quadruple Attack +3','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
    hands="Gazu Bracelet +1",
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+7 Attack+7','Pet: "Store TP"+9','Quadruple Attack +3',}},
    neck="Anu Torque",
    waist="Windbuffet Belt +1",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    left_ring="Niqmaddu Ring",
    right_ring="Epona's Ring",
    back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
	}	

end

------------------------------------------------------------------
-- Action events
------------------------------------------------------------------

-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.english == 'Lunge' or spell.english == 'Swipe' then
        local obi = get_obi(get_rune_obi_element())
        if obi then
            equip({waist=obi})
        end
    end
end


function job_aftercast(spell)
    if not spell.interrupted then
        if spell.type == 'Rune' then
            update_timers(spell)
        elseif spell.name == "Lunge" or spell.name == "Gambit" or spell.name == 'Rayke' then
            reset_timers()
        elseif spell.name == "Swipe" then
            send_command(trim(1))
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(5, 20)
	elseif player.sub_job == 'NIN' then
		set_macro_page(7, 20)
	elseif player.sub_job == 'SAM' then
		set_macro_page(5, 20)
	else
		set_macro_page(5, 20)
	end
end

function get_rune_obi_element()
    weather_rune = buffactive[elements.rune_of[world.weather_element] or '']
    day_rune = buffactive[elements.rune_of[world.day_element] or '']
    
    local found_rune_element
    
    if weather_rune and day_rune then
        if weather_rune > day_rune then
            found_rune_element = world.weather_element
        else
            found_rune_element = world.day_element
        end
    elseif weather_rune then
        found_rune_element = world.weather_element
    elseif day_rune then
        found_rune_element = world.day_element
    end
    
    return found_rune_element
end

function get_obi(element)
    if element and elements.obi_of[element] then
        return (player.inventory[elements.obi_of[element]] or player.wardrobe[elements.obi_of[element]]) and elements.obi_of[element]
    end
end


------------------------------------------------------------------
-- Timer manipulation
------------------------------------------------------------------

-- Add a new run to the custom timers, and update index values for existing timers.
function update_timers(spell)
    local expires_time = os.time() + 300
    local entry_index = rune_count(spell.name) + 1

    local entry = {rune=spell.name, index=entry_index, expires=expires_time}

    rune_timers:append(entry)
    local cmd_queue = create_timer(entry).. ';wait 0.05;'
    
    cmd_queue = cmd_queue .. trim()

    --add_to_chat(123,'cmd_queue='..cmd_queue)

    send_command(cmd_queue)
end

-- Get the command string to create a custom timer for the provided entry.
function create_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    local duration = entry.expires - os.time()
    return 'timers c ' .. timer_name .. ' ' .. tostring(duration) .. ' down'
end

-- Get the command string to delete a custom timer for the provided entry.
function delete_timer(entry)
    local timer_name = '"Rune: ' .. entry.rune .. '-' .. tostring(entry.index) .. '"'
    return 'timers d ' .. timer_name .. ''
end

-- Reset all timers
function reset_timers()
    local cmd_queue = ''
    for index,entry in pairs(rune_timers) do
        cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
    end
    rune_timers:clear()
    send_command(cmd_queue)
end

-- Get a count of the number of runes of a given type
function rune_count(rune)
    local count = 0
    local current_time = os.time()
    for _,entry in pairs(rune_timers) do
        if entry.rune == rune and entry.expires > current_time then
            count = count + 1
        end
    end
    return count
end

-- Remove the oldest rune(s) from the table, until we're below the max_runes limit.
-- If given a value n, remove n runes from the table.
function trim(n)
    local cmd_queue = ''

    local to_remove = n or (rune_timers:length() - max_runes)

    while to_remove > 0 and rune_timers:length() > 0 do
        local oldest
        for index,entry in pairs(rune_timers) do
            if oldest == nil or entry.expires < rune_timers[oldest].expires then
                oldest = index
            end
        end
        
        cmd_queue = cmd_queue .. prune(rune_timers[oldest].rune)
        to_remove = to_remove - 1
    end
    
    return cmd_queue
end

-- Drop the index of all runes of a given type.
-- If the index drops to 0, it is removed from the table.
function prune(rune)
    local cmd_queue = ''
    
    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            cmd_queue = cmd_queue .. delete_timer(entry) .. ';wait 0.05;'
            entry.index = entry.index - 1
        end
    end

    for index,entry in pairs(rune_timers) do
        if entry.rune == rune then
            if entry.index == 0 then
                rune_timers[index] = nil
            else
                cmd_queue = cmd_queue .. create_timer(entry) .. ';wait 0.05;'
            end
        end
    end
    
    return cmd_queue
end


------------------------------------------------------------------
-- Reset events
------------------------------------------------------------------

windower.raw_register_event('zone change',reset_timers)
windower.raw_register_event('logout',reset_timers)
windower.raw_register_event('status change',function(new, old)
    if gearswap.res.statuses[new].english == 'Dead' then
        reset_timers()
    end
end)


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