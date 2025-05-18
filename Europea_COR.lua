-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off
    
    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.
    
    Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(false, "Luzaf's Ring")
    -- Whether a warning has been given for low ammo
    state.warned = M(false)

    define_roll_values()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Ranged', 'Melee', 'Acc')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Att', 'Mod')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT', 'Refresh')

    gear.RAbullet = "Eminent Bullet"
    gear.WSbullet = "Eminent Bullet"
    gear.MAbullet = "Bronze Bullet"
    gear.QDbullet = "Animikii Bullet"
    options.ammo_warning_limit = 15

    -- Additional local binds
    send_command('bind ^` input /ja "Double-up" <me>')
    send_command('bind !` input /ja "Bolter\'s Roll" <me>')
	send_command('bind numpad0 input /ra <t>')
	send_command('bind f10 gs c toggle LuzafRing')
	send_command('bind f11 input /equip feet "Skadi\'s Jambeaux +1"')
	send_command('bind ^- input /item "Remedy" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
	send_command('unbind ^-')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets

    -- Precast sets to enhance JAs
    
    sets.precast.JA['Triple Shot'] = {body="Chasseur's Frac"}
    sets.precast.JA['Snake Eye'] = {legs="Lanun Trews"}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +2"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac +2"}

    
    sets.precast.CorsairRoll = {head="Lanun Tricorne +2",hands="Chasseur's Gants +1",neck="Regal Necklace",legs="Desultor Tassets",back={ name="Camulus's Mantle", augments={'MP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Magic dmg. taken-10%',}}}
    
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Navarch's Culottes +2"})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chasseur's Bottes"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chasseur's Tricorne +1"})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})
    
    sets.precast.LuzafRing = {ring1="Luzaf's Ring"}
    sets.precast.FoldDoubleBust = {hands="Lanun Gants"}
    
    sets.precast.CorsairShot = {head="Blood Mask",body="Mirke Wardecors"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Mummu Bonnet +2",
        body="Mummu Jacket +2",hands={ name="Herculean Gloves", augments={'CHR+3','Phys. dmg. taken -2%','"Refresh"+2','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},ring1="Carbuncle Ring",ring2="Carbuncle Ring",
        legs={ name="Herculean Trousers", augments={'Pet: Attack+27 Pet: Rng.Atk.+27','Accuracy+13 Attack+13','Quadruple Attack +2',}},feet="Meghanada jambeaux +2"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {
		head={ name="Herculean Helm", augments={'Pet: "Mag.Atk.Bns."+29','Pet: "Dbl.Atk."+1 Pet: Crit.hit rate +1','Pet: VIT+4','Pet: Attack+13 Pet: Rng.Atk.+13',}},
		body={ name="Herculean Vest", augments={'Potency of "Cure" effect received+2%','"Cure" spellcasting time -9%','Mag. Acc.+8 "Mag.Atk.Bns."+8',}},
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Herculean Boots", augments={'"Blood Pact" ability delay -1','"Cure" spellcasting time -10%','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		neck="Voltsurge Torque",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Camulus's Mantle", augments={'MP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Magic dmg. taken-10%',}},
	}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})


    sets.precast.RA = {ammo=gear.RAbullet,
        head="Chass. Tricorne +1",
		body="Laksa. Frac +3",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs="Oshosi Trousers",
		feet="Meg. Jam. +2",
		neck="Commodore Charm",
		waist="Impulse Belt",
		back={ name="Camulus's Mantle", augments={'"Snapshot"+10',}},
		}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Meghanada Visor +2",
		body="Meg. Cuirie +2",
		hands="Meg. Gloves +2",
		legs={ name="Herculean Trousers", augments={'CHR+6','Pet: Attack+1 Pet: Rng.Atk.+1','Weapon skill damage +4%','Accuracy+12 Attack+12','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet="Meg. Jam. +2",
		neck="Clotharius Torque",
		waist="Eschan Stone",
		left_ear="Brutal Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Meghanada Ring",
		right_ring="Rajas Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%',}},
		}


    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = {
        head="Mummu Bonnet +2",
		body="Meg. Cuirie +2",
		hands="Mummu Wrists +2",
		legs="Mummu Kecks +2",
		feet="Mummu Gamash. +2",
		neck={ name="Commodore Charm", augments={'Path: A',}},
		waist="Grunfeld Rope",
		left_ear="Brutal Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epona's Ring",
		right_ring="Mummu Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%',}},
	}

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {legs={ name="Herculean Trousers", augments={'Pet: Attack+27 Pet: Rng.Atk.+27','Accuracy+13 Attack+13','Quadruple Attack +2',}}})

    sets.precast.WS['Requiescat'] = set_combine(sets.precast.WS, {legs={ name="Herculean Trousers", augments={'"Mag.Atk.Bns."+21','Weapon skill damage +2%','AGI+9',}}})
	
	sets.precast.WS['Savage Blade'] = {
        head="Meghanada Visor +2",
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs={ name="Herculean Trousers", augments={'CHR+6','Pet: Attack+1 Pet: Rng.Atk.+1','Weapon skill damage +4%','Accuracy+12 Attack+12','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet={ name="Lanun Bottes +2", augments={'Enhances "Wild Card" effect',}},
		neck="Clotharius Torque",
		waist="Prosilio Belt",
		left_ear="Ishvara Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Epona's Ring",
		right_ring="Mujin Band",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},
		}

    sets.precast.WS['Last Stand'] = {ammo=gear.WSbullet,
        head="Meghanada Visor +2",
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs="Meg. Chausses +2",
		feet={ name="Lanun Bottes +2", augments={'Enhances "Wild Card" effect',}},
		neck={ name="Commodore Charm", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear="Ishvara Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Meghanada Ring",
		right_ring="Mujin Band",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}},}

    sets.precast.WS['Last Stand'].Acc = {ammo=gear.WSbullet,
        head="Meghanada visor +2",neck="Fotia Gorget",ear1="Clearview Earring",ear2="Volley Earring",
        body="Oshosi Vest",hands="Meghanada Gloves +2",ring1="Paqichikaji Ring",ring2="Garuda Ring",
        back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},waist="Fotia Belt",legs="Meghanada Chausses +2",feet="Meghanada jambeaux +2"}


    sets.precast.WS['Wildfire'] = {ammo=gear.MAbullet,
        head="Pixie Hairpin +1",
		body={ name="Lanun Frac +3", augments={'Enhances "Loaded Deck" effect',}},
		hands="Carmine Finger Gauntlets +1",
		legs={ name="Herculean Trousers", augments={'CHR+6','Pet: Attack+1 Pet: Rng.Atk.+1','Weapon skill damage +4%','Accuracy+12 Attack+12','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet={ name="Lanun Bottes +2", augments={'Enhances "Wild Card" effect',}},
		neck="Commodore Charm",
		waist="Hachirin-no-Obi",
		left_ear="Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Mujin Band",
		right_ring="Archon Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
		}

    sets.precast.WS['Wildfire'].Brew = {ammo=gear.MAbullet,
        head={ name="Herculean Helm", augments={'Mag. Acc.+14 "Mag.Atk.Bns."+14','Weapon skill damage +3%','MND+2','"Mag.Atk.Bns."+15',}},neck="Sanctity Necklace",ear1="Hecate's Earring",ear2="Friomisi Earring",
        body="Oshosi Vest",hands="Meghanada gloves +2",ring1="Mujin Band",ring2="Garuda Ring",
        back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},waist="Hachirin-no-Obi",legs={ name="Herculean Trousers", augments={'"Mag.Atk.Bns."+21','Weapon skill damage +2%','AGI+9',}},feet={ name="Herculean Boots", augments={'"Mag.Atk.Bns."+20','Pet: Accuracy+22 Pet: Rng. Acc.+22','"Refresh"+2','Accuracy+2 Attack+2',}}}
    
    sets.precast.WS['Leaden Salute'] = sets.precast.WS['Wildfire']
    
    
    -- Midcast Sets
    sets.midcast.FastRecast = {
        head="Herculean Helm",
        body={ name="Taeon Tabard", augments={'"Fast Cast"+5',}},hands="Thaumas Gloves",
        legs="Rawhide Trousers",feet="Taeon Boots"}
		
	sets.midcast.Cure = {
		head={ name="Herculean Helm", augments={'Pet: "Mag.Atk.Bns."+29','Pet: "Dbl.Atk."+1 Pet: Crit.hit rate +1','Pet: VIT+4','Pet: Attack+13 Pet: Rng.Atk.+13',}},
		body={ name="Herculean Vest", augments={'Potency of "Cure" effect received+2%','"Cure" spellcasting time -9%','Mag. Acc.+8 "Mag.Atk.Bns."+8',}},
		hands="Meg. Gloves +2",
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Herculean Boots", augments={'"Dbl.Atk."+2','"Refresh"+2',}},
		neck="Malison Medallion",
		waist="Dynamic Belt +1",
		left_ear="Mendi. Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Yacuruna Ring",
		back={ name="Camulus's Mantle", augments={'MP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Magic dmg. taken-10%',}},
	}
        	
    -- Specific spells
    sets.midcast.Utsusemi = sets.midcast.FastRecast
	
	sets.midcast.Reraise = sets.midcast.FastRecast
	
	sets.midcast.Stoneskin = sets.midcast.FastRecast

    sets.midcast.CorsairShot = {ammo=gear.QDbullet,
        head="Mummu Bonnet +2",
		body="Mummu Jacket +2",
		hands="Malignance Gloves",
		legs="Mummu Kecks +2",
		feet="Mummu Gamash. +2",
		neck="Clotharius Torque",
		waist="Eschan Stone",
		left_ear="Hermetic Earring",
		right_ear="Steelflash Earring",
		left_ring="Mummu Ring",
		right_ring="Kishar Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%',}},
		}

    sets.midcast.CorsairShot.Acc = {ammo=gear.QDbullet,
        head="Mummu Bonnet +2",
		body="Mummu Jacket +2",
		hands="Malignance Gloves",
		legs="Mummu Kecks +2",
		feet="Mummu Gamash. +2",
		neck="Clotharius Torque",
		waist="Eschan Stone",
		left_ear="Hermetic Earring",
		right_ear="Steelflash Earring",
		left_ring="Mummu Ring",
		right_ring="Kishar Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%',}},
		}

    sets.midcast.CorsairShot['Light Shot'] = {ammo=gear.QDbullet,
        head="Mummu Bonnet +2",
		body="Mummu Jacket +2",
		hands="Malignance Gloves",
		legs="Mummu Kecks +2",
		feet="Mummu Gamash. +2",
		neck="Clotharius Torque",
		waist="Eschan Stone",
		left_ear="Hermetic Earring",
		right_ear="Steelflash Earring",
		left_ring="Mummu Ring",
		right_ring="Kishar Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%',}},
		}

    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']
	
	sets.TripleShot = {
		head="Oshosi Mask",
		body="Oshosi Vest",
		hands="Oshosi Gloves",
		legs="Oshosi Trousers",
		feet="Oshosi Leggings",
		neck="Ocachi Gorget",
		waist="Eschan Stone",
		left_ear="Steelflash Earring",
		right_ear="Brutal Earring",
		left_ring="Meghanada Ring",
		right_ring="Mummu Ring",
		back={ name="Camulus's Mantle", augments={'Rng.Acc.+20 Rng.Atk.+20','"Snapshot"+10',}}
		}


    -- Ranged gear
    sets.midcast.RA = {ammo=gear.RAbullet,
        head="Meghanada Visor +2",
		body="Laksa. Frac +3",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		legs="Oshosi Trousers",
		feet="Meg. Jam. +2",
		neck="Ocachi Gorget",
		waist="Eschan Stone",
		left_ear="Steelflash Earring",
		right_ear="Brutal Earring",
		left_ring="Meghanada Ring",
		right_ring="Mummu Ring",
		back={ name="Camulus's Mantle", augments={'Rng.Acc.+20 Rng.Atk.+20','"Snapshot"+10',}},
	}

    sets.midcast.RA.Acc = {ammo=gear.RAbullet,
        head="Meghanada Visor +2",
		body="Laksa. Frac +3",
		hands="Malignance Gloves",
		legs="Meg. Chausses +2",
		feet="Meg. Jam. +2",
		neck="Ocachi Gorget",
		waist="Eschan Stone",
		left_ear="Steelflash Earring",
		right_ear="Brutal Earring",
		left_ring="Meghanada Ring",
		right_ring="Mummu Ring",
		back={ name="Camulus's Mantle", augments={'Rng.Acc.+20 Rng.Atk.+20','"Snapshot"+10',}},
	}

    sets.TripleShot = {
		head="Oshosi Mask",
		body="Oshosi Vest",
		hands="Oshosi Gloves",
		legs="Oshosi Trousers",
		feet="Oshosi Leggings",
		neck="Ocachi Gorget",
		waist="Eschan Stone",
		left_ear="Steelflash Earring",
		right_ear="Brutal Earring",
		left_ring="Meghanada Ring",
		right_ring="Mummu Ring",
		back={ name="Camulus's Mantle", augments={'Rng.Acc.+20 Rng.Atk.+20','"Snapshot"+10',}},
	}
	
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {head="Rawhide Mask",neck="Sanctity Necklace",hands={ name="Herculean Gloves", augments={'CHR+3','Phys. dmg. taken -2%','"Refresh"+2','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},ring1="Sheltered Ring",ring2="Paguroidea Ring",legs="Rawhide Trousers",feet={ name="Herculean Boots", augments={'"Mag.Atk.Bns."+20','Pet: Accuracy+22 Pet: Rng. Acc.+22','"Refresh"+2','Accuracy+2 Attack+2',}}}
    

    -- Idle sets
    sets.idle.Refresh = {ammo=gear.RAbullet,
        head="Rawhide Mask",
		body="Meg. Cuirie +2",
		hands="Malignance Gloves",
		legs={ name="Rawhide Trousers", augments={'MP+50','"Fast Cast"+5','"Refresh"+1',}},
		feet={ name="Herculean Boots", augments={'"Dbl.Atk."+2','"Refresh"+2',}},
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Fortified Ring",
		back={ name="Camulus's Mantle", augments={'MP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Magic dmg. taken-10%',}},
		}
		
	sets.idle.DT = {ammo=gear.RAbullet,
        head="Malignance Chapeau",
		body="Meg. Cuirie +2",
		hands="Malignance Gloves",
		legs="Carmine Cuisses +1",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Fortified Ring",
		back={ name="Camulus's Mantle", augments={'MP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Magic dmg. taken-10%',}},
		}

	sets.idle.Normal = {ammo=gear.RAbullet,
        head="Malignance Chapeau",
		body="Meg. Cuirie +2",
		hands="Malignance Gloves",
		legs="Carmine Cuisses +1",
		feet="Malignance Boots",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Fortified Ring",
		back={ name="Camulus's Mantle", augments={'MP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Magic dmg. taken-10%',}},
		}
   
    -- Defense sets
    

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged.Melee = {ammo=gear.RAbullet,
        head="Malignance Chapeau",
		body="Mummu Jacket +2",
		hands="Malignance Gloves",
		legs="Meg. Chausses +2",
		feet="Malignance Boots",
		neck="Clotharius Torque",
		waist="Dynamic Belt +1",
		left_ear="Brutal Earring",
		right_ear="Suppanomimi",
		left_ring="Epona's Ring",
		right_ring="Rajas Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%',}},
		}
    
    sets.engaged.Acc = {ammo=gear.RAbullet,
        head="Malignance Chapeau",
		body="Mummu Jacket +2",
		hands="Malignance Gloves",
		legs="Meg. Chausses +2",
		feet="Malignance Boots",
		neck="Clotharius Torque",
		waist="Dynamic Belt +1",
		left_ear="Brutal Earring",
		right_ear="Suppanomimi",
		left_ring="Epona's Ring",
		right_ring="Rajas Ring",
		back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%',}},
	}

    sets.engaged.Melee.DW = {ammo=gear.RAbullet,
        head={ name="Herculean Helm", augments={'STR+3','Spell interruption rate down -7%','Quadruple Attack +3','Accuracy+5 Attack+5','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},neck="Clotharius Torque",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Mummu Jacket +2",hands={ name="Herculean Gloves", augments={'Accuracy+28','"Triple Atk."+4','DEX+10',}},ring1="Epona's Ring",ring2="Rajas Ring",
        back="Atheling Mantle",waist="Windbuffet Belt",legs={ name="Herculean Trousers", augments={'Pet: Attack+27 Pet: Rng.Atk.+27','Accuracy+13 Attack+13','Quadruple Attack +2',}},feet={ name="Herculean Boots", augments={'Pet: Attack+12 Pet: Rng.Atk.+12','Magic burst dmg.+1%','Quadruple Attack +2','Accuracy+9 Attack+9',}}}
    
    sets.engaged.Acc.DW = {ammo=gear.RAbullet,
        head={ name="Herculean Helm", augments={'STR+3','Spell interruption rate down -7%','Quadruple Attack +3','Accuracy+5 Attack+5','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},neck="Asperity Necklace",ear1="Dudgeon Earring",ear2="Heartseeker Earring",
        body="Meghanada Cuirie +2",hands={ name="Herculean Gloves", augments={'Accuracy+28','"Triple Atk."+4','DEX+10',}},ring1="Epona's Ring",ring2="Mars's Ring",
        back="Atheling Mantle",waist="Anguinus Belt",legs={ name="Herculean Trousers", augments={'Pet: Attack+27 Pet: Rng.Atk.+27','Accuracy+13 Attack+13','Quadruple Attack +2',}},feet="Mummu Gamashes +2"}


    sets.engaged.Ranged = {ammo=gear.RAbullet,
        head="Meghanada Visor +2",neck="Sanctity Necklace",ear1="Clearview Earring",ear2="Volley Earring",
        body="Oshosi Vest",hands="Malignance Gloves",ring1="Paqichikaji Ring",ring2="Rajas Ring",
        back="Gunslinger's Cape",waist="Kwahu Kachina Belt",legs="Meghanada Chausses +2",feet="Meghanada Jambeaux +2"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end

    -- gear sets
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and state.LuzafRing.value then
        equip(sets.precast.LuzafRing)
    elseif spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
        classes.CustomClass = 'Acc'
    elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Ranged Attack' and buffactive['Triple Shot'] then
        equip(sets.TripleShot)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
        display_roll_info(spell)
    end
end

function aftercast (spell,act)
 if new == 'Engaged' then
  equip(sets.engaged.Acc.DW)
 end 
end
-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, spellMap, default_wsmode)
    if buffactive['Transcendancy'] then
        return 'Brew'
    end
end


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    if newStatus == 'Engaged' and player.equipment.main == 'Chatoyant Staff' then
        state.OffenseMode:set('Ranged')
    end
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''
    
    msg = msg .. 'Off.: '..state.OffenseMode.current
    msg = msg .. ', Rng.: '..state.RangedMode.current
    msg = msg .. ', WS.: '..state.WeaponskillMode.current
    msg = msg .. ', QD.: '..state.CastingMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end
    
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    msg = msg .. ', Roll Size: ' .. ((state.LuzafRing.value and 'Large') or 'Small')
    
    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=4, unlucky=8, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies' Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
		["Naturalist's Roll"] = {lucky=3, unlucky=7, bonus="Enhancing Magic Duration+"},
		["Runeist's Roll"] = {lucky=4, unlucky=8, bonus="Magic Evasion"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, spell.english..' provides a bonus to '..rollinfo.bonus..'.  Roll size: '..rollsize)
        add_to_chat(104, 'Lucky roll is '..tostring(rollinfo.lucky)..', Unlucky roll is '..tostring(rollinfo.unlucky)..'.')
    end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.element == 'None' then
                -- physical weaponskills
                bullet_name = gear.WSbullet
            else
                -- magical weaponskills
                bullet_name = gear.MAbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end
    
    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]
    
    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end
    
    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end
    
    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end
        
        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 18)
end
