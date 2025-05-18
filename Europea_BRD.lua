 include('organizer-lib') -- optional
res = require('resources')
texts = require('texts')
include('Modes.lua')

-- Define your modes: 
-- You can add or remove modes in the table below, they will get picked up in the cycle automatically. 
-- to define sets for idle if you add more modes, name them: sets.me.idle.mymode and add 'mymode' in the group.
-- Same idea for nuke modes. 
idleModes 	= M('refresh','dt','MEVA')
meleeModes 	= M('normal','aftermath','DT','ACC')
THMode 		= M('OFF','ON')
HYBRIDmode 	= M('OFF','ON')
nukeModes 	= M('normal', 'acc')

------------------------------------------------------------------------------------------------------
-- Important to read!
------------------------------------------------------------------------------------------------------
-- This will be used later down for weapon combos, here's mine for example, you can add your REMA+offhand of choice in there
-- Add you weapons in the Main list and/or sub list.
-- Don't put any weapons / sub in your IDLE and ENGAGED sets'
-- You can put specific weapons in the midcasts and precast sets for spells, but after a spell is 
-- cast and we revert to idle or engaged sets, we'll be checking the following for weapon selection. 
-- Defaults are the first in each list
mainWeapon = M('Kali','Carnwenhan','Naegling','Daybreak')
subWeapon = M('Genbu\'s Shield','Blurred Knife +1')
------------------------------------------------------------------------------------------------------

----------------------------------------------------------
-- Auto CP Cape: Will put on CP cape automatically when
-- fighting Apex mobs and job is not mastered
----------------------------------------------------------
CP_CAPE ={} -- Put your CP cape here
DYNA_NECK = ""
----------------------------------------------------------

-- Setting this to true will stop the text spam, and instead display modes in a /UI.
-- Currently in construction.
use_UI = true
hud_x_pos = 1400    --important to update these if you have a smaller screen
hud_y_pos = 225    --important to update these if you have a smaller screen
hud_draggable = true
hud_font_size = 10
hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
hud_font = 'Impact'


-- Setup your Key Bindings here: 
-- ! = ALT
-- ^ = CTRL
	windower.send_command('bind insert gs c nuke cycle')        -- insert to Cycles Nuke element
	windower.send_command('bind delete gs c nuke cycledown')    -- delete to Cycles Nuke element in reverse order   
	windower.send_command('bind f9 gs c toggle idlemode')       -- F9 to change Idle Mode    
	windower.send_command('bind f8 gs c toggle meleemode')      -- F8 to change Melee Mode  
	windower.send_command('bind !f9 gs c toggle melee') 		-- Alt-F9 Toggle Melee mode on / off, locking of weapons
	windower.send_command('bind !f8 gs c toggle mainweapon')	-- Alt-F8 Toggle Main Weapon
	windower.send_command('bind ^f8 gs c toggle subweapon')		-- CTRL-F8 Toggle sub Weapon.
	windower.send_command('bind !` input /ja Tenuto <me>') 		-- Alt-` Quick Tenuto Shortcut.
	windower.send_command('bind home gs c nuke enspellup')		-- Home Cycle Enspell Up
	windower.send_command('bind PAGEUP gs c nuke enspelldown')  -- PgUP Cycle Enspell Down
	windower.send_command('bind ^f10 gs c toggle mb')           -- F10 toggles Magic Burst Mode on / off.
	windower.send_command('bind !f10 gs c toggle nukemode')		-- Alt-F10 to change Nuking Mode
	windower.send_command('bind F10 gs c toggle matchsc')		-- CTRL-F10 to change Match SC Mode      	
	windower.send_command('bind !end gs c hud lite')            -- Alt-End to toggle light hud version       
	windower.send_command('bind ^end gs c hud keybinds')        -- CTRL-End to toggle Keybinds  
	windower.send_command('bind f12 gs c toggle THMode')       -- CTRL-F12 to toggle TH for Horde Lullaby  
	windower.send_command('bind f11 gs c toggle HYBRIDmode')    -- F12 to toggle HYBRID
	windower.send_command('bind ^- input /ja "Troubadour" <me>') 	--CTRL- Quick Troubadour
	windower.send_command('bind ^= input /ja "Nightingale" <me>') 	--CTRL= Quick Nightingale
	windower.send_command('bind ^` input /ja "Pianissimo" <me>')	--Quick Pianissimo
	windower.send_command('bind ^[ input /ws "Mordant Rime" <t>')
    windower.send_command('bind ^] input /ws "Evisceration" <t>')
	windower.send_command('bind ^\\\\ input /ws "Rudra\'s Storm" <t>')
	
	
	windower.send_command('bind f1 input //send Europea //gs c WMAG R5')
	windower.send_command('bind f2 input //send Europea //gs c WMAG AC4')
	windower.send_command('bind f3 input //send Europea //gs c WMAG PHA')
	windower.send_command('bind f4 input //send Europea //gs c WMAG STN')	
	
	windower.send_command('bind !q input //send Dekar /follow Europea') --FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND 
	windower.send_command('bind !a input //send Zinthor /follow Europea') --FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND FOLLOW COMMAND
	
	
function self_command(command)

    local commandArgs = command

    if #commandArgs:split(' ') >= 2 then
        commandArgs = T(commandArgs:split(' '))

        if commandArgs[1] == 'WMAG' then
            if commandArgs[2] == 'R5' then
                send_command('input /ja "Accession" <me>; wait 1.5; input /ja "Perpetuance" <me>; wait 1.5; input /ma "Regen V" <me>')
                add_to_chat(8, '[SEND COMMAND - SELF: AOE REGEN 5]')
            elseif commandArgs[2] == 'P5' then
                send_command('input /ja "Accession" <me>; wait 1.5; input /ma "Protect V" <me>')
                add_to_chat(8, '[SEND COMMAND - SELF: AOE PROTECT 5]')
            elseif commandArgs[2] == 'S5' then
                send_command('input /ja "Accession" <me>; wait 1.5; input /ma "Shell V" <me>')
                add_to_chat(8, '[SEND COMMAND - SELF: AOE SHELL]')
            end
        end

        if commandArgs[1] == 'BMAG' then
            if commandArgs[2] == 'S1' then
                send_command('input /ja "Manifestation" <me>; wait 1.5; input /ma "Sleep" <t>')
                add_to_chat(8, '[SEND COMMAND - SELF: AOE SLEEP]')
            elseif commandArgs[2] == 'DISPEL' then
                send_command('input /ja "Manifestation" <me>; wait 1.5; input /ma "Dispel" <t>')
                add_to_chat(8, '[SEND COMMAND - SELF: AOE DISPEL]')
            end
        end
	end
