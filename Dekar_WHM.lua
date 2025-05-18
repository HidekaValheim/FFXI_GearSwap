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
	state.AfflatusMode=M{['description']='Solace', 'Misery'}
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
        sub="Genbu's Shield", --3
        ammo="Incantor stone", --2
		head="Nahtirah Hat", --10
        body="Inyanga Jubbah +2", --13
        hands="Gendewitha Gages", --7
        legs="Ayanmo Cosciales +2", --6
        feet="Regal Pumps +1", --7
        neck="Cleric's Torque +2", --5
        ear1="Etiolation Earring", --2
        ear2="Enchntr. Earring +1", --2
        ring1="Kishar Ring", --4
        ring2="Prolix Ring", --5
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}}, --10
        waist="Luminary Sash", --3/(2)
        }
        
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Siegel Sash",
        })

    sets.precast.FC['Healing Magic'] = set_combine(sets.precast.FC, {
        sub="Genbu's Shield",
        head="Nahtirah Hat",
        legs="Ebers Pantaloons +1",       
        })

    sets.precast.FC.StatusRemoval = sets.precast.FC['Healing Magic']

    sets.precast.FC.Cure = set_combine(sets.precast.FC['Healing Magic'], {
        sub="Genbu's Shield",
        ammo="Incantor stone",
        head="Nahtirah Hat", --13
		neck="Cleric's Torque +2",
		body="Inyanga Jubbah +2",
		hands="Gendewitha Gages",
		legs="Ebers Pantaloons +1",
		feet="Vanya Clogs",
        ear1="Medicant's Earring", --4
        ear2="Nourishing Earring +1", --5
        ring1="Kishar Ring",--(2)
        ring2="Prolix Ring",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}}, --(4)
        })

    sets.precast.FC.Curaga = sets.precast.FC.Cure
    sets.precast.FC.CureSolace = sets.precast.FC.Cure
    sets.precast.FC.Impact = set_combine(sets.precast.FC, {head=empty, body="Twilight Cloak"})
	
	sets.precast.FC.Dia = set_combine(sets.precast.FC,{})

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
        head="Nahtirah Hat",
        body="Inyanga Jubbah +2",
        hands="Gendewitha Gages",
        legs="Ayanmo Cosciales +2",
        feet="Regal Pumps +1",
		neck="Cleric's Torque +2",
        ear1="Etiolation Earring",
        ear2="Loquacious Earring",
        ring1="Kishar Ring",
		ring2="Prolix Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Cetl Belt",
		ammo="Incantor Stone",
        } -- Haste
    
    -- Cure sets

    sets.midcast.CureSolace = {
        -- 10 from JP Gifts
        main="Queller Rod", --15(+2)/(-15)
        sub="Genbu's Shield", --3/(-5)
        ammo="Incantor Stone", --0/(-5)
        head="Kaykaus Mitra +1", --15/(-8)
        body="Ebers Bliaud +1",
        hands="Theophany Mitts +3", --(+4)/(-7)
        legs="Ebers Pantaloons +1",
        feet="Kaykaus Boots +1", --10/(-10)
        neck="Cleric's Torque +2",
        ear1="Glorious Earring", --7
        ear2="Nourishing Earring +1", -- (+2)/(-5)
        ring1="Janniston Ring", --3/(-5)
        ring2="Lebeche Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','MND+10','"Fast Cast"+10',}},
        waist="Hachirin-no-Obi",
        } -- 16% Cure Potency from JP

    sets.midcast.Cure = sets.midcast.CureSolace

    sets.midcast.CureWeather = set_combine(sets.midcast.Cure, {
        waist="Hachirin-no-Obi",
        })

    sets.midcast.Curaga = set_combine(sets.midcast.Cure, {
        body="Theophany Briault +3", --5(+3)
        neck="Cleric's Torque +2",
        ring1="Janniston Ring",
        ring2="Lebeche Ring",
        waist="Luminary Sash",
        })

    sets.midcast.CuragaWeather = set_combine(sets.midcast.Curaga, {
        back="Twilight Cape",
        waist="Hachirin-no-Obi",
        })
	
	sets.midcast.Cura = {
		main="Asclepius",
		sub="Genbu's Shield",
		ammo="Incantor Stone", --0/(-5)
        head="Kaykaus Mitra +1", --15/(-8)
        body="Theophany Briault +3",
        hands="Theophany Mitts +3", --(+4)/(-7)
        legs="Ebers Pantaloons +1",
        feet="Kaykaus Boots +1", --10/(-10)
        neck="Cleric's Torque +2",
        ear1="Glorious Earring", --7
        ear2="Nourishing Earring +1", -- (+2)/(-5)
        ring1="Janniston Ring", --3/(-5)
        ring2="Lebeche Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','MND+10','"Fast Cast"+10',}},
        waist="Hachirin-no-Obi",	
		}
		
	sets.midcast['Cura II'] = sets.midcast.Cura
	sets.midcast['Cura III'] = sets.midcast.Cura
	
	sets.midcast['Dia'] = set_combine(sets.midcast.MndEnfeebles,{
		legs={ name="Chironic Hose", augments={'Crit.hit rate+2','Pet: Attack+28 Pet: Rng.Atk.+28','"Treasure Hunter"+2','Accuracy+17 Attack+17','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		feet={ name="Chironic Slippers", augments={'DEX+4','AGI+5','"Treasure Hunter"+2','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
        })

	sets.midcast['Dia II'] = set_combine(sets.midcast.MndEnfeebles,{
		legs={ name="Chironic Hose", augments={'Crit.hit rate+2','Pet: Attack+28 Pet: Rng.Atk.+28','"Treasure Hunter"+2','Accuracy+17 Attack+17','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		feet={ name="Chironic Slippers", augments={'DEX+4','AGI+5','"Treasure Hunter"+2','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
        })		
	
	sets.midcast.CuraWeather = set_combine(sets.midcast.Cura, {
        back="Twilight Cape",
        waist="Hachirin-no-Obi",
        })
	
	sets.midcast.Esuna = {
		main="Asclepius",
		sub="Genbu's Shield",
		ammo="Incantor Stone",
		head="Nahtirah Hat",
        body="Inyanga Jubbah +2",
        hands="Gendewitha Gages",
        legs="Ayanmo Cosciales +2",
        feet="Regal Pumps +1",
		neck="Cleric's Torque +2",
        ear1="Etiolation Earring",
        ear2="Magnetic Earring",
        ring1="Kishar Ring",
		ring2="Prolix Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Cetl Belt",	
	}
	
    sets.midcast.CureMelee = sets.midcast.CureSolace

    sets.midcast.StatusRemoval = {
        main="Asclepius",
        sub="Genbu's Shield",
        head="Ebers Cap",
        body="Ebers Bliaud +1",
        hands="Ebers Mitts +1",
        legs="Ebers Pantaloons +1",
        feet="Vanya Clogs",
        neck="Cleric's Torque +2",
		ear1="Gifted Earring",
        ear2="Magnetic Earring",
        ring1="Ephedra Ring",
        ring2="Ephedra Ring",
        back="Mending Cape",
        waist="Cetl Belt",
        }
        
    sets.midcast.Cursna = set_combine(sets.midcast.StatusRemoval, {
        main="Beneficus",
        sub="Genbu's Shield",
        head="Ebers Cap",
        hands="Fanatic Gloves", --15
        legs="Theophany Pantaloons", --17
        neck="Malison Medallion", --15
        feet="Vanya Clogs", --10
        ear1="Beatific Earring",
		ear2="Healing Earring",
        ring1="Ephedra Ring", --15
        ring2="Ephedra Ring", --15
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}}, --25
        waist="Gishbudar Sash",
        })

    -- 110 total Enhancing Magic Skill; caps even without Light Arts
    sets.midcast['Enhancing Magic'] = {
        main="Gada",
        sub="Ammurapi Shield",
        head="Telchine Cap",
        body="Telchine Chasuble",
        hands="Telchine Gloves",
        legs="Piety Pantaloons",
        feet="Ebers Duckbills",
        neck="Colossus's Torque",
        ear1="Magnetic Earring",
        ear2="Andoaa Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Cascade Belt",
        }

    sets.midcast.EnhancingDuration = {
        main="Gada",
        sub="Ammurapi Shield",
        head="Telchine Cap",
        body="Telchine Chasuble",
        hands="Telchine Gloves",
        legs="Ayanmo Cosciales +2",
        feet="Inyanga Crackows +2",
		waist="Hachirin-no-Obi",
        }

    sets.midcast.Regen = set_combine(sets.midcast.EnhancingDuration, {
        main="Bolelabunga",
        sub="Ammurapi Shield",
        head="Inyanga Tiara +2",
        body="Piety Briault",
        hands="Ebers Mitts +1",
        legs="Theophany Pantaloons",
		waist="Hachirin-no-Obi",
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
        })

    sets.midcast.Auspice = set_combine(sets.midcast['Enhancing Magic'], {
        head="Telchine Cap",
        body="Telchine Chasuble",
        hands="Telchine Gloves",
		feet="Ebers Duckbills",
        })

    sets.midcast.BarElement = set_combine(sets.midcast['Enhancing Magic'], {
        main="Beneficus",
        sub="Ammurapi Shield",
        head="Ebers Cap",
        body="Ebers Bliaud +1",
        hands="Ebers Mitts +1",
		back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
        legs="Piety Pantaloons",
        feet="Ebers Duckbills",
        })

    sets.midcast.BoostStat = set_combine(sets.midcast['Enhancing Magic'], {
        feet="Ebers Duckbills"
        })

    sets.midcast.Protect = set_combine(sets.midcast.EnhancingDuration, {
        legs="Piety Pantaloons",
		ring2="Sheltered Ring",
        })

    sets.midcast.Protectra = sets.midcast.Protect
    sets.midcast.Shell = sets.midcast.Protect
    sets.midcast.Shellra = sets.midcast.Protect

    sets.midcast['Divine Magic'] = {
        main="Asclepius",
        sub="Ammurapi Shield",
        ammo="Incantor Stone",
        head="Inyanga Tiara +2",
        body="Inyanga Jubbah +2",
        hands="Inyanga Dastanas +2",
        legs="Inyanga Shalwar +2",
        feet="Inyanga Crackows +2",
        neck="Sanctity Necklace",
        ear1="Dignitary's Earring",
        ear2="Gwati Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Luminary Sash",
        }

    sets.midcast.Banish = set_combine(sets.midcast['Divine Magic'], {
        main="Asclepius",
        sub="Ammurapi Shield",
        head="Inyanga Tiara +2",
        body="Inyanga Jubbah +2",
        legs="Inyanga Shalwar +2",
        neck="Sanctity Necklace",
        ear1="Dignitary's Earring",
        ear2="Gwati Earring",
		ring1="Stikini Ring",
        ring2="Stikini Ring",
        waist="Luminary Sash",
        })

    sets.midcast.Holy = sets.midcast.Banish

    sets.midcast['Dark Magic'] = {
        main="Asclepius",
        sub="Ammurapi Shield",
        ammo="Pemphredo Tathlum",
        head="Befouled Crown",
        body="Shango Robe",
        hands="Inyan. Dastanas +2",
        legs="Chironic Hose",
        feet="Medium's Sabots",
        neck="Erra Pendant",
        ear1="Hermetic Earring",
        ear2="Regal Earring",
        ring1="Evanescence Ring",
        ring2="Stikini Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Yamabuki-no-Obi",
        }

    -- Custom spell classes
    sets.midcast.MndEnfeebles = {
        main="Asclepius",
        sub="Ammurapi Shield",
        ammo="Incantor Stone",
        head="Inyanga Tiara +2",
        body="Theophany Briault +3",
        hands="Inyanga Dastanas +2",
        legs="Inyanga Shalwar +2",
        feet="Inyanga Crackows +2",
        neck="Sanctity Necklace",
        ear1="Dignitary's Earring",
        ear2="Regal Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Luminary Sash",
        }

    sets.midcast.IntEnfeebles = set_combine(sets.midcast.MndEnfeebles, {
        main="Asclepius",
        ammo="Pemphredo Tathlum",
        back={ name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Damage taken-5%',}},
        waist="Yamabuki-no-Obi",
        })

    sets.midcast.Impact = {
        main="Asclepius",
        sub="Ammurapi Shield",
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
        main="Bolelabunga",
        sub="Genmei Shield",
        ammo="Homiliary",
        head="Befouled Crown",
        body="Shamash Robe",
        hands="Chironic Gloves",
        legs="Assid. Pants +1",
        feet="Herald's Gaiters",
        neck="Loricate Torque +1",
        ear1="Infused Earring",
        ear2="Genmei Earring",
        ring1="Defending Ring",
        ring2="Paguroidea Ring",
        back="Moonlight Cape",
        waist="Fucho-no-obi",
		ammo="Homiliary",
        }

    sets.idle.DT = set_combine(sets.idle, {
        main="Asclepius", --10/0
        sub="Genmei Shield", --10/0
        head="Inyanga Tiara +2", --4/4
		neck="Warder's Charm +1",
		ear1="Etiolation Earring",
		ear2="Genmei Earring",
		body="Shamash Robe",
        hands="Inyanga Dastanas +2", --4/3
		ring1="Defending Ring",
        ring2="Inyanga Ring", --10/10
        back={ name="Alaunus's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Occ. inc. resist. to stat. ailments+10',}}, --5/5
		waist="Carrier's Sash",
		legs="Inyanga Shalwar +2",
		feet="Inyanga Crackows +2",
		ammo="Staunch Tathlum +1",
        })
		
	sets.idle.Solace =  set_combine(sets.idle, {
        main="Asclepius", --10/0
        sub="Genmei Shield", --10/0
        head="Inyanga Tiara +2", --4/4
		neck="Warder's Charm +1",
		ear1="Etiolation Earring",
		ear2="Genmei Earring",
		body="Shamash Robe",
        hands="Inyanga Dastanas +2", --4/3
		ring1="Defending Ring",
        ring2="Inyanga Ring", --10/10
        back={ name="Alaunus's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Occ. inc. resist. to stat. ailments+10',}}, --5/5
		waist="Carrier's Sash",
		legs="Inyanga Shalwar +2",
		feet="Inyanga Crackows +2",
		ammo="Staunch Tathlum +1",
        })

	sets.idle.Misery =  set_combine(sets.idle, {
        main="Asclepius", --10/0
        sub="Genbu's Shield",
        })
		
    sets.idle.Misery.DT =  set_combine(sets.idle.Solace, {
        main="Asclepius",
		sub={ name="Genbu's Shield", augments={'"Cure" potency +3%','"Cure" spellcasting time -2%',}},
		ammo="Homiliary",
		head={ name="Chironic Hat", augments={'CHR+6','Pet: Mag. Acc.+6','"Refresh"+1','Accuracy+3 Attack+3','Mag. Acc.+12 "Mag.Atk.Bns."+12',}},
		body="Shamash Robe",
		hands={ name="Chironic Gloves", augments={'"Store TP"+1','Mag. Acc.+11 "Mag.Atk.Bns."+11','"Refresh"+2','Accuracy+12 Attack+12',}},
		legs="Aya. Cosciales +2",
		feet={ name="Chironic Slippers", augments={'Damage taken-1%','Crit.hit rate+1','"Refresh"+1','Accuracy+10 Attack+10',}},
		neck="Loricate Torque +1",
		waist="Slipor Sash",
		left_ear="Etiolation Earring",
		right_ear="Infused Earring",
		left_ring="Defending Ring",
		right_ring="Paguroidea Ring",
		back="Moonlight Cape",
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
        main="Sindri",
        sub="Genbu's Shield",
        ammo="Vanir Battery",
        head="Ayanmo Zucchetto +2",
        body="Ayanmo Corazza +2",
        hands="Ayanmo Manopolas +2",
        legs="Aya. Cosciales +2",
        feet="Ayanmo Gambieras +2",
        neck="Sanctity Necklace",
        ear1="Steelflash Earring",
        ear2="Brutal Earring",
        ring1="Mars's Ring",
        ring2="Rajas Ring",
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
    sets.buff['Divine Caress'] = {hands="Ebers Mitts +1", back="Mending Cape"}
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
        if spellMap == 'Cure' or spellMap == "CureSolace" then
            equip(sets.midcast.CureWeather)
		elseif spell.english == 'Cura' or spell.english == 'Cura II' or spell.english == 'Cura III' then
			equip(sets.midcast.CuraWeather)
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

function job_buff_change(buff, gain)
	if buff == 'Afflatus Solace' and gain then
		state.AfflatusMode.current = 'Solace'
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	elseif buff == 'Afflatus Misery' and gain then
		state.AfflatusMode.current = 'Misery'
		if not midaction() then
			handle_equipping_gear(player.status)
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
	if state.IdleMode.current == 'Normal' then
		if state.AfflatusMode.current == 'Solace' or buffactive['Afflatus Solace'] then
			idleSet = sets.idle
		elseif state.AfflatusMode.current == 'Misery' or buffactive['Afflatus Misery'] then
			idleSet = sets.idle.Misery
		end
	end
	if state.IdleMode.current == 'DT' then
		if state.AfflatusMode.current == 'Solace' or buffactive['Afflatus Solace'] then
			idleSet = sets.idle.Solace
		elseif state.AfflatusMode.current == 'Misery' or buffactive['Afflatus Misery'] then
			idleSet = sets.idle.Misery.DT
		end
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
    send_command('wait 2; input /lockstyleset 11')
end