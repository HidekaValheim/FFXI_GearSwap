-- LEGEND 
-- Use CTRL+F, and search for [[UPDATE START]] to jump to each block of code that needs to be updated with gear. 
-- There are sets in the [[IGNORE START]] blocks that can be fine tuned if you want, but it should largely be unncessary. these are default gears, or set combines that should need little to no tweaking. 
--if using notepad ++ you can select Ignore start to ignore end, and hit hide lines to reduce the clutter. 
-------------------------------------------------------------------------------------------------------------------
--[[UPDATE START]] --this indicates gear that needs to be Updated
--[[UPDATE END]] --this indicates gear the end of the update block
--[[IGNORE START]] --This indicates code that can be ignored
--[[IGNORE End]] --This indicates the end of ignored gear

-------------------------------------------------------------------------------------------------------------------
--Disclaimer: this is a heavily modified version of a random lua found out on the internet years ago.  
-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------

--[[Disable Below Code for Organizer and Porter packer if you dont have these addons]]
send_command('input //send @all lua l superwarp') 
send_command('input //lua l porterpacker') 
include('organizer-lib')

organizer_items = {
    Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
    NinjaTools={"Shihei"},
	Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},
}

PortTowns= S{"Mhaura","Selbina","Rabao","Norg"}

function get_sets()
	mote_include_version = 2
	include('Mote-Include.lua')
	require('vectors')

end
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(4, 9)
	elseif player.sub_job == 'NIN' then
		set_macro_page(3, 9)
	elseif player.sub_job == 'SAM' then
		set_macro_page(1, 9)
	elseif player.sub_job == 'DRG' then
		set_macro_page(2, 9)
	else
		set_macro_page(1, 9)
	end
end
function get_gear()
	--[[Disable code in this sub if you dont have organizer or porter packer]]
	-- if PortTowns:contains(world.area) then
		-- send_command('wait 3;input //gs org') 
		-- send_command('wait 6;input //po repack') 
    -- else
		-- add_to_chat(8,'User Not in Town - Utilize GS ORG and PO Repack Functions in Rabao, Norg, Mhaura, or Selbina')
    -- end
end

-- Setup vars that are user-independent.
function job_setup()
	--[[Enable Locks, enables locking of Retalliation gear during retalliation, and overrides all Set modifiers while retalliation is active for those items]]
	EnableLocks="ON"
	--[[Set AutoHasso to Disabled to disable automatic usage of hasso when it expires. Set it to Enabled to automatically Hasso whenever you are engaged in combat, but dont have Hasso Active]]
	AutoHasso='Enabled'
	state.Buff.Doomed = buffactive.doomed or false

	include('Mote-TreasureHunter')
	state.TreasureMode:set('None')
	state.HasteMode = M{['description']='Haste Mode', 'Haste I', 'Haste II'}
	state.MarchMode = M{['description']='March Mode', 'Trusts', '3', '7', 'Honor'}
	state.GeoMode = M{['description']='Geo Haste', 'Trusts', 'Dunna', 'Idris'}
	
	select_ammo()

	gear.MovementFeet = {}
	gear.DayFeet = ""
	gear.NightFeet = ""
	gear.ElementalObi = {name="Hachirin-no-Obi"}
	gear.default.obi_waist = "Orpheus Sash"
	
	update_combat_form()
	ninbuff_status()
	stance_status()

	state.warned = M(false)
	options.ammo_warning_limit = 25
	-- For th_action_check():
	-- JA IDs for actions that always have TH: Provoke, Animated Flourish
	info.default_ja_ids = S{35, 204}
	-- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
	info.default_u_ja_ids = S{201, 202, 203, 205, 207}
	get_gear()

end

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	windower.register_event('time change', time_change)	
	-- Options: Override default values
	state.OffenseMode:options ('Normal', 'LowAcc', 'MidAcc', 'HighAcc')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'MAXBUFF')
	state.HybridMode:options('Normal', 'Hybrid', 'Sakpata')
	state.CastingMode:options('Normal', 'Resistant', 'Burst')
	state.IdleMode:options('Normal','PDT')
	state.SchereMode=M('Off','On')
	
	Style={}
	TwoHanded={}
	DualWield={}
	SingleWield={}
	HandtoHand={}
	
	--[[Loading Addtional Sets, requires you to add a conditional statement to the self commands matching that new set]]
	--[[list out all of the main and sub weapons you want to use for cycling]]
	state.Style = M('Two-Handed','DualWield',"Sword n' Board",'Hand-to-Hand')

	--[[Pre Loaded: Chango, Ukonvasara, Bravura, Conqueror, Ragnarok, Montante, ShiningOne, Custom]]
	state.TwoHanded = M('Bunzi','Shining One','Montante +1')
	
	--[[Pre Loaded: DualSword, DualAxe, DualClub, DualDagger, Custom]]
	state.DualWield = M('DualSword', 'DualAxe', 'DualDagger')
	
	--[[Pre Loaded: Naegling, Dolichenus, Loxotic, Ternion, Custom]]
	state.SingleWield = M('Naegling', 'Dolichenus', 'Ternion')
	
	--[[Pre Loaded: Karambit, Custom]]
	state.HandtoHand = M('Karambit')

	-- Defensive Sets
	state.PhysicalDefenseMode:options('PDT')
	state.MagicalDefenseMode:options('MDT')
	-- Binds

	send_command('bind numpad7 gs c cycle OffenseMode')
	send_command('bind numpad9 gs c cycle RangedMode')
	send_command('bind numpad5 gs c cycle WeaponskillMode')
	send_command('bind numpad6 gs c cycle IdleMode')
	send_command('bind numpad3 gs c cycle SchereMode')
	send_command('bind numpad8 gs c cycle HybridMode')
	send_command('bind numpad4 gs c cycle CastingMode')
	send_command('bind numpad/ gs c StyleShift')
	send_command('bind numpad* gs c SubShift')
	send_command('bind numpad- gs c cycle HasteMode')
	send_command('bind numpad+ gs c cycle MarchMode')
	send_command('bind numpad0 input /ja Provoke <t>')
	send_command('unbind ^r')
	
	
	
	select_movement_feet()
	select_default_macro_book()
	use_UI = true
	hud_x_pos = 1515    --important to update these if you have a smaller screen
	hud_y_pos = 300     --important to update these if you have a smaller screen
	hud_draggable = true
	hud_font_size = 10
	hud_transparency = 200 -- a value of 0 (invisible) to 255 (no transparency at all)
	hud_font = 'Impact'
	setupTextWindow()
	
	stance = "No Stance"
	stance_status()
	
end

function file_unload()
	send_command('unbind ^[')
	send_command('unbind ![')
	send_command('unbind ^=')
	send_command('unbind !=')
	send_command('unbind @f9')
	send_command('unbind @[')
	send_command('unbind `')
	send_command('unbind numpad7')
	send_command('unbind numpad9')
	send_command('unbind numpad5')
	send_command('unbind numpad8')
	send_command('unbind numpad4')
	send_command('unbind numpad/')
	send_command('unbind numpad*')
	send_command('unbind numpad-')
	send_command('unbind numpad+')
	send_command('unbind numpad0')
	send_command('unbind numpad3')
end

-- Define sets and vars used by this job file.
-- sets.engaged[state.CombatForm][state.CombatWeapon][state.OffenseMode][state.HybridMode][classes.CustomMeleeGroups] (any number)