end	
	
	
--[[
    This gets passed in when the Keybinds is turned on.
    IF YOU CHANGED ANY OF THE KEYBINDS ABOVE, edit the ones below so it can be reflected in the hud using the "//gs c hud keybinds" command
]]
keybinds_on = {}
keybinds_on['key_bind_idle'] = '(F9)'
keybinds_on['key_bind_melee'] = '(F8)'
keybinds_on['key_bind_HYBRIDmode'] = '(F11)'
keybinds_on['key_bind_casting'] = '(ALT-F10)'
keybinds_on['key_bind_THMode'] = '(F12)'
keybinds_on['key_bind_mainweapon'] = '(ALT-F8)'
keybinds_on['key_bind_subweapon'] = '(CTR-F8)'
keybinds_on['key_bind_element_cycle'] = '(INS + DEL)'
keybinds_on['key_bind_enspell_cycle'] = '(HOM + pUP)'
keybinds_on['key_bind_lock_weapon'] = '(ALT-F9)'
keybinds_on['key_bind_matchsc'] = '(F10)'
send_command('gs c hud hidejob')
send_command('gs c hud keybinds')
send_command('lua l gearinfo')
send_command('lua l equipviewer')
send_command('lua l partybuffs')

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
    send_command('unbind f11')
    send_command('unbind f12')
    send_command('unbind !`')
    send_command('unbind home')
    send_command('unbind !f10')	
    send_command('unbind `f10')
    send_command('unbind !end')  
    send_command('unbind ^end')
	send_command('unbind ^`')
	send_command('unbind ^[')
    send_command('unbind ^]')	
	send_command('unbind ^\\\\')
	send_command('unbind !q')
	send_command('unbind !a')	
end

include('BRD_Lib.lua')

-- Optional. Swap to your sch macro sheet / book
set_macros(4,1) -- Sheet, Book
send_command('wait 10;input /lockstyleset 63')
refreshType = idleModes[1] -- leave this as is  
   
function sub_job_change(new,old)
send_command('wait 10;input /lockstyleset 63')
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
--------------------
--[ARTIFACT ARMOR]-[ART]
--------------------    
	ART = {}		--Leave This Empty
		ART.HED	= "Brioso Roundlet +3"
		ART.BOD	= "Brioso Justaucorps"
		ART.HND	= "Brioso Cuffs +3"
		ART.LEG	= "Brioso Cannions +3"
		ART.FEE	= "Brioso Slippers +3"

--------------------
--[RELIC ARMOR]-[REL]
--------------------    
	REL = {}		--Leave This Empty
		REL.HED	= "Bihu Roundlet +3"
		REL.BOD	= "Bihu Justaucorps +3"
		REL.HND	= "Bihu Cuffs +3"
		REL.LEG	= "Bihu Cannions +3"
		REL.FEE	= "Bihu Slippers +3"
		REL.NEK = "Bard's Charm +2"
--------------------
--[EMPERYAN ARMOR]-[EMP]
--------------------    
	EMP = {}		--Leave This Empty
		EMP.HED	= "Fili Calot"
		EMP.BOD	= "Fili Hongreline +2"
		EMP.HND	= "Fili Manchettes +2"
		EMP.LEG	= "Fili Rhingrave +1"
		EMP.FEE	= "Fili Cothurnes +1"
--------------------
--[JSE CAPES]-[JSE]
--------------------  
	JSE = {}		--Leave This Empty
--[WS CAPES]
	JSE.WSD={}
		JSE.WSD.STR	= "" --STR WS damage Cape
		JSE.WSD.DEX = "" --DEX WS damage Cape	
		JSE.WSD.AGI	= "" --AGI WS damage Cape
		JSE.WSD.CHR = {name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}} --CHR WS damage Cape
		JSE.WSD.INT	= "" --INT WS damage Cape
		JSE.WSD.MND	= "" --MND WS damage Cape
--[CASTING CAPES]
	JSE.FAS={}
		JSE.FAS.CHR	= {name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','CHR+10','"Fast Cast"+10',}} --CHR FAST CAST CAPE
		JSE.FAS.MND	= "" --MND FAST CAST CAPE
		JSE.FAS.INT	= "" --INT FAST CAST CAPE
		
		JSE.SID		= "" --SPELL INTERRUPTION RATE CAPE
	JSE.MAB={}
		JSE.MAB.CHR = "" --MAGIC ATTACK BONUS CAPE
		JSE.MAB.INT = "" --MAGIC ATTACK BONUS CAPE
		JSE.MAB.MND = "" --MAGIC ATTACK BONUS CAPE
--[MELEE CAPES]		
		JSE.CRT		= "" --CRITICAL HIT CAPE
		JSE.STP		= {name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}} --STORE TP CAPE
		JSE.DWL		= "" --Dual wield Cape
		JSE.HAS		= "" --HASTE CAPE
		JSE.DBL		= {name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Damage taken-5%',}} --Double Attack TP Cape
--[IDLE CAPES]
	JSE.IDL={}	
		JSE.IDL.REG	= "" --REGEN CAPE
		JSE.IDL.DT	= "" --DT CAPE
		JSE.IDL.RES	= "" --RES CAPE
		JSE.IDL.MEV = {name="Intarabus's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Waltz" potency +10%','Phys. dmg. taken-10%',}} --Magic Evasison Cape (and WALTZ)
--------------------
--//////////////////
--AMBUSCADE GEAR
--//////////////////		
--------------------
--[Inyanga ARMOR]-[INY]
--------------------    
	INY = {}		--Leave This Empty
		INY.HED	= "Inyanga Tiara +2"
		INY.BOD	= "Inyanga Jubbah +2"
		INY.HND	= "Inyanga Dastanas +2"
		INY.LEG	= "Inyanga Shalwar +2"
		INY.FEE	= "Inyanga Crackows +2"
		INY.RNG = "Inyanga Ring"
--------------------
--[AYANMO ARMOR]-[AYA]
--------------------    
	AYA = {}		--Leave This Empty
		AYA.HED	= "Ayanmo Zucchetto +2"
		AYA.BOD	= "Ayanmo Corazza +2"
		AYA.HND	= "Ayanmo Manopolas +2"
		AYA.LEG	= "Ayanmo Cosciales +2"
		AYA.FEE	= "Ayanmo Gambieras +2"
		AYA.RNG = "Ayanmo Ring"

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
--[IDLE]-[REFRESH]-[NORMAL]
---------------
 	sets.me.idle.refresh = {
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}},
		sub="Genbu's Shield",
		range={ name="Terpander", augments={'HP+30','Mag. Acc.+10','Damage Taken -3%',}},
		head="Inyanga Tiara +2",
		body="Inyanga Jubbah +2",
		hands="Inyan. Dastanas +2",
		legs="Assid. Pants +1",
		feet="Inyanga Crackows +2",
		neck="Loricate Torque +1",
		waist="Flume Belt",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Inyanga Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}	-- ?? Refresh :: 52 PDT :: 43 MDT
