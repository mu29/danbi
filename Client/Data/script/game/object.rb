# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ Objects
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 9
#────────────────────────────────────────────────────────────────────────────
class ItemData
  attr_accessor :no
  attr_accessor :name
  attr_accessor :description
  attr_accessor :image
  attr_accessor :job
  attr_accessor :limitLevel
  attr_accessor :type
  attr_accessor :price
  attr_accessor :damage
  attr_accessor :magicDamage
  attr_accessor :defense
  attr_accessor :magicDefense
  attr_accessor :str
  attr_accessor :dex
  attr_accessor :agi
  attr_accessor :hp
  attr_accessor :mp
  attr_accessor :critical
  attr_accessor :avoid
  attr_accessor :hit
  attr_accessor :delay
  attr_accessor :consume
  attr_accessor :maxLoad
  attr_accessor :trade
  
  def initialize(list)
    @no           = list[0].to_i
    @name         = list[1].to_s
    @description  = list[2].to_s
    @image        = list[3].to_s
    @job          = list[4].to_i
    @limitLevel   = list[5].to_i
    @type         = list[6].to_i
    @price        = list[7].to_i
    @damage       = list[8].to_i
    @magicDamage  = list[9].to_i
    @defense      = list[10].to_i
    @magicDefense = list[11].to_i
    @str          = list[12].to_i
    @dex          = list[13].to_i
    @agi          = list[14].to_i
    @hp           = list[15].to_i
    @mp           = list[16].to_i
    @critical     = list[17].to_i
    @avoid        = list[18].to_i
    @hit          = list[19].to_i
    @delay        = list[20].to_i
    @consume      = list[21].to_i
    @maxLoad      = list[22].to_i
    @trade        = list[23].to_i
  end
end

class Item
  attr_accessor :itemNo
  attr_accessor :amount
  attr_accessor :index
  attr_accessor :damage
  attr_accessor :magicDamage
  attr_accessor :defense
  attr_accessor :magicDefense
  attr_accessor :str
  attr_accessor :dex
  attr_accessor :agi
  attr_accessor :hp
  attr_accessor :mp
  attr_accessor :critical
  attr_accessor :avoid
  attr_accessor :hit
  attr_accessor :reinforce
  attr_accessor :trade
  attr_accessor :equipped
  
  def initialize(userNo, itemNo, amount, index, damage, magicDamage,
                defense, magicDefense, str, dex, agi, hp, mp, critical,
                avoid, hit, reinforce, trade, equipped)
    @userNo       = userNo
		@itemNo       = itemNo
		@amount       = amount
    @index        = index
    @damage       = damage
    @magicDamage  = magicDamage
    @defense      = defense
    @magicDefense = magicDefense
    @str          = str
    @dex          = dex
    @agi          = agi
    @hp           = hp
    @mp           = mp
    @critical     = critical
    @avoid        = avoid
    @hit          = hit
    @reinforce    = reinforce
    @trade        = trade == 1
    @equipped     = equipped == 1
  end
end

class SkillData
  attr_accessor :no
  attr_accessor :name
  attr_accessor :description
  attr_accessor :type
  attr_accessor :job
  attr_accessor :delay
  attr_accessor :limitLevel
  attr_accessor :maxRank
  attr_accessor :userAnimation
  attr_accessor :targetAnimation
  attr_accessor :image
  
  def initialize(list)
    @no              = list[0].to_i
    @name            = list[1].to_s
    @description     = list[2].to_s
    @type            = list[3].to_s
    @job             = list[4].to_i
    @delay           = list[5].to_i
    @limitLevel      = list[6].to_i
    @maxRank         = list[7].to_s
    @userAnimation   = list[8].to_s
    @targetAnimation = list[9].to_s
    @image           = list[10].to_s
  end
end

class Skill
  attr_accessor :no
  attr_accessor :rank
  
  def initialize(no, rank)
    @no   = no
    @rank = rank
  end
end