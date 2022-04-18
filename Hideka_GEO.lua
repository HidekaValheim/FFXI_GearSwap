
--[[
        Custom commands:
    
        Toggle Function: 
        gs c toggle melee               Toggle Melee mode on / off and locking of weapons
        gs c toggle mb                  Toggles Magic Burst Mode on / off.
        gs c toggle runspeed            Toggles locking on / off Herald's Gaiters
        gs c toggle idlemode            Toggles between Refresh and DT idle mode. Activating Sublimation JA will auto replace refresh set for sublimation set. DT set will superceed both.        
        gs c toggle regenmode           Toggles between Hybrid, Duration and Potency mode for regen set  
        gs c toggle nukemode            Toggles between Normal and Accuracy mode for midcast Nuking sets (MB included)  
        gs c toggle matchsc             Toggles auto swapping element to match the last SC that just happenned.
		
        Casting functions:
        these are to set fewer macros (2 cycle, 5 cast) to save macro space when playing lazily with controler
        
        gs c nuke cycle              	Cycles element type for nuking & SC
		gs c nuke cycledown				Cycles element type for nuking & SC	in reverse order
        gs c nuke t1                    Cast tier 1 nuke of saved element 
        gs c nuke t2                    Cast tier 2 nuke of saved element 
        gs c nuke t3                    Cast tier 3 nuke of saved element 
        gs c nuke t4                    Cast tier 4 nuke of saved element 
        gs c nuke t5                    Cast tier 5 nuke of saved element 
        gs c nuke ra1                   Cast tier 1 -ra nuke of saved element 
        gs c nuke ra2                   Cast tier 2 -ra nuke of saved element 
        gs c nuke ra3                   Cast tier 3 -ra nuke of saved element 	
		
		gs c geo geocycle				Cycles Geomancy Spell
		gs c geo geocycledown			Cycles Geomancy Spell in reverse order
		gs c geo indicycle				Cycles IndiColure Spell
		gs c geo indicycledown			Cycles IndiColure Spell in reverse order
		gs c geo geo					Cast saved Geo Spell
		gs c geo indi					Cast saved Indi Spell

        HUD Functions:
        gs c hud hide                   Toggles the Hud entirely on or off
        gs c hud hidemode               Toggles the Modes section of the HUD on or off
        gs c hud hidejob                Toggles the job section of the HUD on or off
        gs c hud hidebattle             Toggles the Battle section of the HUD on or off
        gs c hud lite                   Toggles the HUD in lightweight style for less screen estate usage. Also on ALT-END
        gs c hud keybinds               Toggles Display of the HUD keybindings (my defaults) You can change just under the binds in the Gearsets file.

        // OPTIONAL IF YOU WANT / NEED to skip the cycles...  
        gs c nuke Ice                   Set Element Type to Ice DO NOTE the Element needs a Capital letter. 
        gs c nuke Air                   Set Element Type to Air DO NOTE the Element needs a Capital letter. 
        gs c nuke Dark                  Set Element Type to Dark DO NOTE the Element needs a Capital letter. 
        gs c nuke Light                 Set Element Type to Light DO NOTE the Element needs a Capital letter. 
        gs c nuke Earth                 Set Element Type to Earth DO NOTE the Element needs a Capital letter. 
        gs c nuke Lightning             Set Element Type to Lightning DO NOTE the Element needs a Capital letter. 
        gs c nuke Water                 Set Element Type to Water DO NOTE the Element needs a Capital letter. 
        gs c nuke Fire                  Set Element Type to Fire DO NOTE the Element needs a Capital letter. 
--]]
send_command('input //send @all lua l superwarp') 
send_command('input //lua l porterpacker') 
include('organizer-lib')

organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
    NinjaTools={"Shihei"},
	Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},
}
PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

-- if PortTowns:contains(world.area) then
	-- send_command('wait 3;input //gs org') 
