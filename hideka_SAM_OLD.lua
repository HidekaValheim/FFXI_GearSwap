 include('organizer-lib') -- optional
res = require('resources')
texts = require('texts')
include('Modes.lua')

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes = M('REGAIN','DT','REGEN')
meleeModes = M('NORMAL','HYBRID','LOWACC','HIGHACC')
nukeModes = M('normal', 'acc')

------------------------------------------------------------------------------------------------------
-- Important to read!
------------------------------------------------------------------------------------------------------
-- This will be used later down for weapon combos, here's mine for example, you can add your REMA+offhand of choice in there
-- Add you weapons in the Main list and/or sub list.
-- Don't put any weapons / sub in your IDLE and ENGAGED sets'
-- You can put specific weapons in the midcasts and precast sets for spells, but after a spell is 
-- cast and we revert to idle or engaged sets, we'll be checking the following for weapon selection. 
-- Defaults are the first in each list
mainWeapon = M('Masamune','Shining One', 'Norifusa +1')
subWeapon = M('Utu grip')
------------------------------------------------------------------------------------------------------

----------------------------------------------------------
-- Auto CP Cape: Will put on CP cape automatically when
-- fighting Apex mobs and job is not mastered
----------------------------------------------------------
CP_CAPE ={name="Mecisto. Mantle", augments={'Cap. Point+48%','DEX+3','DEF+3',}} -- Put your CP cape here
DYNA_NECK = "Samurai's Nodowa +2"
----------------------------------------------------------

-- Setting this to true will stop the text spam, and instead display modes in a /UI.
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
end

include('SAM_Lib.lua')

-- Optional. Swap to your sch macro sheet / book
set_macros(1,12) -- Sheet, Book
send_command('wait 10;input /lockstyleset 11')
refreshType = idleModes[1] -- leave this as is  
   
