
function get_sets()	
  
  include("organizer-lib")
  
  send_command('wait 2;input /lockstyleset 6')
  
  send_command('bind f7 gs c GH')  
  
  send_command('bind f9 gs c d')
  
  send_command('bind f10 gs c dt')
  
  send_command('bind f11 gs c a')   
  
  send_command('bind f12 gs c St')  
 
  
  local capped = false -- toggle attack capped setting with //gs c cap
  
  local boosted = false
  

  
  sets.idle = {
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Ken. Tekko +1",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Warder's Charm +1",
    waist="Moonbow Belt +1",
    left_ear="Etiolation Earring",
    right_ear="Eabani Earring",
    left_ring="Defending Ring",
    right_ring={ name="Gelatinous Ring +1", augments={'Path: A',}},
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
    }
    

  end


  -- Job Ability Swaps

  sets.ja = {
  
    ['Hundred Fists'] = {
	legs="Hes. hose +3"
	},
	
    ['Dodge'] = {
	feet = "Anchorite's Gaiters +3"
	},
	
    ['Focus'] = {
	head="Anchorite's Crown +2"	
	},
	
    ['Footwork'] = {
	feet = "Shukuyu Sune-Ate"
	},
	
    ['Counterstance'] = {
	feet="Hes. Gaiters +3"	
	},
	
    ['Chi Blast'] = {
	head = "Hesychast's Crown +3"
	},
	
    ['Chakra'] = {
    body="Anch. Cyclas +2",
    hands="Hes. Gloves +3",
	},
	
    ['Formless Strikes'] = {
	body = "Hesychast's Cyclas +3"
	},
	
    ['Mantra'] = {
	feet = "Hesychast's Gaiters +3"
	},
	
    ['Boost'] = {
    head="Gnadbhod's Helm",
    feet="Mahant Sandals",
    neck="Justiciar's Torque",
	waist="Ask Sash",
	hands=empty,
	--hands="Anchorite's gloves +3",
	body=empty,
	legs=empty,
    left_ring="Sljor Ring",
    right_ring="Karieyh Ring +1",
	},
	
	['Provoke'] = {
    ammo="Sapience Orb",
    head="Halitus Helm",
    body="Emet Harness +1",
    hands="Kurys Gloves",
    feet="Rager Ledel. +1",
    neck="Unmoving Collar +1",
    waist="Kasiri Belt",
    left_ear="Trux Earring",
    right_ear="Cryptic Earring",
    left_ring="Eihwaz Ring",
    right_ring="Supershear Ring"
	},
	
	['Jump'] = {
    ammo="Aurgelmir orb +1",	
    head="Ken. Jinpachi +1",
    body="Ken. Samue +1",
    hands={ name="Herculean Gloves", augments={'Accuracy+17 Attack+17','"Triple Atk."+4','STR+9','Accuracy+14','Attack+9',}},
    legs="Ken. Hakama +1",
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    right_ear="Telos Earring",	
    left_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	},	
	
	['High Jump'] = {
    ammo="Aurgelmir orb +1",
    head="Ken. Jinpachi +1",
    body="Ken. Samue +1",
    hands={ name="Herculean Gloves", augments={'Accuracy+17 Attack+17','"Triple Atk."+4','STR+9','Accuracy+14','Attack+9',}},
    legs="Ken. Hakama +1",
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    right_ear="Telos Earring",	
    left_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
	},
	
  }

  -- Standard Tp Sets

  melee_sets = {
    ['d'] = "Verethragna", -- //gs c Vere
	
    ['sb'] = "Subtle Blow", -- //gs c sb
	
    ['St'] = "Staff", -- //gs c St
	
    ['dt'] = "Damage Taken", -- //gs c dt
	
    ['a'] = "Accuracy", -- //gs c a
	
    ['ax'] = "Max Accuracy", -- //gs c ax
	
    ['GH'] = "Godhands", -- //gs c GH
	
    ['la'] = "Low Haste", -- //gs c lh
	
    ['c1'] = "Counter 1 (Defensive)", -- //gs c c1
	
    ['c2'] = "Counter 2 (Offensive)" -- //gs c c2
  }
  
  melee_key = "d"

  sets.tp = {
  
    footwork = {	
    feet = "Anchorite's Gaiters +3",
    legs = "Hesychast's Hose +3"
    },
	
    ['Verethragna'] = {
	main= "Verethragna",
    ammo="Aurgelmir orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    feet = "Anchorite's Gaiters +3",
    legs = "Hesychast's Hose +3",
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    right_ear="Telos Earring",	
    left_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}	
      },	  
 	
    ['Godhands'] = {
	main="Godhands",
    ammo="Aurgelmir orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    feet = "Anchorite's Gaiters +3",
    legs = "Hesychast's Hose +3",
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    right_ear="Mache Earring +1",	
    left_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}	
    },	
  
	
    ['Subtle Blow'] = {
    ammo="Aurgelmir orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    right_ear="Telos Earring",	
    left_ear="Mache Earring +1",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}	
    },
	
	
    ['Magic Evasion'] = {
    ammo="Aurgelmir orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+22 Attack+22','"Triple Atk."+4','Accuracy+3','Attack+15',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    right_ear="Telos Earring",	
    left_ear="Mache Earring +1",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}	  
    },
	
	['Staff'] = {
    main="Xoanon",
    sub="Niobid Strap",
    ammo="Aurgelmir Orb +1",
    head="Dampening Tam",
    body="Ken. Samue +1",
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs="Ken. Hakama +1",
    feet="Ken. Sune-Ate +1",
    neck="Combatant's Torque",
    waist="Moonbow Belt +1",
    right_ear="Telos Earring",	
    left_ear="Sherida Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}	
    },
	  
    ['Damage Taken'] = {
    ammo="Staunch Tathlum +1",
    head="Malignance Chapeau",
    body="Malignance tabard",
    hands="Ken. Tekko +1",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear="Telos Earring",
    left_ring="Defending Ring",
    right_ring="Chirich ring +1",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
     },	  

	
    ['Accuracy'] = {
    ammo="Falcon Eye",
    head="Ken. Jinpachi +1",
    body="Ken. Samue +1",
    hands="Ken. Tekko +1",
    legs="Ken. Hakama +1",
    feet="Ken. Sune-Ate +1",
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    right_ear="Telos Earring",	
    left_ear="Mache Earring +1",
    left_ring="Ilabrat Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}}
    },

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
    ammo="Aurgelmir orb +1",
    head={ name="Adhemar Bonnet +1", augments={'STR+12','DEX+12','Attack+20',}},
    body="Ken. Samue +1",
    hands="Ryuo Tekko +1",
    legs="Ken. Hakama +1",
    feet={ name="Herculean Boots", augments={'Accuracy+15 Attack+15','Crit. hit damage +5%','STR+3',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
	left_ear="Sherida Earring",
    right_ear="Odr Earring",
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    },
	
    ['Howling Fist'] = {
    ammo="Knobkierrie",
    head="Ken. Jinpachi +1",
    body="Ken. Samue +1",
    hands={ name="Herculean Gloves", augments={'Accuracy+17 Attack+17','"Triple Atk."+4','STR+9','Accuracy+14','Attack+9',}},
    legs="Tatena. Haidate +1",
    feet={ name="Herculean Boots", augments={'Accuracy+29','"Triple Atk."+2','STR+15','Attack+7',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}	
     },

	
    ['Raging Fists'] = {
    ammo="Knobkierrie",
    head="Ken. Jinpachi +1",
    body={ name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}},
    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
    legs="Tatena. Haidate +1",
    feet={ name="Herculean Boots", augments={'Accuracy+29','"Triple Atk."+2','STR+15','Attack+7',}},
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    },	  
	
    ['Asuran Fists'] = {
    ammo="Knobkierrie",
    head={ name="Hes. Crown +3", augments={'Enhances "Penance" effect',}},
    body="Ashera Harness",
    hands="Anchor. Gloves +3",
    legs="Hiza. Hizayoroi +2",
    feet={ name="Ryuo Sune-Ate +1", augments={'STR+12','Attack+25','Crit. hit rate+4%',}},
    neck="Fotia Gorget",
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear="Ishvara Earring",
    left_ring="Regal Ring",
    right_ring="Karieyh Ring +1",
    back={ name="Segomo's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
    },
	
    ['Shijin Spiral'] = {
    ammo="Knobkierrie",
    head="Ken. Jinpachi +1",
    body="Malignance Tabard",
    hands="Ken. Tekko +1",
    legs="Tatena. Haidate +1",
    feet="Ken. Sune-Ate +1",
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear="Mache Earring +1",
    left_ring="Ilabrat Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    },
	
    ['Tornado Kick'] = {
    ammo="Knobkierrie",
    head="Ken. Jinpachi +1",
    body="Ken. Samue +1",
    hands={ name="Herculean Gloves", augments={'Accuracy+17 Attack+17','"Triple Atk."+4','STR+9','Accuracy+14','Attack+9',}},
    legs="Tatena. Haidate +1",
    feet="Anch. Gaiters +3",
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
    },
	
    ['Dragon Kick'] = {
    ammo="Knobkierrie",
    head="Ken. Jinpachi +1",
    body="Ken. Samue +1",
    hands={ name="Herculean Gloves", augments={'Accuracy+17 Attack+17','"Triple Atk."+4','STR+9','Accuracy+14','Attack+9',}},
    legs="Tatena. Haidate +1",
    feet="Anch. Gaiters +3",
    neck={ name="Mnk. Nodowa +2", augments={'Path: A',}},
    waist="Moonbow Belt +1",
    left_ear="Sherida Earring",
    right_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    left_ring="Gere Ring",
    right_ring="Niqmaddu Ring",
    back={ name="Segomo's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}}
    },
	
	['Shell Crusher'] ={
    ammo="Pemphredo Tathlum",
    head="Malignance Chapeau",
    body="Malignance Tabard",
    hands="Gazu bracelet +1",
    legs="Malignance Tights",
    feet="Malignance Boots",
    neck="Sanctity Necklace",
    waist={ name="Acuity Belt +1", augments={'Path: A',}},
    left_ear="Digni. Earring",
    right_ear="Gwati Earring",
    left_ring="Stikini Ring +1",
    right_ring="Stikini Ring +1",
    back={ name="Segomo's Mantle", augments={'STR+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10',}}
	},
	
	['Cataclysm'] = {
    ammo="Knobkierrie",
    head="Pixie Hairpin +1",
    body={ name="Samnuha Coat", augments={'Mag. Acc.+13','"Mag.Atk.Bns."+14','"Fast Cast"+3','"Dual Wield"+4',}},
 hands={ name="Herculean Gloves", augments={'Attack+19','"Mag.Atk.Bns."+28','Magic Damage +9','Accuracy+17 Attack+17','Mag. Acc.+13 "Mag.Atk.Bns."+13',}},
    legs="Hiza. Hizayoroi +2",
    feet={ name="Adhemar Gamashes", augments={'STR+10','DEX+10','Attack+15',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear={ name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
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
    ['Victory Smite'] = {ammo = "Knobkierrie"},
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
  ring2="Karieyh ring +1",
  waist = "Ask Sash"
  }
  
  sets.impetus = {
  right_ear="Telos Earring",	 
  body = "Bhikku Cyclas +1", 
  }
  
  sets.overflow = {
  right_ear = "Brutal Earring"
  }
  
  sets.treasure = {
  }

  sets.Hundred_Fists = {
    legs="Ken. Hakama +1",
    feet="Ken. Sune-Ate +1", 
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
      if buffactive['Hundred Fists'] then
        equip(sets.Hundred_Fists)
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
      if buffactive['Hundred Fists'] then
        equip(sets.Hundred_Fists)
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