-- else
	-- send_command('wait 3;input //gs org') 
-- end

--------------------------------------------------------------------------------------------------------------
res = require('resources')      -- leave this as is    
texts = require('texts')        -- leave this as is    
include('Modes.lua')            -- leave this as is      
--------------------------------------------------------------------------------------------------------------

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- to define sets for regen if you add more modes, name them: sets.midcast.regen.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('normal', 'dt', 'mdt')
-- To add a new mode to nuking, you need to define both sets: sets.midcast.nuking.mynewmode as well as sets.midcast.MB.mynewmode
nukeModes = M('normal', 'acc')

-- Setting this to true will stop the text spam, and instead display modes in a UI.
-- Currently in construction.
use_UI = true
hud_x_pos = 1400    --important to update these if you have a smaller screen
hud_y_pos = 200     --important to update these if you have a smaller screen
hud_draggable = true
hud_font_size = 10
hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
hud_font = 'Impact'

-- Setup your Key Bindings here:  
    windower.send_command('bind insert gs c nuke cycle')            -- insert Cycles Nuke element
    windower.send_command('bind delete gs c nuke cycledown')        -- delete Cycles Nuke element in reverse order   
    windower.send_command('bind home gs c geo geocycle') 			-- home Cycles Geomancy Spell
    windower.send_command('bind PAGEUP gs c geo geocycledown') 		-- end Cycles Geomancy Spell in reverse order	
    windower.send_command('bind PAGEDOWN gs c geo indicycle') 		-- PgUP Cycles IndiColure Spell
    windower.send_command('bind end gs c geo indicycledown') 	    -- PgDown Cycles IndiColure Spell in reverse order	
    windower.send_command('bind !f9 gs c toggle runspeed') 			-- Alt-F9 toggles locking on / off Herald's Gaiters
	windower.send_command('bind f10 gs c toggle mb')				-- F10 toggles Magic Burst Mode on / off.
    windower.send_command('bind !f10 gs c toggle nukemode')         -- Alt-F10 to change Nuking Mode
    windower.send_command('bind ^F10 gs c toggle matchsc')          -- CTRL-F10 to change Match SC Mode         
    windower.send_command('bind f12 gs c toggle melee')				-- F12 Toggle Melee mode on / off and locking of weapons
	windower.send_command('bind f9 gs c toggle idlemode')			-- F9 Toggles between MasterRefresh or MasterDT when no luopan is out
--[[
    This gets passed in when the Keybinds is turned on.
    Each one matches to a given variable within the text object
    IF you changed the Default Keybind above, Edit the ones below so it can be reflected in the hud using "//gs c hud keybinds" command
]]																	-- or between Full Pet Regen+DT or Hybrid PetDT and MasterDT when a Luopan is out
keybinds_on = {}
keybinds_on['key_bind_idle'] = '(F9)'
keybinds_on['key_bind_regen'] = '(END)'
keybinds_on['key_bind_casting'] = '(ALT-F10)'
keybinds_on['key_bind_mburst'] = '(F10)'
keybinds_on['key_bind_matchsc'] = '(CTRL-F10)'

keybinds_on['key_bind_element_cycle'] = '(INS + DEL)'
keybinds_on['key_bind_geo_cycle'] = '(HOME + PgUP)'
keybinds_on['key_bind_indi_cycle'] = '(End + PgDOWN)'
keybinds_on['key_bind_lock_weapon'] = '(F12)'
keybinds_on['key_bind_movespeed_lock'] = '(ALT-F9)'


-- Remember to unbind your keybinds on job change.
function user_unload()
    send_command('unbind insert')
    send_command('unbind delete')
    send_command('unbind home')
    send_command('unbind PAGEUP')
    send_command('unbind PAGEDOWN')
    send_command('unbind end')
    send_command('unbind f10')
    send_command('unbind f12')
    send_command('unbind f9')
    send_command('unbind !f9')
end