---------------
--[IDLE]-[REFRESH]-[PDT]
---------------
	sets.me.idle.dt = {
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}},
		sub="Genbu's Shield",
		range={ name="Terpander", augments={'HP+30','Mag. Acc.+10','Damage Taken -3%',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Infused Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Shneddick Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}	-- ?? Refresh :: 50 PDT+ :: 50+ MDT :: 50 BDT 
---------------
--[IDLE]-[REFRESH]-[DYNA]
---------------
	sets.me.idle.MEVA = {
		range={ name="Linos", augments={'Mag. Evasion+13','Phys. dmg. taken -4%','HP+15',}},
		sub="Genbu's Shield",
		range={ name="Terpander", augments={'HP+30','Mag. Acc.+10','Damage Taken -3%',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Infused Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Shneddick Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	} --26 PDT (36 w/ Genmei Shield) :: 41 MDT (w/o Shell V)
	
	
	
---------------
--[IDLE]-[REFRESH]-[DYNA]
---------------
	sets.me.idle.town = {}
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
--[MELEE]-[NORMAL]
---------------
--Only need to Add Dual wield + to dual wield specific sets
--Set names are "Set" "Melee type" "Hybrid Toggle"
-- E.G. Your "Normal" "Dualwield" "Hybrid set", would be normaldwdt
-- E.G.  your "Normal" "Dualwield" set would be "normaldw"
--Set combine flow is  NormalSW > NormalDW & NormalSWDT > NormalDWDT
    sets.me.melee.normalsw 		= {
		range={ name="Linos", augments={'Accuracy+15','"Dbl.Atk."+3','Quadruple Attack +3',}},
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",
		feet="Aya. Gambieras +2",
		neck="Bard's Charm +1",
		waist="Sarissapho. Belt",
		left_ear="Brutal Earring",
		right_ear="Telos Earring",
		left_ring="Hetairoi Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	}
	
    sets.me.melee.normalswdt 	=set_combine(sets.me.melee.normalsw,{
		ring1="Defending Ring"
	}) --45 PDT :: 35 MDT
	
    sets.me.melee.normaldw		=set_combine(sets.me.melee.normalsw, {
		feet={ name="Chironic Slippers", augments={'"Dual Wield"+1','Attack+2','Quadruple Attack +2','Accuracy+20 Attack+20',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	})
	
    sets.me.melee.normaldwdt 	=set_combine(sets.me.melee.normalswdt,{
		hands="Nyame Gauntlets",
		feet={ name="Chironic Slippers", augments={'"Dual Wield"+1','Attack+2','Quadruple Attack +2','Accuracy+20 Attack+20',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	})
	
---------------
--[MELEE]-[AFTERMATH]
---------------
    sets.me.melee.aftermathsw 	= {
		range={ name="Linos", augments={'Accuracy+15','"Store TP"+4','Quadruple Attack +3',}},
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",
		feet="Aya. Gambieras +2",
		neck="Bard's Charm +1",
		waist="Sarissapho. Belt",
		left_ear="Brutal Earring",
		right_ear="Telos Earring",
		left_ring="Hetairoi Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	}
	
    sets.me.melee.aftermathswdt = set_combine(sets.me.melee.aftermathsw,{
		ring1="Defending Ring"
	})
	
    sets.me.melee.aftermathdw 	= set_combine(sets.me.melee.aftermathsw,{
		feet={ name="Chironic Slippers", augments={'"Dual Wield"+1','Attack+2','Quadruple Attack +2','Accuracy+20 Attack+20',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	})	
	
    sets.me.melee.aftermathdwdt = set_combine(sets.me.melee.aftermathswdt, {
		hands="Nyame Gauntlets",
		feet={ name="Chironic Slippers", augments={'"Dual Wield"+1','Attack+2','Quadruple Attack +2','Accuracy+20 Attack+20',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	})
	
---------------
--[MELEE]-[ACC]
---------------
    sets.me.melee.ACCsw 	= {
		range={ name="Linos", augments={'Accuracy+15','"Dbl.Atk."+3','Quadruple Attack +3',}},
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands={ name="Gazu Bracelet +1", augments={'Path: A',}},
		legs="Aya. Cosciales +2",
		feet="Aya. Gambieras +2",
		neck="Bard's Charm +1",
		waist="Grunfeld Rope",
		left_ear="Digni. Earring",
		right_ear="Telos Earring",
		left_ring="Hetairoi Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	} --36 PDT :: 19 MDT (48 MDT w/ Shell V)
	
	sets.me.melee.ACCswdt 	= set_combine(sets.me.melee.ACCsw, {
		ring1="Defending Ring",
	}) --35 PDT :: 35 MDT
	
	sets.me.melee.ACCdw 	= set_combine(sets.me.melee.ACCsw, {
		feet={ name="Chironic Slippers", augments={'"Dual Wield"+1','Attack+2','Quadruple Attack +2','Accuracy+20 Attack+20',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	}) --26 PDT :: 19 MDT (48 w/ Shell V)
	
	sets.me.melee.ACCdwdt 	= set_combine(sets.me.melee.ACCswdt, {
		hands="Nyame Gauntlets",
		feet={ name="Chironic Slippers", augments={'"Dual Wield"+1','Attack+2','Quadruple Attack +2','Accuracy+20 Attack+20',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	}) --35 PDT :: 35 MDT
---------------
--[MELEE]-[DT]
---------------
    sets.me.melee.dtsw 		= {
		range={ name="Linos", augments={'Accuracy+15','"Dbl.Atk."+3','Quadruple Attack +3',}},
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Aya. Manopolas +2",
		legs="Aya. Cosciales +2",
		feet="Aya. Gambieras +2",
		neck="Bard's Charm +1",
		waist="Sarissapho. Belt",
		left_ear="Brutal Earring",
		right_ear="Telos Earring",
		left_ring="Defending Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	} --50 PDT :: 30 MDT
	
	sets.me.melee.dtswdt 	= set_combine(sets.me.melee.dtsw, {
		head="Nyame Helm",
		body="Nyame Mail",
		hands={ name="Gazu Bracelet +1", augments={'Path: A',}},
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		waist="Carrier's Sash",
	})
	
	sets.me.melee.dtdw 		= set_combine(sets.me.melee.dtsw, {
		feet={ name="Chironic Slippers", augments={'"Dual Wield"+1','Attack+2','Quadruple Attack +2','Accuracy+20 Attack+20',}},
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	}) --40 PDT :: 38 MDT
	
	sets.me.melee.dtdwdt 	= set_combine(sets.me.melee.dtswdt, {
		head="Nyame Helm",
		body="Nyame Mail",
		hands={ name="Gazu Bracelet +1", augments={'Path: A',}},
		legs="Nyame Flanchard",
		feet={ name="Chironic Slippers", augments={'"Dual Wield"+1','Attack+2','Quadruple Attack +2','Accuracy+20 Attack+20',}},
		waist="Carrier's Sash",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}},
	}) --40 PDT :: 38 MDT


--/////////////////
--WEAPONSKILL SECTION
--/////////////////
	--ALL WEAPONSKILLS USE ATTACK, OR MAGIC ATTACK. IT IS LISTED IN THE MODIFIERS SECTION
	--IF A WEAPONSKILL TRANSFERS fTP ACROSS ALL HITS, IT WILL LIST GORGET IN THE MODIFIERS SECTION, THE GORGET MATCHES ANY ELIGIBLE ELEMENTS	

---------------
--[WEAPONSKILL]-[SWORD]-[SAVAGE BLADE]-[MOD:50%MND/50%STR/P.ATTK]-[ELEMENT:Fragmentation/Scission]
---------------
    sets.me["Savage Blade"] = {
		range={ name="Linos", augments={'Accuracy+13 Attack+13','Weapon skill damage +3%','Quadruple Attack +3',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+11','"Store TP"+4','Weapon skill damage +9%','Accuracy+18 Attack+18',}},
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Bard's Charm +1",
		waist="Grunfeld Rope",
		left_ear="Ishvara Earring",
		right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
		left_ring="Rufescent Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
	}
---------------
--[WEAPONSKILL]-[DAGGER]-[]-[]
---------------
    sets.me["Mordant Rime"] = {
		range={ name="Linos", augments={'Accuracy+13 Attack+13','Weapon skill damage +3%','Quadruple Attack +3',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+11','"Store TP"+4','Weapon skill damage +9%','Accuracy+18 Attack+18',}},
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Bard's Charm +1",
		waist="Grunfeld Rope",
		left_ear="Ishvara Earring",
		right_ear="Regal Earring",
		left_ring="Rajas Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
	}
---------------
--[WEAPONSKILL]-[DAGGER]-[]-[MOD:80%DEX/P.ATTK]
---------------
    sets.me["Rudra's Storm"] = {
		range={ name="Linos", augments={'Accuracy+13 Attack+13','Weapon skill damage +3%','Quadruple Attack +3',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands={ name="Chironic Gloves", augments={'"Mag.Atk.Bns."+11','"Store TP"+4','Weapon skill damage +9%','Accuracy+18 Attack+18',}},
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Bard's Charm +1",
		waist="Grunfeld Rope",
		left_ear="Ishvara Earring",
		right_ear="Telos Earring",
		left_ring="Rajas Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
    }
---------------
--[WEAPONSKILL]-[DAGGER]-[EXTENERATOR]-[MOD:85%AGI/P.ATTK/GORGET]-[ELEMENT:FRAGMENTATION/SCISSION]
---------------
    sets.me["Exenterator"] = {
		range={ name="Linos", augments={'Accuracy+15','"Dbl.Atk."+3','Quadruple Attack +3',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Aya. Gambieras +2",
		neck="Bard's Charm +1",
		waist="Grunfeld Rope",
		left_ear="Ishvara Earring",
		right_ear="Telos Earring",
		left_ring="Begrudging Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
    }
	
---------------
--[WEAPONSKILL]-[DAGGER]-[EVISCERATION]-[MOD:50%DEX/P.ATTK/GORGET]-[ELEMENT:GRAVITATION/TRANSFIXION]
---------------
    sets.me["Evisceration"] = {
		range={ name="Linos", augments={'Accuracy+15','"Dbl.Atk."+3','Quadruple Attack +3',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Aya. Manopolas +2",
		legs="Nyame Flanchard",
		feet="Aya. Gambieras +2",
		neck="Bard's Charm +1",
		waist="Grunfeld Rope",
		left_ear="Ishvara Earring",
		right_ear="Telos Earring",
		left_ring="Begrudging Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
    }
	
---------------
--[WEAPONSKILL]-[DAGGER]-[AEOLIAN EDGE]-[MOD:40%DEX/40%INT/M.ATTK]-[ELEMENT: IMPACTION/SCISSION/DETONATION]
---------------
    sets.me["Aeolian Edge"] = {
		range={ name="Linos", augments={'Accuracy+13 Attack+13','Weapon skill damage +3%','Quadruple Attack +3',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Skrymir Cord",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Apate Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
    }

---------------
--[WEAPONSKILL]-[DAGGER]-[ENERGY DRAIN]-[MOD:100%MND/NO ATTK MOD]-[ELEMENT:DARK (NO SC ELEMENT)]
---------------
    sets.me["Energy Drain"] = {
		range={ name="Linos", augments={'Accuracy+13 Attack+13','Weapon skill damage +3%','Quadruple Attack +3',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Skrymir Cord",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Apate Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
    }
	
---------------
--[WEAPONSKILL]-[DAGGER]-[ENERGY STEAL]-[MOD:100%MND/NO ATTK MOD]-[ELEMENT:DARK (NO SC ELEMENT)]
---------------
    sets.me["Energy Steal"] = {
		range={ name="Linos", augments={'Accuracy+13 Attack+13','Weapon skill damage +3%','Quadruple Attack +3',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Skrymir Cord",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Apate Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
    }
	
	---------------
--[WEAPONSKILL]-[STAFF]-[SHELL CRUSHER]-[MOD:100%STR]-[DETONATION)]
---------------
    sets.me["Shell Crusher"] = {
		range={ name="Linos", augments={'Accuracy+13 Attack+13','Weapon skill damage +3%','Quadruple Attack +3',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Skrymir Cord",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Apate Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
    }	
	
	
---------------
--[WEAPONSKILL]-[STAFF]-[SHATTERSOUL]-[MOD:73~85%INT]-[GRAVITATION/INDURATION)]
---------------
    sets.me["Shattersoul"] = {
		range={ name="Linos", augments={'Accuracy+13 Attack+13','Weapon skill damage +3%','Quadruple Attack +3',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Skrymir Cord",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Apate Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
    }	
	
---------------
--[WEAPONSKILL]-[STAFF]-[CATACLYSM]-[MOD:30% STR/30% INT]-[GRAVITATION/REVERBERATION)]
---------------
    sets.me["Cataclysm"] = {
		range={ name="Linos", augments={'Accuracy+13 Attack+13','Weapon skill damage +3%','Quadruple Attack +3',}},
		head="Pixie Hairpin +1",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Skrymir Cord",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Apate Ring",
		right_ring="Archon Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
    }		

---------------
--[WEAPONSKILL]-[CLUB]-[FLASH NOVA]-[MOD:50% STR/50% MND]-[REVERBERATION/INDURATION)]
---------------
    sets.me["Flash Nova"] = {
		range={ name="Linos", augments={'Accuracy+13 Attack+13','Weapon skill damage +3%','Quadruple Attack +3',}},
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Baetyl Pendant",
		waist="Skrymir Cord",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Apate Ring",
		right_ring="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Accuracy+20 Attack+20','CHR+10','Weapon skill damage +10%',}},
    }

	sets.me["Shining Strike"] = set_combine(sets.me["Flash Nova"],{	
	})
	
	sets.me["Seraph Strike"] = set_combine(sets.me["Flash Nova"],{	
	})
	
	
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
	sets.midcast.songs = {}
---------------
--[JOB ABILITIES]	
---------------
	sets.precast["Soul Voice"] 		= {legs=REL.LEG,}
	sets.precast["Pianissimo"] 		= {}
	sets.precast["Nightingale"] 	= {feet=REL.FEE,}
	sets.precast["Troubadour"] 		= {body=REL.BOD,}
	sets.precast["Tenuto"] 			= {}
	sets.precast["Marcato"]			= {}
	sets.precast["Clarion Call"] 	= {}
	sets.precast["Curing Waltz"] 	= {back=JSE.IDL.MEV,}	
	sets.precast["Curing Waltz II"] = {back=JSE.IDL.MEV,}	
	sets.precast["Curing Waltz III"]= {back=JSE.IDL.MEV,}	
	sets.precast["Curing Waltz IV"] = {back=JSE.IDL.MEV,}	
	sets.precast["Curing Waltz V"] 	= {back=JSE.IDL.MEV,}	
	sets.precast["Healing Waltz"] 	= {}	
	sets.precast["Divine Waltz"] 	= {back=JSE.IDL.MEV,}

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
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}}, 
		sub="Genbu's Shield",
		range="Eminent Flute",
		head="Nahtirah Hat",
		body="Inyanga Jubbah +2",
		hands={ name="Gendewitha Gages", augments={'Phys. dmg. taken -3%','"Cure" potency +4%',}},
		legs="Aya. Cosciales +2",
		feet="Fili Cothurnes +1",
		neck="Voltsurge Torque",
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }	--62 FC in gear
	
    sets.precast.songs = {
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}},
		sub="Genbu's Shield",
		range="Eminent Flute",
		head="Fili Calot",
		body="Inyanga Jubbah +2",
		hands={ name="Gendewitha Gages", augments={'Phys. dmg. taken -3%','"Cure" potency +4%',}},
		legs="Aya. Cosciales +2",
		feet="Fili Cothurnes +1",
		neck="Voltsurge Torque",
		waist="Embla Sash",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }	--87 FC (80 w/o the Kali)
---------------
--[PRECASTING]-[HONOR MARCH]
--LEAVE THIS BLANK. THIS FORCES YOU BACK INTO YOUR FAST CAST SET
---------------
    sets.precast["Honor March"] = set_combine(sets.precast.songs,{range="Marsyas",})
	
---------------
--[PRECASTING]-[DISPELGA]
--LEAVE THIS BLANK. THIS FORCES YOU BACK INTO YOUR FAST CAST SET
---------------
    sets.precast["Dispelga"] = set_combine(sets.precast.casting,{main="Daybreak",})
	
---------------
--[PRECASTING]-[STUN]
--LEAVE THIS BLANK. THIS FORCES YOU BACK INTO YOUR FAST CAST SET
---------------
    sets.precast["Stun"] = set_combine(sets.precast.casting,{})
	
---------------
--[PRECASTING]-[ENHANCING]
--LEAVE THIS BLANK UNLESS USING AN ENHANCING MAGIC SPELL CASTING TIME DOWN PIECE IN PLACE OF FAST CAST
---------------
    sets.precast.enhancing = set_combine(sets.precast.casting,{
	waist="Siegel Sash"}) --8 (70% FC Total w/o Kali) 	
	
---------------
--[PRECASTING]-[STONESKIN]
--LEAVE THIS BLANK UNLESS USING A STONESKIN SPELL CASTING TIME DOWN PIECE IN PLACE OF FAST CAST
---------------
    sets.precast.stoneskin = set_combine(sets.precast.enhancing,{
		head="Umuthi Hat",}) --15  (75% FC Total w/o Kali)
		
---------------
--[PRECASTING]-[CURE]
--LEAVE THIS BLANK UNLESS USING A CURE SPELL CASTING TIME DOWN PIECE IN PLACE OF FAST CAST
---------------
    sets.precast.cure = set_combine(sets.precast.casting,{
		feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}}, --15
		ear1="Mendicant's Earring"}) --87% FC (80% Total w/o Kali)

--//////////////////
--MIDCASTING
--EACH SET IN THIS GROUP NEEDS TO BE TAILORED TO MATCH WHAT YOU ARE DOING. IF A PIECE IS LEFT UNSPECIFIED, IT WILL DEFAULT
--TO THE GENERIC CASTING SET FOR THAT SLOT. A RECOMMENDED STRATEGY IS TO SET THIS SET TO 'CONSERVE MP' TO CATCH SPELLS THAT DO NOT
--HAVE A SPECIFIED CASTING SET ATTACHED TO THEM TO MINIMIZE THEIR MP DRAIN
--EG. SPELLS LIKE BLINK	

	sets.midcast["Curing Waltz"] 	= {back=JSE.IDL.MEV,}	
	sets.midcast["Curing Waltz II"] = {back=JSE.IDL.MEV,}	
	sets.midcast["Curing Waltz III"]= {back=JSE.IDL.MEV,}	
	sets.midcast["Curing Waltz IV"] = {back=JSE.IDL.MEV,}	
	sets.midcast["Curing Waltz V"] 	= {back=JSE.IDL.MEV,}	
	sets.midcast["Healing Waltz"] 	= {}	
	sets.midcast["Divine Waltz"] 	= {back=JSE.IDL.MEV,}
	
---------------
--[MIDCASTING]-[ELEMENTAL OBI]
--USE THIS IF YOU HAVE YOUR OBI
---------------
    sets.midcast.Obi = {Waist = "Hachirin-no-obi"}
---------------
--[MIDCASTING]-[ORPHEUS SASH]
--USE THIS IF USING AN ORPHEUS SASH
---------------
    sets.midcast.Orpheus = {}  

---------------
--[MIDCASTING]-[DEFAULT]
--GENERAL CASTING - WILL BE THE DEFAULT SET UNLESS SPELL BEING CAST IS A PART OF ANOTHER SPECIFIED GROUP.
--EG. GETS REPLACED BY ANY SPELLS IN THE NUKING CATEGORY WITH THE NUKING NORMAL SET. 
---------------
    sets.midcast.casting = {

    }
	
---------------
--[MIDCASTING]-[NUKING]
---------------
    sets.midcast.nuking.normal = {
		main="Carnwenhan",
		sub="Ammurapi Shield",
		range={ name="Linos", augments={'Mag. Evasion+13','Phys. dmg. taken -4%','HP+15',}},
		head={ name="Kaykaus Mitra +1", augments={'MND+12','Mag. Acc.+20','"Mag.Atk.Bns."+20',}},
		body="Brioso Justau. +3",
		hands="Inyan. Dastanas +2",
		legs={ name="Chironic Hose", augments={'Crit.hit rate+2','Pet: Attack+28 Pet: Rng.Atk.+28','"Treasure Hunter"+2','Accuracy+17 Attack+17','Mag. Acc.+10 "Mag.Atk.Bns."+10',}},
		feet={ name="Chironic Slippers", augments={'DEX+4','AGI+5','"Treasure Hunter"+2','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Friomisi Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=JSE.FAS.CHR,
	}
	
---------------
--[MIDCASTING]-[MAGIC BURSTING]
--USES MAGIC BURST PIECES WHEN CASTING A MAGIC BURST. 
--USE F10 TO TURN ON MAGIC BURSTING. THIS WILL TURN OFF NORMAL NUKING, 
--SHOULD ONLY BE USED IF PURELY BURSTING. ALL OTHER SITUATIONS KEEP IT OFF. 
--RECCOMENDED TO SWAP INTO A STAFF IF DOING FULL BURSTING OFF OF YOUR OWN SC. 
--GS WILL AUTO RE-EQUIP MELEE WEAPONS AFTER CAST. 
---------------
    sets.midcast.MB.normal = set_combine(sets.midcast.nuking.normal, {neck="Mizu. Kubikazari"})
---------------
--[MIDCASTING]-[MAGIC ACCURACY]
--USE THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.nuking.acc = {

	}
---------------
--[MIDCASTING]-[MAGIC BURSTING MAGIC ACCURACY]
-- SEE MAGIC BURST SET FOR DETAILS. 
--USES THIS SET WHEN IN MAGIC ACCURACY MODE
---------------
    sets.midcast.MB.acc = set_combine(sets.midcast.nuking.acc, {neck="Mizu. Kubikazari"})	
---------------
--[MIDCASTING]-[] --blank template for specific spells
---------------
    --sets.midcast[""] = {}

---------------
--[MIDCASTING]-[ENFEEBLING MAGIC ACCURACY]
---------------
    sets.midcast.Enfeebling.macc = {
		main="Carnwenhan",
		sub="Genbu's Shield",
		range="Eminent Flute",
		head="Inyanga Tiara +2",
		body="Inyanga Jubbah +2",
		hands="Inyan. Dastanas +2",
		legs="Inyanga Shalwar +2",
		feet="Inyan. Crackows +2",
		neck="Moonbow Whistle +1",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }
	
	 sets.midcast["Dispelga"] = set_combine(sets.midcast.Enfeebling.macc,{main="Daybreak",})
	 
---------------
--[MIDCASTING]-[ENFEEBLING Raw Potency]
---------------
    sets.midcast.Enfeebling.potency = {
		main="Carnwenhan",
		sub="Ammurapi Shield",
		range="Gjallarhorn",
		head=ART.HED,
		body=ART.BOD,
		hands=INY.HND,
		legs={ name="Chironic Hose", augments={'Pet: STR+7','MND+10','Crit.hit rate+2','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet=ART.FEE,
		neck="Mnbw. Whistle +1",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=JSE.FAS.CHR, --I need a specific cape for this.
	}
---------------
--[MIDCASTING]-[ENFEEBLING MIND]
---------------
    sets.midcast.Enfeebling.mndpot = {
		main="Carnwenhan",
		sub="Ammurapi Shield",
		range="Gjallarhorn",
		head=ART.HED,
		body=ART.BOD,
		hands=INY.HND,
		legs={ name="Chironic Hose", augments={'Pet: STR+7','MND+10','Crit.hit rate+2','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet=ART.FEE,
		neck="Mnbw. Whistle +1",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=JSE.FAS.CHR, --I need a specific cape for this.
    }
---------------
--[MIDCASTING]-[ENFEEBLING MIND & SKILL]
---------------
    sets.midcast.Enfeebling.skillmndpot = {
		main="Carnwenhan",
		sub="Ammurapi Shield",
		range="Gjallarhorn",
		head=ART.HED,
		body=ART.BOD,
		hands=INY.HND,
		legs={ name="Chironic Hose", augments={'Pet: STR+7','MND+10','Crit.hit rate+2','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet=ART.FEE,
		neck="Mnbw. Whistle +1",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=JSE.FAS.CHR, --I need a specific cape for this.	
	}
---------------
--[MIDCASTING]-[ENFEEBLING INTELLIGENCE]
---------------
    sets.midcast.Enfeebling.intpot = {
		main="Carnwenhan",
		sub="Ammurapi Shield",
		range="Gjallarhorn",
		head=ART.HED,
		body=ART.BOD,
		hands=INY.HND,
		legs={ name="Chironic Hose", augments={'Pet: STR+7','MND+10','Crit.hit rate+2','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet=ART.FEE,
		neck="Mnbw. Whistle +1",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=JSE.FAS.CHR, --I need a specific cape for this.
    }
---------------
--[MIDCASTING]-[ENFEEBLING SKILL]
---------------
    sets.midcast.Enfeebling.skillpot = {
		main="Carnwenhan",
		sub="Ammurapi Shield",
		range="Gjallarhorn",
		head=ART.HED,
		body=ART.BOD,
		hands=INY.HND,
		legs={ name="Chironic Hose", augments={'Pet: STR+7','MND+10','Crit.hit rate+2','Mag. Acc.+20 "Mag.Atk.Bns."+20',}},
		feet=ART.FEE,
		neck="Mnbw. Whistle +1",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring +1",
		right_ring="Stikini Ring +1",
		back=JSE.FAS.CHR, --I need a specific cape for this.
    }
	
---------------
--[MIDCASTING]-[STUN]
---------------
	sets.midcast["Stun"] = set_combine(sets.midcast.Enfeebling.macc, {})

---------------
--[MIDCASTING]-[ENHANCING DURATION (SELF)]
---------------
    sets.midcast.enhancing.duration = {
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}},
		sub="Genbu's Shield",
		range={ name="Terpander", augments={'HP+30','Mag. Acc.+10','Damage Taken -3%',}},
		head={ name="Telchine Cap", augments={'"Conserve MP"+2','Enh. Mag. eff. dur. +8',}},
		body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +8',}},
		hands={ name="Telchine Gloves", augments={'"Cure" potency +3%','Enh. Mag. eff. dur. +10',}},
		legs={ name="Telchine Braconi", augments={'"Cure" potency +6%','Enh. Mag. eff. dur. +10',}},
		feet={ name="Telchine Pigaches", augments={'"Conserve MP"+4','Enh. Mag. eff. dur. +9',}},
		neck="Loricate Torque +1",
		waist="Embla Sash",
		left_ear="Andoaa Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    }
	
---------------
--[MIDCASTING]-[DIA / TREASURE HUNTER 4]
---------------	
	sets.midcast["Dia"] = {
		main={ name="Kali", augments={'MP+60','Mag. Acc.+20','"Refresh"+1',}},
		sub="Genbu's Shield",
		range={ name="Terpander", augments={'HP+30','Mag. Acc.+10','Damage Taken -3%',}},
		head="Wh. Rarab Cap +1",
		body="Zendik Robe",
		hands={ name="Chironic Gloves", augments={'STR+6','Rng.Atk.+3','"Treasure Hunter"+1','Accuracy+14 Attack+14','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		legs={ name="Chironic Hose", augments={'Blood Pact Dmg.+9','Attack+16','"Treasure Hunter"+2','Accuracy+8 Attack+8','Mag. Acc.+3 "Mag.Atk.Bns."+3',}},
		feet="Aya. Gambieras +2",
		neck="Baetyl Pendant",
		waist="Luminary Sash",
		left_ear="Loquac. Earring",
		right_ear="Etiolation Earring",
		left_ring="Prolix Ring",
		right_ring="Kishar Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	
	sets.midcast["Dia II"] = sets.midcast["Dia"]	
	sets.midcast["Diaga"] = sets.midcast["Dia"]
---------------
--[MIDCASTING]-[ENHANCING POTENCY (SELF)]
---------------
    sets.midcast.enhancing.potency = set_combine(sets.midcast.enhancing.duration, {

    })

---------------
--[MIDCASTING]-[ENHANCING DURATION (OTHERS)]
--USE EMPY SET, OR ENHANCING MAGIC DURATION +15% OR GREATER. 
--EMPY SET GIVES FOR PIECES 2-5 +10%/20%/35%/50%. THIS MEANS ARTIFACT GLOVES+1 > EMPY GLOVES+1
--EMPY BOOTS GIVE A MASSIVE +35-45% BONUS IF USED WITH AT LEAST ONE OTHER PIECE.
--SET BONUS STACKS ACROSS UPGRADE LEVELS. 
---------------

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
		ear1="Earthcry Earring",
		neck="Nodens Gorget",
		waist="Siegel Sash",
		legs="Shedir Seraweels",	
	})
	
---------------
--[MIDCASTING]-[REFRESH]
--HUGELY IMPORTANT. CAN GET REFRESH3 TO ABSURD LEVELS OF RECOVERY
---------------
    sets.midcast.refresh = set_combine(sets.midcast.enhancing.duration, {
		back="Grapevine Cape",
		waist="Gishdubar Sash"
	})
---------------
--[MIDCASTING]-[AQUAVEIL]
---------------
    sets.midcast.aquaveil = set_combine(sets.midcast.refresh, {
		head={ name="Chironic Hat", augments={'CHR+6','Pet: Mag. Acc.+6','"Refresh"+1','Accuracy+3 Attack+3','Mag. Acc.+12 "Mag.Atk.Bns."+12',}},
		legs="Shedir Seraweels",
		})

---------------
--[MIDCASTING]-[CURE]
--CURE POTENCY CAPS AT 50%. 
--PRIORITIZE HEALING MAGIC SKILL > CURE POTENCY. RDMS HEALING MAGIC IS VERY LOW. 
--BECAUSE CURE POT IS A % INCREASE, IT PERFORMS BETTER IF WE INCREASE ITS BASE VALUE THROUGH HEALING SKILL. 
---------------
    sets.midcast.cure.normal = set_combine(sets.midcast.casting,{
		main="Daybreak",
		sub="Genbu's Shield",
		range={ name="Terpander", augments={'HP+30','Mag. Acc.+10','Damage Taken -3%',}},
		head={ name="Kaykaus Mitra", augments={'MP+60','MND+10','Mag. Acc.+15',}},
		body="Zendik Robe",
		hands={ name="Kaykaus Cuffs", augments={'MP+60','"Cure" spellcasting time -5%','Enmity-5',}},
		legs={ name="Chironic Hose", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','Enmity-4','MND+9','Mag. Acc.+14','"Mag.Atk.Bns."+15',}},
		feet={ name="Vanya Clogs", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
		neck="Nodens Gorget",
		waist="Luminary Sash",
		left_ear="Mendi. Earring",
		right_ear="Regal Earring",
		left_ring="Kuchekula Ring",
		right_ring="Sirona's Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}) --80 Cure Potency with Daybreak :: -40 Enmity :: 23 Fast Cast
	
---------------
--[MIDCASTING]-[CURE WEATHER]
---------------
    sets.midcast.cure.weather = set_combine(sets.midcast.cure.normal,{
		waist="Hachirin-no-obi",
		back="Twilight Cape",		
    })   
	
---------------
--[MIDCASTING]-[REGEN+]
--RDM ONLY GETS REGEN 2. NEED TO MAX OUT ITS POWER USING GEAR
--BOLELABUNGA GIVES +10%
--TELCHINE BODY GIVES +12 SECONDS (EXTENDED UNDER COMPOSURE)
--TELCHINE GIVES +3 POTENCY AUGMENT PER PIECE USING DUSKDIM AUGMENTATION, FOR +15 TOTAL HP
--RDM CAN GET REGEN 2 UP TO 30 HP PER TIC, WHICH IS INCREDIBLY STRONG - ALMOST AS STRONG AS A FULL POWER REGEN 5  
---------------
	sets.midcast.regen = set_combine(sets.midcast.enhancing.duration, {
		main="Bolelabunga",
		head=INY.HED,
		body="Telchine Chasuble",
	})

--------------
--[MIDCASTING]-[SONGS]
--------------

	sets.midcast.songs.normal = {
		main="Carnwenhan",
		sub="Genbu's Shield",
		range="Gjallarhorn",
		head="Fili Calot",
		body="Fili Hongreline +2",
		hands="Fili Manchettes +2",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +3",
		neck="Moonbow Whistle +1",
		waist="Flume Belt",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Fortified Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	
	sets.midcast.songs.debuff = {
		main="Carnwenhan",
		sub="Genbu's Shield",
		range="Gjallarhorn",
		head="Inyanga Tiara +2",
		body="Inyanga Jubbah +2",
		hands="Inyan. Dastanas +2",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +3",
		neck="Moonbow Whistle +1",
		waist="Luminary Sash",
		left_ear="Digni. Earring",
		right_ear="Regal Earring",
		left_ring="Stikini Ring",
		right_ring="Stikini Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
	}
	
	sets.midcast.songs.dummy = {
		head="Nyame Helm",
		body="Nyame Mail",
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet="Nyame Sollerets",
		neck="Warder's Charm +1",
		waist="Carrier's Sash",
		left_ear="Genmei Earring",
		right_ear="Etiolation Earring",
		left_ring="Defending Ring",
		right_ring="Ayanmo Ring",
		back="Moonlight Cape",
	}

	sets.midcast.HonorMarch	= set_combine(sets.midcast.songs.normal, {range="Marsyas",})	
	sets.midcast.Minuet 	= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",body=EMP.BOD,})
	sets.midcast.Minne 		= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",})
	sets.midcast.March 		= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",hands=EMP.HND,})
	sets.midcast.Madrigal 	= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",head=EMP.HED,back=JSE.FAS.CHR,})
	sets.midcast.Prelude 	= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",back=JSE.FAS.CHR,})
	sets.midcast.Mambo 		= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",})
	sets.midcast.Mazurka 	= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",})
	sets.midcast.Etude 		= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",})
	sets.midcast.Ballad 	= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",legs=INY.LEG,})
	sets.midcast.Paeon 		= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",ART.HED,})
	sets.midcast.Carol 		= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",hands="",})
	
	sets.midcast.NormlLullaby 	= set_combine(sets.midcast.songs.debuff, {
		range="Daurdabla",
		--range="Marsyas", --Duration Instrument. Don't forget to disable the other instruments. 
		--range="Gjallarhorn", --Magic Accuracy Instrument.  Don't forget to disable the other instruments.
		hands="Inyan. Dastanas +2",
		legs=INY.LEG, --(Duration +17% instead of the standard raw MACC of AF Legs)  Simply --the AF Hands to use this
	}) 
	--Marysas gives duration +50% for the longest sleep.  
	--Gjallarhorn gives duration +40% but has the best magic accuracy.  
	--Daurdabla gives duration +30% and needs at least 486 String Skill for max AOE.
	--EMP.LEG -8 Song Reast for quick sleep recast.
	
	sets.midcast.THLullaby 	= set_combine(sets.midcast.songs.debuff, {
		range="Daurdabla",
		--range="Marsyas", --Duration Instrument. Don't forget to disable the other instruments. 
		--range="Gjallarhorn", --Magic Accuracy Instrument.  Don't forget to disable the other instruments.
		head="Wh. Rarab Cap +1",
		hands={ name="Chironic Gloves", augments={'STR+6','Rng.Atk.+3','"Treasure Hunter"+1','Accuracy+14 Attack+14','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		legs={ name="Chironic Hose", augments={'Blood Pact Dmg.+9','Attack+16','"Treasure Hunter"+2','Accuracy+8 Attack+8','Mag. Acc.+3 "Mag.Atk.Bns."+3',}},
	})
		
	sets.midcast.Threnody 	= set_combine(sets.midcast.songs.debuff, {range="Gjallarhorn",})
	sets.midcast.Elegy 		= set_combine(sets.midcast.songs.debuff, {range="Gjallarhorn",})
	sets.midcast.Requiem 	= set_combine(sets.midcast.songs.debuff, {range="Gjallarhorn",})
	sets.midcast.Finale 	= set_combine(sets.midcast.songs.debuff, {range="Gjallarhorn",
		legs=EMP.LEG,})
		
	sets.midcast.Scherzo 	= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",feet=EMP.FEE,})
	sets.midcast.Virelai 	= set_combine(sets.midcast.songs.debuff, {range="Gjallarhorn",})
	sets.midcast.Hymnus 	= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",})
	sets.midcast.Dirge 		= set_combine(sets.midcast.songs.normal, {range="Marsyas",})
	sets.midcast.Sirvente 	= set_combine(sets.midcast.songs.normal, {range="Gjallarhorn",})
--------------
--[MIDCASTING]-[DUMMYSONGS]
--------------

-- Type Spell name between "" to have specific set for spell. will join any dummy song gear in by default. 	
	sets.midcast["Army's Paeon"] 	= set_combine(sets.midcast.songs.dummy, {range="Daurdabla",neck="Mnbw. Whistle +1",})
	sets.midcast["Army's Paeon II"] = set_combine(sets.midcast.songs.dummy, {range="Daurdabla",neck="Mnbw. Whistle +1",})
	sets.midcast["Army's Paeon III"]= set_combine(sets.midcast.songs.dummy, {range="Daurdabla",neck="Mnbw. Whistle +1",})
	sets.midcast["Army's Paeon IV"] = set_combine(sets.midcast.songs.dummy, {range="Daurdabla",neck="Mnbw. Whistle +1",})
	sets.midcast["Goblin Gavotte"] 	= set_combine(sets.midcast.songs.dummy, {range="Daurdabla",})
	sets.midcast["Herb Pastoral"] 	= set_combine(sets.midcast.songs.dummy, {range="Daurdabla",})
end