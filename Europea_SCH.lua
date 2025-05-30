
--[[
        Custom commands:
        Shorthand versions for each strategem type that uses the version appropriate for
        the current Arts.
                                        Light Arts              Dark Arts
        gs c scholar light              Light Arts/Addendum
        gs c scholar dark                                       Dark Arts/Addendum
        gs c scholar cost               Penury                  Parsimony
        gs c scholar speed              Celerity                Alacrity
        gs c scholar aoe                Accession               Manifestation
        gs c scholar power              Rapture                 Ebullience
        gs c scholar duration           Perpetuance
        gs c scholar accuracy           Altruism                Focalization
        gs c scholar enmity             Tranquility             Equanimity
        gs c scholar skillchain                                 Immanence
        gs c scholar addendum           Addendum: White         Addendum: Black
    
        Toggle Function: 
        gs c toggle melee               Toggle Melee mode on / off and locking of weapons
        gs c toggle mb                  Toggles Magic Burst Mode on / off.
        gs c toggle runspeed            Toggles locking on / off Herald's Gaiters
        gs c toggle idlemode            Toggles between Refresh and DT idle mode. Activating Sublimation JA will auto replace refresh set for sublimation set. DT set will superceed both.        
        gs c toggle regenmode           Toggles between Hybrid, Duration and Potency mode for regen set  
        gs c toggle nukemode            Toggles between Normal and Accuracy mode for midcast Nuking sets (MB included)  
        gs c toggle matchsc             Toggles auto swapping element to match the last SC that just happenned.
                
        Casting functions:
        these are to set fewer macros (1 cycle, 5 cast) to save macro space when playing lazily with controler
        
        gs c nuke cycle                 Cycles element type for nuking & SC
        gs c nuke cycledown             Cycles element type for nuking & SC in reverse order    
        gs c nuke t1                    Cast tier 1 nuke of saved element 
        gs c nuke t2                    Cast tier 2 nuke of saved element 
        gs c nuke t3                    Cast tier 3 nuke of saved element 
        gs c nuke t4                    Cast tier 4 nuke of saved element 
        gs c nuke t5                    Cast tier 5 nuke of saved element 
        gs c nuke helix                 Cast helix2 nuke of saved element 
        gs c nuke storm                 Cast Storm II buff of saved element  
                    
        gs c sc tier                    Cycles SC Tier (1 & 2)
        gs c sc castsc                  Cast All the stuff to create a SC burstable by the nuke element set with '/console gs c nuke element'.
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

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- to define sets for regen if you add more modes, name them: sets.midcast.regen.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('refresh', 'dt')
regenModes = M('hybrid', 'duration', 'potency')
-- To add a new mode to nuking, you need to define both sets: sets.midcast.nuking.mynewmode as well as sets.midcast.MB.mynewmode
nukeModes = M('normal', 'acc', 'Seidr')

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
	--windower.send_command('bind ^\\\\ input /ja "Penury" <me>')	
	windower.send_command('lua l gearinfo')
	windower.send_command('lua l equipviewer')
	windower.send_command('lua l partybuffs')
	windower.send_command('bind !q input //send Dekar /follow Europea') --FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND 
	windower.send_command('bind !a input //send Theroon /follow Europea') --FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND
	

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
end

--------------------------------------------------------------------------------------------------------------
include('SCH_Lib.lua')          -- leave this as is    
refreshType = idleModes[1]      -- leave this as is     
--------------------------------------------------------------------------------------------------------------


-- Optional. Swap to your sch macro sheet / book
set_macros(1,17) -- Sheet, Book


-------------------------------------------------------------                                        
--      ,---.                         |         
--      |  _.,---.,---.,---.,---.,---.|--- ,---.
--      |   ||---',---||    `---.|---'|    `---.
--      `---'`---'`---^`    `---'`---'`---'`---'
-------------------------------------------------------------                                              

-- Setup your Gear Sets below:
function get_sets()
  
    -- My formatting is very easy to follow. All sets that pertain to my character doing things are under 'me'.
    -- All sets that are equipped to faciliate my avatar's behaviour or abilities are under 'avatar', eg, Perpetuation, Blood Pacts, etc
      
    sets.me = {}        		-- leave this empty
    sets.buff = {} 				-- leave this empty
    sets.me.idle = {}			-- leave this empty

    -- Your idle set
    sets.me.idle.refresh = {
		main="Malignance Pole",
		sub="Kaja Grip",
		ammo="Homiliary",
		head={ name="Chironic Hat", augments={'CHR+5','Pet: Mag. Acc.+3 Pet: "Mag.Atk.Bns."+3','Damage taken-5%','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		body="Jhakri Robe +2",
		hands="Pinga Mittens",
		legs="Assid. Pants +1",
		feet={ name="Chironic Slippers", augments={'AGI+4','Weapon skill damage +1%','"Refresh"+2','Accuracy+10 Attack+10','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Ethereal Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Patricius Ring",
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Occ. inc. resist. to stat. ailments+10',}},
    }

    -- Your idle Sublimation set combine from refresh or DT depening on mode.
    sets.me.idle.sublimation = set_combine(sets.me.idle.refresh,{
		head="Academic's Mortarboard +1",
		body="Pedagogy Gown +3",
    })   
    -- Your idle DT set
    sets.me.idle.dt = set_combine(sets.me.idle[refreshType],{
		main="Malignance Pole",
		sub="Kaja Grip",
		ammo="Staunch Tathlum +1",
		head={ name="Chironic Hat", augments={'CHR+5','Pet: Mag. Acc.+3 Pet: "Mag.Atk.Bns."+3','Damage taken-5%','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Pinga Mittens",
		legs="Assid. Pants +1",
		feet={ name="Chironic Slippers", augments={'AGI+4','Weapon skill damage +1%','"Refresh"+2','Accuracy+10 Attack+10','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Ethereal Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Patricius Ring",
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Occ. inc. resist. to stat. ailments+10',}},
    })  
    sets.me.idle.mdt = set_combine(sets.me.idle[refreshType],{
		main="Malignance Pole",
		sub="Kaja Grip",
		ammo="Staunch Tathlum +1",
		head={ name="Chironic Hat", augments={'CHR+5','Pet: Mag. Acc.+3 Pet: "Mag.Atk.Bns."+3','Damage taken-5%','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Pinga Mittens",
		legs="Assid. Pants +1",
		feet={ name="Chironic Slippers", augments={'AGI+4','Weapon skill damage +1%','"Refresh"+2','Accuracy+10 Attack+10','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		neck="Loricate Torque +1",
		waist="Carrier's Sash",
		left_ear="Ethereal Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Fortified Ring",
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Occ. inc. resist. to stat. ailments+10',}},
    })  
	-- Your MP Recovered Whilst Resting Set
    sets.me.resting = { 

    }
    
    sets.me.latent_refresh = {waist="Fucho-no-obi"}     
    
	-- Combat Related Sets
    sets.me.melee = {
		ammo="Staunch Tathlum +1",
		head="Jhakri Coronal +2",
		body="Jhakri Robe +2",
		hands="Gazu Bracelet +1",
		legs="Jhakri Slops +2",
		feet="Jhakri Pigaches +2",
		neck="Sanctity Necklace",
		waist="Cetl Belt",
		left_ear="Brutal Earring",
		right_ear="Telos Earring",
		left_ring="Hetairoi Ring",
		right_ring="Rajas Ring",
		back={ name="Lugh's Cape", augments={'HP+60','"Fast Cast"+10','Damage taken-5%',}},
    }
      
    -- Weapon Skills sets just add them by name.
    sets.me["Shattersoul"] = {
		ammo="Pemphredo Tathlum",
		head="Jhakri Coronal +2",
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs="Jhakri Slops +2",
		feet="Jhakri Pigaches +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring="Rufescent Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
    }
	
    sets.me["Myrkr"] = {
		ammo="Hydrocera",
		head="Pixie Hairpin +1",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Kaykaus Cuffs", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet="Skaoi Boots",
		neck="Nodens Gorget",
		waist="Luminary Sash",
		left_ear="Gifted Earring",
		right_ear="Etiolation Earring",
		left_ring="Persis Ring",
		right_ring="Fortified Ring",
		back="Fi Follet Cape",
    }
	
	sets.me["Cataclysm"] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body="Jhakri Robe +2",
		hands="Jhakri Cuffs +2",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic burst dmg.+1%','CHR+2','Mag. Acc.+13','"Mag.Atk.Bns."+13',}},
		feet={ name="Peda. Loafers +3", augments={'Enhances "Stormsurge" effect',}},
		neck="Mizu. Kubikazari",
		waist="Hachirin-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring="Archon Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
    }
	
	sets.me["Omniscience"] = {
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
		hands={ name="Peda. Bracers +3", augments={'Enh. "Tranquility" and "Equanimity"',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Enmity-4','MND+9','Mag. Acc.+14','"Mag.Atk.Bns."+15',}},
		feet={ name="Peda. Loafers +3", augments={'Enhances "Stormsurge" effect',}},
		neck="Mizu. Kubikazari",
		waist="Hachirin-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Rufescent Ring",
		right_ring="Archon Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
	}
	
	sets.me["Flash Nova"] = {
		ammo="Pemphredo Tathlum",
		head={ name="Peda. M.Board +3", augments={'Enh. "Altruism" and "Focalization"',}},
		body={ name="Peda. Gown +3", augments={'Enhances "Enlightenment" effect',}},
		hands={ name="Peda. Bracers +3", augments={'Enh. "Tranquility" and "Equanimity"',}},
		legs={ name="Peda. Pants +3", augments={'Enhances "Tabula Rasa" effect',}},
		feet={ name="Peda. Loafers +3", augments={'Enhances "Stormsurge" effect',}},
		neck="Baetyl Pendant",
		waist="Hachirin-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Rufescent Ring",
		right_ring="Stikini Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
	}
	
	sets.me["Shining Strike"] = set_combine(sets.me["Flash Nova"],{	
	})
	
	sets.me["Seraph Strike"] = set_combine(sets.me["Flash Nova"],{	
	})
      
    -- Feel free to add new weapon skills, make sure you spell it the same as in game. These are the only two I ever use though
  
    ------------
    -- Buff Sets
    ------------	
    -- Gear that needs to be worn to **actively** enhance a current player buff.
    -- Fill up following with your avaible pieces.
    sets.buff['Rapture'] = {head="Arbatel bonnet +1"}
    sets.buff['Perpetuance'] = {hands="Arbatel Bracers +1"}
    sets.buff['Immanence'] = {hands="Arbatel Bracers +1"}
    sets.buff['Penury'] = {legs="Arbatel Pants"}
    sets.buff['Parsimony'] = {legs="Arbatel Pants"}
    sets.buff['Celerity'] = {feet="Peda. Loafers +3"}
    sets.buff['Alacrity'] = {feet="Peda. Loafers +3"}
    sets.buff['Klimaform'] = {feet="Arbatel Loafers"}	
    -- Ebulience set empy now as we get better damage out of a good Merlinic head
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
		main="Pedagogy Staff", --8 FC
		sub="Clerisy Strap", --2
		ammo="Incantor Stone", --2
		head="Pedagogy Mortarboard +3", --Grimoire: Spellcasting Time -13%.
		body="Zendik Robe", --13
		hands="Academic's Bracers +2", --7
		legs="Psycloth Lappas", --7
		feet={ name="Merlinic Crackows", augments={'"Fast Cast"+7','VIT+7','Mag. Acc.+15',}}, --12
		neck="Voltsurge Torque", --4
		waist="Embla Sash", --5
		left_ear="Malignance Earring", --4
		right_ear="Loquacious Earring", --2
		left_ring="Kishar Ring", --4
		right_ring="Prolix Ring", --2
		back={ name="Lugh's Cape", augments={'HP+60','"Fast Cast"+10','Damage taken-5%',}}, --10
    } --82% FC.  92FC w/ /RDM (native 15%)

	sets.precast["Stun"] = {set_combine(sets.precast.casting,{
	})}
	
	sets.precast["Dia"] = {set_combine(sets.precast.casting,{
		waist="",		
    })
	
	}
	
	sets.precast["Dia II"] = {set_combine(sets.precast.casting,{
		waist="",		
    })

	}
	
	sets.precast["Diaga"] = {set_combine(sets.precast.casting,{
		waist="",		
    })

	}
	
	sets.precast.Impact = {		
		main={ name="Pedagogy Staff", augments={'Path: C',}},
		sub="Clerisy Strap",
		ammo="Incantor Stone",
		head=empty,
		body="Twilight Cloak",
		hands="Academic's Bracers +2",
		legs={ name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
		feet={ name="Merlinic Crackows", augments={'"Fast Cast"+7','VIT+7','Mag. Acc.+15',}},
		neck="Voltsurge Torque",
		waist="Channeler's Stone",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Lugh's Cape", augments={'HP+60','"Fast Cast"+10','Damage taken-5%',}},
		}

    -- When spell school is aligned with grimoire, swap relevent pieces -- Can also use Arbatel +1 set here if you value 1% quickcast procs per piece. (2+ pieces)  
    -- Dont set_combine here, as this is the last step of the precast, it will have sorted all the needed pieces already based on type of spell.
    -- Then only swap in what under this set after everything else. 
    sets.precast.grimoire = {
		head="Pedagogy Mortarboard +3", --13% (Job Ability FC)
    }

	
    -- Enhancing Magic, eg. Siegal Sash, etc
    sets.precast.enhancing = set_combine(sets.precast.casting,{
		waist="Siegal Sash",		
    })
  
    -- Stoneskin casting time -, works off of enhancing -
    sets.precast.stoneskin = set_combine(sets.precast.enhancing,{

    })
      
    -- Curing Precast, Cure Spell Casting time -
    sets.precast.cure = set_combine(sets.precast.casting,{
		right_ear="Mendicant's Earring",
		feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
		})
      
    ---------------------
    -- Ability Precasting
    ---------------------

    sets.precast["Tabula Rasa"] = {legs="Pedagogy Pants +3"}
    sets.precast["Enlightenment"] = {body="Peda. Gown +3"}	 
    sets.precast["Sublimation"] = {head="Acad. Mortar. +1", body="Peda. Gown +3"}	 

	
	----------
    -- Midcast
    ----------
	
    -- Just go make it, inventory will thank you and making rules for each is meh.
    sets.midcast.Obi = {
    	waist="Hachirin-no-obi",
    }
	
	-----------------------------------------------------------------------------------------------
	-- Helix sets automatically derives from casting sets. SO DONT PUT ANYTHING IN THEM other than:
	-- Pixie in DarkHelix
	-- Boots that aren't arbatel +1 (15% of small numbers meh, amalric+1 does more)
	-- Belt that isn't Obi.
	-----------------------------------------------------------------------------------------------
    -- Make sure you have a non weather obi in this set. Helix get bonus naturally no need Obi.	
    sets.midcast.DarkHelix = {
		main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
		sub="Enki Strap",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Merlinic Shalwar", augments={'"Mag.Atk.Bns."+29','Magic burst dmg.+11%','INT+9','Mag. Acc.+5',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+5%','CHR+5','Mag. Acc.+2','"Mag.Atk.Bns."+14',}},
		neck="Mizu. Kubikazari",
		waist="Skrymir Cord",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Locus Ring",
		right_ring="Archon Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},			
    }
	
    -- Make sure you have a non weather obi in this set. Helix get bonus naturally no need Obi.	
    sets.midcast.Helix = {
		main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
		sub="Enki Strap",
		ammo="Pemphredo Tathlum",
		head={ name="Peda. M.Board +3", augments={'Enh. "Altruism" and "Focalization"',}},
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Merlinic Shalwar", augments={'"Mag.Atk.Bns."+29','Magic burst dmg.+11%','INT+9','Mag. Acc.+5',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+5%','CHR+5','Mag. Acc.+2','"Mag.Atk.Bns."+14',}},
		neck="Mizu. Kubikazari",
		waist="Skrymir Cord",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Locus Ring",
		right_ring="Mujin Band",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
    }	

    -- Whatever you want to equip mid-cast as a catch all for all spells, and we'll overwrite later for individual spells
    sets.midcast.casting = {
		main="Pedagogy Staff",
		sub="Clerisy Strap",
		ammo="Pemphredo Tathlum",
		head="Nahtirah Hat",
		body="Shango Robe",
		hands="Academic's Bracers +2",
		legs="Psycloth Lappas",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+5%','CHR+5','Mag. Acc.+2','"Mag.Atk.Bns."+14',}},
		neck="Voltsurge Torque",
		waist="Channeler's Stone",
		left_ear="Malignance Earring",
		right_ear="Etiolation Earring",
		left_ring="Kishar Ring",
		right_ring="Prolix Ring",
		back={ name="Lugh's Cape", augments={'HP+60','"Fast Cast"+10','Damage taken-5%',}},
    }

	sets.midcast["Sublimation"] = {head="Acad. Mortar. +1", body="Peda. Gown +3"}
    
    sets.midcast.nuking.normal = {
		main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
		sub="Enki Strap",
		ammo="Pemphredo Tathlum",
		head="Pedagogy Mortarboard +3",
		body="Amalric Doublet +1",
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic burst dmg.+1%','CHR+2','Mag. Acc.+13','"Mag.Atk.Bns."+13',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+5%','CHR+5','Mag. Acc.+2','"Mag.Atk.Bns."+14',}},
		neck="Mizukage-no-Kubikazari",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring="Stikini Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
    }
		
	sets.midcast.nuking.Seidr = {
		main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
		sub="Enki Strap",
		ammo="Pemphredo Tathlum",
		head="Pedagogy Mortarboard +3",
		body="Seidr Cotehardie",
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic burst dmg.+1%','CHR+2','Mag. Acc.+13','"Mag.Atk.Bns."+13',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+5%','CHR+5','Mag. Acc.+2','"Mag.Atk.Bns."+14',}},
		neck="Mizukage-no-Kubikazari",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring="Stikini Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
    }
	
	sets.midcast.Kaustra = set_combine(sets.midcast.nuking.normal, {
		head="Pixie Hairpin +1",
		legs={ name="Merlinic Shalwar", augments={'"Mag.Atk.Bns."+29','Magic burst dmg.+11%','INT+9','Mag. Acc.+5',}},
		feet="Jhakri Pigaches +2",
		waist="Hachirin-no-obi",
		right_ring="Archon Ring",		
	})
	
    -- used with toggle, default: F10
    -- Pieces to swap from freen nuke to Magic Burst
    sets.midcast.MB.normal = set_combine(sets.midcast.nuking.normal, {
		legs={ name="Merlinic Shalwar", augments={'"Mag.Atk.Bns."+29','Magic burst dmg.+11%','INT+9','Mag. Acc.+5',}},
		right_ring="Mujin Band",
		left_ring="Locus Ring",
    })
	
    sets.midcast.nuking.acc = {
		main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
		sub="Kaja Grip",
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','Mag. Acc.+13','"Mag.Atk.Bns."+9',}},
		body="Amalric Doublet +1",
		hands="Jhakri Cuffs +2",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic burst dmg.+1%','CHR+2','Mag. Acc.+13','"Mag.Atk.Bns."+13',}},
		feet="Jhakri Pigaches +2",
		neck="Erra Pendant",
		waist="Eschan Stone",
		left_ear="Malignance Earring",
		right_ear="Dignitary's Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
    }
    -- used with toggle, default: F10
    -- Pieces to swap from freen nuke to Magic Burst
    sets.midcast.MB.acc = set_combine(sets.midcast.nuking.normal, {
		right_ring="Mujin Band",
		left_ring="Locus Ring",
    })	
	
    -- Enfeebling
	sets.midcast["Stun"] = {
		main={ name="Pedagogy Staff", augments={'Path: C',}},
		sub="Kaja Grip",
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','Mag. Acc.+13','"Mag.Atk.Bns."+9',}},
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic burst dmg.+1%','CHR+2','Mag. Acc.+13','"Mag.Atk.Bns."+13',}},
		feet="Pedagogy Loafers +3",
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Malignance Earring",
		right_ear="Dignitary's Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Lugh's Cape", augments={'HP+60','"Fast Cast"+10','Damage taken-5%',}}, --GET MAGIC ACC ON THIS ASAP!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	}

	sets.midcast["Dia"] = {
		main="Malignance Pole",
		sub="Enki Strap",
		ammo="Staunch Tathlum +1",
		head={ name="Chironic Hat", augments={'CHR+5','Pet: Mag. Acc.+3 Pet: "Mag.Atk.Bns."+3','Damage taken-5%','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		body="Mallquis Saio +2",
		hands="Acad. Bracers +2",
		legs={ name="Merlinic Shalwar", augments={'"Mag.Atk.Bns."+19','INT+1','"Treasure Hunter"+2','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		feet={ name="Merlinic Crackows", augments={'Pet: "Dbl.Atk."+2 Pet: Crit.hit rate +2','Rng.Atk.+28','"Treasure Hunter"+2','Accuracy+2 Attack+2',}},
		neck="Loricate Torque +1",
		waist="Carrier's Sash",
		left_ear="Ethereal Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Fortified Ring",
		back={ name="Lugh's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Occ. inc. resist. to stat. ailments+10',}},
	}
	
	sets.midcast["Dia II"] = sets.midcast["Dia"]	
	sets.midcast["Diaga"] = sets.midcast["Dia"]
	
	sets.midcast["Distract"] = set_combine(sets.midcast.IntEnfeebling, {
		legs={ name="Merlinic Shalwar", augments={'"Mag.Atk.Bns."+19','INT+1','"Treasure Hunter"+2','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		feet={ name="Merlinic Crackows", augments={'Pet: "Dbl.Atk."+2 Pet: Crit.hit rate +2','Rng.Atk.+28','"Treasure Hunter"+2','Accuracy+2 Attack+2',}},
	})
	
	sets.midcast.Impact = {
		main={ name="Pedagogy Staff", augments={'Path: C',}},
		sub="Kaja Grip",
		ammo="Pemphredo Tathlum",
		head=empty,
		body="Twilight Cloak",
		hands="Acad. Bracers +2",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic burst dmg.+1%','CHR+2','Mag. Acc.+13','"Mag.Atk.Bns."+13',}},
		feet="Jhakri Pigaches +2",
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Malignance Earring",
		right_ear="Digni. Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
	}

		
    sets.midcast.IntEnfeebling = {
		main={ name="Pedagogy Staff", augments={'Path: C',}},
		sub="Kaja Grip",
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','Mag. Acc.+13','"Mag.Atk.Bns."+9',}},
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Pedagogy Bracers +3",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Enmity-4','MND+9','Mag. Acc.+14','"Mag.Atk.Bns."+15',}},
		feet="Skaoi Boots",
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Malignance Earring",
		right_ear="Digni. Earring",
		left_ring="Kishar Ring",
		right_ring="Stikini Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
    }
	
    sets.midcast.MndEnfeebling = {
		main={ name="Pedagogy Staff", augments={'Path: C',}},
		sub="Kaja Grip",
		ammo="Pemphredo Tathlum",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Magic burst dmg.+8%','Mag. Acc.+13','"Mag.Atk.Bns."+9',}},
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Pedagogy Bracers +3",
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Enmity-4','MND+9','Mag. Acc.+14','"Mag.Atk.Bns."+15',}},
		feet="Skaoi Boots",
		neck="Erra Pendant",
		waist="Luminary Sash",
		left_ear="Malignance Earring",
		right_ear="Digni. Earring",
		left_ring="Kishar Ring",
		right_ring="Stikini Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
    }
	
    -- Enhancing
    sets.midcast.enhancing = set_combine(sets.midcast.casting,{
		main="Pedagogy Staff",
		sub="Fulcio Grip",
		ammo="Incantor Stone",
		head={ name="Telchine Cap", augments={'"Conserve MP"+2','Enh. Mag. eff. dur. +8',}},
		body="Pedagogy Gown +3",
		hands="Arbatel Bracers +1",
		legs={ name="Telchine Braconi", augments={'"Cure" potency +6%','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+4','Enh. Mag. eff. dur. +9',}},
		neck="Voltsurge Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Andoaa Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back="Fi Follet Cape",
    })
    sets.midcast.storm = set_combine(sets.midcast.enhancing,{
		feet="Pedagogy Loafers +3",

    })       
    -- Stoneskin
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing,{
		neck="Nodens Gorget",
		waist="Siegel Sash",
    })
    sets.midcast.refresh = set_combine(sets.midcast.enhancing,{
		head="",
    })
    sets.midcast.aquaveil = set_combine(sets.midcast.refresh,{
		head="Chironic Hat",
	})
	
    sets.midcast["Drain"] = set_combine(sets.midcast.nuking, {
		main={ name="Akademos", augments={'INT+15','"Mag.Atk.Bns."+15','Mag. Acc.+15',}},
		sub="Enki Strap",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands="Academic's Bracers +2",
		legs="Pedagogy pants +3",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+25 "Mag.Atk.Bns."+25','Magic burst dmg.+5%','CHR+5','Mag. Acc.+2','"Mag.Atk.Bns."+14',}},
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Evanescence Ring",
		right_ring="Archon Ring",
		back={ name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
    })
    sets.midcast["Aspir"] = sets.midcast["Drain"]
 	
 	sets.midcast.cure = {} -- Leave This Empty
    -- Cure Potency
    sets.midcast.cure.normal = set_combine(sets.midcast.casting,{
		main="Chatoyant Staff",
		sub="Kaja Grip",
		ammo="Pemphredo Tathlum",
		head={ name="Kaykaus Mitra", augments={'MP+60','MND+10','Mag. Acc.+15',}},
		body="Arbatel Gown +1",
		hands="Pedagogy Bracers +3",
		legs="Acad. Pants +2",
		feet={ name="Vanya Clogs", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
		neck="Nodens Gorget",
		waist="Luminary Sash",
		left_ear="Regal Earring",
		right_ear="Mendi. Earring",
		left_ring="Sirona's Ring",
		right_ring="Kuchekula Ring",
		back={ name="Lugh's Cape", augments={'HP+60','"Fast Cast"+10','Damage taken-5%',}},
    })
	
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{
		main="Chatoyant Staff",
		waist="Hachirin-no-obi",
		back="Twilight Cape",

    })
	sets.midcast.cure.normal.self={}
	sets.midcast.cure.weather.self = set_combine(sets.midcast.cure.normal.self,{main="Chatoyant Staff",waist="Hachirin-no-obi",back="Twilight Cape",})
	------------
    -- Cure Nukes you sick son of a bitch
    ------------
	sets.midcast.cure.nuke = {}
	sets.midcast.cure.nuke.weather=set_combine(sets.midcast.cure.nuke,{waist="Hachirin-no-Obi",})
	sets.midcast.cure.nuke.MB = {}
	sets.midcast.cure.nuke.MB.weather=set_combine(sets.midcast.cure.nuke.MB,{waist="Hachirin-no-Obi",})
    ------------
    -- Regen
    ------------	
	sets.midcast.regen = {} 	-- leave this empty
	-- Normal hybrid well rounded Regen
    sets.midcast.regen.hybrid = {
		main="Pedagogy Staff",
		sub="Clerisy Strap",
		ammo="Incantor Stone",
		head="Arbatel Bonnet +1",
		body="Pedagogy Gown +3",
		hands="Arbatel Bracers +1",
		legs={ name="Telchine Braconi", augments={'"Cure" potency +6%','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+4','Enh. Mag. eff. dur. +9',}},
		neck="Nodens Gorget",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Gifted Earring",
		left_ring="Kishar Ring",
		right_ring="Kuchekula Ring",
		back={ name="Lugh's Cape", augments={'HP+60','"Fast Cast"+10','Damage taken-5%',}},
    }
	-- Focus on Regen Duration 	
    sets.midcast.regen.duration = set_combine(sets.midcast.regen.hybrid,{
		head={ name="Telchine Cap", augments={'"Conserve MP"+2','Enh. Mag. eff. dur. +8',}},

    }) 
	-- Focus on Regen Potency 	
    sets.midcast.regen.potency = set_combine(sets.midcast.regen.hybrid,{
		main="Pedagogy Staff",
		sub="Clerisy Strap",
		head="Arbatel Bonnet +1",
    })

	sets.midcast.Erase = set_combine(sets.precast.casting,{
	})	
	
    ------------
    -- Aftercast
    ------------
      
    -- I don't use aftercast sets, as we handle what to equip later depending on conditions using a function.
	
end