function init_gear_sets()
--[[IGNORE START]]	
	--[[ These sets are for determining your toggleable weapons]]
	sets.default={}
	--[[ you can make sub variants of each group, and have custom sub equips on each weapon if needed. 
		generally speaking, the listed three subs are the best subs]]
	sets.default.grip		= {sub	= "Utu Grip"}
	sets.default.shield 	= {sub	= "Blurred Shield +1"}
	sets.default.OffHand	= {sub	= "Demers. Degen +1"}
	
	sets.default.Karambit	= {main = "Karambit"}
	sets.default.Naegling	= set_combine(sets.default.shield,		{main = "Naegling"})
	sets.default.Dolichenus	= set_combine(sets.default.shield,		{main = "Dolichenus"})
	sets.default.Loxotic	= set_combine(sets.default.shield,		{main = "Loxotic mace +1"})
	sets.default.Ternion	= set_combine(sets.default.shield,		{main = "Ternion Dagger +1"})
	
	sets.default.Chango 	= set_combine(sets.default.grip, 		{main = "Chango"})
	sets.default.Ukonvasara	= set_combine(sets.default.grip, 		{main = "Ukonvasara"})
	sets.default.Bravura	= set_combine(sets.default.grip, 		{main = "Bravura"})
	sets.default.Conqueror	= set_combine(sets.default.grip, 		{main = "Conqueror"})
	sets.default.Bunzi		= set_combine(sets.default.grip, 		{main = "Bunzi's Chopper"})
	sets.default.Ragnarok	= set_combine(sets.default.grip, 		{main = "Ragnarok"})
	sets.default.Montante	= set_combine(sets.default.grip, 		{main = "Montante +1"})
	sets.default.ShiningOne	= set_combine(sets.default.grip, 		{main = "Shining One"})
	
	sets.default.DualSword	= set_combine(sets.default.Naegling, 	sets.default.OffHand)
	sets.default.DualAxe	= set_combine(sets.default.Dolichenus, 	sets.default.OffHand)
	sets.default.DualClub	= set_combine(sets.default.Loxotic, 	sets.default.OffHand)
	sets.default.DualDagger = set_combine(sets.default.Ternion, 	sets.default.OffHand)

	--[[use these sets if you want a custom weapon that isnt pre-defined - you wont need to add these to the logic for weapon selection]]
	sets.default.CustomOffhand={sub="Blurred Knife +1"}
	sets.default.CustomShield={sub  = "Adapa Shield"}
	sets.default.TwHnCustom	= set_combine(sets.default.grip,		{main="Beryllium Sword"})
	sets.default.H2HCustom	= {main="Hepatizon Baghnaks"}
	sets.default.SWCustom	= set_combine(sets.default.CustomShield,{main = "Hepatizon Sapara"})
	sets.default.DualCustom = set_combine(sets.default.SWCustom, sets.default.CustomOffhand)
	-- Set the Ear to override for Schere Earring if used. 
	sets.default.schere={left_ear="Schere Earring"}
--[[IGNORE END]]

