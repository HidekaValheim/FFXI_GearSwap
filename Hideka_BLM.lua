include('organizer-lib')
include('Modes.lua')
res = require('resources')
texts = require('texts')

send_command('input //send @all lua l superwarp') 
send_command('input //lua l porterpacker') 
send_command('wait 30;input //gs validate') 

organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
    NinjaTools={"Shihei"},
	Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},
}
PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

function get_gear()
	--[[Disable code in this sub if you dont have organizer or porter packer]]
    send_command('wait 3;input //gs org')
	-- if PortTowns:contains(world.area) then
		-- send_command('wait 3;input //gs org') 
		-- send_command('wait 6;input //po repack') 
    -- else
		-- add_to_chat(8,'User Not in Town - Utilize GS ORG and PO Repack Functions in Rabao, Norg, Mhaura, or Selbina')
    -- end
end

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('refresh', 'dt')
meleeModes = M('FullHaste', 'dt')
nukeModes = M('normal', 'acc', 'Accumen')

------------------------------------------------------------------------------------------------------
-- Important to read!
------------------------------------------------------------------------------------------------------
-- This will be used later down for weapon combos, here's mine for example, you can add your REMA+offhand of choice in there
-- Add you weapons in the Main list and/or sub list.
-- Don't put any weapons / sub in your IDLE and ENGAGED sets'
-- You can put specific weapons in the midcasts and precast sets for spells, but after a spell is 
-- cast and we revert to idle or engaged sets, we'll be checking the following for weapon selection. 
-- Defaults are the first in each list
mainWeapon = M('Malignance Pole','Contemplator +1','Maxentius','Daybreak')
subWeapon = M('Kaja Grip','Genmei Shield')
------------------------------------------------------------------------------------------------------

----------------------------------------------------------
-- Auto CP Cape: Will put on CP cape automatically when
-- fighting Apex mobs and job is not mastered
----------------------------------------------------------
CP_CAPE ={name="Mecisto. Mantle", augments={'Cap. Point+48%','DEX+3','DEF+3',}} -- Put your CP cape here
DYNA_NECK = ""
----------------------------------------------------------

-- Setting this to true will stop the text spam, and instead display modes in a /UI.
-- Currently in construction.
use_UI = true
hud_x_pos = 1765    --important to update these if you have a smaller screen
hud_y_pos = 300     --important to update these if you have a smaller screen
hud_draggable = true
hud_font_size = 10
hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
hud_font = 'Impact'


-- Setup your Key Bindings here:
	windower.send_command('bind insert gs c nuke cycle')        -- insert to Cycles Nuke element
	windower.send_command('bind delete gs c nuke cycledown')    -- delete to Cycles Nuke element in reverse order   
	windower.send_command('bind f9 gs c toggle idlemode')       -- F9 to change Idle Mode    
	windower.send_command('bind f8 gs c toggle meleemode')      -- F8 to change Melee Mode  
	windower.send_command('bind !f9 gs c toggle melee') 		-- Alt-F9 Toggle Melee mode on / off, locking of weapons
	windower.send_command('bind !f8 gs c toggle mainweapon')	-- Alt-F8 Toggle Main Weapon
	windower.send_command('bind ^f8 gs c toggle subweapon')		-- CTRL-F8 Toggle sub Weapon.
	windower.send_command('bind !` input /ma Stun <t>') 		-- Alt-` Quick Stun Shortcut.
	windower.send_command('bind home gs c nuke enspellup')		-- Home Cycle Enspell Up
	windower.send_command('bind PAGEUP gs c nuke enspelldown')  -- PgUP Cycle Enspell Down
	windower.send_command('bind ^f10 gs c toggle mb')           -- F10 toggles Magic Burst Mode on / off.
	windower.send_command('bind !f10 gs c toggle nukemode')		-- Alt-F10 to change Nuking Mode
	windower.send_command('bind F10 gs c toggle matchsc')		-- CTRL-F10 to change Match SC Mode      	
	windower.send_command('bind !end gs c hud lite')            -- Alt-End to toggle light hud version       
	windower.send_command('bind ^end gs c hud keybinds')        -- CTRL-End to toggle Keybinds  
	windower.send_command('bind f11 parse report damage p')
	windower.send_command('bind ^f11 parse reset')
	send_command('unbind ^r')
	
--[[
    This gets passed in when the Keybinds is turned on.
    IF YOU CHANGED ANY OF THE KEYBINDS ABOVE, edit the ones below so it can be reflected in the hud using the "//gs c hud keybinds" command
]]
keybinds_on = {}
keybinds_on['key_bind_idle'] = '(F9)'
keybinds_on['key_bind_melee'] = '(F8)'
keybinds_on['key_bind_casting'] = '(ALT-F10)'
keybinds_on['key_bind_mainweapon'] = '(ALT-F8)'
keybinds_on['key_bind_subweapon'] = '(CTRL-F8)'
keybinds_on['key_bind_element_cycle'] = '(INS + DEL)'
keybinds_on['key_bind_enspell_cycle'] = '(HOME + PgUP)'
keybinds_on['key_bind_lock_weapon'] = '(ALT-F9)'
keybinds_on['key_bind_matchsc'] = '(F10)'

send_command('lua l gearinfo')
send_command('lua l equipviewer')
send_command('lua l parse')
send_command('gs c hud hidejob')

-- Remember to unbind your keybinds on job change.
function user_unload()
    send_command('unbind insert')
    send_command('unbind delete')	
    send_command('unbind f9')
    send_command('unbind !f9')
    send_command('unbind f8')
    send_command('unbind !f8')
    send_command('unbind ^f8')
    send_command('unbind f10')
    send_command('unbind f12')
    send_command('unbind !`')
    send_command('unbind home')
    send_command('unbind !f10')	
    send_command('unbind `f10')
    send_command('unbind !end')  
    send_command('unbind ^end')  	
	send_command('lua u gearinfo')
	send_command('lua u equipviewer')
	send_command('lua u parse')
	send_command('unbind f11 parse reset')
	send_command('unbind ^f11 parse reset')
