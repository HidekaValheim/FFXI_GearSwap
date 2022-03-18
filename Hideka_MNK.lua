
function get_sets()	
  
  include("organizer-lib")
  
  send_command('wait 2;input /lockstyleset 10')
  
  send_command('bind f10 gs c dt')
  
  send_command('bind f9 gs c d') 
  
  send_command('bind f11 gs equip sets.MoveSpeed')   
  
  send_command('bind f12 gs equip sets.idle')  
 
organizer_items = {
	Consumables={"Panacea","Echo Drops","Holy Water", "Remedy","Antacid","Silent Oil","Prisim Powder","Hi-Reraiser"},
	NinjaTools={"Shihei","Inoshishinofuda","Shikanofuda","Chonofuda", "Toolbag (Shihe)", "Toolbag (Ino)", "Toolbag (Shika)", "Toolbag (Cho)"},
	Food={"Grape Daifuku","Rolanberry Daifuku", "Red Curry Bun","Om. Sandwich","Miso Ramen"},
}
  
  local capped = false -- toggle attack capped setting with //gs c cap
  
  local boosted = false
  

  
  sets.idle = {
    ammo="Staunch Tathlum +1",
    head="Mpaca's Cap",
    body="Mpaca's Doublet",
    hands="Mpaca's Gloves",
    legs="Mpaca's Hose",
    feet="Mpaca's Boots",
    neck="Loricate Torque +1",
    waist="Moonbow Belt +1",
    left_ear="Brutal Earring",
    right_ear="Sherida Earring",
    left_ring="Defending Ring",
    right_ring="Epona's Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}}
    }
    

  end

	
  -- Job Ability Swaps

  sets.ja = {
    ['Hundred Fists'] = {legs="Hes. hose +3"},
    ['Dodge'] = {feet = "Anchorite's Gaiters +3"},
    ['Focus'] = {head="Anchorite's Crown +1"},
    ['Footwork'] = {feet = "Bhikku Gaiters +1"},
    ['Counterstance'] = {feet="Hes. Gaiters +3"},
    ['Chi Blast'] = {head = "Hesychast's Crown +1"},
    ['Formless Strikes'] = {body = "Hesychast's Cyclas +3"},
    ['Mantra'] = {feet = "Hesychast's Gaiters +3"},
    ['Chakra'] = {
		head="Mpaca's Cap",
		body={ name="Nyame Mail", augments={'Path: B',}},
		hands="Nyame Gauntlets",
		legs="Nyame Flanchard",
		feet={ name="Nyame Sollerets", augments={'Path: B',}},
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear="Odnowa Earring +1",
		right_ear="Tuisto Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Regal Ring",
		back="Sacro Mantle",	
	},
    ['Boost'] = {},
	['Provoke'] = {
		main="Karambit",
		ammo="Sapience Orb",
		head="Halitus Helm",
		body="Emet Harness",
		hands="Kurys Gloves",
		legs="Nyame Flanchard",
		feet="Ahosi Leggings",
		neck={ name="Unmoving Collar +1", augments={'Path: A',}},
		waist="Eschan Stone",
		left_ear="Odnowa Earring +1",
		right_ear="Tuisto Earring",
		left_ring="Provocare Ring",
		right_ring="Begrudging Ring",
		back="Reiki Cloak",
	},
	
  }

  -- Standard Tp Sets

  melee_sets = {
    ['d'] = "Max DD", -- //gs c d
    ['sb'] = "Subtle Blow", -- //gs c sb
    ['dt'] = "Damage Taken", -- //gs c dt
    ['a'] = "Accuracy", -- //gs c a
    ['c1'] = "Counter 1 (Defensive)", -- //gs c c1
    ['c2'] = "Counter 2 (Offensive)" -- //gs c c2
  }
  
  melee_key = "d"

  sets.tp = {
  
    footwork = {	
    feet = "Anchorite's Gaiters +3",
    legs = "Hesychast's Hose +3"
    },
	
    ['Max DD'] = {
    ammo="Coiste Bodhar",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    feet = "Anchorite's Gaiters +3",
    legs = "Hesychast's Hose +3",
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear="Telos Earring",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}}	
      },	  
   
	
    ['Subtle Blow'] = {
    ammo="Ginsen",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+15','"Triple Atk."+4','Attack+6',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear="Mache Earring +1",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}}	
    },
	
	
    ['Magic Evasion'] = {
    ammo="Ginsen",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+15','"Triple Atk."+4','Attack+6',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear="Mache Earring +1",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}}	  
    },
	
    ['Damage Taken'] = {
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Mpaca's Doublet",
    hands="Malignance Gloves",
    legs="Mpaca's Hose",
    feet="Mpaca's Boots",
    neck="Loricate Torque +1",
    waist="Moonbow Belt +1",
    left_ear="Brutal Earring",
    right_ear="Sherida Earring",
    left_ring="Defending Ring",
    right_ring="Gelatinous Ring +1",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}}
     },	  

	
    ['Accuracy'] = {
    ammo="Ginsen",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+15','"Triple Atk."+4','Attack+6',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear="Mache Earring +1",
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}}	
    },
	
    ['Max Accuracy'] = {
      ammo = "Ginsen",
      head = "Ken. Jinpachi +1",
      body = "Ken. Samue +1",
      hands = {name = "Adhemar Wrist. +1", augments = {"DEX+12", "AGI+12", "Accuracy+20"}},
      legs = "Ken. Hakama +1",
      feet = "Anchorite's Gaiters +3",
      neck = "Mnk. Nodowa +2",
      waist = "Moonbow Belt +1",
      left_ear = "Telos Earring",
      right_ear = "Mache Earring +1",
      left_ring = "Regal Ring",
      right_ring = "Chirich Ring +1",
      back = {
        name = "Segomo's Mantle", augments = {"DEX+20", "Accuracy+20 Attack+20", "DEX+10", '"Dbl.Atk."+10', "Phys. dmg. taken-10%"}
      }
    },
	
    ['Skillchain'] = {
      ammo = "Ginsen",
      head = "Ken. Jinpachi +1",
      body = "Ken. Samue +1",
      hands = {name = "Adhemar Wrist. +1", augments = {"DEX+12", "AGI+12", "Accuracy+20"}},
      legs = "Samnuha Tights",
      feet = { name="Herculean Boots", augments={'Accuracy+15','"Triple Atk."+4','Attack+6',}},
      neck = "Mnk. Nodowa +2",
      waist = "Moonbow Belt +1",
      left_ear = "Sherida Earring",
      right_ear = "Mache Earring +1",
      left_ring = "Gere Ring",
      right_ring = "Epona's Ring",
      back = {name = "Segomo's Mantle", augments = {"DEX+20", "Accuracy+20 Attack+20", '"Store TP"+10', "Phys. dmg. taken-10%"}
      }
    },
	
    ['Low Haste'] = {
      ammo = "Focal Orb",
      head = "Kendatsuba jinpachi +1",
      body = "Kendatsuba samue +1",
      hands = {name = "Adhemar Wrist. +1", augments = {"DEX+12", "AGI+12", "Accuracy+20"}},
      legs = "Samnuha Tights",
      feet = { name="Herculean Boots", augments={'Accuracy+15','"Triple Atk."+4','Attack+6',}},
      neck = "Monk's Nodowa +2",
      waist = "Moonbow Belt +1",
      left_ear = "Mache Earring +1",
      right_ear = "Mache Earring +1",
      left_ring = "Gere Ring",
      right_ring = "Epona's Ring",
      back = {
        name = "Segomo's Mantle",
        augments = {"DEX+20", "Accuracy+20 Attack+20", "DEX+10", '"Dbl.Atk."+10', "Phys. dmg. taken-10%"}
      }
    },
	
    ['Counter 1 (Defensive)'] = {
      ammo = "Amar Cluster",
      head = "Malignance Chapeau",
      body = {name = "Hes. Cyclas +3", augments = {'Enhances "Formless Strikes" effect'}},
      hands = "Hizamaru Kote +2",
      legs = "Anch. Hose +3",
      feet = "Hiza. Sune-Ate +2",
      neck = "Loricate Torque +1",
      waist = "Moonbow Belt +1",
      left_ear = "Sherida Earring",
      right_ear = "Cryptic Earring",
      left_ring = "Hizamaru Ring",
      right_ring = "Defending Ring",
      back = {
        name = "Segomo's Mantle",
        augments = {"DEX+20", "Accuracy+20 Attack+20", "DEX+10", '"Dbl.Atk."+10', "System: 1 ID: 640 Val: 4"}
      }
    },
	
    ['Counter 2 (Offensive)'] = {
      ammo = "Amar Cluster",
      head = "Kendatsuba jinpachi +1",
      body = "Hesychast's Cyclas +3",
      hands = {name = "Adhemar Wrist. +1", augments = {"DEX+12", "AGI+12", "Accuracy+20"}},
      legs = "Samnuha Tights",
      feet = "Hesychast's Gaiters +3",
      neck = "Monk's Nodowa +2",
      waist = "Moonbow Belt +1",
      left_ear = "Sherida Earring",
      right_ear = "Mache Earring +1",
      left_ring = "Niqmaddu Ring",
      right_ring = "Epona's Ring",
      back = {
        name = "Segomo's Mantle",
        augments = {"DEX+20", "Accuracy+20 Attack+20", "DEX+10", '"Dbl.Atk."+10', "System: 1 ID: 640 Val: 4"}
      }
    }
  }
	
	sets.MoveSpeed = {
	feet = "Hermes' Sandals"
	}
  -- Standard Weapon Skill Sets

  sets.ws = {
  
    footwork = {
	feet = "Anchorite's Gaiters +3"
	},
	
    ['Victory Smite'] = {
    ammo="Knobkierrie",
    head="Mpaca's Cap",
    body="Ken. Samue +1",
    hands={ name="Ryuo Tekko +1", augments={'DEX+12','Accuracy+25','"Dbl.Atk."+4',}},
    legs="Ken. Hakama +1",
    feet={ name="Herculean Boots", augments={'Accuracy+15','"Triple Atk."+4','Attack+6',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
	left_ear="Sherida Earring",
    right_ear="Odr Earring",
    left_ring="Gere Ring",
    right_ring="Regal Ring",
    back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    },
	
    ['Howling Fist'] = {
    ammo="Knobkierrie",
    head={ name="Hes. Crown +3", augments={'Enhances "Penance" effect',}},
    body={ name="Tatena. Harama. +1", augments={'Path: A',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
    feet={ name="Herculean Boots", augments={'Accuracy+15','"Triple Atk."+4','Attack+6',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}	
     },

	
    ['Raging Fists'] = {
    ammo="Knobkierrie",
    head="Mpaca's Cap",
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
    feet={ name="Herculean Boots", augments={'Accuracy+15','"Triple Atk."+4','Attack+6',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Regal Ring",
    back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    },	  
	
    ['Asuran Fists'] = {
    ammo="Knobkierrie",
    head={ name="Hes. Crown +3", augments={'Enhances "Penance" effect',}},
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+24','STR+4','Weapon skill damage +9%','Accuracy+9 Attack+9','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
    feet={ name="Ryuo Sune-Ate +1", augments={'STR+12','Attack+25','Crit. hit rate+4%',}},
    neck="Fotia Gorget",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Regal Ring",
    back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+8','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    },
	
    ['Shijin Spiral'] = {
    ammo="Knobkierrie",
    head="Mpaca's Cap",
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
    feet={ name="Herculean Boots", augments={'Accuracy+15','"Triple Atk."+4','Attack+6',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ear="Mache Earring +1",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
    },
	
    ['Tornado Kick'] = {
    ammo="Knobkierrie",
    head={ name="Hes. Crown +3", augments={'Enhances "Penance" effect',}},
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Tatena. Haidate +1", augments={'Path: A',}},
    feet="Anchorite's Gaiters +3",
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Brutal Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}}
    },
	
    ['Dragon Kick'] = {
    ammo="Knobkierrie",
    head={ name="Hes. Crown +3", augments={'Enhances "Penance" effect',}},
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs="Ken. Hakama +1",
    feet="Anch. Gaiters +3",
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Brutal Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}}
    },
	
	['Shell Crusher'] ={
    ammo="Pemphredo Tathlum",
    head="Malignance Chapeau",
    body="Mpaca's Doublet",
    hands="Mpaca's Gloves",
    legs="Mpaca's Hose",
    feet="Mpaca's Boots",
    neck="Sanctity Necklace",
    waist="Luminary Sash",
    left_ear="Digni. Earring",
    right_ear="Gwati Earring",
    left_ring="Stikini Ring",
    right_ring="Rahab Ring",
    back={ name="Segomo's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}}
	},
	
	['Cataclysm'] = {
    ammo="Knobkierrie",
    head="Pixie Hairpin +1",
    body={ name="Samnuha Coat", augments={'Mag. Acc.+13','"Mag.Atk.Bns."+14','"Fast Cast"+3','"Dual Wield"+4',}},
    hands={ name="Herculean Gloves", augments={'"Mag.Atk.Bns."+29','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+24','STR+4','Weapon skill damage +9%','Accuracy+9 Attack+9','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
    feet={ name="Adhemar Gamashes", augments={'STR+10','DEX+10','Attack+15',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Friomisi Earring",
    left_ring="Archon Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-4%',}}
    },
	
    }


  -- WSD Swap Sets

  sets.wsd = {
    ['Howling Fist'] = {
      head = "Hesychast's crown +3",
      ammo = "Knobkierrie",
      hands = "Anchorite's gloves +3",
      neck = "Fotia Gorget",
      right_ring = "Regal Ring"
    }
  }

  -- Attack Capped Swap Sets

  sets.capped = {
    neck = "Monk's Nodowa +2",
    ['Victory Smite'] = {ammo = "Focal Orb"},
    ['Dragon Kick'] = {body = "Kendatsuba Samue +1"},
    ['Tornado Kick'] = {body = "Kendatsuba Samue +1"},
    ['Shijin Spiral'] = {body = "Kendatsuba Samue +1"},
    ['Asuran Fists'] = {},
    ['Howling Fist'] = {body = "Kendatsuba Samue +1"},
    ['Raging Fists'] = {
      body = "Kendatsuba Samue +1",
      head = "Kendatsuba Jinpachi +1"
    },
    ['Howling Fist'] = {
      body = "Kendatsuba Samue +1"
    }
  }

  -- Misc Swaps

  sets.during_boost = {
  ring2="Karieyh Ring +1",
  waist = "Ask Sash"
  }
  
  sets.impetus = {
  body = "Bhikku Cyclas +1", 
  left_ear = "Brutal Earring"
  }
  
  sets.overflow = {
  left_ear = "Brutal Earring"
  }
  
  sets.treasure = {
  }

  sets.MoveSpeed = {
  feet = "Hermes' Sandals"
  }
	
  function precast(spell)
    if spell.prefix == "/jobability" and buffactive['paralysis'] then
      cancel_spell()
      send_command(
        "@input /echo _____Warning: Paralyzed. Using Remedy (_" .. (player.inventory['Remedy'].count - 1) .. "_)_____"
      )
      send_command('@input /item "Remedy" <me>')
    elseif spell.action_type == "Magic" and buffactive['silence'] then
      cancel_spell()
      send_command(
        "@input /echo _____Warning: Silenced. Using Echo Drops (_" ..
          (player.inventory['Echo Drops'].count - 1) .. "_)_____"
      )
      send_command('@input /item "Echo Drops" <me>')
    elseif buffactive['Impetus'] and spell.english == "Victory Smite" then
      equip(
        set_combine(
          sets.ws[spell.english],
          capped and set_combine(sets.capped, sets.capped[spell.english]) or {},
          sets.impetus
        )
      )
    elseif spell.english == "Tornado Kick" or spell.english == "Dragon Kick" then
      if buffactive['Footwork'] then
        equip(
          set_combine(
            sets.ws[spell.english],
            sets.ws.footwork,
            capped and set_combine(sets.capped, sets.capped[spell.english]) or {},
            player.tp > 2449 and sets.overflow or {}
          )
        )
      end
    elseif sets.ws[spell.english] then
      equip(
        set_combine(
          sets.ws[spell.english],
          player.tp > 2299 and sets.wsd[spell.english] or {},
          player.tp > 2449 and sets.overflow or {},
          capped and set_combine(sets.capped, sets.capped[spell.english]) or {}
        )
      )
    elseif sets.ja[spell.english] then
      equip(sets.ja[spell.english])
      if spell.english == "Boost" then
        boosted = true
      end
    end
  end

  function midcast(spell)
  end

  function aftercast(spell)
    if player.status == "Engaged" then
      equip(sets.tp[melee_sets[melee_key]])
      if buffactive['Impetus'] then
        equip(sets.impetus)
      end
      if buffactive['Footwork'] then
        equip(sets.tp.footwork)
      end
      if boosted or buffactive['Boost'] then
        equip(sets.during_boost)
      end
    else
      equip(sets.idle, (boosted or buffactive['Boost']) and sets.during_boost or {})
    end
    if not buffactive['Boost'] then
      boosted = false
    end
  end

  function status_change(new, old)
    if T {"Idle", "Resting"}:contains(new) then
      equip(sets.idle, buffactive['Boost'] and sets.during_boost or {})
    elseif new == "Engaged" then
      equip(sets.tp[melee_sets[melee_key]])
      if buffactive['Impetus'] then
        equip(sets.impetus)
      end
      if buffactive['Footwork'] then
        equip(sets.tp.footwork)
      end
      if boosted or buffactive['Boost'] then
        equip(sets.during_boost)
      end
    end
  end

  function self_command(command)
    if melee_sets[command] then
      melee_key = command
      send_command("@input /echo ----- TP Set changed to " .. melee_sets[command] .. "-----")
      equip(sets.tp[melee_sets[command]])
    elseif command == "th" then
      send_command("@input /echo ----- Setting Treasure Hunter Gear-----")
      equip(sets.treasure)
    elseif command == "cap" then
      capped = not capped
      send_command("@input /echo ----- Attack Capped changed to " .. tostring(capped) .. "-----")
      equip(set_combine(sets.tp[melee_sets[melee_key]], capped and sets.capped or {}))
    end
		
	
  end