--[[UPDATE START]]	
	cape={}
	--WS CAPES
		cape.STRDA  = {name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Damage taken-5%',}}
		cape.STRWSD = {name="Cichol's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}}
		cape.VITWSD = {name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Damage taken-5%',}}
		cape.INTWSD = {name="Cichol's Mantle", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','Weapon skill damage +10%','Damage taken-5%',}}
	--MeleeCapes
		cape.DA 	= {name="Cichol's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Damage taken-5%',}}
		cape.DW		= {name="Cichol's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Dual Wield"+10','Damage taken-5%',}}
		cape.STP	= {name="Cichol's Mantle", augments={'HP+60','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Damage taken-5%',}}
	--Utility Capes
		cape.Enmity = {name="Cichol's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Damage taken-5%',}}
		cape.FC		= {name="Cichol's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}
		cape.Waltz 	= {name="Cichol's Mantle", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','CHR+10','"Waltz" potency +10%','Phys. dmg. taken-10%',}}
		cape.Crit 	= {name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10','Damage taken-5%',}}
--[[UPDATE END]]	

	--------------------------------------
	-- Job Abilties
	--------------------------------------
--[[Ignore Start]]
	sets.precast.JA['Berserk'] = {feet="Agoge Calligae +3", body="Pummeler's Lorica +3", back = "Cichol's Mantle"}
	sets.precast.JA['Defender'] = {}
	sets.precast.JA['Warcry'] = set_combine(sets.precast.JA['Provoke'],{head = "Agoge Mask +3"})
	sets.precast.JA['Aggressor'] = {body = "Agoge Lorica +3", head="Pummeler's Mask +3"}
	sets.precast.JA['Retaliation'] = {feet="Boii Calligae +1", hands = "Pummeler's Mufflers +1"}
	sets.precast.JA["Warrior's Charge"] = {legs="Agoge Cuisses +3"}
	sets.precast.JA['Tommahawk'] = {ammo="Tommahawk"}
	sets.precast.JA['Restraint'] = {hands = "Boii Mufflers +1"}
	sets.precast.JA['Blood Rage'] = {body = "Boii Lorica +1"}	
	sets.precast.JA['Mighty Strikes'] = {hands = "Agoge Mufflers +3"}
	sets.precast.JA['Brazen Rush'] = {}
	sets.precast.JA['Warding Circle'] = {}
	sets.precast.JA['Hasso'] = {}
	sets.precast.JA['Seigan'] = {}
	sets.precast.JA['Third Eye'] = {}
	sets.precast.JA['Meditate'] = {}
	sets.precast.JA['Sekkanoki'] = {}
	sets.precast.JA['Ancient Circle'] = {}
--[[IGNORE END]]
--[[UPDATE START]]
	sets.precast.JA['Provoke'] = {
		back = cape.Enmity,
	}
	
	sets.precast.JA['Jump'] = {back = cape.STP,}
	sets.precast.JA['High Jump'] = {back = cape.STP,}
	sets.precast.JA['Super Jump'] = {back = cape.STP,}

	-- Waltz (chr and vit)
	sets.precast.Waltz = {
		back = cape.Waltz,
	}
	sets.precast.Waltz['Healing Waltz'] = set_combine(sets.precast.Waltz,{})
	sets.precast.Step = {
		back = cape.Crit,
	}
--[[UPDATE END]]
--[[IGNORE START]]
	sets.precast.JA['Animated Flourish'] = set_combine(	sets.precast.JA['Provoke'],{})
	sets.precast.Flourish1 = set_combine(sets.precast.Step,{})
	sets.midcast["Apururu (UC)"] = {body="Apururu Unity shirt"}

	sets.precast.JA['Vallation']	 	= set_combine(sets.precast.JA['Provoke'],{})
	sets.precast.JA['Swordplay'] 	 	= set_combine(sets.precast.JA['Provoke'],{})
	sets.precast.JA['Pflug'] 		 	= set_combine(sets.precast.JA['Provoke'],{})
	sets.precast.JA['Valiance'] 		= set_combine(sets.precast.JA['Provoke'],{})
	sets.precast.JA['Embolden'] 	 	= set_combine(sets.precast.JA['Provoke'],{})
	sets.precast.JA['Vivacious Pulse']	= set_combine(sets.precast.JA['Provoke'],{})
	sets.precast.JA['Gambit'] 			= set_combine(sets.precast.JA['Provoke'],{})
 
	-- Effusions
	sets.precast.Effusion = {}
	sets.precast.Effusion.Lunge = {}
	sets.precast.Effusion.Swipe = {}
	
	--------------------------------------
	--Buff Locking
	--------------------------------------	
	--[[Gear that needs to be locked while the corresponding buff is active. 
		make sure EnableLocks is set to "ON" if you want these to lock, 
		or the set is left blank if you dont want to enable that lock]]
	sets.locked={}
	sets.locked.Retaliation={feet="Boii Calligae +1", hands="Pumm. Mufflers +3"}
	

	--------------------------------------
	-- Ranged
	--------------------------------------
	-- Snapshot for ranged
	sets.precast.RA = {}	
	sets.midcast.RA = {}
	sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {})
	sets.midcast.RA.TH = set_combine(sets.midcast.RA, sets.TreasureHunter)
--[[IGNORE END]]
	----------------------------------
    -- Casting
	----------------------------------
	-- Precasts
--[[UPDATE START]]
	sets.precast.FC = {
		back = cape.FC,
	}
--[[UPDATE END]]
--[[IGNORE START]]
	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})
	-- Midcasts
	sets.midcast.FastRecast = set_combine(sets.precast.FC, {})
	sets.midcast.Utsusemi = set_combine(sets.midcast.SelfNinjutsu, {})
--[[IGNORE END]]
	----------------------------------
	-- Idle Sets
	----------------------------------
--[[UPDATE START]]
	sets.idle = {
		back = cape.STP,
	}

    sets.idle.PDT = {
		back = cape.STP,
	}
--[[UPDATE END]]
--[[IGNORE START]]
	----------------------------------
	-- Defensive Set Overrides. 
	----------------------------------

	sets.Hybrid = {
		head="Flam. Zucchetto +2",
		body="Sakpata's Plate",-- Can be swapped for  "Dagon Breast.",
		hands="Sakpata's Gauntlets",
		legs="Pumm. Cuisses +3",
		feet="Pumm. Calligae +3"
	}
	sets.Sakpata = {
		head="Sakpata's Helm",
		body="Sakpata's Plate",
		hands="Sakpata's Gauntlets",
		legs="Sakpata's Cuisses",
		feet="Sakpata's Leggings",
	}
	
	sets.Death = set_combine(sets.Sakpata, {left_ring="Warden's Ring"})
	sets.Resist = set_combine(sets.Sakpata, {})
	sets.Resist.Stun = set_combine(sets.Sakpata, {})
	sets.DayMovement = {feet=""}
	sets.NightMovement = {feet=""}

	--------------------------------------------------------------------
	-- Generic Armor Sets used for Micromanaging Haste DW ACC and DT tiers
	--------------------------------------------------------------------
	--Generic Accuracy Sets
	----------------------------------
	--[[ACC Guidelines Before Food(AfterFood) - Content
		Normal: 1100 (1200) - casual/solo
		Low:	1200 (1300) - Omen bosses, Geas Fete T3
		Mid:	1300 (1400) - VD Ambuscade (normal Month), Wave 3 Dyna D
		High:	1400 (1500) - Helms, VD Ambuscade (Hard month)
	Buff tiers assume No external buffs. Lower the tier if recieving madrigals or hunters.
	Use the minimum amount of gear needed to reach desired effect. These sets get merged into the final sets, overwriting the base STP/DW Sets, and then are overwritten by DT sets. 
	The less pieces you use in each set, the more accurate the end set will build out to in any variant sets
	]]
	
	sets.acc ={}
	--[ACC+100] - Need 1200 total once combined into parent set
		sets.acc.low = {
			neck="Sanctity Necklace",
			waist="Ioskeha Belt +1",
			right_ring="Moonlight Ring",		
		}
	--[ACC+200] - need 1400 Total once Combined into parent set
		sets.acc.mid = {
			neck="Sanctity Necklace",
			waist="Ioskeha Belt +1",
			left_ear="Telos Earring",
			right_ear="Crep. Earring",
			right_ring="Moonlight Ring",		
		}
	--[ACC+300] - need 1500 total once combined into parent set
		sets.acc.high= {
			neck="Sanctity Necklace",
			waist="Ioskeha Belt +1",
			left_ear="Telos Earring",
			right_ear="Crep. Earring",
			left_ring="Moonlight Ring",
			right_ring="Moonlight Ring",		
		}
		
	----------------------------------
	--DW SETS
	----------------------------------		
	--[[Use DW Sets to cap haste. if you are missing pieces from these sets, or have downgraded pieces, you can change out the slot with a new piece of gear. 
		just be sure to balance the sets to match as close as possible to the required DW
		NOTICE: Make sure you dont include gear you dont have, or "" for the slot. any set you join it into, will ignore that slot and incorrectly equip gear
		]]
	sets.dw={}
		sets.dw.head = {head 	 = ""} --+
		sets.dw.body = {body 	 = ""} --+
		sets.dw.hands= {hands 	 = "Emicho gauntlets +1"} --+6 hands
		sets.dw.legs = {legs 	 = ""} --+
		sets.dw.feet = {feet 	 = ""} --+
		sets.dw.ear1 = {left_ear = "Suppanomimi"}		--+5
		sets.dw.ear2 = {right_ear= "Eabani Earring"}	--+4
		sets.dw.waist= {waist 	 = "Reiki Yotai"}		--+7	
		sets.dw.back = {back 	 = cape.DW}				--+10 back
		sets.dw.MAX  = set_combine(sets.dw.ear2, sets.dw.waist) --Needs 11
		sets.dw.H30  = set_combine(sets.dw.hands, sets.dw.ear1, sets.dw.ear2, sets.dw.waist, sets.dw.back) --Needs 31
		sets.dw.H15	 = set_combine(sets.dw.hands, sets.dw.ear1, sets.dw.ear2, sets.dw.waist, sets.dw.back) --Needs 42
		sets.dw.H10	 = set_combine(sets.dw.hands, sets.dw.ear1, sets.dw.ear2, sets.dw.waist, sets.dw.back) --Needs 45
		sets.dw.H0   = set_combine(sets.dw.hands, sets.dw.ear1, sets.dw.ear2, sets.dw.waist, sets.dw.back) --Needs 49
--[[IGNORE END]]
--[[UPDATE START]]
	----------------------------------
	-- Untyped Engaged - 
	----------------------------------	
	sets.engaged = {
		back = cape.DA,
	}

--[[UPDATE END]]
--[[IGNORE START]]	
	----------------------------------
	--*NOTE: NONE OF THE FOLLOWING SETS NEED TO BE CHANGED AT ALL UNLESS YOU WANT TO MICROMANGE THE FINAL OUTPUT OF A SPECIFIC CONFIGURATION.]] 	
	----------------------------------
	--[[
		Set Build order: [Melee Set] > [Accuracy set] > [DW Sets] > [DT Set] > [Custom Sets]
		* DW > ACC- Most DW Gear has native acc, so stack it after ACC gear to prevent mis-equips
		* Stack DT Last to prevent DT overwrites. Current DT Set keeps 43% PDT and 50% MDT under shell 5 at all times. 
		Use 10PDT Capes over 5 DT Capes.
	]]	
	----------------------------------
	-- No Haste SetVariants
	----------------------------------
	--Accuracy Variants
	sets.engaged.DW 				= set_combine(sets.engaged, sets.dw.H0, {})
	sets.engaged.DW.LowAcc 			= set_combine(sets.engaged, sets.acc.low, sets.dw.H0, {})
	sets.engaged.DW.MidAcc 			= set_combine(sets.engaged,	sets.acc.mid, sets.dw.H0, {})
	sets.engaged.DW.HighAcc 		= set_combine(sets.engaged,	sets.acc.high,sets.dw.H0, {})

	sets.engaged.DW.Hybrid 			= set_combine(sets.engaged, sets.dw.H0, sets.Hybrid, {})
	sets.engaged.DW.LowAcc.Hybrid	= set_combine(sets.engaged, sets.acc.low, sets.dw.H0, sets.Hybrid, {})
	sets.engaged.DW.MidAcc.Hybrid 	= set_combine(sets.engaged, sets.acc.mid, sets.dw.H0, sets.Hybrid, {})
	sets.engaged.DW.HighAcc.Hybrid 	= set_combine(sets.engaged, sets.acc.high,sets.dw.H0, sets.Hybrid, {})
	
	sets.engaged.DW.Sakpata 		= set_combine(sets.engaged, sets.dw.H0, sets.Sakpata, {})
	sets.engaged.DW.LowAcc.Sakpata	= set_combine(sets.engaged, sets.acc.low, sets.dw.H0, sets.Sakpata, {})
	sets.engaged.DW.MidAcc.Sakpata 	= set_combine(sets.engaged, sets.acc.mid, sets.dw.H0, sets.Sakpata, {})
	sets.engaged.DW.HighAcc.Sakpata = set_combine(sets.engaged, sets.acc.high,sets.dw.H0, sets.Sakpata, {})
	

	----------------------------------
    -- MAX HASTE (~11%DW Needed)
	----------------------------------
	sets.engaged.DW.MaxHaste  				= set_combine(sets.engaged, sets.dw.MAX, {})
	sets.engaged.DW.LowAcc.MaxHaste 		= set_combine(sets.engaged, sets.acc.low, sets.dw.MAX, {})
	sets.engaged.DW.MidAcc.MaxHaste 		= set_combine(sets.engaged, sets.acc.mid, sets.dw.MAX, {})
	sets.engaged.DW.HighAcc.MaxHaste 		= set_combine(sets.engaged, sets.acc.high,sets.dw.MAX, {})

	sets.engaged.DW.Hybrid.MaxHaste 		= set_combine(sets.engaged, sets.dw.MAX,  sets.Hybrid, {})	
	sets.engaged.DW.LowAcc.Hybrid.MaxHaste 	= set_combine(sets.engaged, sets.acc.low, sets.dw.MAX, sets.Hybrid, {})
	sets.engaged.DW.MidAcc.Hybrid.MaxHaste 	= set_combine(sets.engaged, sets.acc.mid, sets.dw.MAX, sets.Hybrid, {})
	sets.engaged.DW.HighAcc.Hybrid.MaxHaste = set_combine(sets.engaged, sets.acc.high,sets.dw.MAX, sets.Hybrid, {})	 
	
	sets.engaged.DW.Sakpata.MaxHaste 		= set_combine(sets.engaged, sets.dw.MAX,  sets.Sakpata, {})	
	sets.engaged.DW.LowAcc.Sakpata.MaxHaste = set_combine(sets.engaged, sets.acc.low, sets.dw.MAX, sets.Sakpata, {})
	sets.engaged.DW.MidAcc.Sakpata.MaxHaste = set_combine(sets.engaged, sets.acc.mid, sets.dw.MAX, sets.Sakpata, {})
	sets.engaged.DW.HighAcc.Sakpata.MaxHaste= set_combine(sets.engaged, sets.acc.high,sets.dw.MAX,sets.Sakpata, {})	
	  
	----------------------------------
    -- 35% Haste (~10-12%DW Needed)
	----------------------------------
	-- DW Total in Gear: 12 DW / 12 DW Needed to Cap Delay Reduction
	sets.engaged.DW.Haste_35 				= set_combine(sets.engaged, sets.dw.H30, {})
	sets.engaged.DW.LowAcc.Haste_35 		= set_combine(sets.engaged, sets.acc.low, 	sets.dw.H30, 	{})
	sets.engaged.DW.MidAcc.Haste_35 		= set_combine(sets.engaged, sets.acc.mid, 	sets.dw.H30, 	{})
	sets.engaged.DW.HighAcc.Haste_35 		= set_combine(sets.engaged, sets.acc.high,	sets.dw.H30, 	{})

	sets.engaged.DW.Hybrid.Haste_35 		= set_combine(sets.engaged, sets.dw.H30,	sets.Hybrid, 	{})
	sets.engaged.DW.LowAcc.Hybrid.Haste_35 	= set_combine(sets.engaged, sets.acc.low, 	sets.dw.H30, sets.Hybrid, {})
	sets.engaged.DW.MidAcc.Hybrid.Haste_35 	= set_combine(sets.engaged, sets.acc.mid, 	sets.dw.H30, sets.Hybrid, {})
	sets.engaged.DW.HighAcc.Hybrid.Haste_35 = set_combine(sets.engaged, sets.acc.high, sets.dw.H30, sets.Hybrid, {})
	
	sets.engaged.DW.Sakpata.Haste_35 		= set_combine(sets.engaged, sets.dw.H30,	sets.Sakpata, 	{})
	sets.engaged.DW.LowAcc.Sakpata.Haste_35 = set_combine(sets.engaged, sets.acc.low, 	sets.dw.H30, sets.Sakpata, {})
	sets.engaged.DW.MidAcc.Sakpata.Haste_35 = set_combine(sets.engaged, sets.acc.mid, 	sets.dw.H30, sets.Sakpata, {})
	sets.engaged.DW.HighAcc.Sakpata.Haste_35= set_combine(sets.engaged, sets.acc.high, sets.dw.H30, sets.Sakpata, {})


	----------------------------------
    -- 30% Haste (~21-22%DW Needed)
	----------------------------------
	-- DW Total in Gear: 21 DW / 21 DW Needed to Cap Delay Reduction
	-- DW DT Sets CANT cap DW in this haste tier Without sacrificing DT. If you want to override a piece of DT Gear, simply include it. (Use DW Head, Ear2, and Waist if dropping malignance for DT)
	-- Use DW Cape 
	sets.engaged.DW.Haste_30				= set_combine(sets.engaged, sets.dw.H15, {})
	sets.engaged.DW.LowAcc.Haste_30 		= set_combine(sets.engaged, sets.acc.low, 	sets.dw.H15, {})
	sets.engaged.DW.MidAcc.Haste_30			= set_combine(sets.engaged, sets.acc.mid, 	sets.dw.H15, {})
	sets.engaged.DW.HighAcc.Haste_30 		= set_combine(sets.engaged, sets.acc.high, sets.dw.H15, {})

	sets.engaged.DW.Hybrid.Haste_30 		= set_combine(sets.engaged, sets.dw.H15,	sets.Hybrid, 	{})
	sets.engaged.DW.LowAcc.Hybrid.Haste_30 	= set_combine(sets.engaged, sets.acc.low, 	sets.dw.H15, sets.Hybrid, {})
	sets.engaged.DW.MidAcc.Hybrid.Haste_30 	= set_combine(sets.engaged, sets.acc.mid, 	sets.dw.H15, sets.Hybrid, {})
	sets.engaged.DW.HighAcc.Hybrid.Haste_30 = set_combine(sets.engaged, sets.acc.high, sets.dw.H15, sets.Hybrid, {})	
	
	sets.engaged.DW.Sakpata.Haste_30 		= set_combine(sets.engaged, sets.dw.H15,	sets.Sakpata, 	{})
	sets.engaged.DW.LowAcc.Sakpata.Haste_30 = set_combine(sets.engaged, sets.acc.low, 	sets.dw.H15, sets.Sakpata, {})
	sets.engaged.DW.MidAcc.Sakpata.Haste_30 = set_combine(sets.engaged, sets.acc.mid, 	sets.dw.H15, sets.Sakpata, {})
	sets.engaged.DW.HighAcc.Sakpata.Haste_30= set_combine(sets.engaged, sets.acc.high, sets.dw.H15, sets.Sakpata, {})	

	----------------------------------
	-- 15% Haste (~32%DW Needed)
	----------------------------------
	-- DW Total in Gear: 32 DW / 32 DW Needed to Cap Delay Reduction
	sets.engaged.DW.Haste_15 				= set_combine(sets.engaged, sets.dw.H10, 	{})
	sets.engaged.DW.LowAcc.Haste_15 		= set_combine(sets.engaged, sets.acc.low, 	sets.dw.H10, 	{})
	sets.engaged.DW.MidAcc.Haste_15 		= set_combine(sets.engaged, sets.acc.mid, 	sets.dw.H10, 	{})
	sets.engaged.DW.HighAcc.Haste_15 		= set_combine(sets.engaged, sets.acc.high,	sets.dw.H10,	{})

	sets.engaged.DW.Hybrid.Haste_15 		= set_combine(sets.engaged, sets.dw.H10,	sets.Hybrid, {})
	sets.engaged.DW.LowAcc.Hybrid.Haste_15 	= set_combine(sets.engaged, sets.acc.low,	sets.dw.H10, sets.Hybrid, {})
	sets.engaged.DW.MidAcc.Hybrid.Haste_15 	= set_combine(sets.engaged, sets.acc.mid,	sets.dw.H10, sets.Hybrid, {})
	sets.engaged.DW.HighAcc.Hybrid.Haste_15 = set_combine(sets.engaged, sets.acc.high,	sets.dw.H10, sets.Hybrid, {})	
	
	sets.engaged.DW.Sakpata.Haste_15 		= set_combine(sets.engaged, sets.dw.H10,	sets.Sakpata, {})
	sets.engaged.DW.LowAcc.Sakpata.Haste_15 = set_combine(sets.engaged, sets.acc.low,	sets.dw.H10, sets.Sakpata, {})
	sets.engaged.DW.MidAcc.Sakpata.Haste_15 = set_combine(sets.engaged, sets.acc.mid,	sets.dw.H10, sets.Sakpata, {})
	sets.engaged.DW.HighAcc.Sakpata.Haste_15= set_combine(sets.engaged, sets.acc.high,	sets.dw.H10, sets.Sakpata, {})	

--[[IGNORE END]]	
--[[UPDATE START]]	
	----------------------------------
	--Sword And Board
	----------------------------------	
	
	sets.engaged.SNB = {
		back = cape.DA,
	}
--[[UPDATE END]]
--[[IGNORE START]]	
	----------------------------------
	-- Sword And Board Variants (Dont need to alter these unless you need to specifically change the combined set)
	----------------------------------		
	sets.engaged.SNB.LowAcc 		= set_combine(sets.engaged.SNB, sets.acc.low,	{})
	sets.engaged.SNB.MidAcc 		= set_combine(sets.engaged.SNB, sets.acc.mid,	{})
	sets.engaged.SNB.HighAcc 		= set_combine(sets.engaged.SNB, sets.acc.high, {})

	sets.engaged.SNB.Hybrid 		= set_combine(sets.engaged.SNB, sets.Hybrid, {})
	sets.engaged.SNB.LowAcc.Hybrid	= set_combine(sets.engaged.SNB, sets.acc.low,	sets.Hybrid, {})
	sets.engaged.SNB.MidAcc.Hybrid 	= set_combine(sets.engaged.SNB, sets.acc.mid,	sets.Hybrid, {})
	sets.engaged.SNB.HighAcc.Hybrid = set_combine(sets.engaged.SNB, sets.acc.high,sets.Hybrid, {})
	
	sets.engaged.SNB.Sakpata 		= set_combine(sets.engaged.SNB, sets.Sakpata, {})
	sets.engaged.SNB.LowAcc.Sakpata	= set_combine(sets.engaged.SNB, sets.acc.low,	sets.Sakpata, {})
	sets.engaged.SNB.MidAcc.Sakpata = set_combine(sets.engaged.SNB, sets.acc.mid,	sets.Sakpata, {})
	sets.engaged.SNB.HighAcc.Sakpata= set_combine(sets.engaged.SNB, sets.acc.high,sets.Sakpata, {})
--[[IGNORE END]]
--[[UPDATE START]]	
	----------------------------------
	-- TwoHanded
	----------------------------------

	sets.engaged.Twohanded = {
		back = cape.DA,	
	}
--[[UPDATE END]]
--[[IGNORE START]]		
	----------------------------------
	-- TwoHanded Variants (Dont need to alter these unless you need to specifically change the combined set)
	----------------------------------		
	sets.engaged.Twohanded.LowAcc 		= set_combine(sets.engaged.Twohanded, sets.acc.low,	{})
	sets.engaged.Twohanded.MidAcc 		= set_combine(sets.engaged.Twohanded, sets.acc.mid,	{})
	sets.engaged.Twohanded.HighAcc 		= set_combine(sets.engaged.Twohanded, sets.acc.high, {})

	sets.engaged.Twohanded.Hybrid 		= set_combine(sets.engaged.Twohanded, sets.Hybrid, {})
	sets.engaged.Twohanded.LowAcc.Hybrid	= set_combine(sets.engaged.Twohanded, sets.acc.low,	sets.Hybrid, {})
	sets.engaged.Twohanded.MidAcc.Hybrid 	= set_combine(sets.engaged.Twohanded, sets.acc.mid,	sets.Hybrid, {})
	sets.engaged.Twohanded.HighAcc.Hybrid = set_combine(sets.engaged.Twohanded, sets.acc.high,sets.Hybrid, {})
	
	sets.engaged.Twohanded.Sakpata 		= set_combine(sets.engaged.Twohanded, sets.Sakpata, {})
	sets.engaged.Twohanded.LowAcc.Sakpata	= set_combine(sets.engaged.Twohanded, sets.acc.low,	sets.Sakpata, {})
	sets.engaged.Twohanded.MidAcc.Sakpata 	= set_combine(sets.engaged.Twohanded, sets.acc.mid,	sets.Sakpata, {})
	sets.engaged.Twohanded.HighAcc.Sakpata = set_combine(sets.engaged.Twohanded, sets.acc.high,sets.Sakpata, {})
--[[IGNORE END]]
--[[UPDATE START]]			
	----------------------------------
	-- Hand to Hand
	----------------------------------	
	
	sets.engaged.H2H = {
		back = cape.DA,	
	}
--[[UPDATE END]]
--[[IGNORE START]]
	----------------------------------
	-- Hand to Hand Variants (Dont need to alter these unless you need to specifically change the combined set)
	----------------------------------		
	sets.engaged.H2H.LowAcc 		= set_combine(sets.engaged.H2H, sets.acc.low,	{})
	sets.engaged.H2H.MidAcc 		= set_combine(sets.engaged.H2H, sets.acc.mid,	{})
	sets.engaged.H2H.HighAcc 		= set_combine(sets.engaged.H2H, sets.acc.high, {})

	sets.engaged.H2H.Hybrid 			= set_combine(sets.engaged.H2H, sets.Hybrid, {})
	sets.engaged.H2H.LowAcc.Hybrid	= set_combine(sets.engaged.H2H, sets.acc.low,	sets.Hybrid, {})
	sets.engaged.H2H.MidAcc.Hybrid 	= set_combine(sets.engaged.H2H, sets.acc.mid,	sets.Hybrid, {})
	sets.engaged.H2H.HighAcc.Hybrid 	= set_combine(sets.engaged.H2H, sets.acc.high,sets.Hybrid, {})
	
	sets.engaged.H2H.Sakpata 			= set_combine(sets.engaged.H2H, sets.Sakpata, {})
	sets.engaged.H2H.LowAcc.Sakpata	= set_combine(sets.engaged.H2H, sets.acc.low,	sets.Sakpata, {})
	sets.engaged.H2H.MidAcc.Sakpata 	= set_combine(sets.engaged.H2H, sets.acc.mid,	sets.Sakpata, {})
	sets.engaged.H2H.HighAcc.Sakpata 	= set_combine(sets.engaged.H2H, sets.acc.high,sets.Sakpata, {})
--[[IGNORE END]]
--[[UPDATE START]]
	----------------------------------
	-- Weaponskills (General)
	----------------------------------
	--[[
		Individual WS Sets. The Precast.WS set is the default set for when no set is declared for that weaponskill. The MAXBUFF is a toggle set, for when you are 
		recieving full buffs, and dont need to wear as much attack or accuracy in your set
	]]
	
	--Generic Catch all set, for any WS not specifically declared. Use full Weaponskill Damage in this set, and use set combines to swap out unneeded gear
	sets.precast.WS = {
		back = cape.STRWSD,		
	}
	sets.precast.WS.MAXBUFF = set_combine(sets.precast.WS, {
	
	})

  	-- Generic Set for Attack Damage to serve as the base for any Attack WS you might use. Does not Catch Undeclared Attack WS. This is used as a join set only.   
	sets.precast.WS.ATK={
		back = cape.STRDA,	
	}
	sets.precast.WS.ATK.MAXBUFF = set_combine(sets.precast.WS.ATK,{
	
	})	

 	-- Generic Set for Critcal Damage to serve as the base for any Critcal WS you might use. Does not Catch Undeclared Critcal WS. This is used as a join set only.   
	sets.precast.WS.CRIT={
		back = cape.Crit
	}
	sets.precast.WS.CRIT.MAXBUFF = set_combine(sets.precast.WS.CRIT,{
	
	})	

	-- Generic Set for Hybrid Damage to serve as the base for any Hybrid WS you might use. Does not Catch Undeclared Hybrid WS. This is used as a join set only.
	sets.precast.WS.HYBRID={
		back = cape.STRWSD	
	}
	sets.precast.WS.HYBRID.MAXBUFF = set_combine(sets.precast.WS.HYBRID,{
	
	})
	
	-- Generic Set for magic Damage to serve as the base for any magic WS you might use. Does not Catch Undeclared magic WS. This is used as a join set only.
	sets.precast.WS.MAB={
		back = cape.INTWSD
	}
	sets.precast.WS.MAB.MAXBUFF = set_combine(sets.precast.WS.MAB,{
	
	})
		
	-- Generic Set for magic Damage to serve as the base for any magic WS you might use. Does not Catch Undeclared magic WS. This is used as a join set only.
	sets.precast.WS.MACC={
		back = cape.INTWSD
	}
	sets.precast.WS.MACC.MAXBUFF = set_combine(sets.precast.WS.MACC,{
	
	})
--[[UPDATE END]]
--[[IGNORE START]]
	-------------------
	--[SPECIFIC WEAPONSKILL SETS]
	--These do not need to be changed unless you want to override the default sets gear
	--If a weapon skill is not included in the below Weaponskills list, it will default to the sets.precast.WS Set. Be sure to declare any other WS's you want to use that arent listed here. 
	-------------------
	--[Great Axe Weaponskills]
		sets.precast.WS["Ukko's Fury"] = set_combine(sets.precast.WS.CRIT, {})
		sets.precast.WS["Ukko's Fury"].MAXBUFF = set_combine(sets.precast.WS.CRIT.MAXBUFF, {})	
		
		sets.precast.WS['Metatron Torment'] = set_combine(sets.precast.WS, {})
		sets.precast.WS['Metatron Torment'].MAXBUFF = set_combine(sets.precast.WS.MAXBUFF, {})	
		
		sets.precast.WS['Upheaval'] = set_combine(sets.precast.WS.ATK, {})
		sets.precast.WS['Upheaval'].MAXBUFF = set_combine(sets.precast.WS.ATK.MAXBUFF, {})	
		
		sets.precast.WS['Fell Cleave'] = set_combine(sets.precast.WS, {})
		sets.precast.WS['Fell Cleave'].MAXBUFF = set_combine(sets.precast.WS.MAXBUFF, {})	

		sets.precast.WS['Full Break'] = set_combine(sets.precast.WS.MACC, {})
		sets.precast.WS['Full Break'].MAXBUFF = set_combine(sets.precast.WS.MACC.MAXBUFF, {})		
	
	--[Great Sword Weaponskills]
		sets.precast.WS['Resolution'] = set_combine(sets.precast.WS.ATK, {neck="Fotia Gorget", waist="Fotia Belt"})
		sets.precast.WS['Resolution'].MAXBUFF = set_combine(sets.precast.WS.ATK.MAXBUFF, {neck="Fotia Gorget", waist="Fotia Belt"})		
	
	--[Polearm Weaponskills]
		sets.precast.WS['Impulse Drive'] = set_combine(sets.precast.WS.CRIT, {})
		sets.precast.WS['Impulse Drive'].MAXBUFF = set_combine(sets.precast.WS.CRIT.MAXBUFF, {})		
	
	--[Scythe Weaponskills]
		sets.precast.WS['Entropy'] = set_combine(sets.precast.WS.ATK, {neck="Fotia Gorget", waist="Fotia Belt"})
		sets.precast.WS['Entropy'].MAXBUFF = set_combine(sets.precast.WS.ATK.MAXBUFF, {neck="Fotia Gorget", waist="Fotia Belt"})	
	
	--[Staff Weaponskills]
		sets.precast.WS['Shell Crusher'] = set_combine(sets.precast.WS.MACC, {})
		sets.precast.WS['Shell Crusher'].MAXBUFF = set_combine(sets.precast.WS.MACC.MAXBUFF, {})	
	
	--[Great Katana Weaponskills]
		sets.precast.WS['Tachi: Koki'] = set_combine(sets.precast.WS.HYBRID, {})
		sets.precast.WS['Tachi: Koki'].MAXBUFF = set_combine(sets.precast.WS.HYBRID.MAXBUFF, {})	
	
		sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS.HYBRID, {})
		sets.precast.WS['Tachi: Jinpu'].MAXBUFF = set_combine(sets.precast.WS.HYBRID.MAXBUFF, {})	
		
		sets.precast.WS['Tachi: Kagero'] = set_combine(sets.precast.WS.HYBRID, {})
		sets.precast.WS['Tachi: Kagero'].MAXBUFF = set_combine(sets.precast.WS.HYBRID.MAXBUFF, {})	
		
		sets.precast.WS['Tachi: Goten'] = set_combine(sets.precast.WS.HYBRID, {})
		sets.precast.WS['Tachi: Goten'].MAXBUFF = set_combine(sets.precast.WS.HYBRID.MAXBUFF, {})	
	
	--[Axe Weaponskills]
		sets.precast.WS['Decimation'] = set_combine(sets.precast.WS.ATK, {neck="Fotia Gorget", waist="Fotia Belt"})
		sets.precast.WS['Decimation'].MAXBUFF = set_combine(sets.precast.WS.ATK.MAXBUFF, {neck="Fotia Gorget", waist="Fotia Belt"})		
	
	--[Sword Weaponskills]
		sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {})
		sets.precast.WS['Savage Blade'].MAXBUFF = set_combine(sets.precast.WS.MAXBUFF, {})		
		
		sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS.MAB, {head="Pixie Hairpin +1"})

	--[Dagger Weaponskills]
		sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS.MAB, {})
		sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS.CRIT,{neck="Fotia Gorget", waist="Fotia Belt"})

	--[Club Weaponskills]
		sets.precast.WS['Realmrazer'] = set_combine(sets.precast.WS.ATK, {neck="Fotia Gorget", waist="Fotia Belt"})
		sets.precast.WS['Realmrazer'].MAXBUFF = set_combine(sets.precast.WS.ATK.MAXBUFF, {neck="Fotia Gorget", waist="Fotia Belt"})	
	
		sets.precast.WS['Black Halo'] = set_combine(sets.precast.WS, {})
		sets.precast.WS['Black Halo'].MAXBUFF = set_combine(sets.precast.WS.MAXBUFF, {})		

		sets.precast.WS['Judgment'] = set_combine(sets.precast.WS, {})
		sets.precast.WS['Judgment'].MAXBUFF = set_combine(sets.precast.WS.MAXBUFF, {})		
		
	--[Hand To Hand]
		sets.precast.WS['Raging Fists'] = set_combine(sets.precast.WS.ATK, {neck="Fotia Gorget", waist="Fotia Belt"})
		sets.precast.WS['Raging Fists'].MAXBUFF = set_combine(sets.precast.WS.ATK.MAXBUFF, {neck="Fotia Gorget", waist="Fotia Belt"})	
		
		sets.precast.WS['Tornado Kick'] = set_combine(sets.precast.WS, {})
		sets.precast.WS['Tornado Kick'].MAXBUFF = set_combine(sets.precast.WS.MAXBUFF, {})		
		
		sets.precast.WS['Asuran Fists'] = set_combine(sets.precast.WS.ATK, {neck="Fotia Gorget", waist="Fotia Belt"})
		sets.precast.WS['Asuran Fists'].MAXBUFF = set_combine(sets.precast.WS.ATK.MAXBUFF, {neck="Fotia Gorget", waist="Fotia Belt"})	