end

include('BLM_Lib.lua')

-- Optional. Swap to your sch macro sheet / book
set_macros(1,1) -- Sheet, Book
send_command('wait 10;input /lockstyleset 1')
refreshType = idleModes[1] -- leave this as is  
  
function sub_job_change(new,old)
send_command('wait 10;input /lockstyleset 1')
end
-- Setup your Gear Sets below:
function get_sets()
--///////////////////
--Gear Sets
--///////////////////
	--This creates a constant of whole armor sets, so that when you upgrade a piece, its much simpler, 
	--and upgrades that piece through all of your sets. 
	--ADD +1/2 TO ARMOR SET TO UPGRADE IT. 
	--ADD NEW .TYPE TO CREATE AUGMENT VARIATIONS OF THE SAME PIECE. 
	--EG. SUC.TP ={name="",augments={}}
	--SOME ARMOR SETS USE ABREVIATIONS FOR THEIR +1/2/3 VARIANTS. 
	--MAKE SURE YOU USE THE ABREVIATED FORMAT. E.G "Atro. Chapeau +1"
--------------------
--//////////////////
--JSE GEAR
--//////////////////		
--------------------
	JSE = {}		--Leave This Empty
		JSE.WSD = {}
			JSE.WSD.MNDMAG 	= {}
			JSE.WSD.STRATK 	= {}
			JSE.WSD.DEXMAG 	= {}
			JSE.WSD.AGIATK 	= {}
		JSE.MAG = {}
			JSE.MAG.NUKE 	= {}
			JSE.MAG.CURE 	= {}
			JSE.MAG.FAST 	= {}
			JSE.MAG.MND 	= {}
			JSE.MAG.INT 	= {}
		JSE.MELEE = {}
			JSE.MELEE.STP 	= {}
			JSE.MELEE.DW 	= {}
			JSE.MELEE.CRIT 	= {}


--SETS
--Leave weapons out of the idles and melee sets. You can/should add weapons to the casting sets though
--delete or remark '--' out any empty slots or else the gs will remove those slots when using that set
---------------
--GENERIC SETS
---------------
    sets.me = {}        		-- leave this empty
	sets.buff = {} 				-- leave this empty
    sets.me.idle = {}			-- leave this empty
    sets.me.melee = {}          -- leave this empty
    sets.weapons = {}			-- leave this empty
--//////////////
--IDLE SETS
--//////////////	
	--USE HOTKEY TO CYCLE IDLE SETS BASED ON CONTENT. 
	--USE PDT/MDT IF FACING AN AOE HAZARD AS A CASTER. 
	--USE REFRESH ALL OTHER TIMES. 	
	--DT/PDT/MDT/BDT CAP AT 50%
	--DT IS ADDITIVE TO PDT/MDT/BDT TOTALS
	--EG: 20DT+30PDT = 50%PDT, WHICH IS THE CAP. 
