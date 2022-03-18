-------------------------------------------------------------                                        
--                              
--      ,---.     |    o               
--      |   |,---.|--- .,---.,---.,---.
--      |   ||   ||    ||   ||   |`---.
--      `---'|---'`---'``---'`   '`---'
--           |                         
-------------------------------------------------------------  

include('organizer-lib') -- Can remove this if you dont use organizer
res = require('resources')
texts = require('texts')
include('Modes.lua')
send_command('input //send @all lua l superwarp') 
send_command('input //lua l porterpacker') 


organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
    NinjaTools={"Shihei"},
	Food={"Grape Daifuku","Rolanberry Daifuku","Miso Ramen"},
}
PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

-- if PortTowns:contains(world.area) then
	-- send_command('wait 3;input //gs org') 
-- else
	-- send_command('wait 3;input //gs org') 
-- end
-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- to define sets for regen if you add more modes, name them: sets.midcast.regen.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('Refresh', 'Slow_R', 'Sphere_R','DT','Slow_DT','Sphere_DT' , 'Crisis')
regenModes = M('hybrid', 'duration', 'potency')
-- To add a new mode to nuking, you need to define both sets: sets.midcast.nuking.mynewmode as well as sets.midcast.MB.mynewmode
nukeModes = M('normal', 'acc', 'Seidr')

-- Setting this to true will stop the text spam, and instead display modes in a UI.
-- Currently in construction.
use_UI = true
hud_x_pos = 1560    --important to update these if you have a smaller screen
hud_y_pos = 300     --important to update these if you have a smaller screen
hud_draggable = true
hud_font_size = 8
hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
hud_font = 'Impact'


-- Setup your Key Bindings here:
    windower.send_command('bind insert gs c nuke cycle')        -- insert to Cycles Nuke element
    windower.send_command('bind delete gs c nuke cycledown')    -- delete to Cycles Nuke element in reverse order   
    windower.send_command('bind f9 gs c toggle idlemode')       -- F9 to change Idle Mode    
    windower.send_command('bind !f9 gs c toggle runspeed') 		-- Alt-F9 toggles locking on / off Herald's Gaiters
    windower.send_command('bind f12 gs c toggle melee')			-- F12 Toggle Melee mode on / off and locking of weapons
    windower.send_command('bind !` input /ja "Dark Arts" <me>') -- Alt-` DARK ARTS.
    windower.send_command('bind home gs c sc tier')				-- home to change SC tier between Level 1 or Level 2 SC
    windower.send_command('bind end gs c toggle regenmode')		-- end to change Regen Mode	
    windower.send_command('bind f10 gs c toggle mb')            -- F10 toggles Magic Burst Mode on / off.
    windower.send_command('bind !f10 gs c toggle nukemode')		-- Alt-F10 to change Nuking Mode
    windower.send_command('bind ^F10 gs c toggle matchsc')      -- CTRL-F10 to change Match SC Mode      	
    windower.send_command('bind !end gs c hud lite')            -- Alt-End to toggle light hud version
	windower.send_command('bind ^- input /ma "Protect V" <t>')
	windower.send_command('bind ^= input /ma "Shell V" <t>')
	windower.send_command('bind ^` input /ja "Light Arts" <me>') --Alt` LIGHT ARTS.	
	windower.send_command('bind ^[ input /ja "Accession" <me>')
    windower.send_command('bind ^] input /ja "Perpetuance" <me>')
	windower.send_command('bind ^\\\\ input /ja "Rapture" <me>')
	windower.send_command('bind ^numpad0 gs c toggle MinimumDamage')	
	windower.send_command('lua l partybuffs')
	windower.send_command('lua l sch-hud')


--[[
    This gets passed in when the Keybinds is turned on.
    Each one matches to a given variable within the text object
    IF you changed the Default Keybind above, Edit the ones below so it can be reflected in the hud using "//gs c hud keybinds" command
]]
keybinds_on = {}
keybinds_on['key_bind_idle'] = '(F9)'
keybinds_on['key_bind_regen'] = '(END)'
keybinds_on['key_bind_casting'] = '(ALT-F10)'
keybinds_on['key_bind_mburst'] = '(F10)'