--[[IGNORE END]]

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------
function job_pretarget(spell, action, spellMap, eventArgs)
	if state.Buff[spell.english] ~= nil then
		state.Buff[spell.english] = true
	end
	if (spell.type:endswith('Magic') or spell.type == "Ninjutsu") and buffactive.silence then
		cancel_spell()
		send_command('input /item "Echo Drops" <me>')
	end
end
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spell.skill == "Ninjutsu" and spell.target.type:lower() == 'self' and spellMap ~= "Utsusemi" then
		if spell.english == "Migawari" then
			classes.CustomClass = "Migawari"
		else
			classes.CustomClass = "SelfNinjutsu"
		end
	end
-- Cancel Sneak before reapplying spectral jig
	if spell.name == 'Spectral Jig' and buffactive.sneak then
		send_command('cancel 71')
	end
--Cancel Utsusemi Shadows during casting lower tier utsusemi spells. prevents re-casting utsusemi with more than 4 shadows remaining to prevent overbuffing
    if spell.name == 'Utsusemi: Ichi' then
		if buffactive['Copy Image'] or buffactive['Copy Image (2)'] or buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)']  then
			send_command('cancel 66; cancel 444; cancel 445; cancel 446; cancel Copy Image; cancel Copy Image (2); cancel Copy Image (3);cancel Copy Image (4+)')