---------------
--[IDLE]-[Mana Wall Override]
---------------
	-- Overrides all melee and idle slots with this gear when manawall is active. only use relevant gear to mana wall
	sets.ManaWall={left_ear="Ethereal Earring", feet = "Mallquis Clogs +2"}
---------------
--[IDLE]-[REFRESH]-[NORMAL]
---------------
 	sets.me.idle.refresh = {
		ammo="Staunch Tathlum",
		head="Befouled Crown",
		body="Jhakri Robe +2",
		hands="Nyame Gauntlets",
		legs="Assid. Pants +1",
		feet={ name="Merlinic Crackows", augments={'DEX+8','Crit. hit damage +1%','"Refresh"+1','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		neck="Warder's Charm",
		waist="Carrier's Sash",
		left_ear="Eabani Earring",
		right_ear="Tuisto Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back="Moonbeam Cape",
	}		

---------------
--[IDLE]-[REFRESH]-[PDT]
---------------
	sets.me.idle.dt = {
		ammo="Staunch Tathlum",
		head="Nyame Helm",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Agwu's Gages",
		legs="Nyame Flanchard",
		feet="Mallquis Clogs +2",
		neck="Loricate Torque +1",
		waist="Carrier's Sash",
		left_ear="Etiolation Earring",
		right_ear="Eabani Earring",
		left_ring="Defending Ring",
		right_ring="Warden's Ring",
		back="Moonbeam Cape",
	}

---------------
--[RESTING]
---------------
    sets.me.resting = {}
---------------
--[LATENT]-[REFRESH]
---------------
    sets.me.latent_refresh = {waist="Fucho-no-obi"}  

--//////////////
--MELEE SETS
--//////////////
	--USE HOTKEY TO CYCLE MELEE SETS BASED ON CONTENT. 
	--USE ACC WHEN YOU CANT HIT, AND PDT/MDT IF FACING AN AOE HAZARD	
	--DT/PDT/MDT/BDT CAP AT 50%
		--DT IS ADDITIVE TO PDT/MDT/BDT TOTALS
		--EG: 20DT+30PDT = 50%PDT, WHICH IS THE CAP. 
	--NOTE:DONT DISCOUNT SWORD AND BOARD SUB PLD/WAR/BLU TANKING, OR /THF FARMING. 
		--WE GET A STUPID POWERFUL SHIELD IN THE BEATIFIC SHIELD, WHICH GIVES +25%MDT, AND BLOCK RATES. 
		--WE CAN EASILY SIT AT CAPPED REDUCTION WITHOUT HURTING OUR ABILITY TO PERFORM MUCH.

---------------	
--[MELEE]-[DUALWIELD]-[NORMAL]
---------------
    sets.me.melee.FullHastedw = {
		ammo="Amar Cluster",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Asperity Necklace",
		waist="Witful Belt",
		left_ear="Telos Earring",
		right_ear="Brutal Earring",
		left_ring="Chirich Ring +1",
		right_ring="Chirich Ring +1",
		back="Moonbeam Cape",
		}
---------------
--[MELEE]-[DUALWIELD]-[PDT]
---------------
    sets.me.melee.dtdw = set_combine(sets.me.melee.FullHastedw,{
	
    })

---------------
--[MELEE]-[SWORD&BOARD]-[NORMAL]
---------------
    sets.me.melee.FullHastesw = set_combine(sets.me.melee.FullHastedw,{   

    })

---------------
--[MELEE]-[SWORD&BOARD]-[PDT]
---------------
    sets.me.melee.dtsw = set_combine(sets.me.melee.dtdw,{

    })

--/////////////////
--WEAPONSKILL SECTION
--/////////////////
	--ALL WEAPONSKILLS USE ATTACK, OR MAGIC ATTACK. IT IS LISTED IN THE MODIFIERS SECTION
	--IF A WEAPONSKILL TRANSFERS fTP ACROSS ALL HITS, IT WILL LIST GORGET IN THE MODIFIERS SECTION, THE GORGET MATCHES ANY ELIGIBLE ELEMENTS	
	sets.me.STRWSD = {
		ammo="Amar Cluster",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs="Nyame Flanchard",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back="Moonbeam Cape",	
	}
	sets.me["Brainshaker"] = set_combine(sets.me.STRWSD , {})
	sets.me["Skullbreaker"] = set_combine(sets.me.STRWSD , {})
	sets.me["Black Halo"] = set_combine(sets.me.STRWSD , {})
	sets.me["Realmrazer"] = set_combine(sets.me.STRWSD , {})
	sets.me["Heavy Swing"] = set_combine(sets.me.STRWSD , {})
	sets.me["Full Swing"] = set_combine(sets.me.STRWSD , {})	
	sets.me["Retribution"] = set_combine(sets.me.STRWSD , {})	
		
	sets.me.INTWSD = {
		ammo="Amar Cluster",
		head={ name="Blistering Sallet +1", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Jhakri Cuffs +2",
		legs="Nyame Flanchard",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Epaminondas's Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back="Moonbeam Cape",	
	}	
    sets.me["Shattersoul"] = set_combine(sets.me.INTWSD, {})
    sets.me["Spirit Taker"] = set_combine(sets.me.INTWSD, {})
		
	sets.me.MAGWS = {
		ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back="Aurist's Cape +1",	
	}
    sets.me["Rock Crusher"] = set_combine(sets.me.MAGWS, {})
    sets.me["Earth Crusher"] = set_combine(sets.me.MAGWS, {})
    sets.me["Sunburst"] = set_combine(sets.me.MAGWS, {})
	sets.me["Starburst"] = set_combine(sets.me.MAGWS, {})
	sets.me[""] = set_combine(sets.me.MAGWS, {})
    sets.me["Cataclysm"] = set_combine(sets.me.MAGWS, {})
    sets.me["Vidohunir"] = set_combine(sets.me.INTWSD, {})

    sets.me["Energy Steal"] = {
		ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back="Aurist's Cape +1",
    }

--////////////////
--Spellcasting sets
--////////////////
---------------
--[CASTING SETS]
---------------
    sets.precast = {}   			--Leave This Empty
    sets.midcast = {}    			--Leave This Empty
    sets.aftercast = {}  			--Leave This Empty
    sets.midcast.nuking = {}		--Leave This Empty
    sets.midcast.MB	= {}			--Leave This Empty  
    sets.midcast.enhancing = {} 	--Leave This Empty
	sets.midcast.Enfeebling = {} 	--Leave This Empty
	sets.midcast.cure = {} 			--Leave This Empty
	
---------------
--[PRECASTING]-[FAST CAST]
--[FAST CAST]: +30TRAIT|+8GIFT|GEAR NEEDS MIN+42 MAX+50, REDUCE FOR GIFTS
--	[TRAIT TOTAL]	: +30
--	[GIFT TOTAL]	: +0
--	[GEAR TOTAL]	: +50 (Exactly at cap)
--[RECAST] - RECAST CAPS AT 80%
--	[TRAIT TOTAL]			: +15
--	[GIFT TOTAL]			: +0
--	[GEAR HASTE TOTAL]		: +22
--	[GEAR FAST CAST TOTAL]	: +25
--	[MAGIC HASTE2]			: +30
--	[GRAND TOTAL]			: +92 (overcapped by 10)
--WITH MAX FAST CAST GIFTS, GEAR, AND SPELL HASTE, YOU NEED 20 HASTE ON YOUR GEAR TO CAP RECASTING TIME
--RECASTING TIME ONLY BENEFITS SPELLS WITH NO DIRECT MODIFIERS, LIKE UTSUSEMI. IT IS POSSIBLE TO GET A 9 SECOND RECAST ON UTSU NI. 
--NON MOD SPELLS DEFAULT TO PRECASTING FOR THEIR MIDCASTING SETS
--TL/DR GET 20-24 HASTE, AND CAP FASTCAST ON THIS SET NO MATTER WHAT. 
---------------
    sets.precast.casting = {
		main={ name="Grioavolr", augments={'"Conserve MP"+10',}},
		sub="Kaja Grip",
		ammo="Sapience Orb",
		head="C. Palug Crown",
		body="Zendik Robe",
		hands="Agwu's Gages",
		legs="Agwu's Slops",
		feet="Agwu's Pigaches",
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Rahab Ring",
		back="Aurist's Cape +1",
    }											
---------------
--[PRECASTING]-[STUN]
--LEAVE THIS BLANK. THIS FORCES YOU BACK INTO YOUR FAST CAST SET
---------------
    sets.precast["Stun"] = set_combine(sets.precast.casting,{})
    sets.precast["Dispelga"] = set_combine(sets.precast.casting,{main = "Daybreak",})
	sets.precast.Impact = {body="Twilight Cloak"}
---------------
--[PRECASTING]-[ENHANCING]
--LEAVE THIS BLANK UNLESS USING AN ENHANCING MAGIC SPELL CASTING TIME DOWN PIECE IN PLACE OF FAST CAST
---------------
    sets.precast.enhancing = set_combine(sets.precast.casting,{})
---------------
--[PRECASTING]-[STONESKIN]
--LEAVE THIS BLANK UNLESS USING A STONESKIN SPELL CASTING TIME DOWN PIECE IN PLACE OF FAST CAST
---------------
    sets.precast.stoneskin = set_combine(sets.precast.enhancing,{})
---------------
--[PRECASTING]-[CURE]
--LEAVE THIS BLANK UNLESS USING A CURE SPELL CASTING TIME DOWN PIECE IN PLACE OF FAST CAST
---------------
    sets.precast.cure = set_combine(sets.precast.casting,{})

--//////////////////
--MIDCASTING
--EACH SET IN THIS GROUP NEEDS TO BE TAILORED TO MATCH WHAT YOU ARE DOING. IF A PIECE IS LEFT UNSPECIFIED, IT WILL DEFAULT
--TO THE GENERIC CASTING SET FOR THAT SLOT. A RECOMMENDED STRATEGY IS TO SET THIS SET TO 'CONSERVE MP' TO CATCH SPELLS THAT DO NOT
--HAVE A SPECIFIED CASTING SET ATTACHED TO THEM TO MINIMIZE THEIR MP DRAIN
--EG. SPELLS LIKE BLINK	
	
	sets.midcast.Impact= {

	}
---------------
--[MIDCASTING]-[ELEMENTAL OBI]
--USE THIS IF YOU HAVE YOUR OBI
---------------
    sets.midcast.Obi = {Waist = "Hachirin-no-obi"}
---------------
--[MIDCASTING]-[ORPHEUS SASH]
--USE THIS IF USING AN ORPHEUS SASH
---------------
    sets.midcast.Orpheus = {waist = "Orpheus's Sash"}  
---------------
--[MIDCASTING]-[HELIX]
--DONT USE ELEMENTAL OBI'S FOR THIS SPELL CLASS. SELECT AN INT/MAB BELT
---------------
    sets.midcast.DarkHelix = {}
---------------
--[MIDCASTING]-[DEFAULT]
--GENERAL CASTING - WILL BE THE DEFAULT SET UNLESS SPELL BEING CAST IS A PART OF ANOTHER SPECIFIED GROUP.
--EG. GETS REPLACED BY ANY SPELLS IN THE NUKING CATEGORY WITH THE NUKING NORMAL SET. 
---------------
    sets.midcast.casting = {
		main={ name="Grioavolr", augments={'"Conserve MP"+10',}},
		sub="Kaja Grip",
		ammo="Sapience Orb",
		head="C. Palug Crown",
		body="Zendik Robe",
		hands="Agwu's Gages",
		legs="Agwu's Slops",
		feet="Agwu's Pigaches",
		neck="Orunmila's Torque",
		waist="Embla Sash",
		left_ear="Malignance Earring",
		right_ear="Loquac. Earring",
		left_ring="Kishar Ring",
		right_ring="Rahab Ring",
		back="Aurist's Cape +1",
    }
	sets.midcast.StatusRemoval={}
---------------
--[MIDCASTING]-[NUKING]
---------------
    sets.midcast.nuking.normal = {
		main="Bunzi's Rod", 
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="C. Palug Crown",
		body={ name="Amalric Doublet +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		legs={ name="Amalric Slops +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Baetyl Pendant",
		waist="Orpheus's Sash",
		left_ear="Malignance Earring",
		right_ear="Regal Earring",
		left_ring="Freke Ring",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back="Aurist's Cape +1",
	}
	sets.midcast.aja=set_combine(sets.midcast.nuking.normal,{})
---------------
--[MIDCASTING]-[MAGIC BURSTING]
--USES MAGIC BURST PIECES WHEN CASTING A MAGIC BURST. 
--USE F10 TO TURN ON MAGIC BURSTING. THIS WILL TURN OFF NORMAL NUKING, 
--SHOULD ONLY BE USED IF PURELY BURSTING. ALL OTHER SITUATIONS KEEP IT OFF. 
--RECCOMENDED TO SWAP INTO A STAFF IF DOING FULL BURSTING OFF OF YOUR OWN SC. 
--GS WILL AUTO RE-EQUIP MELEE WEAPONS AFTER CAST. 
---------------
    sets.midcast.MB.normal = set_combine(sets.midcast.nuking.normal, {
		main="Bunzi's Rod",  --10/0
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Ea Hat +1", --7/7
		body="Ea Houppe. +1", --9/9
		hands={ name="Amalric Gages +1", augments={'INT+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},--0/6
		legs="Ea Slops +1", --8/8
		feet={ name="Amalric Nails +1", augments={'MP+80','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		neck="Mizu. Kubikazari",--10/0
		waist="Orpheus's Sash",
		left_ear="Regal Earring",
		right_ear="Malignance Earring",
		left_ring="Freke Ring",
		right_ring="Mujin Band",--0/5
		back="Aurist's Cape +1",
	 })

    sets.midcast.MB.Accumen = {

	 }
---------------
--[MIDCASTING]-[MAGIC ACCURACY]
--USE THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.nuking.acc = set_combine(sets.midcast.nuking.normal,{
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
	})
---------------
--[MIDCASTING]-[MAGIC BURSTING MAGIC ACCURACY]
-- SEE MAGIC BURST SET FOR DETAILS. 
--USES THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.MB.acc = set_combine(sets.midcast.nuking.acc, {
		left_ring	= {name="Stikini Ring +1", bag="wardrobe2"},
		right_ring	= {name="Stikini Ring +1", bag="wardrobe7"},
    })	
	sets.midcast.ElementalEnfeeble={
	
	}
---------------
--[MIDCASTING]-[DRAIN]
---------------
    sets.midcast["Drain"] = {
		main={ name="Rubicundity", augments={'Mag. Acc.+9','"Mag.Atk.Bns."+8','Dark magic skill +9','"Conserve MP"+5',}},
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
		head="Pixie Hairpin +1",
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+13','"Drain" and "Aspir" potency +11','"Mag.Atk.Bns."+13',}},
		hands={ name="Merlinic Dastanas", augments={'"Drain" and "Aspir" potency +10','Mag. Acc.+2','"Mag.Atk.Bns."+13',}},
		legs="Agwu's Slops",
		feet="Agwu's Pigaches",
		neck="Erra Pendant",
		waist="Fucho-no-Obi",
		left_ear="Hirudinea Earring",
		right_ear="Regal Earring",
		left_ring="Defending Ring",
		right_ring="Evanescence Ring",
	}
---------------
--[MIDCASTING]-[ASPIR]
---------------
    sets.midcast["Aspir"] = sets.midcast["Drain"]
---------------
--[MIDCASTING]-[ENFEEBLING MAGIC ACCURACY]
---------------
	
    sets.midcast.Enfeebling.Dia = {

	}
    sets.midcast.Bio = {


    }
------------------------------------------
--------------[PURE ACC]------------------
    sets.midcast.Enfeebling.Dispel = {

    }	
    sets.midcast.Enfeebling.Dispelga = {

    }	
	sets.midcast["Stun"] = set_combine(sets.midcast.Enfeebling.Dispel,{})
    sets.midcast.Enfeebling.FrazzleII = set_combine(sets.midcast.Enfeebling.Dispel,{})
    sets.midcast.Enfeebling.Silence = set_combine(sets.midcast.Enfeebling.Dispel,{})
------------------------------------------
---------[MND + ACC + POTENCY]------------
    sets.midcast.Enfeebling.Addle = {

    }
    sets.midcast.Enfeebling.Paralyze = set_combine(sets.midcast.Enfeebling.Addle,{})
    sets.midcast.Enfeebling.Slow = set_combine(sets.midcast.Enfeebling.Addle,{})
    sets.midcast.Enfeebling.Blind = {

	}
------------------------------------------
-------------[MND + POTENCY]--------------	
		
    sets.midcast.Enfeebling.Distract = {

    }	
-------------------------------------------
---------[INT + Skill + DURATION]----------
    sets.midcast.Enfeebling.Poison = {

    }	
-------------------------------------------
-------------[INT + DURATION]--------------		
    sets.midcast.Enfeebling.Bind = {

    }	
    sets.midcast.Enfeebling.Sleep 	= set_combine(sets.midcast.Enfeebling.Bind,{})
    sets.midcast.Enfeebling.Break 	= set_combine(sets.midcast.Enfeebling.Bind,{})
    sets.midcast.Enfeebling.Gravity = set_combine(sets.midcast.Enfeebling.Bind,{})
	
---------------
--[MIDCASTING]-[ENHANCING DURATION (SELF)]
---------------
    sets.midcast.enhancing.duration = {

    }
---------------
--[MIDCASTING]-[ENHANCING POTENCY (SELF)]
---------------
    sets.midcast.enhancing.potency = set_combine(sets.midcast.enhancing.duration, {

    })

---------------
--[MIDCASTING]-[PHALANX]
--TAEON CAN BE AUGMENTED WITH +1-3 PHALANX USING DUSKDIM STONES. 
--+15PHALANX CAN LET YOU IMMORTAL MODE TRASH MOBS. 
--PHALANX CAPS AT -35 DAMAGE FROM SKILL. THIS LETS YOU GET -50 DAMAGE, AND BE BASICALLY IMMORTAL TO 
--MOST TRASH UP TO AND INCLUDING ESCHA ZITAH IF USING A PDT SET. CAN LET YOU TAKE AS LITTLE AS 50 DAMAGE FROM EVEN APEX MOBS.  
---------------
    sets.midcast.phalanx ={

    }
---------------
--[MIDCASTING]-[STONESKIN]
---------------
    sets.midcast.stoneskin = set_combine(sets.midcast.enhancing.duration, {
		neck="Nodens Gorget",
		right_ear="Earthcry Earring",	
	})
---------------
--[MIDCASTING]-[REFRESH]
--HUGELY IMPORTANT. CAN GET REFRESH3 TO ABSURD LEVELS OF RECOVERY
---------------
    sets.midcast.refresh = set_combine(sets.midcast.enhancing.duration, {

    })
---------------
--[MIDCASTING]-[AQUAVEIL]
---------------
    sets.midcast.aquaveil = set_combine(sets.midcast.refresh, {hands = "Regal Cuffs"})
---------------
--[MIDCASTING]-[Protect]
---------------
    sets.midcast.protect = set_combine(sets.midcast.enhancing.duration, {right_ring="Sheltered Ring"})
---------------
--[MIDCASTING]-[SHELL]
---------------
    sets.midcast.shell = set_combine(sets.midcast.enhancing.duration, {right_ring="Sheltered Ring"})
---------------
--[MIDCASTING]-[CURE]
--CURE POTENCY CAPS AT 50%. 
--PRIORITIZE HEALING MAGIC SKILL > CURE POTENCY. RDMS HEALING MAGIC IS VERY LOW. 
--BECAUSE CURE POT IS A % INCREASE, IT PERFORMS BETTER IF WE INCREASE ITS BASE VALUE THROUGH HEALING SKILL. 
---------------
    sets.midcast.cure.normal = {

    }
---------------
--[MIDCASTING]-[CURE WEATHER]
---------------
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{main="Iridal Staff", sub="Enki Strap", waist= "Hachirin-no-obi"})  

sets.midcast.cure.normal.self={

	}
sets.midcast.cure.weather.self = set_combine(sets.midcast.cure.normal.self,{main="Iridal Staff", sub="Enki Strap", waist= "Hachirin-no-obi"}) 
---------------
--[MIDCASTING]-[REGEN+]
--RDM ONLY GETS REGEN 2. NEED TO MAX OUT ITS POWER USING GEAR
--BOLELABUNGA GIVES +10%
--TELCHINE BODY GIVES +12 SECONDS (EXTENDED UNDER COMPOSURE)
--TELCHINE GIVES +3 POTENCY AUGMENT PER PIECE USING DUSKDIM AUGMENTATION, FOR +15 TOTAL HP
--RDM CAN GET REGEN 2 UP TO 30 HP PER TIC, WHICH IS INCREDIBLY STRONG - ALMOST AS STRONG AS A FULL POWER REGEN 5  
---------------
	sets.midcast.Regen = {    

	}

    sets.buff.Doom = {
        neck="Nicander's Necklace", --20
        ring1="Purity ring",	--7
        ring2="Ephedra ring",
        waist="Gishdubar Sash", --10
        }
	sets.midcast.BlueCure={}
	sets.midcast.BlueENH={}
	sets.midcast.BlueACC={}
	sets.midcast.BlueNuke={}
end