--------------------------------------------------------------------------------------------------------------
include('GEO_Lib.lua')          -- leave this as is     
--------------------------------------------------------------------------------------------------------------

geomancy:set('Geo-Frailty')     -- Geo Spell Default      (when you first load lua / change jobs the saved spells is this one)
indicolure:set('Indi-Haste')    -- Indi Spell Default     (when you first load lua / change jobs the saved spells is this one)
validateTextInformation()

-- Optional. Swap to your geo macro sheet / book
set_macros(1,5) -- Sheet, Book   
send_command('wait 2;input /lockstyleset 19')   


-- Setup your Gear Sets below:
function get_sets()
  
    -- My formatting is very easy to follow. All sets that pertain to my character doing things are under 'me'.
    -- All sets that are equipped to faciliate my.pan's behaviour or abilities are under .pan', eg, Perpetuation, Blood Pacts, etc
      
    sets.me = {}        -- leave this empty
    sets.pan = {}       -- leave this empty
	sets.me.idle = {}	-- leave this empty    
	sets.pan.idle = {}	-- leave this empty 

	-- sets starting with sets.me means you DONT have a luopan currently out.
	-- sets starting with sets.pan means you DO have a luopan currently out.

    -- Your idle set when you DON'T have a luopan out
    sets.me.idle.normal = {
		main="Malignance Pole",
		sub="Kaja Grip",
		range="Dunna",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Agwu's Robe",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Loricate Torque +1",
		waist="Fucho-no-Obi",
		left_ear="Odnowa Earring +1",
		right_ear="Etiolation Earring",
		left_ring="Warden's Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
    }
	
	-- This or herald gaiters or +1 +2 +3... 
	sets.me.movespeed = {feet="Geomancy Sandals"}	
	
    -- Your idle MasterDT set (Notice the sets.me, means no Luopan is out)
    sets.me.idle.dt = set_combine(sets.me.idle.normal,{})
    sets.me.idle.mdt = set_combine(sets.me.idle.normal,{})	
    -- Your MP Recovered Whilst Resting Set
    sets.me.resting = { 

    }
	
	sets.me.latent_refresh = {waist="Fucho-no-obi"}
	
	
    -----------------------
    -- Luopan Perpetuation
    -----------------------
      
    -- Luopan's Out --  notice sets.pan 
    -- This is the base for all perpetuation scenarios, as seen below
    sets.pan.idle.normal = {
		main="Malignance Pole",
		sub="Kaja Grip",
		range="Dunna",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Agwu's Robe",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Loricate Torque +1",
		waist="Fucho-no-Obi",
		left_ear="Odnowa Earring +1",
		right_ear="Etiolation Earring",
		left_ring="Warden's Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
    }
	
	-- This is when you have a Luopan out but want to sacrifice some slot for master DT, put those slots in.
    sets.pan.idle.dt = set_combine(sets.pan.idle.normal,{})   
    sets.pan.idle.mdt = set_combine(sets.pan.idle.normal,{})   
    -- Combat Related Sets
      
    -- Melee
    -- Anything you equip here will overwrite the perpetuation/refresh in that slot.
	-- No Luopan out
	-- they end in [idleMode] so it will derive from either the normal or the dt set depending in which mode you are then add the pieces filled in below.
    sets.me.melee = set_combine(sets.me.idle[idleMode],{
		head="Jhakri Coronal +2",
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Fast Cast"+1','Enh. Mag. eff. dur. +8',}},
		feet="Jhakri Pigaches +2",
		neck="Asperity Necklace",
		waist="Goading Belt",
		left_ear="Telos Earring",
		right_ear="Brutal Earring",
		left_ring="Petrov Ring",
		right_ring="Chirich Ring",
		back={ name="Mecisto. Mantle", augments={'Cap. Point+48%','DEX+3','DEF+3',}},
    })
	
    -- Luopan is out
	sets.pan.melee = set_combine(sets.pan.idle[idleMode],{
		head="Jhakri Coronal +2",
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Fast Cast"+1','Enh. Mag. eff. dur. +8',}},
		feet="Jhakri Pigaches +2",
		neck="Asperity Necklace",
		waist="Goading Belt",
		left_ear="Telos Earring",
		right_ear="Brutal Earring",
		left_ring="Petrov Ring",
		right_ring="Chirich Ring",
		back={ name="Mecisto. Mantle", augments={'Cap. Point+48%','DEX+3','DEF+3',}},
    }) 
    
    -- Weapon Skill sets
	-- Example:
    sets.me["Flash Nova"] = {
		main="Kaja Rod",
		sub="Genbu's Shield",
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Jhakri Cuffs +2",
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet="Jhakri Pigaches +2",
		neck="Saevus Pendant +1",
		waist="Refoccilation Stone",
		left_ear="Malignance Earring",
		right_ear="Barkaro. Earring",
		left_ring="Freke Ring",
		right_ring="Shiva Ring +1",
		back="Toro Cape",
    }

    sets.me["Realmrazer"] = {
		main="Kaja Rod",
		sub="Genbu's Shield",
		range="Dunna",
		head="Jhakri Coronal +2",
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs="Jhakri Slops +2",
		feet="Jhakri Pigaches +2",
		neck="Caro Necklace",
		waist="Luminary Sash",
		left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		right_ear="Malignance Earring",
		left_ring="Shukuyu Ring",
		right_ring="Rufescent Ring",
		back="Potentia Cape",
    }
	
    sets.me["Black Halo"] = {
		head="Jhakri Coronal +2",
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs="Jhakri Slops +2",
		feet="Jhakri Pigaches +2",
		neck="Asperity Necklace",
		waist="Luminary Sash",
		left_ear="Malignance Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Levia. Ring",
		right_ring="Shukuyu Ring",
		back={ name="Mecisto. Mantle", augments={'Cap. Point+48%','DEX+3','DEF+3',}},
    } 
    -- Feel free to add new weapon skills, make sure you spell it the same as in game.
  
    ---------------
    -- Casting Sets
    ---------------
      
    sets.precast = {}               -- leave this empty    
    sets.midcast = {}               -- leave this empty    
    sets.aftercast = {}             -- leave this empty    
    sets.midcast.nuking = {}        -- leave this empty
    sets.midcast.MB = {}            -- leave this empty    
    ----------
    -- Precast
    ----------
      
    -- Generic Casting Set that all others take off of. Here you should add all your fast cast  
    sets.precast.casting = {
		main="C. Palug Hammer",
		sub="Culminus",
		range="Dunna",
		head="Agwu's Cap",
		body="Agwu's Robe",
		hands="Agwu's Gages",
		legs="Agwu's Slops",
		feet="Agwu's Pigaches",
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Tuisto Earring",
		right_ear="Malignance Earring",
		left_ring="Kishar Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
	}   

    sets.precast.geomancy = set_combine(sets.precast.casting,{})
    -- Enhancing Magic, eg. Siegal Sash, etc
    sets.precast.enhancing = set_combine(sets.precast.casting,{})
  
    -- Stoneskin casting time -, works off of enhancing -
    sets.precast.stoneskin = set_combine(sets.precast.enhancing,{})
      
    -- Curing Precast, Cure Spell Casting time -
    sets.precast.cure = set_combine(sets.precast.casting,{

	})
    sets.precast.regen = set_combine(sets.precast.casting,{

    })     
    ---------------------
    -- Ability Precasting
    ---------------------
	
	-- Fill up with your JSE! 
    sets.precast["Life Cycle"]			 = {body = "Geomancy Tunic +1"}
    sets.precast["Bolster"] 			 = {body = "Bagua Tunic"}
    sets.precast["Primeval Zeal"] 		 = {head = "Bagua Galero"}  
    sets.precast["Cardinal Chant"] 		 = {head = "Geomancy Galero +1"}  
    sets.precast["Full Circle"] 		 = {head = "Azimuth Hood +1"}  
    sets.precast["Curative Recantation"] = {hands = "Bagua Mitaines"}  
    sets.precast["Mending Halation"] 	 = {legs = "Bagua Pants"}
    sets.precast["Radial Arcana"] 		 = {feet = "Bagua Sandals"}

    ----------
    -- Midcast
    ----------
            
    -- Whatever you want to equip mid-cast as a catch all for all spells, and we'll overwrite later for individual spells
    sets.midcast.casting = {
		main="C. Palug Hammer",
		sub="Culminus",
		range="Dunna",
		head="Agwu's Cap",
		body="Agwu's Robe",
		hands="Agwu's Gages",
		legs="Agwu's Slops",
		feet="Agwu's Pigaches",
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Tuisto Earring",
		right_ear="Malignance Earring",
		left_ring="Kishar Ring",
		right_ring="Defending Ring",
		back="Moonbeam Cape",
    }
	
	-- For Geo spells /
    sets.midcast.geo = set_combine(sets.midcast.casting,{
		head="Azimuth Hood +1",
		body={ name="Bagua Tunic", augments={'Enhances "Bolster" effect',}},
		hands="Geo. Mitaines +1",
		legs={ name="Bagua Pants", augments={'Enhances "Mending Halation" effect',}},
		feet="Azimuth Gaiters",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Lifestream Cape", augments={'Geomancy Skill +9','Indi. eff. dur. +17','Pet: Damage taken -3%',}},
	})
	-- For Indi Spells
		sets.midcast.indi = set_combine(sets.midcast.geo,{
		
		})

	sets.midcast.Obi = {
	    waist="Hachirin-no-Obi",
	}
	
	-- Nuking
    sets.midcast.nuking.normal = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Ghastly Tathlum +1",
		head="C. Palug Crown",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Baetyl Pendant",
		waist="Refoccilation Stone",
		left_ear="Malignance Earring",
		right_ear="Barkaro. Earring",
		left_ring="Freke Ring",
		right_ring="Metamorph Ring +1",
		back="Toro Cape",
	}
	sets.midcast.MB.normal = set_combine(sets.midcast.nuking.normal, {
		neck="Mizu. Kubikazari",
		right_ring="Mujin Band",
	})
    sets.midcast.nuking.acc = set_combine(sets.midcast.nuking.normal,{

    })
    sets.midcast.MB.acc = set_combine(sets.midcast.MB.normal, {

    })

	-- Enfeebling
	sets.midcast.IntEnfeebling = set_combine(sets.midcast.casting,{
		main={ name="Grioavolr", augments={'Enfb.mag. skill +13','MND+8','Mag. Acc.+23','Magic Damage +1',}},
		sub="Mephitis Grip",
		ammo="Pemphredo Tathlum",
		head="Befouled Crown",
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs="Psycloth Lappas",
		feet={ name="Bagua Sandals", augments={'Enhances "Radial Arcana" effect',}},
		neck="Incanter's Torque",
		waist="Channeler's Stone",
		left_ear="Barkaro. Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back="Moonbeam Cape",
    })
	sets.midcast.MndEnfeebling = set_combine(sets.midcast.casting,{
    main={ name="Grioavolr", augments={'Enfb.mag. skill +13','MND+8','Mag. Acc.+23','Magic Damage +1',}},
		sub="Mephitis Grip",
		ammo="Pemphredo Tathlum",
		head="Befouled Crown",
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs="Psycloth Lappas",
		feet={ name="Bagua Sandals", augments={'Enhances "Radial Arcana" effect',}},
		neck="Incanter's Torque",
		waist="Luminary Sash",
		left_ear="Andoaa Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back="Moonbeam Cape",
    })
	
    -- Enhancing
    sets.midcast.enhancing = set_combine(sets.midcast.casting,{
		main="Malignance Pole",
		sub="Enki Strap",
		head="Befouled Crown",
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5',}},
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Fast Cast"+1','Enh. Mag. eff. dur. +8',}},
		neck="Incanter's Torque",
		waist="Olympus Sash",
		left_ear="Andoaa Earring",
		back="Moonbeam Cape",
    })
	
    -- Stoneskin
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing,{
		left_ear = "Earthcry Earring"
    })
    sets.midcast.refresh = set_combine(sets.midcast.enhancing,{
		waist = "Gishdubar Sash"
    })
    sets.midcast.aquaveil = sets.midcast.refresh
	
	sets.midcast["Drain"] = set_combine(sets.midcast.IntEnfeebling, {
		main={ name="Rubicundity", augments={'Mag. Acc.+9','"Mag.Atk.Bns."+8','Dark magic skill +9','"Conserve MP"+5',}},
		sub="Sors Shield",
		ammo="Pemphredo Tathlum",
		head={ name="Bagua Galero", augments={'Enhances "Primeval Zeal" effect',}},
		body="Geo. Tunic +1",
		hands="Jhakri Cuffs +2",
		legs="Azimuth Tights",
		feet={ name="Merlinic Crackows", augments={'DEX+8','Crit. hit damage +1%','"Refresh"+1','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck="Incanter's Torque",
		waist="Fucho-no-Obi",
		left_ear="Hirudinea Earring",
		right_ear="Etiolation Earring",
		left_ring="Evanescence Ring",
		right_ring="Meridian Ring",
		back="Moonbeam Cape",
	})
	
	sets.midcast["Stun"] ={
		main={ name="Rubicundity", augments={'Mag. Acc.+9','"Mag.Atk.Bns."+8','Dark magic skill +9','"Conserve MP"+5',}},
		sub="Genbu's Shield",
		range="Dunna",
		head="Jhakri Coronal +2",
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic burst dmg.+10%','Mag. Acc.+3','"Mag.Atk.Bns."+7',}},
		feet="Jhakri Pigaches +2",
		neck="Sanctity Necklace",
		waist="Refoccilation Stone",
		left_ear="Barkaro. Earring",
		right_ear="Malignance Earring",
		left_ring="Vertigo Ring",
		right_ring="Evanescence Ring",
		back="Merciful Cape",
	}
	sets.midcast["Aspir"] = sets.midcast["Drain"]
     
    sets.midcast.cure = {} -- Leave This Empty
    -- Cure Potency
    sets.midcast.cure.normal = set_combine(sets.midcast.casting,{
		main={ name="Divinity", augments={'Attack+5','Accuracy+7','DMG:+8',}},
		sub="Genbu's Shield",
		ammo="Staunch Tathlum",
		head={ name="Vanya Hood", augments={'MP+49','"Cure" potency +7%','Enmity-5',}},
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Telchine Gloves", augments={'"Conserve MP"+1',}},
		legs="Geomancy Pants",
		feet={ name="Vanya Clogs", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
		neck="Phalaina Locket",
		waist="Gishdubar Sash",
		left_ear="Gifted Earring",
		right_ear="Etiolation Earring",
		left_ring="Vocane Ring",
		right_ring="Meridian Ring",
		back="Moonbeam Cape",
    })
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{

    })    
    sets.midcast.regen = set_combine(sets.midcast.enhancing,{
		main="Bolelabunga",
		sub="Sors Shield",
		ammo="Staunch Tathlum",
		head={ name="Telchine Cap", augments={'Enh. Mag. eff. dur. +7',}},
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5',}},
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Fast Cast"+1','Enh. Mag. eff. dur. +8',}},
	}) 
   
    ------------
    -- Aftercast
    ------------
      
    -- I don't use aftercast sets, as we handle what to equip later depending on conditions using a function, eg, do we have a Luopan pan out?
  
end