--[[debug	add_to_chat(123, '**!!CASTING UTSUSEMI: ICHI - REMOVING EXISTING SHADOWS!!**')]]
		end
	elseif spell.name == 'Utsusemi: Ni' then
		if buffactive['Copy Image'] or buffactive['Copy Image (2)'] or buffactive['Copy Image (3)'] or buffactive['Copy Image (4+)']  then
			send_command('cancel 66; cancel 444; cancel 445; cancel 446; cancel Copy Image; cancel Copy Image (2); cancel Copy Image (3);cancel Copy Image (4+)')
--[[debug	add_to_chat(123, '**!!CASTING UTSUSEMI: NI - REMOVING EXISTING SHADOWS!!**')]]
		end
	end
end

function job_post_precast(spell, action, spellMap, eventArgs)
	-- Ranged Attacks 
	if spell.action_type == 'Ranged Attack' and state.OffenseMode ~= 'LowAcc' then
		equip(sets.SangeAmmo)
	end
	-- Protection for lag
	if spell.name == 'Sange' and player.equipment.ammo == gear.RegularAmmo then
		state.Buff.Sange = false
		eventArgs.cancel = true
	end
	if state.SchereMode.value == 'On' and spell.type == "WeaponSkill" and spell.name ~= 'Sanguine Blade'then
		equip(sets.default.schere)
	end	
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.english == "Monomi: Ichi" then
		if buffactive['Sneak'] then
			send_command('@wait 1;cancel 71')
		end
	end