function sub_job_change(new,old)
send_command('wait 10;input /lockstyleset 2')
end
-- Setup your Gear Sets below:
function get_sets()
sets.me = {}        		-- leave this empty
sets.buff = {} 				-- leave this empty
sets.me.idle = {}			-- leave this empty
sets.me.melee = {}          -- leave this empty
sets.weapons = {}			-- leave this empty

	sets.me.idle.REGAIN = {
		ammo="Staunch Tathlum +1",
		head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+21','"Dbl.Atk."+3','Pet: INT+8','Pet: Accuracy+3 Pet: Rng. Acc.+3',}},
		body="Sacro Breastplate",
		hands={ name="Rao Kote +1", augments={'Accuracy+12','Attack+12','Evasion+20',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Rao Sune-Ate +1", augments={'HP+65','Crit. hit rate+4%','"Dbl.Atk."+4',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Infused Earring",
		right_ear="Tuisto Earring",
		left_ring="Defending Ring",
		right_ring="Gelatinous Ring +1",
		back="Moonbeam Cape",
	}

---------------
--[IDLE]-[REFRESH]-[REGEN]
---------------
	sets.me.idle.REGEN = {
		ammo="Staunch Tathlum +1",
		head={ name="Valorous Mask", augments={'Pet: "Mag.Atk.Bns."+21','"Dbl.Atk."+3','Pet: INT+8','Pet: Accuracy+3 Pet: Rng. Acc.+3',}},
		body="Sacro Breastplate",
		hands={ name="Rao Kote +1", augments={'Accuracy+12','Attack+12','Evasion+20',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Rao Sune-Ate +1", augments={'HP+65','Crit. hit rate+4%','"Dbl.Atk."+4',}},
		neck={ name="Bathy Choker +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Infused Earring",
		right_ear="Tuisto Earring",
		left_ring="Defending Ring",
		right_ring="Gelatinous Ring +1",
		back="Moonbeam Cape",
	}	
---------------
--[IDLE]-[REFRESH]-[DT]
---------------
	sets.me.idle.DT = {
		ammo="Staunch Tathlum +1",
		head={ name="Nyame Helm", augments={'Path: B',}},
		body="Sacro Breastplate",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Plat. Mog. Belt",
		left_ear="Odnowa Earring +1",
		right_ear="Tuisto Earring",
		left_ring="Defending Ring",
		right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
		back="Moonbeam Cape",
	}	
---------------
--[RESTING]
---------------
    sets.me.resting = { 

    }
---------------
--[LATENT]-[REFRESH]
---------------
    sets.me.latent_refresh = {}  

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

    sets.me.melee.NORMALdw ={
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Kasuga Kabuto +2",
		body="Kasuga Domaru +2",
		hands="Tatena. Gote +1",
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet="Ryuo Sune-Ate +1",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Sweordfaetels +1",
		left_ear="Dedition Earring",
		right_ear="Crep. Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Lehko's Ring",
		back="Moonbeam Cape",	
	}
    sets.me.melee.LOWACCdw ={}
    sets.me.melee.HIGHACCdw ={}
    sets.me.melee.HYBRIDdw = {}

    sets.me.melee.NORMALsw 	= {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Kasuga Kabuto +2",
		body="Kasuga Domaru +2",
		hands="Tatena. Gote +1",
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet="Ryuo Sune-Ate +1",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Sweordfaetels +1",
		left_ear="Dedition Earring",
		right_ear="Crep. Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Lehko's Ring",
		back="Moonbeam Cape",	
	}
    sets.me.melee.LOWACCsw 	= {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Kasuga Kabuto +2",
		body="Kasuga Domaru +2",
		hands="Tatena. Gote +1",
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet="Ryuo Sune-Ate +1",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Sweordfaetels +1",
		left_ear="Schere Earring",
		right_ear="Crep. Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Lehko's Ring",
		back="Moonbeam Cape",		
	}
    sets.me.melee.HIGHACCsw	= {
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head="Kasuga Kabuto +2",
		body="Kasuga Domaru +2",
		hands="Tatena. Gote +1",
		legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
		feet="Ryuo Sune-Ate +1",
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist="Ioskeha Belt +1",
		left_ear="Schere Earring",
		right_ear="Crep. Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Lehko's Ring",
		back="Moonbeam Cape",	
	}
    sets.me.melee.HYBRIDsw 	= {}
	
--/////////////////
--WEAPONSKILL SECTION
--/////////////////
	--ALL WEAPONSKILLS USE ATTACK, OR MAGIC ATTACK. IT IS LISTED IN THE MODIFIERS SECTION
	--IF A WEAPONSKILL TRANSFERS fTP ACROSS ALL HITS, IT WILL LIST GORGET IN THE MODIFIERS SECTION, THE GORGET MATCHES ANY ELIGIBLE ELEMENTS	
---------------
--[WEAPONSKILL]
---------------
	sets.me["Tachi: Fudo"] = {
		ammo="Knobkierrie",
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist={ name="Sailfi Belt +1", augments={'Path: A',}},
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back="Moonbeam Cape",
    }
	sets.me["Tachi: Kasha"] 	= set_combine(sets.me["Tachi: Fudo"],{})
	sets.me["Tachi: Gekko"] 	= set_combine(sets.me["Tachi: Fudo"],{})
	sets.me["Tachi: Yukikaze"]  = set_combine(sets.me["Tachi: Fudo"],{})
	
	
	sets.me["Tachi: Shoha"] 	= set_combine(sets.me["Tachi: Fudo"],{left_ring="Niqmaddu Ring"})
	sets.me["Tachi: Rana"] 		= set_combine(sets.me["Tachi: Fudo"],{left_ring="Niqmaddu Ring"})
	sets.me["Tachi: Ageha"] 	= {
		ammo="Pemphredo Tathlum",
		head="Kasuga Kabuto +2",
		body="Kasuga Domaru +2",
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Gwati Earring",
		right_ear="Crep. Earring",
		left_ring="Stikini Ring +1",
		right_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
		back="Moonbeam Cape",	
	}
	sets.me["Tachi: Jinpu"] 	= {
		ammo="Knobkierrie",
		head= "Nyame Helm",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands={ name="Nyame Gauntlets", augments={'Path: B',}},
		legs={ name="Nyame Flanchard", augments={'Path: B',}},
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Sam. Nodowa +2", augments={'Path: A',}},
		waist= "Orpheus Sash",
		left_ear= "Friomisi Earring",
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Regal Ring",
		right_ring="Epaminondas's Ring",
		back="Moonbeam Cape",	
	}	
	sets.me["Tachi: Koki"] 		= set_combine(sets.me["Tachi: Jinpu"],{})
	sets.me["Tachi: Kagero"] 	= set_combine(sets.me["Tachi: Jinpu"],{})
	sets.me["Tachi: Goten"] 	= set_combine(sets.me["Tachi: Jinpu"],{})
	
	sets.me["Stardiver"] = {		
		ammo={ name="Coiste Bodhar", augments={'Path: A',}},
		head={ name="Mpaca's Cap", augments={'Path: A',}},
		body={ name="Mpaca's Doublet", augments={'Path: A',}},
		hands={ name="Mpaca's Gloves", augments={'Path: A',}},
		legs={ name="Mpaca's Hose", augments={'Path: A',}},
		feet={ name="Mpaca's Boots", augments={'Path: A',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear={ name="Schere Earring", augments={'Path: A',}},
		right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Regal Ring",
		back="Moonbeam Cape",
    }
	sets.me["Impulse Drive"] = set_combine(sets.me["Tachi: Fudo"],{})
	sets.me["Sonic Thrust"] =set_combine(sets.me["Tachi: Fudo"],{})
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
	
--WARRIOR ABILITIES
	sets.precast["Provoke"] = {}
	sets.precast["Warcry"] = {}
	sets.precast["Berserk"] = {}
	sets.precast["Aggressor"] = {}
--DRAGOON ABILITIES
	sets.precast["Jump"] = {}
	sets.precast["High jump"] = {}
	sets.precast["Ancient Circle"] = {}
--DANCER ABILITIES
	sets.precast["Curing Waltz"] = {}
	sets.precast["Curing Waltz II"] = {}
	sets.precast["Curing Waltz III"] = {}
	sets.precast["Healing Waltz"] = {}
	sets.precast["Divine Waltz"] = {}
	sets.precast["Box Step"] = {}
	sets.precast["Quick Step"] = {}
	sets.precast["Violent Flourish"] = {}
	sets.precast["Animated Flourish"] = {}
--SAMURAI ABILITIES
	sets.precast["Mekiyo Shisui"] = {}
	sets.precast["Hasso"] = {}
	sets.precast["Seigan"] = {}
	sets.precast["Third Eye"] = {}
	sets.precast["Meditate"] = {}
	sets.precast["Warding Circle"] = {}
	sets.precast["Blade Bash"] = {}
	sets.precast["Sekkanoki"] = {}
	sets.precast["Konzen-ittai"] = {}
	sets.precast["Shikikoyo"] = {}
	sets.precast["Sengikori"] = {}
	sets.precast["Hamanoha"] = {}
	sets.precast["Hagakure"] = {}
	sets.precast["Yaegasumi"] = {}
	--WARRIOR ABILITIES
    sets.midcast["Provoke"] = {}
    sets.midcast["Warcry"] = {}
    sets.midcast["Berserk"] = {}
    sets.midcast["Aggressor"] = {}
--DRAGOON ABILITIES
    sets.midcast["Jump"] = {}
    sets.midcast["High jump"] = {}
    sets.midcast["Ancient Circle"] = {}
--DANCER ABILITIES
    sets.midcast["Curing Waltz"] = {}
    sets.midcast["Curing Waltz II"] = {}
    sets.midcast["Curing Waltz III"] = {}
    sets.midcast["Healing Waltz"] = {}
    sets.midcast["Divine Waltz"] = {}
    sets.midcast["Box Step"] = {}
    sets.midcast["Quick Step"] = {}
    sets.midcast["Violent Flourish"] = {}
    sets.midcast["Animated Flourish"] = {}
--SAMURAI ABILITIES
    sets.midcast["Mekiyo Shisui"] = {}
    sets.midcast["Hasso"] = {}
    sets.midcast["Seigan"] = {}
    sets.midcast["Third Eye"] = {}
    sets.midcast["Meditate"] = {}
    sets.midcast["Warding Circle"] = {}
    sets.midcast["Blade Bash"] = {}
    sets.midcast["Sekkanoki"] = {}
    sets.midcast["Konzen-ittai"] = {}
    sets.midcast["Shikikoyo"] = {}
    sets.midcast["Sengikori"] = {}
    sets.midcast["Hamanoha"] = {}
    sets.midcast["Hagakure"] = {}
    sets.midcast["Yaegasumi"] = {}	
--================================================================	
------------MAGE SHIT BELOW HERE: IGNORE IF NOT CASTING----------
--================================================================
---------------
--[PRECASTING]-[FAST CAST]
---------------
    sets.precast.casting = {
    }											
---------------
--[PRECASTING]-[STUN]
--LEAVE THIS BLANK. THIS FORCES YOU BACK INTO YOUR FAST CAST SET
---------------
    sets.precast["Stun"] = set_combine(sets.precast.casting,{})
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
---------------
--[MIDCASTING]-[ELEMENTAL OBI]
--USE THIS IF YOU HAVE YOUR OBI
---------------
    sets.midcast.Obi = {}
---------------
--[MIDCASTING]-[ORPHEUS SASH]
--USE THIS IF USING AN ORPHEUS SASH
---------------
    sets.midcast.Orpheus = {}  
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
    sets.midcast.casting = {}
    sets.midcast['Dispel'] = {}	
---------------
--[MIDCASTING]-[NUKING]
---------------
    sets.midcast.nuking.normal = {}
---------------
--[MIDCASTING]-[MAGIC BURSTING]
--USES MAGIC BURST PIECES WHEN CASTING A MAGIC BURST. 
--USE F10 TO TURN ON MAGIC BURSTING. THIS WILL TURN OFF NORMAL NUKING, 
--SHOULD ONLY BE USED IF PURELY BURSTING. ALL OTHER SITUATIONS KEEP IT OFF. 
--RECCOMENDED TO SWAP INTO A STAFF IF DOING FULL BURSTING OFF OF YOUR OWN SC. 
--GS WILL AUTO RE-EQUIP MELEE WEAPONS AFTER CAST. 
---------------
    sets.midcast.MB.normal = {}
---------------
--[MIDCASTING]-[MAGIC ACCURACY]
--USE THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.nuking.acc = {}
---------------
--[MIDCASTING]-[MAGIC BURSTING MAGIC ACCURACY]
-- SEE MAGIC BURST SET FOR DETAILS. 
--USES THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.MB.acc = {}
---------------
--[MIDCASTING]-[DRAIN]
---------------
    sets.midcast["Drain"] = {}
---------------
--[MIDCASTING]-[ASPIR]
---------------
    sets.midcast["Aspir"] = sets.midcast["Drain"]
---------------
--[MIDCASTING]-[ENFEEBLING MAGIC ACCURACY]
---------------
    sets.midcast.Enfeebling.macc = {}
---------------
--[MIDCASTING]-[ENFEEBLING Raw Potency]
---------------
    sets.midcast.Enfeebling.potency = {}
---------------
--[MIDCASTING]-[ENFEEBLING MIND]
---------------
    sets.midcast.Enfeebling.mndpot = {}
---------------
--[MIDCASTING]-[ENFEEBLING MIND & SKILL]
---------------
    sets.midcast.Enfeebling.skillmndpot = {}
---------------
--[MIDCASTING]-[ENFEEBLING INTELLIGENCE]
---------------
    sets.midcast.Enfeebling.intpot = {}
---------------
--[MIDCASTING]-[ENFEEBLING SKILL]
---------------
    sets.midcast.Enfeebling.skillpot = {}
---------------
--[MIDCASTING]-[STUN]
---------------
	sets.midcast["Stun"] ={}

---------------
--[MIDCASTING]-[ENHANCING DURATION (SELF)]
---------------
    sets.midcast.enhancing.duration = {}
---------------
--[MIDCASTING]-[ENHANCING POTENCY (SELF)]
---------------
    sets.midcast.enhancing.potency = {}

---------------
--[MIDCASTING]-[ENHANCING DURATION (OTHERS)]
--USE EMPY SET, OR ENHANCING MAGIC DURATION +15% OR GREATER. 
--EMPY SET GIVES FOR PIECES 2-5 +10%/20%/35%/50%. THIS MEANS ARTIFACT GLOVES+1 > EMPY GLOVES+1
--EMPY BOOTS GIVE A MASSIVE +35-45% BONUS IF USED WITH AT LEAST ONE OTHER PIECE.
--SET BONUS STACKS ACROSS UPGRADE LEVELS. 
---------------
    sets.midcast.enhancing.composure = {}
---------------
--[MIDCASTING]-[OHALANX]
--TAEON CAN BE AUGMENTED WITH +1-3 PHALANX USING DUSKDIM STONES. 
--+15PHALANX CAN LET YOU IMMORTAL MODE TRASH MOBS. 
--PHALANX CAPS AT -35 DAMAGE FROM SKILL. THIS LETS YOU GET -50 DAMAGE, AND BE BASICALLY IMMORTAL TO 
--MOST TRASH UP TO AND INCLUDING ESCHA ZITAH IF USING A PDT SET. CAN LET YOU TAKE AS LITTLE AS 50 DAMAGE FROM EVEN APEX MOBS.  
---------------
    sets.midcast.phalanx ={}
---------------
--[MIDCASTING]-[STONESKIN]
---------------
    sets.midcast.stoneskin = {}
---------------
--[MIDCASTING]-[REFRESH]
--HUGELY IMPORTANT. CAN GET REFRESH3 TO ABSURD LEVELS OF RECOVERY
---------------
    sets.midcast.refresh ={}
---------------
--[MIDCASTING]-[AQUAVEIL]
---------------
    sets.midcast.aquaveil = {}
---------------
--[MIDCASTING]-[CURE]
--CURE POTENCY CAPS AT 50%. 
--PRIORITIZE HEALING MAGIC SKILL > CURE POTENCY. RDMS HEALING MAGIC IS VERY LOW. 
--BECAUSE CURE POT IS A % INCREASE, IT PERFORMS BETTER IF WE INCREASE ITS BASE VALUE THROUGH HEALING SKILL. 
---------------
    sets.midcast.cure.normal = {}
---------------
--[MIDCASTING]-[CURE WEATHER]
---------------
    sets.midcast.cure.weather ={}
---------------
--[MIDCASTING]-[REGEN+]
--RDM ONLY GETS REGEN 2. NEED TO MAX OUT ITS POWER USING GEAR
--BOLELABUNGA GIVES +10%
--TELCHINE BODY GIVES +12 SECONDS (EXTENDED UNDER COMPOSURE)
--TELCHINE GIVES +3 POTENCY AUGMENT PER PIECE USING DUSKDIM AUGMENTATION, FOR +15 TOTAL HP
--RDM CAN GET REGEN 2 UP TO 30 HP PER TIC, WHICH IS INCREDIBLY STRONG - ALMOST AS STRONG AS A FULL POWER REGEN 5  
---------------
	sets.midcast.regen = {}
	


end