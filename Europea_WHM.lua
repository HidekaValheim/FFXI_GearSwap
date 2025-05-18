-------------------------------------------------------------------------------------------------------------------
-- (Original: Motenten / Modified: Arislan)
-------------------------------------------------------------------------------------------------------------------

--[[    Custom Features:
        
        Capacity Pts. Mode    Capacity Points Mode Toggle [WinKey-C]
        Auto. Lockstyle        Automatically locks desired equipset on file load
--]]

-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
    state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'DT')
    
    state.WeaponLock = M(false, 'Weapon Lock')    
    state.CP = M(false, "Capacity Points Mode")

    -- Additional local binds
    send_command('bind ^` input /ja "Afflatus Solace" <me>')
    send_command('bind !` input /ja "Afflatus Misery" <me>')
    send_command('bind ^- input /ma "Protectra V" <me>')
	send_command('bind ^= input /ma "Shellra V" <me>')
    send_command('bind ^[ input /ja "Divine Seal" <me>')
    send_command('bind ^] input /ja "Light Arts" <me>')
    send_command('bind ![ input /ja "Accession" <me>')
    send_command('bind !o input /ma "Regen IV" <stpc>')
    send_command('bind ^, input /ma Sneak <stpc>')
    send_command('bind ^. input /ma Invisible <stpc>')
    send_command('bind !c gs c toggle CP')
    send_command('bind @w gs c toggle WeaponLock')
	send_command('bind ^\\\\ input /ja "Divine Caress" <me>')

    send_command('bind ^numpad7 input /ma "Protectra V" <me>')
    send_command('bind ^numpad8 input /ma "Shellra V" <me>')
    send_command('bind ^numpad9 input /ws "Realmrazer" <t>')
    send_command('bind ^numpad1 input /ws "Flash Nova" <t>')

    select_default_macro_book()
    set_lockstyle()
end