end

-- Run after the general midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if state.Buff.Futae and spellMap == 'ElementalNinjutsu' then
		 equip(sets.precast.JA['Futae'])
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	if midaction() then
		return
	end
	ninbuff_status()
	-- Aftermath timer creation
	aw_custom_aftermath_timers_aftercast(spell)
	stance_status()

end

-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Called before the Include starts constructing melee/idle/resting sets.
-- Can customize state or custom melee class values at this point.
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_handle_equipping_gear(playerStatus, eventArgs)
	local lockables = T{'Mamool Ja Earring', 'Aptitude Mantle', 'Nexus Cape', 'Aptitude Mantle +1', 'Warp Ring', 'Vocation Ring', 'Reraise Earring', 'Capacity Ring', 'Trizek Ring', 'Echad Ring', 'Facility Ring', 'Dim. Ring (Holla)', 'Dim. Ring (Dem)', 'Dim. Ring (Mea)'}
	local watch_slots = T{'lear','rear','ring1','ring2','back','head'}
	for _,v in pairs(watch_slots) do
		if lockables:contains(player.equipment[v]) then
			disable(v)
			if has_charges(player.equipment[v]) and (not is_enchant_ready(player.equipment[v])) then
				enable(v)
			end
		else
			enable(v)
		end
	end
	ninbuff_status()
	stance_status()
	tool_counter()
	validateTextInformation()
	update_combat_form()
	select_weapons()
end

-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
--[[Placeholder code if you want to add custom modifiers to idle sets, like HP Sub X% then Equip regen items]]
	if state.HybridMode.value == 'PDT' then
		idleSet = idleSet
	else
		idleSet = idleSet
	end
	
	return idleSet
end

-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	meleeSet = set_combine(meleeSet, select_ammo())
	if state.TreasureMode.value == 'Fulltime' then
		meleeSet = set_combine(meleeSet, sets.TreasureHunter)
	end
	if buffactive[''] and EnableLocks=='ON' then
		meleeSet=set_combine(meleeSet,sets.locked.Retaliation)
	end
	if state.SchereMode.value == 'On' then
		meleeSet=set_combine(meleeSet,{left_ear="Schere Earring"})
	end
	return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
-- General hooks for other events.
-------------------------------------------------------------------------------------------------------------------
-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if state.Buff[buff] ~= nil then
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end

	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste', 'march', 'mighty guard', 'embrava', 'haste samba', 'geo-haste', 'indi-haste'}:contains(buff:lower()) then
		determine_haste_group()
		if not midaction() then
			handle_equipping_gear(player.status)
		end
	end


end