keybinds_on['key_bind_element_cycle'] = '(INSERT)'
keybinds_on['key_bind_sc_level'] = '(HOME)'
keybinds_on['key_bind_lock_weapon'] = '(F12)'
keybinds_on['key_bind_movespeed_lock'] = '(ALT-F9)'
keybinds_on['key_bind_matchsc'] = '(CTRL-F10)'

-- Remember to unbind your keybinds on job change.
function user_unload()
    send_command('unbind insert')
    send_command('unbind delete')	
    send_command('unbind f9')
    send_command('unbind f10')
    send_command('unbind f12')
    send_command('unbind !`')
    send_command('unbind home')
    send_command('unbind end')
    send_command('unbind !f10')	
    send_command('unbind `f10')
    send_command('unbind !f9')	
    send_command('unbind !end')
	send_command('unbind ^-')
	send_command('unbind ^=')
	send_command('unbind ^`')
	send_command('unbind ^[')
    send_command('unbind ^]')	
	send_command('unbind ^\\\\')
	send_command('unbind !q')
	send_command('unbind !a')
	send_command('unbind ^numpad0')
	windower.send_command('lua u sch-hud')

end

--------------------------------------------------------------------------------------------------------------
include('SCH_Lib.lua')          -- leave this as is    
refreshType = idleModes[1]      -- leave this as is     
--------------------------------------------------------------------------------------------------------------


-- Optional. Swap to your sch macro sheet / book
set_macros(1,17) -- Sheet, Book
send_command('wait 10;input /lockstyleset 6')