function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
    send_command('unbind ^-')
    send_command('unbind ^[')
    send_command('unbind ^]')
    send_command('unbind ![')
    send_command('unbind !o')
    send_command('unbind ^,')
    send_command('unbind !.')
    send_command('unbind @c')
    send_command('unbind @w')
	send_command('unbind ^\\\\')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------

    -- Precast Sets

    -- Fast cast sets for spells

    sets.precast.FC = {
    --    /SCH --3
        main="Sucellus", --5
        sub="Genbu's Shield", --0
        ammo="Incantor stone", --2
		head="Nahtirah Hat", --10
        body="Inyanga Jubbah +2", --14
        hands={ name="Gendewitha Gages", augments={'Phys. dmg. taken -3%','"Cure" potency +4%',}}, --7
        legs="Ayanmo Cosciales +2", --6
        feet="Regal Pumps +1", --5
        neck="Orison Locket", --5
        ear1="Malignance Earring", --2
        ear2="Loquacious Earring", --4
        ring1="Kishar Ring", --4
        ring2="Prolix Ring", --2
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}}, --10
        waist="Channeler's Stone", --2
        }
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        back="Alaunus's Cape",
        waist="Siegel Sash",
        })

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {
        main="Sucellus",
        sub="Genbu's Shield",
        head="Nahtirah Hat",
        legs="Ebers Pantaloons",
		feet="Regal Pumps +1",
		ear1="Malignance Earring",
		ear2="Loquacious Earring",
		ring1="Kishar Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        })

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {
        main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
		ammo="Incantor Stone",
		head="Nahtirah Hat",
		body="Inyanga Jubbah +2",
		legs="Ebers Pantaloons",
		feet="Hygieia Clogs +1",
		neck="Orison Locket",
		left_ear="Mendi. Earring",
		right_ear="Nourish. Earring +1",
		ring1="Kishar Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},})

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})

    -- Precast sets to enhance JAs
    sets.precast.JA.Benediction = {body="Piety Briault",}
    
    -- Weaponskill sets

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Floestone",
        head="Chironic Hat",
        body="Onca Suit",
        neck="Fotia Gorget",
        ear1="Moonshade Earring",
        ear2="Telos Earring",
        ring1="Rufescent Ring",
        ring2="Shukuyu Ring",
        waist="Fotia Belt",
        }

    sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, {
        neck="Caro Necklace",
        waist="Prosilio Belt +1",
        })

    sets.precast.WS['Hexa Strike'] = set_combine(sets.precast.WS, {
        ring2="Begrudging Ring",
        })

    sets.precast.WS['Flash Nova'] = set_combine(sets.precast.WS, {
        ammo="Pemphredo Tathlum",
        head="Telchine Cap",
        body="Vedic Coat",
        hands="Fanatic Gloves",
        legs="Gyve Trousers",
        feet="Chironic Slippers",
        neck="Baetyl Pendant",
        ear1="Friomisi Earring",
        ear2="Regal Earring",
        ring1="Rufescent Ring",
        ring2="Weather. Ring +1",
        back="Toro Cape",
        waist="Refoccilation Stone",
        })

    -- Midcast Sets
    
    sets.midcast.FC = {
		main="Sucellus",
        ammo="Incantor Stone",
		head="Nahtirah Hat",
        body="Inyanga Jubbah +2",
        hands={ name="Gendewitha Gages", augments={'Phys. dmg. taken -3%','"Cure" potency +4%',}},
        legs="Ayanmo Cosciales +2",
        feet="Regal Pumps +1",
		neck="Orison Locket",
        ear1="Malignance Earring",
        ear2="Loquacious Earring",
        ring1="Kishar Ring",
		ring2="Prolix Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Channeler's Stone",
        } -- Haste
    
    -- Cure sets

    sets.midcast.CureSolace = {
        -- 10 from JP Gifts
		main={ name="Queller Rod", augments={'MP+80','"Cure" potency +15%','Enmity-5',}},
		sub="Genbu's Shield",
		ammo="Incantor Stone",
		head="Ebers Cap +1",
		body="Ebers Bliaud +1",
		hands="Inyan. Dastanas +2",
		legs="Ebers Pantaloons",
		feet={ name="Vanya Clogs", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
		neck="Cleric's Torque",
		waist="Hachirin-no-Obi",
		left_ear="Glorious Earring",
		right_ear="Nourish. Earring +1",
		left_ring="Sirona's Ring",
		right_ring="Kuchekula Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        } -- 16% Cure Potency from JP

    sets.midcast.Cure = sets.midcast.CureSolace

    sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
        main={ name="Queller Rod", augments={'MP+80','"Cure" potency +15%','Enmity-5',}}, --10
        sub="Genbu's Shield", --0/(-4)
        back="Twilight Cape", --(-6)
        waist="Hachirin-no-Obi",
        })

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        body="Theophany Briault +2", --5(+3)
        neck="Cleric's Torque",
        ring1="Sirona's Ring",
        ring2="Kuchekula Ring",
        waist="Cetl Belt",
        })

    sets.midcast.CuragaWeather = set_combine(sets.midcast.Curaga, {
        main={ name="Queller Rod", augments={'MP+80','"Cure" potency +15%','Enmity-5',}}, --10
        sub="Genbu's Shield", --0/(-4)
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Hachirin-no-Obi",
        })

    sets.midcast.CureMelee = sets.midcast.CureSolace

    sets.midcast.StatusRemoval = {
        main="Sucellus",
        sub="Genbu's Shield",
		ammo="Incantor Stone",
        head="Ebers Cap +1",
        body="Inyanga Jubbah +2",
        hands="Inyanga Dastanas +2",
        legs="Ayanmo Cosciales +2",
        feet="Regal Pumps +1",
        neck="Cleric's Torque",
		ear1="Malignance Earring",
        ear2="Loquacious Earring",
        ring1="Kishar Ring",
        ring2="Prolix Ring",
        back="Mending Cape",
        waist="Channeler's Stone",
        }
        
    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        main={ name="Queller Rod", augments={'Healing magic skill +15','"Cure" potency +10%','"Cure" spellcasting time -7%',}},
        sub="Genbu's Shield",
		ammo="Incantor Stone",
        head="Ebers Cap +1",
        hands="Ebers Mitts", --15
        legs="Theophany Pantaloons", --17
        neck="Malison Medallion", --15
        feet="Vanya Clogs", --10
        ear1="Malignance Earring",
		ear2="Loquacious Earring",
        ring1="Ephedra Ring", --15
        ring2="Ephedra Ring", --15
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}}, --25
        waist="Channeler's Stone",
        })

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {
        main="Beneficus",
        sub="Genbu's Shield",
		ammo="Incantor Stone",
        head="Telchine Cap",
        body="Telchine Chasuble",
        hands="Dynasty Mitts",
        legs="Piety Pantaloons",
        feet="Theophany Duckbills +3",
        neck="Orison Locket",
        ear1="Malignance Earring",
        ear2="Andoaa Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back="Merciful Cape",
        waist="Olympus Sash",
        }

    sets.midcast.EnhancingDuration = {
        main="Beneficus",
		sub="Genbu's Shield",
		ammo="Incantor Stone",
		head={ name="Telchine Cap", augments={'"Conserve MP"+2','Enh. Mag. eff. dur. +8',}},
		body="Inyanga Jubbah +2",
		hands="Dynasty Mitts",
		legs={ name="Telchine Braconi", augments={'"Cure" potency +6%','Enh. Mag. eff. dur. +10',}},
		feet="Theophany Duckbills +3",
		neck="Orison Locket",
		waist="Olympus Sash",
		left_ear="Malignance Earring",
		right_ear="Loquacious Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        }

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        main="Bolelabunga",
        sub="Genbu's Shield",
        head="Inyanga Tiara +2",
        body="Piety Briault",
        hands="Ebers Mitts",
        legs="Theophany Pantaloons",
		waist="Hachirin-no-Obi",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
        })
    
    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        waist="Gishdubar Sash",
        back="Grapevine Cape",
        })

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        neck="Nodens Gorget",
		ear1="Earthcry Earring",
		legs="Haven Hose",
        waist="Siegel Sash",
        })

    sets.midcast.Aquaveil = set_combine(sets.midcast['Enhancing Magic'], {
        main="Vadose Rod",
        waist="Emphatikos Rope",
		head="Chironic Hat",
        })

    sets.midcast.Auspice = set_combine(sets.midcast['Enhancing Magic'], {
        head="Telchine Cap",
        body="Telchine Chasuble",
        hands="Dynasty Mitts",
		legs="Telchine Braconi",
		feet="Ebers Duckbills",
        })

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
        main="Beneficus",
        sub="Genbu's Shield",
        head="Ebers Cap +1",
        body="Ebers Bliaud +1",
        hands="Inyanga Dastanas +2",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        legs="Piety Pantaloons",
        feet="Theophany Duckbills +3",
        })

    sets.midcast.BoostStat = set_combine(sets.midcast['Enhancing Magic'], {
        feet="Theophany Duckbills +3"
        })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
        legs="Piety Pantaloons",
		ring2="Sheltered Ring",
        })

    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.midcast['Divine Magic'] = {
        main="Kaja Rod",
        sub="Genbu's Shield",
        ammo="Hydrocera",
        head="Inyanga Tiara +2",
        body="Theophany Briault +2",
        hands="Inyanga Dastanas +2",
        legs="Inyanga Shalwar +2",
        feet="Theophany Duckbills +3",
        neck="Erra Pendant",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Eschan Stone",
        }

    sets.midcast.Banish = set_combine(sets.midcast['Divine Magic'], {
        main="Kaja Rod",
        sub="Genbu's Shield",
		ammo="Hydrocera",
        head="Inyanga Tiara +2",
        body="Inyanga Jubbah +2",
        legs="Inyanga Shalwar +2",
		feet={ name="Chironic Slippers", augments={'AGI+4','Weapon skill damage +1%','"Refresh"+2','Accuracy+10 Attack+10','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
        neck="Erra Pendant",
        ear1="Malignance Earring",
        ear2="Regal Earring",
		ring1="Stikini Ring",
        ring2="Stikini Ring",
        waist="Hachirin-no-Obi",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        })

    sets.midcast.Holy = sets.midcast.Banish

    sets.midcast['Dark Magic'] = {
        main="Kaja Rod",
        sub="Genbu's Shield",
        ammo="Hydrocera",
        head="Inyanga Tiara +2",
        body="Inyanga Jubbah +2",
        hands="Inyan. Dastanas +2",
        legs="Inyanga Shalwar +2",
        feet="Inyanga Crackows +2",
        neck="Erra Pendant",
        ear1="Hermetic Earring",
        ear2="Etiolation Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Eschan Stone",
        }

    -- Custom spell classes
    sets.midcast.MndEnfeebles = {
        main="Kaja Rod",
        sub="Genbu's Shield",
        ammo="Hydrocera",
        head="Inyanga Tiara +2",
        body="Theophany Briault +2",
        hands="Inyanga Dastanas +2",
        legs="Inyanga Shalwar +2",
        feet="Theophany Duckbills +3",
        neck="Erra Pendant",
        ear1="Malignance Earring",
        ear2="Regal Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Rumination Sash",
        }

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        main="Kaja Rod",
        ammo="Pemphredo Tathlum",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Rumination Sash",
        })

    sets.midcast.Impact = {
        main="Kaja Rod",
        sub="Genbu's Shield",
        head=empty,
        body="Twilight Cloak",
        legs="Gyve Trousers",
        ring2="Archon Ring",
        }

    -- Initializes trusts at iLvl 119
    sets.midcast.Trust = sets.precast.FC

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {
        main="Bolelabunga",
        waist="Fucho-no-obi",
        }
    
    -- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
    sets.idle = {
        main={ name="Queller Rod", augments={'MP+80','"Cure" potency +15%','Enmity-5',}},
        sub="Genbu's Shield",
        ammo="Homiliary",
        head="Inyanga Tiara +2",
        body="Theophany Briault +2",
        hands="Inyanga Dastanas +2",
        legs="Assid. Pants +1",
        feet={ name="Chironic Slippers", augments={'AGI+4','Weapon skill damage +1%','"Refresh"+2','Accuracy+10 Attack+10','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
        neck="Loricate Torque +1",
        ear1="Ethereal Earring",
        ear2="Etiolation Earring",
        ring1="Defending Ring",
        ring2="Inyanga Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Slipor Sash",
        }

    sets.idle.DT = set_combine(sets.idle, {
        main="Mafic Cudgel", --10/0
        sub="Genbu's Shield", --10/0
		ammo="Staunch Tathlum",
        head={ name="Chironic Hat", augments={'CHR+5','Pet: Mag. Acc.+3 Pet: "Mag.Atk.Bns."+3','Damage taken-5%','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}, --4/4
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ear2="Etiolation Earring",
		body="Inyanga Jubbah +2",
        hands="Inyanga Dastanas +2", --4/3
		ring1="Defending Ring",
        ring2="Inyanga Ring", --10/10
        back={ name="Alaunus's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Occ. inc. resist. to stat. ailments+10',}}, --5/5
		waist="Carrier's Sash",
		legs="Ayanmo Cosciales +2",
		feet="Inyanga Crackows +2",
        })
    
    sets.idle.Weak = sets.idle.DT
    
    -- Defense sets

    sets.defense.PDT = sets.idle.DT
    sets.defense.MDT = sets.idle.DT

    sets.Kiting = {
        feet="Herald's Gaiters"
        }

    sets.latent_refresh = {
        waist="Fucho-no-obi"
        }

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Basic set for if no TP weapon is defined.
    sets.engaged = {
        ammo="Vanir Battery",
        head="Ayanmo Zucchetto +1",
        body="Ayanmo Corazza +1",
        hands="Ayanmo Manopolas +1",
        legs="Aya. Cosciales +2",
        feet="Ayanmo Gambieras +1",
        neck="Sanctity Necklace",
        ear1="Suppanomimi",
        ear2="Brutal Earring",
        ring1="Rajas Ring",
        ring2="Ayanmo Ring",
        waist="Windbuffet Belt",
        back="Relucent Cape",
        }

    sets.engaged.DW = set_combine(sets.engaged, {
        main="Izcalli",
        sub="Sindri",
        ear1="Eabani Earring",
        waist="Shetal Stone",
        })

    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
    sets.buff['Divine Caress'] = {hands="Ebers Mitts", back="Mending Cape"}
    sets.buff['Devotion'] = {head="Piety Cap +1"}

    sets.buff.Doom = {ring1="Ephedra Ring", ring2="Ephedra Ring", waist="Gishdubar Sash"}

    sets.Obi = {waist="Hachirin-no-Obi"}
    sets.CP = {back="Aptitude Mantle"}

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    if spell.english == "Paralyna" and buffactive.Paralyzed then
        -- no gear swaps if we're paralyzed, to avoid blinking while trying to remove it.
        eventArgs.handled = true
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.name == 'Impact' then
        equip(sets.precast.FC.Impact)
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
    -- Apply Divine Caress boosting items as highest priority over other gear, if applicable.
    if spellMap == 'StatusRemoval' and buffactive['Divine Caress'] then
        equip(sets.buff['Divine Caress'])
    end
    if spell.skill == 'Healing Magic' and (world.weather_element == 'Light' or world.day_element == 'Light') then
        if spellMap == 'Cure' then
            equip(sets.midcast.CureWeather)
        elseif spellMap == 'Curaga' then
            equip(sets.midcast.CuragaWeather)
        end
    end
    if spellMap == 'Banish' or spellMap == "Holy" then
        if (world.weather_element == 'Light' or world.day_element == 'Light') then
            equip(sets.Obi)
        end
    end
    if spell.skill == 'Enhancing Magic' and classes.NoSkillSpells:contains(spell.english) then
        equip(sets.midcast.EnhancingDuration)
        if spellMap == 'Refresh' then
            equip(sets.midcast.Refresh)
        end
	end	
	if spellMap == 'Storm' then equip(sets.midcast.EnhancingDuration)	
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english == "Sleep II" then
            send_command('@timers c "Sleep II ['..spell.target.name..']" 90 down spells/00259.png')
        elseif spell.english == "Sleep" or spell.english == "Sleepga" then -- Sleep & Sleepga Countdown --
            send_command('@timers c "Sleep ['..spell.target.name..']" 60 down spells/00253.png')
        elseif spell.english == "Repose" then
            send_command('@timers c "Repose ['..spell.target.name..']" 90 down spells/00098.png')
        end 
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

function job_buff_change(buff,gain)
    if buff == "doom" then
        if gain then           
            equip(sets.buff.Doom)
            --send_command('@input /p Doomed.')
            disable('ring1','ring2','waist')
        else
            enable('ring1','ring2','waist')
            handle_equipping_gear(player.status)
        end
    end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if state.WeaponLock.value == true then
        disable('main','sub')
    else
        enable('main','sub')
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Custom spell mapping.
function job_get_spell_map(spell, default_spell_map)
    if spell.action_type == 'Magic' then
        if (default_spell_map == 'Cure' or default_spell_map == 'Curaga') and player.status == 'Engaged' then
            return "CureMelee"
        elseif default_spell_map == 'Cure' and state.Buff['Afflatus Solace'] then
            return "CureSolace"
        elseif spell.skill == "Enfeebling Magic" then
            if spell.type == "WhiteMagic" then
                return "MndEnfeebles"
            else
                return "IntEnfeebles"
            end
        end
    end
end


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
    
    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
--[[if cmdParams[1] == 'user' and not areas.Cities:contains(world.area) then
        local needsArts = 
            player.sub_job:lower() == 'sch' and
            not buffactive['Light Arts'] and
            not buffactive['Addendum: White'] and
            not buffactive['Dark Arts'] and
            not buffactive['Addendum: Black']
            
        if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
            if needsArts then
                send_command('@input /ja "Afflatus Solace" <me>;wait 1.2;input /ja "Light Arts" <me>')
            else
                send_command('@input /ja "Afflatus Solace" <me>')
            end
        end
    end--]]
    update_offense_mode()
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

function update_offense_mode()  
    if player.sub_job == 'NIN' or player.sub_job == 'DNC' then
        state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    set_macro_page(1, 4)
end

function set_lockstyle()
    send_command('wait 2; input /lockstyleset 16')
end