function ninbuff_status()
	if buffactive['Copy Image'] then
		shadows='1 Shadow'
	elseif buffactive['Copy Image (2)'] then
		shadows='2 Shadows'
	elseif buffactive['Copy Image (3)'] then
		shadows='3 Shadows'
	elseif buffactive['Copy Image (4+)'] then
		shadows='4 Shadows' 
	else
		shadows='No Shadows'
	end
end

function job_status_change(newStatus, oldStatus, eventArgs)
	if newStatus == 'Engaged' then
		update_combat_form()
	end
	update_combat_form()
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements self-commands.
-------------------------------------------------------------------------------------------------------------------
-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)

	select_ammo()
	select_movement_feet()
	determine_haste_group()
	update_combat_form()
	th_update(cmdParams, eventArgs)
	tool_counter()
	validateTextInformation()
	stance_status()
end

-------------------------------------------------------------------------------------------------------------------
-- Facing ratio
-------------------------------------------------------------------------------------------------------------------
function facing_away(spell)

end
-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
	if state.Buff[buff_name] then
		equip(sets.buff[buff_name] or {})
		if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
			equip(sets.TreasureHunter)
		end
		eventArgs.handled = true
	end
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
	if category == 2 or -- any ranged attack
		--category == 4 or -- any magic action
		(category == 3 and param == 30) or -- Aeolian Edge
		(category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
		(category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
		then 
			return true
    end
end

function select_movement_feet()
	if world.time >= (17*60) or world.time < (7*60) then
		gear.MovementFeet.name = gear.NightFeet
	else
		gear.MovementFeet.name = gear.DayFeet
	end
end

function determine_haste_group()
	classes.CustomMeleeGroups:clear()
	
	h = 0
	-- Spell Haste 15/30
	if buffactive[33] then
		if state.HasteMode.value == 'Haste I' then
			h = h + 15
		elseif state.HasteMode.value == 'Haste II' then
			h = h + 30
		end
	end
	-- Geo Haste 29/35/40 (assumes dunna and idris have 900 skill)
	if buffactive[580] then
		if state.GeoMode.value == 'Trusts' then
			h = h + 29.9
		elseif state.GeoMode.value == 'Dunna' then
			h = h + 35.4
		elseif state.GeoMode.value == 'Idris' then
			h = h + 40
		end
	end
	-- Mighty Guard 15
	if buffactive[604] then
		h = h + 15
	end
	-- Embrava 25.9
	if buffactive.embrava then
		h = h + 25.9
	end
	-- March(es) 
	if buffactive.march then
		if state.MarchMode.value == 'Honor' then
			if buffactive.march == 2 then
				h = h + 27 + 16
			elseif buffactive.march == 1 then
				h = h + 16
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		elseif state.MarchMode.value == 'Trusts' then
			if buffactive.march == 2 then
				h = h + 26
			elseif buffactive.march == 1 then
				h = h + 16
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		elseif state.MarchMode.value == '7' then
			if buffactive.march == 2 then
				h = h + 27 + 17
			elseif buffactive.march == 1 then
				h = h + 27
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		elseif state.MarchMode.value == '3' then
			if buffactive.march == 2 then
				h = h + 13.5 + 20.6
			elseif buffactive.march == 1 then
				h = h + 20.6
			elseif buffactive.march == 3 then
				h = h + 27 + 17 + 16
			end
		end
	end

	-- Determine CustomMeleeGroups
	if h >= 15 and h < 30 then 
		classes.CustomMeleeGroups:append('Haste_15')
		add_to_chat('Haste Group: 15% -- From Haste Total: '..h)
	elseif h >= 30 and h < 35 then 
		classes.CustomMeleeGroups:append('Haste_30')
		add_to_chat('Haste Group: 30% -- From Haste Total: '..h)
	elseif h >= 35 and h < 40 then 
		classes.CustomMeleeGroups:append('Haste_35')
		add_to_chat('Haste Group: 35% -- From Haste Total: '..h)
	elseif h >= 40 then
		classes.CustomMeleeGroups:append('MaxHaste')
		add_to_chat('Haste Group: Max -- From Haste Total: '..h)
	end

end

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)

end

-- Creating a custom spellMap, since Mote capitalized absorbs incorrectly
function job_get_spell_map(spell, default_spell_map)
	if spell.type == 'Trust' then
		return 'Trust'
	end
end

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
	local msg = ''
	msg = msg .. 'Offense: '..state.OffenseMode.current

	if state.CombatWeapon.value == 'Kannagi' or state.CombatWeapon.value == 'GKT' then
		msg = msg..' --'..state.CombatWeapon.value..'-- '
	end
	
	if state.DefenseMode.value ~= 'None' then
		local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
		msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
	end
	if state.HasteMode.value ~= 'Normal' then
		msg = msg .. ', Haste: '..state.HasteMode.current
	end
	if state.MarchMode.value ~= 'Normal' then
		msg = msg .. ', March Mode: '..state.MarchMode.current
	end
	if state.RangedMode.value ~= 'Normal' then
		msg = msg .. ', Rng: '..state.RangedMode.current
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
	add_to_chat(123, msg)
	eventArgs.handled = true
end

-- Call from job_precast() to setup aftermath information for custom timers.
function aw_custom_aftermath_timers_precast(spell)

end

-- Call from job_aftercast() to create the custom aftermath timer.
function aw_custom_aftermath_timers_aftercast(spell)

end

function select_ammo()

end

function select_weapons()
	if state.Style.current == "Two-Handed" then
		if state.TwoHanded.current=="Chango" then 
			equip(sets.default.Chango)
		elseif state.TwoHanded.current=="Ukonvasara" then 
			equip(sets.default.Ukonvasara)
		elseif state.TwoHanded.current=="Bravura" then 
			equip(sets.default.Bravura)
		elseif state.TwoHanded.current=="Conqueror" then 
			equip(sets.default.Conqueror)
		elseif state.TwoHanded.current=="Bunzi" then 
			equip(sets.default.Bunzi)
		elseif state.TwoHanded.current=="Ragnarok" then 
			equip(sets.default.Ragnarok)
		elseif state.TwoHanded.current=="Montante +1" then 
			equip(sets.default.Montante)
		elseif state.TwoHanded.current=="Shining One" then 
			equip(sets.default.ShiningOne)
		elseif state.TwoHanded.current=="Custom" then 
			equip(sets.default.TwHnCustom)
		end
		state.CombatWeapon:set('Twohanded')	
	elseif state.Style.current == "DualWield" then
		if state.DualWield.current=="DualSword" then 
			equip(sets.default.DualSword)
		elseif state.DualWield.current=="DualAxe" then 
			equip(sets.default.DualAxe)
		elseif state.DualWield.current=="DualClub" then 
			equip(sets.default.DualClub)
		elseif state.DualWield.current=="DualDagger" then 
			equip(sets.default.DualDagger)	
		elseif state.DualWield.current=="Custom" then 
			equip(sets.default.DualCustom)
		end
		state.CombatWeapon:set('DW')
	elseif state.Style.current == "Sword n' Board" then
		if state.SingleWield.current=="Naegling" then 
			equip(sets.default.Naegling)
		elseif state.SingleWield.current=="Dolichenus" then 
			equip(sets.default.Dolichenus)
		elseif state.SingleWield.current=="Loxotic" then 
			equip(sets.default.Loxotic)
		elseif state.SingleWield.current=="Ternion" then 
			equip(sets.default.Ternion)	
		elseif state.SingleWield.current=="Custom" then 
			equip(sets.default.SWCustom)
		end
		state.CombatWeapon:set('SNB')	
	elseif state.Style.Current == "Hand-to-Hand" then 
		if state.HandtoHand.current=="Karambit" then 
			equip(sets.default.Karambit)
		elseif state.HandtoHand.current=="Custom" then 
			equip(sets.default.H2HCustom)
		end
		state.CombatWeapon:set('H2H')
	end

setupTextWindow()
end

function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'StyleShift' then
		state.Style:cycle()
		state.TwoHanded:reset()
		state.DualWield:reset()
		state.SingleWield:reset()
		state.HandtoHand:reset()
		select_weapons()
	end
	if cmdParams[1] == 'SubShift' then
		if state.Style.current == "Two-Handed" then
			state.TwoHanded:cycle()
		elseif state.Style.current == "DualWield" then
			state.DualWield:cycle()
		elseif state.Style.current == "Sword n' Board" then
			state.SingleWield:cycle()
		elseif state.Style.Current == "Hand-to-Hand" then 
			state.HandtoHand:cycle()
		end
	select_weapons()	
	end

end
	
function update_combat_form()

end


function stance_status()
	if player.sub_job == 'SAM' and AutoHasso == 'Enabled' and state.Style.current == "TwoHanded" then
		if buffactive['Hasso'] then
			stance = 'Hasso'
		elseif buffactive['Seigan'] then
			stance = 'Seigan'
		else
			stance = 'No Stance'
		end
		hasso_check()
	end
end

function hasso_check()
 local ability_recasts = windower.ffxi.get_ability_recasts()
	if stance =='No Stance' and player.status=='Engaged' then
		if ability_recasts[138] == 0 then
			send_command('@input /ja "Hasso" <me> ;wait 1')
		end
	end
end

--NIN_HUD--
--------------------------------------------------------------------------------------------------------------
-- HUD STUFF
--------------------------------------------------------------------------------------------------------------
require('logger')
require('tables')
require('strings')
--global tool placeholder
shihei 	= {}
shadows = {}
--global colors
color={}
color.red		='(255,0,0)'
color.yellow 	='(0,255,0)'
color.blue		='(0,0,255)'
color.white		='(255,255,255)'
color.black		='(0,0,0)'
color.grey		='(175,175,175)'
color.ltred		='(255,125,125)'
color.ltblue	='(125,125,255)'
color.ltyellow	='(125,255,125)'


function tool_counter()

	local inv = windower.ffxi.get_items(0) -- get main inventory
	
	shihei.count = 0
	shihei.id = 1179
	
	for b,v in ipairs(inv) do
		if v.id == shihei.id then
			shihei.count = shihei.count + v.count
		end
	end
--[[
Debug Viewer
	windower.add_to_chat(8,'shihei:' ..shihei.count)
]]
end


const_on = "\\cs(32, 255, 32)ON\\cr"
const_off = "\\cs(255, 32, 32)OFF\\cr"

hud_x_pos_og = hud_x_pos
hud_y_pos_og = hud_y_pos
hud_font_size_og = hud_font_size
hud_padding_og = hud_padding
hud_transparency_og = hud_transparency

MB_Window = 0
time_start = 0
hud_padding = 10

-- Standard Mode
hub_mode_std = [[\cs(204, 0, 0)KeyBinds    \cs(255, 115, 0)GS Info: \cr              
		\cs(175, 125, 225)${KB_C_MH}\cs(0, 150, 175)Combat:\cr \cs(125,255,125)${player_current_mainweapon}
		\cs(175, 125, 225)${KB_C_OH}\cs(0, 150, 175)Main:\cr \cs(125,255,125)  ${player_current_subweapon}
		\cs(175, 125, 225)${KB_Melee_M}\cs(0, 150, 175)Melee Mode:\cr     ${player_current_melee}
		\cs(175, 125, 225)${KB_WS_M}\cs(0, 150, 175)WS Mode:\cr            ${player_current_ws}
		\cs(175, 125, 225)${KB_PDT_M}\cs(0, 150, 175)Hybrid Mode:\cr    ${player_current_Hybrid}
		\cs(175, 125, 225)${KB_ID_M}\cs(0, 150, 175)Idle Mode:\cr           ${player_current_Idle}
		\cs(175, 125, 225)${KB_SC_M}\cs(0, 150, 175)Schere Mode:\cr   ${player_current_Schere}
		\cs(175, 125, 225)${KB_Haste_M}\cs(0, 150, 175)Haste Mode:\cr       ${player_current_Haste}
		\cs(175, 125, 225)${KB_March_M}\cs(0, 150, 175)March Mode:\cr      ${player_current_March}
		\cs(204, 0, 0)Item    \cs(255, 115, 0)                                Count: \cr 	
		\cs(255, 150, 0)   Shihei:\cr \cs${shihei_color}                                    ${Shihei_Left}
		\cs(204, 0, 0)Job Info\cs(255, 115, 0)                              Detail: \cr 	
		\cs(255, 150, 200)   Shadows:\cr ${shadow_color}                       ${shadow_value}
]]



-- init style
hub_mode = hub_mode_std
hub_options = hub_options_std
hub_job = hub_job_std
hub_battle = hub_battle_std

KB = {}
KB['KB_C_MH'] 	 = '   (NUM /)         '
KB['KB_C_OH'] 	 = '   (NUM *)          '
KB['KB_Melee_M'] = '   (NUM 7)         '
KB['KB_WS_M'] 	 = '   (NUM 5)        '
KB['KB_PDT_M'] 	 = '   (NUM 8)        '
KB['KB_ID_M'] 	 = '   (NUM 9)        '
KB['KB_SC_M'] 	 = '   (NUM 3)        '
KB['KB_Haste_M'] = '   (NUM -)         '
KB['KB_March_M'] = '   (NUM +)        '



function validateTextInformation()
	
	local stancecolor 	={}
	local shiheicolor	={}
	local inocolor		={}
	local chonocolor	={}
	local shikacolor	={}
	local happocolor	={}
	local shadowcolor	={}
	local migawaricolor ={}

	
	if stance == "No Stance"	then
		stancecolor = color.grey
	elseif stance == "Innin" then
		stancecolor = color.ltblue
	elseif stance == "Yonin"	then
		stancecolor = color.ltred
	else
		stancecolor=color.white
	end

	if shihei.count ~= nil then
		if shihei.count == 0 then
			shiheicolor = color.red
		elseif shihei.count <= 20 then
			shiheicolor = color.ltred
		elseif shihei.count <= 50 then
			shiheicolor = color.ltyellow
		else
			shiheicolor = color.white
		end
	else
		shiheicolor = color.white
	end

	if shadows =='1 Shadow' then
		shadowcolor=color.ltred
	elseif shadows=='2 Shadows' then
		shadowcolor=color.ltyellow
	elseif shadows=='3 Shadows' then
		shadowcolor=color.ltgreen
	elseif shadows=='4 Shadows' then
		shadowcolor=color.ltblue
	elseif shadows=='No Shadows' then
		shadowcolor=color.red
	else 
		shadowcolor=color.white
	end
	
	if migawari=='Active' then
		migawaricolor=color.ltblue
	elseif migawari=='Inactive' then
		migawaricolor=color.red
	else
		migawaricolor=color.white
	end


    --Mode Information
	main_text_hub.player_current_Idle =  state.IdleMode.current
    main_text_hub.player_current_melee =  state.OffenseMode.current
	main_text_hub.player_current_ws =  state.WeaponskillMode.current
    main_text_hub.player_current_mainweapon = state.Style.current
	
	if state.Style.current == "Two-Handed" then
		main_text_hub.player_current_subweapon = state.TwoHanded.current
	elseif state.Style.current == "DualWield" then
		main_text_hub.player_current_subweapon = state.DualWield.current
	elseif state.Style.current == "Sword n' Board" then
		main_text_hub.player_current_subweapon = state.SingleWield.current
	elseif state.Style.Current == "Hand-to-Hand" then 
		main_text_hub.player_current_subweapon = state.HandtoHand.current
	end
	
	main_text_hub.player_current_Hybrid = state.HybridMode.current
	main_text_hub.player_current_Schere = state.SchereMode.current    
	main_text_hub.player_current_Haste = state.HasteMode.value
	main_text_hub.player_current_March = state.MarchMode.current    
	
	--inventory counts
	main_text_hub.Shihei_Left=shihei.count

	--job details
	main_text_hub.stance_value=stance
	main_text_hub.shadow_value=shadows


	main_text_hub.shihei_color=shiheicolor

end

function setupTextWindow()

    local default_settings = {}
    default_settings.pos = {}
    default_settings.pos.x = hud_x_pos
    default_settings.pos.y = hud_y_pos
	
    default_settings.bg = {}
    default_settings.bg.alpha = hud_transparency
    default_settings.bg.red = 30
    default_settings.bg.green = 20
    default_settings.bg.blue = 55
    default_settings.bg.visible = true
    
	default_settings.flags = {}
    default_settings.flags.right = false
    default_settings.flags.bottom = false
    default_settings.flags.bold = true
    default_settings.flags.draggable = hud_draggable
    default_settings.flags.italic = false
    
	default_settings.padding = hud_padding
    
	default_settings.text = {}
    default_settings.text.size = hud_font_size
    default_settings.text.font = hud_font
    default_settings.text.fonts = {}
    default_settings.text.alpha = 255
    default_settings.text.red = 147
    default_settings.text.green = 161
    default_settings.text.blue = 161
    
	default_settings.text.stroke = {}
    default_settings.text.stroke.width = 1
    default_settings.text.stroke.alpha = 255
    default_settings.text.stroke.red = 0
    default_settings.text.stroke.green = 0
    default_settings.text.stroke.blue = 0

    --Creates the initial Text Object will use to create the different sections in
    if not (main_text_hub == nil) then
        texts.destroy(main_text_hub)
    end
    main_text_hub = texts.new('', default_settings, default_settings)

    --Appends the different sections to the main_text_hub
    texts.append(main_text_hub, hub_mode)
	texts.update(main_text_hub, KB)
    --We then do a quick validation
    validateTextInformation()

    --Finally we show this to the user
    main_text_hub:show()
    
end