-------------------------------------------------------------                                        
--      ,---.                         |         
--      |  _.,---.,---.,---.,---.,---.|--- ,---.
--      |   ||---',---||    `---.|---'|    `---.
--      `---'`---'`---^`    `---'`---'`---'`---'
-------------------------------------------------------------                                              

-- Setup your Gear Sets below:
function get_sets()

	af={}
		af.head = "Acad. Mortar. +3"
		af.body = "Acad. Gown +2"
		af.hand = "Acad. Bracers +2"
		af.legs = "Acad. Pants +2"
		af.feet = "Acad. Loafers +2"
		
	rl={}
		rl.head = "Peda. M.Board +3"
		rl.body = "Peda. Gown +3"
		rl.hand = "Peda. Bracers +3"
		rl.legs = "Peda. Pants +3"
		rl.feet = "Peda. Loafers +3"
		
	em={}
		em.head = "Arbatel Bonnet +1"
		em.body = "Arbatel Gown +1"
		em.hand = "Arbatel Bracers +1"
		em.legs = "Arbatel Pants +1"
		em.feet = "Arbatel Loafers +1"
	
    -- My formatting is very easy to follow. All sets that pertain to my character doing things are under 'me'.
    -- All sets that are equipped to faciliate my avatar's behaviour or abilities are under 'avatar', eg, Perpetuation, Blood Pacts, etc
    
    sets.me = {}        		-- leave this empty
    sets.buff = {} 				-- leave this empty
    sets.me.idle = {}			-- leave this empty
	sets.movement={feet="Herald's Gaiters"}
	sets.sublimationgear={		
		head= af.head,
		body= rl.body,
		waist="Embla Sash",
	}
    -- Your idle set
    sets.me.idle.Refresh = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Homiliary",
		head="Befouled Crown",
		body="Agwu's Robe",
		hands={ name="Chironic Gloves", augments={'Pet: Haste+3','Rng.Atk.+16','"Refresh"+1','Accuracy+2 Attack+2',}},
		legs="Assid. Pants +1",
		feet={ name="Merlinic Crackows", augments={'DEX+8','Crit. hit damage +1%','"Refresh"+1','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Fucho-no-Obi",
		left_ear="Etiolation Earring",
		right_ear="Eabani Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		--back={ name="Mecisto. Mantle", augments={'Cap. Point+48%','DEX+3','DEF+3',}},
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }
	sets.me.idle.Refresh.sublimation=set_combine(sets.me.idle.Refresh,sets.sublimationgear,{})
    -- Your idle DT set
    sets.me.idle.DT = set_combine(sets.me.idle.Refresh,{
		main="Malignance Pole",
		sub="Kaja Grip",
		head="Nyame Helm",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Mallquis Clogs +2",
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},
		left_ear = "Ethereal Earring",
		waist="Carrier's Sash",
	}) 
	sets.me.idle.DT.sublimation = set_combine(sets.me.idle.DT,sets.sublimationgear,{})
    sets.me.idle.Slow_DT = set_combine(sets.me.idle.DT,{}) 
	sets.me.idle.Slow_DT.sublimation 	= set_combine(sets.me.idle.DT,{}) 
    sets.me.idle.Slow_R = set_combine(sets.me.idle.Refresh,{}) 
	sets.me.idle.Slow_R.sublimation = set_combine(sets.me.idle.Refresh,{}) 
	
	sets.me.idle.Sphere_R=set_combine(sets.me.idle.Refresh,{body="Zendik Robe"})
	sets.me.idle.Sphere_R.sublimation=set_combine(sets.me.idle.Refresh,sets.sublimationgear,{body="Zendik Robe"})
	sets.me.idle.Sphere_DT=set_combine(sets.me.idle.DT,{body="Zendik Robe"})
	sets.me.idle.Sphere_DT.sublimation=set_combine(sets.me.idle.DT,sets.sublimationgear,{body="Zendik Robe"})
	
	sets.me.idle.Crisis={
		main="Malignance Pole",
		sub="Enki Strap",
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Carrier's Sash",
		left_ear="Tuisto Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Warden's Ring",
		right_ring="Meridian Ring",
		--right_ring="Gelatinous Ring +1",
		back="Moonbeam Cape",	
	}
	sets.me.idle.Crisis.sublimation=set_combine(sets.me.idle.Crisis,{})
	-- Your MP Recovered Whilst Resting Set
    sets.me.resting = {}
    sets.me.latent_refresh = {waist="Fucho-no-obi"}     
    
	-- Combat Related Sets
    sets.me.melee = {
		main="Malignance Pole",
		sub="Kaja Grip",
		ammo="Amar Cluster",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Asperity Necklace",
		waist="Windbuffet Belt +1",
		left_ear="Brutal Earring",
		right_ear="Telos Earring",
		left_ring="Petrov Ring",
		right_ring="Hetairoi Ring",
		back="Moonbeam Cape",
    }
      
    -- Weapon Skills sets just add them by name.
    sets.me["Shattersoul"] = {}
	sets.me["Myrkr"] = {}
	sets.me["Cataclysm"] = {}
	sets.me["Omniscience"] = {}
	sets.me["Flash Nova"] = {}
	sets.me["Shining Strike"] = set_combine(sets.me["Flash Nova"],{})
	sets.me["Seraph Strike"] = set_combine(sets.me["Flash Nova"],{})
      
    -- Feel free to add new weapon skills, make sure you spell it the same as in game. These are the only two I ever use though
  
    ------------
    -- Buff Sets
    ------------	
    -- Gear that needs to be worn to **actively** enhance a current player buff.
    -- Fill up following with your avaible pieces.
    sets.buff['Rapture'] 	= {head=em.head}
    sets.buff['Perpetuance']= {hands=em.hand}
    sets.buff['Immanence'] 	= {hands=em.hand}
    sets.buff['Penury'] 	= {legs=em.legs}
    sets.buff['Parsimony']	= {legs=em.legs}
    sets.buff['Celerity'] 	= {feet=rl.feet}
    sets.buff['Alacrity'] 	= {feet=rl.feet}
    sets.buff['Klimaform'] 	= {feet=em.feet}
    sets.buff['Ebullience'] = {} -- I left it there still if it becomes needed so the SCH.lua file won't need modification should you want to use this set
   
    ---------------
    -- Casting Sets
    ---------------
    sets.precast = {}   		-- Leave this empty  
    sets.midcast = {}    		-- Leave this empty  
    sets.aftercast = {}  		-- Leave this empty  
	sets.midcast.nuking = {}	-- leave this empty
	sets.midcast.MB	= {}		-- leave this empty      
    ----------
    -- Precast
    ----------
      
    -- Generic Casting Set that all others take off of. Here you should add all your fast cast 
    -- Grimoire: 10(cap:25) / rdm: 15
    sets.precast.casting = {
		main="Marin Staff +1", --3/0%
		sub="Kaja Grip", --0/0%		
		ammo="Sapience Orb",--2/0%
		head=rl.head, --0/11%
		body="Zendik Robe", --13%/0
		hands=af.hand, --5%/0
		legs="Agwu's Slops",--7%/0%
		feet="Amalric Nails +1",--0%/0%
		neck="Orunmila's Torque",--5%/0%
		waist="Embla Sash",--5%/0%
		left_ear="Etiolation Earring",--1%/0%
		right_ear="Malignance Earring",--4%/0%
		left_ring="Kishar Ring",--4%/0%
		right_ring="Meridian Ring",--0%/0%
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},--10%/0%
    } 

	sets.precast["Stun"] = {set_combine(sets.precast.casting,{})}
	sets.precast["Dia"] = {set_combine(sets.precast.casting,{})}
	sets.precast["Dia II"] = {set_combine(sets.precast.casting,{})}
	sets.precast["Diaga"] = {set_combine(sets.precast.casting,{})}
	
	sets.precast.Impact = {		
		main="Marin Staff +1",
		sub="Kaja Grip",
		ammo="Sapience Orb",
		body="Twilight Cloak",
		hands="Agwu's Gages",
		legs="Agwu's Slops",
		feet="Amalric Nails +1",
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Etiolation Earring",
		right_ear="Malignance Earring",
		left_ring="Kishar Ring",
		right_ring="Rahab Ring",
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}

    -- When spell school is aligned with grimoire, swap relevent pieces -- Can also use Arbatel +1 set here if you value 1% quickcast procs per piece. (2+ pieces)  
    -- Dont set_combine here, as this is the last step of the precast, it will have sorted all the needed pieces already based on type of spell.
    -- Then only swap in what under this set after everything else. 
    sets.precast.grimoire = {head = rl.head} --13% (Job Ability FC)
	
    -- Enhancing Magic, eg. Siegal Sash, etc
    sets.precast.enhancing = set_combine(sets.precast.casting,{})
  
    -- Stoneskin casting time -, works off of enhancing -
    sets.precast.stoneskin = set_combine(sets.precast.enhancing,{})
      
    -- Curing Precast, Cure Spell Casting time -
    sets.precast.cure = set_combine(sets.precast.casting,{})
	
    --Precast Quick Magic; use for set combines for Raise and other spells that arent modified by gear, like non cursna na/erase spells. 
	sets.precast.QuickMagic={
		main={ name="Pedagogy Staff", augments={'Path: C',}},
		sub="Giuoco Grip",
		ammo="Impatiens",
		head={ name="Peda. M.Board +3", augments={'Enh. "Altruism" and "Focalization"',}},
		body="Zendik Robe",
		hands="Agwu's Gages",
		legs="Agwu's Slops",
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Orunmila's Torque",
		waist="Witful Belt",
		left_ear="Etiolation Earring",
		right_ear="Malignance Earring",
		left_ring="Lebeche Ring",
		right_ring="Weather. Ring",
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},	
	}
	sets.precast.Raise			= set_combine(sets.precast.QuickMagic,{})
	sets.precast.Reraise		= set_combine(sets.precast.QuickMagic,{})
	sets.precast.StatusRemoval	= set_combine(sets.precast.QuickMagic,{})
	sets.precast.Teleport		= set_combine(sets.precast.QuickMagic,{})
	sets.precast.Reraise		= set_combine(sets.precast.QuickMagic,{})	
	
    ---------------------
    -- Ability Precasting
    ---------------------

    sets.precast["Tabula Rasa"] = {legs= rl.legs}
    sets.precast["Enlightenment"] = {body=rl.body}	 
    sets.precast["Sublimation"] = {head=af.head, body=rl.body}	 
	
	----------
    -- Midcast
    ----------
	
    -- Just go make it, inventory will thank you and making rules for each is meh.
    sets.midcast.Obi = {waist="Hachirin-no-obi",}
	-----------------------------------------------------------------------------------------------
	-- Helix sets automatically derives from casting sets. SO DONT PUT ANYTHING IN THEM other than:
	-- Pixie in DarkHelix
	-- Boots that aren't arbatel +1 (15% of small numbers meh, amalric+1 does more)
	-- Belt that isn't Obi.
	-----------------------------------------------------------------------------------------------
    -- Make sure you have a non weather obi in this set. Helix get bonus naturally no need Obi.	
    sets.midcast.DarkHelix = {
		main="Bunzi's Rod",
		sub="Culminus",
		ammo="Ghastly Tathlum +1",
		head="Pixie Hairpin +1",
		body="Agwu's Robe",
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs="Agwu's Slops",
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Argute Stole +2",
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Shiva Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}
    sets.midcast.LightHelix = {
		main="Daybreak",
		sub="Culminus",
		ammo="Ghastly Tathlum +1",
		head="Agwu's Cap",
		body="Agwu's Robe",
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs="Agwu's Slops",
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Argute Stole +2",
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Weather. Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}	
    -- Make sure you have a non weather obi in this set. Helix get bonus naturally no need Obi.	
    sets.midcast.Helix = {
		main="Bunzi's Rod",
		sub="Culminus",
		ammo="Ghastly Tathlum +1",
		head="Agwu's Cap",
		body="Agwu's Robe",
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs="Agwu's Slops",
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Argute Stole +2",
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Mallquis Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
    }	
    sets.midcast.Helix.MB = set_combine(sets.midcast.Helix,{left_ring="Mujin Band",})	
    -- Whatever you want to equip mid-cast as a catch all for all spells, and we'll overwrite later for individual spells
    sets.midcast.casting = {
		main="Marin Staff +1",
		sub="Kaja Grip",
		ammo="Sapience Orb",
		head=rl.head,
		body="Zendik Robe",
		hands=af.hand,
		legs="Agwu's Slops",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Etiolation Earring",
		right_ear="Malignance Earring",
		left_ring="Kishar Ring",
		right_ring="Meridian Ring",
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }

	sets.midcast["Sublimation"] = {head=af.head, body=rl.body}
    
    sets.midcast.nuking.normal = {
		main="Akademos",
		sub="Enki Strap",
		ammo="Pemphredo Tathlum",
		head={ name="Peda. M.Board +3", augments={'Enh. "Altruism" and "Focalization"',}},
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Argute Stole +2",
		waist="Eschan Stone",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}
		
	sets.midcast.nuking.Seidr = set_combine(sets.midcast.nuking.normal,{body="Seidr Cotehardie"})
	
	sets.midcast.Kaustra = set_combine(sets.midcast.nuking.normal, {head="Pixie Hairpin +1"})
	
    -- used with toggle, default: F10
    -- Pieces to swap from freen nuke to Magic Burst
    sets.midcast.MB.normal = set_combine(sets.midcast.nuking.normal, {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head={ name="Peda. M.Board +3", augments={'Enh. "Altruism" and "Focalization"',}},
		body="Agwu's Robe",
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Mujin Band",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
    })
	
    sets.midcast.nuking.acc = set_combine(sets.midcast.nuking.normal, {
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
    })
    -- used with toggle, default: F10
    -- Pieces to swap from freen nuke to Magic Burst
    sets.midcast.MB.acc = set_combine(sets.midcast.MB.normal, {
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
    })	

	sets.midcast.MinDmgSC={
		main="Malignance Pole",
		sub="Kaja Grip",
		ammo="Sapience Orb",
		head={ name="Telchine Cap", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		body="Zendik Robe",
		hands="Agwu's Gages",
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Etiolation Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Weather. Ring",
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},	
	}
	--Drain/Aspir
    sets.midcast["Drain"] = {
		main={ name="Rubicundity", augments={'Mag. Acc.+9','"Mag.Atk.Bns."+8','Dark magic skill +9','"Conserve MP"+5',}},
		sub="Ammurapi Shield",
		ammo="Staunch Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+13','"Drain" and "Aspir" potency +11','"Mag.Atk.Bns."+13',}},
		hands={ name="Merlinic Dastanas", augments={'"Drain" and "Aspir" potency +10','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
		legs={ name="Peda. Pants +3", augments={'Enhances "Tabula Rasa" effect',}},
		feet="Agwu's Pigaches",
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Hirudinea Earring",
		right_ear="Regal Earring",
		left_ring="Defending Ring",
		right_ring="Evanescence Ring",
		back={ name="Bookworm's Cape", augments={'INT+1','MND+1','Helix eff. dur. +15','"Regen" potency+10',}},	
	}
    sets.midcast["Aspir"] = sets.midcast["Drain"]
 		
    -- Enfeebling
	sets.midcast["Stun"] = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Kaja Grip",
		ammo="Pemphredo Tathlum",
		head=af.head,
		body=af.body,
		hands=af.hand,
		legs=af.legs,
		feet=rl.feet,
		neck="Argute Stole +2",
		waist="Witful Belt",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}
	--[[Accuracy and Skill help partial resist states, but acc to cap bio duration is minimal. 
	DOT Potency caps naturally at 291 dark magic skill for Bio II.
	Magic Damage does not increase the base value of the spell.
	Enfeebling Duration does not work
	1.5 Damage per MAB Base before int. 
	0.7 damage per Int
	2:1 MAB:INT]]
	sets.midcast.Bio={
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Baetyl Pendant",
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Shiva Ring +1",
		right_ring="Freke Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}
--Blind - 300 INT Required to Cap Blind on Any given NM - use 250 for Omen and below, for reference Ou is 255 INT. 
--Fill rest with MACC+Enfeebling Skill to Ensure Hits. Fill remainder with Duration to Minimize Casting. 
-- -50 Acc to target at cap. Very valuable for eva tanking even as blind 1. 
	sets.midcast.Blind = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Enki Strap",
		ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
		body="Agwu's Robe",
		hands="Regal Cuffs",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Spell interruption rate down -9%','MND+14','Mag. Acc.+11',}},
		feet="Agwu's Pigaches",
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
    }
	-- Poison scales purely and infinitely with skill. stack skill over all else - even duration. Skill Will even cover MACC. 
	sets.midcast.Poison= {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Mephitis Grip",
		ammo="Pemphredo Tathlum",
		head="Befouled Crown",
		body="Acad. Gown +2",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Merlinic Crackows", augments={'DEX+8','Crit. hit damage +1%','"Refresh"+1','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck="Incanter's Torque",
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}
--Bind - Accuracy Scales the Land rate, Skill Scales the Resist states. Same set for all acc skill focused spells
	sets.midcast.Bind= {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Kaja Grip",
		ammo="Pemphredo Tathlum",
		head="Agwu's Cap",
		body="Acad. Gown +2",
		hands="Regal Cuffs",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Spell interruption rate down -9%','MND+14','Mag. Acc.+11',}},
		feet={ name="Peda. Loafers +3", augments={'Enhances "Stormsurge" effect',}},
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Obstin. Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Kishar Ring",
		right_ring="Stikini Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}

	sets.midcast.Gravity	= set_combine(sets.midcast.Bind,{})
	sets.midcast.Sleep		= set_combine(sets.midcast.Bind,{})
	sets.midcast.Break		= set_combine(sets.midcast.Bind,{})
	
	sets.midcast.Dispel= {
	    main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Kaja Grip",
		ammo="Pemphredo Tathlum",
		head="Agwu's Cap",
		body="Agwu's Robe",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Spell interruption rate down -9%','MND+14','Mag. Acc.+11',}},
		feet={ name="Peda. Loafers +3", augments={'Enhances "Stormsurge" effect',}},
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}
	sets.midcast.Frazzle		= set_combine(sets.midcast.Dispel,{})
	sets.midcast.Distract		= set_combine(sets.midcast.Dispel,{})
	sets.midcast.Silence		= set_combine(sets.midcast.Dispel,{})

--[[SPECIALTY SPELLS- KEEP CASTING GEAR FOR SPELL EQUIPPED]]	
	sets.midcast.Dispelga= {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Agwu's Cap",
		body="Agwu's Robe",
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Spell interruption rate down -9%','MND+14','Mag. Acc.+11',}},
		feet={ name="Peda. Loafers +3", augments={'Enhances "Stormsurge" effect',}},
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}	
	sets.midcast.Impact = {
		main={ name="Contemplator +1", augments={'Path: A',}},
		sub="Kaja Grip",
		ammo="Pemphredo Tathlum",
		body="Twilight Cloak",
		hands="Agwu's Gages",
		legs="Agwu's Slops",
		feet="Agwu's Pigaches",
		neck="Argute Stole +2",
		waist="Acuity Belt +1",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},
	}

--MND Scaling Potency Spells	
    sets.midcast.Paralyze = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head=af.head,
		body=af.body,
		hands={ name="Kaykaus Cuffs +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		legs="Chironic Hose",
		feet=af.feet,
		neck="Argute Stole +2",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Lugh's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','"Cure" potency +10%','Phys. dmg. taken-10%',}},
    }
    sets.midcast.Slow = set_combine(sets.midcast.Paralyze,{})

-- MND Scaling Duration 	
	sets.midcast["Dia"] = set_combine(sets.midcast.Paralyze,{left_ring="Kishar Ring", waist="Obstinate Sash", hands="Regal Cuffs"})
	sets.midcast["Dia II"] = sets.midcast["Dia"]	
	sets.midcast["Diaga"] = sets.midcast["Dia"]
	
-- Enhancing
    sets.midcast.enhancing = {
		main="Bolelabunga",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head={ name="Telchine Cap", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
		hands="Acad. Bracers +2",
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		neck="Reti Pendant",
		waist="Embla Sash",
		left_ear="Gifted Earring",
		right_ear="Calamitous Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back="Aurist's Cape +1",
    }
-- Full Conserve MP for Spells with no reliance on Fast cast, Duration, or potency
	sets.midcast.ConserveMp ={
		main="Grioavolr", --15
		sub="Giuoco Grip", --4
		ammo="Pemphredo Tathlum", --4
		head={ name="Vanya Hood", augments={'MP+49','"Cure" potency +7%','Enmity-5',}}, --6
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},--7
		hands="Acad. Bracers +2",--4
		legs={ name="Lengo Pants", augments={'INT+10','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Refresh"+1',}},--5
		feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},--6
		neck="Reti Pendant",--4
		waist="Austerity Belt",--8
		left_ear="Calamitous Earring",--4
		right_ear="Gifted Earring",--3
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back="Aurist's Cape +1",--5
	}
	sets.midcast.ConserveMpDuration ={
		main="Pedagogy Staff",
		sub="Giuoco Grip",
		ammo="Pemphredo Tathlum",
		head={ name="Telchine Cap", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		body=rl.body,
		hands="Acad. Bracers +2",
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		neck="Reti Pendant",
		waist="Embla Sash",
		left_ear="Calamitous Earring",
		right_ear="Gifted Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back="Aurist's Cape +1",
	}
    sets.midcast.Storm 		= set_combine(sets.midcast.ConserveMpDuration,{feet = rl.feet})       
	sets.midcast.BarElement	= set_combine(sets.midcast.ConserveMpDuration,{})
	sets.midcast.BarStatus	= set_combine(sets.midcast.ConserveMpDuration,{})
    sets.midcast.Stoneskin 	= set_combine(sets.midcast.ConserveMpDuration,{neck="Nodens Gorget",left_ear="Earthcry Earring",waist="Siegel Sash",})
    sets.midcast.Refresh 	= set_combine(sets.midcast.ConserveMpDuration,{})
    sets.midcast.Aquaveil 	= set_combine(sets.midcast.ConserveMpDuration,{hands = "Regal Cuffs"})
	sets.midcast.Protect	= set_combine(sets.midcast.ConserveMp,{})
	sets.midcast.Shell		= set_combine(sets.midcast.ConserveMp,{})
	sets.midcast.Raise		= set_combine(sets.midcast.ConserveMp,{})
	sets.midcast.Reraise	= set_combine(sets.midcast.ConserveMp,{})	
	sets.midcast.Haste		= set_combine(sets.midcast.ConserveMpDuration,{})
	sets.midcast.Phalanx	= set_combine(sets.midcast.ConserveMpDuration,{})
	
 	sets.midcast.cure = {} -- Leave This Empty
	
    sets.midcast.cure.normal = {
		main="Daybreak",
		sub="Sors Shield",
		ammo="Esper Stone +1",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		hands={ name="Peda. Bracers +3", augments={'Enh. "Tranquility" and "Equanimity"',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		neck="Reti Pendant",
		waist="Austerity Belt",
		left_ear="Gifted Earring",
		right_ear="Calamitous Earring",
		left_ring="Lebeche Ring",
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back="Aurist's Cape +1",
	}
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{
		main="Iridal Staff",
		sub="Giuoco Grip",
		waist="Hachirin-no-Obi",	
	})     
	sets.midcast.cure.normal.self={
		main="Daybreak",
		sub="Sors Shield",
		ammo="Esper Stone +1",
		head={ name="Kaykaus Mitra +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		body={ name="Kaykaus Bliaut +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		hands="Agwu's Gages",
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Kaykaus Boots +1", augments={'MP+80','"Cure" spellcasting time -7%','Enmity-6',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Gishdubar Sash",
		left_ear="Etiolation Earring",
		right_ear="Regal Earring",
		left_ring="Lebeche Ring",
		right_ring="Meridian Ring",
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	sets.midcast.cure.weather.self = set_combine(sets.midcast.cure.normal.self,{
		main="Iridal Staff",
		sub="Giuoco Grip",	
		waist="Hachirin-no-Obi",
	}) 
	
	sets.midcast.cure.nuke = {
		main="Daybreak",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},	
	}
	sets.midcast.cure.nuke.weather=set_combine(sets.midcast.cure.nuke,{waist="Hachirin-no-Obi",})
	sets.midcast.cure.nuke.MB = {
		main="Bunzi's Rod",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Agwu's Cap",
		body="Agwu's Robe",
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Kaykaus Tights +1", augments={'MP+80','MND+12','Mag. Acc.+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Mizu. Kubikazari",
		waist="Eschan Stone",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Locus Ring",
		right_ring="Mujin Band",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%',}},	
	}
	sets.midcast.cure.nuke.MB.weather=set_combine(sets.midcast.cure.nuke,{waist="Hachirin-no-Obi",})
    ------------
    -- Regen
    ------------	
	sets.midcast.regen = {} 	-- leave this empty
	-- Normal hybrid well rounded Regen
    sets.midcast.regen.hybrid = {
		main="Pedagogy Staff",
		sub="Giuoco Grip",
		ammo="Pemphredo Tathlum",
		head=em.head,
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		hands="Arbatel Bracers +1",
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		neck="Reti Pendant",
		waist="Embla Sash",
		left_ear="Gifted Earring",
		right_ear="Calamitous Earring",
		left_ring="Defending Ring",
		right_ring="Meridian Ring",
		back={ name="Bookworm's Cape", augments={'INT+1','MND+1','Helix eff. dur. +15','"Regen" potency+10',}},
	}
	-- Focus on Regen Duration 	
    sets.midcast.regen.duration = {
		main={ name="Pedagogy Staff", augments={'Path: C',}},
		sub="Giuoco Grip",
		ammo="Pemphredo Tathlum",
		head={ name="Telchine Cap", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		body={ name="Telchine Chas.", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		hands="Arbatel Bracers +1",
		legs={ name="Telchine Braconi", augments={'Mag. Acc.+6','"Conserve MP"+5','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+5','Enh. Mag. eff. dur. +9',}},
		neck={ name="Argute Stole +2", augments={'Path: A',}},
		waist="Embla Sash",
		left_ear="Gifted Earring",
		right_ear="Calamitous Earring",
		left_ring="Defending Ring",
		right_ring="Meridian Ring",
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},	
	} 
	-- Focus on Regen Potency 	
    sets.midcast.regen.potency = set_combine(sets.midcast.regen.hybrid,{})

	sets.midcast.Erase = set_combine(sets.precast.casting,{})		
end