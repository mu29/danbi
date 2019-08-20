# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ Player
# --------------------------------------------------------------------------
# Author    뮤(mu29gl@gmail.com)
# Date      2015. 1. 8
#────────────────────────────────────────────────────────────────────────────
class Player < Character
  attr_accessor :no
  attr_accessor :id
  attr_accessor :name
  attr_accessor :title
  attr_accessor :image
  attr_accessor :job
  attr_accessor :guild
  attr_accessor :statPoint
  attr_accessor :skillPoint
  attr_accessor :str
  attr_accessor :dex
  attr_accessor :agi
  attr_accessor :critical
  attr_accessor :hit
  attr_accessor :avoid
  attr_accessor :hp
  attr_accessor :maxHp
  attr_accessor :mp
  attr_accessor :maxMp
  attr_accessor :level
  attr_accessor :exp
  attr_accessor :maxExp
  attr_accessor :gold
  attr_accessor :map
  attr_accessor :x
  attr_accessor :y
  attr_accessor :direction
  
  attr_accessor :weapon
  attr_accessor :shield
  attr_accessor :helmet
  attr_accessor :armor
  attr_accessor :cape
  attr_accessor :shoes
  attr_accessor :accessory
  attr_accessor :equipped
  
  attr_accessor :new_map_id
  attr_accessor :new_x
  attr_accessor :new_y
  attr_accessor :new_direction
  attr_accessor :transferring
  
  attr_accessor :friend
  attr_accessor :partyNo
  attr_accessor :party_member
  attr_accessor :guildNo
  attr_accessor :guild_member
  attr_accessor :shopNo
  
  attr_accessor :chatBalloonText
  attr_accessor :chatBalloonVisible
  
  CENTER_X =(320 - 16) * 4
  CENTER_Y =(240 - 16) * 4
  
  def initialize
    super
    @guild = ""
    @transferring = false
    @equipped = {}
    @inventory = {}
    @skillList = {}
    @shopList = {}
    
    @friend = []
    @partyNo = 0
    @party_member = []
    @guildNo = 0
    @guild_member = []
    
    chatBalloonText = ""
    chatBalloonVisible = false
  end
  
  def addItem(index, item)
    @inventory[index] = item
  end
  
  def hasItem?(index)
    return @inventory.include?(index)
  end
  
  def getItem(index)
    return @inventory[index]
  end
  
  def updateItem(index, amount, damage, magicDamage,
                defense, magicDefense, str, dex, agi, hp, mp, critical,
                avoid, hit, reinforce, trade, equipped)
    @inventory[index].amount       = amount
    @inventory[index].damage       = damage
    @inventory[index].magicDamage  = magicDamage
    @inventory[index].defense      = defense
    @inventory[index].magicDefense = magicDefense
    @inventory[index].str          = str
    @inventory[index].dex          = dex
    @inventory[index].agi          = agi
    @inventory[index].hp           = hp
    @inventory[index].mp           = mp
    @inventory[index].critical     = critical
    @inventory[index].avoid        = avoid
    @inventory[index].hit          = hit
    @inventory[index].reinforce    = reinforce
    @inventory[index].trade        = trade == 1
    @inventory[index].equipped     = equipped == 1
  end
  
  def removeItem(index)
    @inventory.delete(index)
  end
  
  def addSkill(skill)
    @skillList[skill.no] = skill
  end
  
  def getSkill(no)
    return @skillList[no]
  end
  
  def getSkillList
    return @skillList
  end
  
  def updateSkill(no, rank)
    @skillList[no].rank = rank
  end
  
  def removeSkill(no)
    @skillList.delete(no)
  end
  
  def addShopItem(item)
    @shopList[@shopList.size + 1] = item
    @shopList[@shopList.size].index = @shopList.size
  end
  
  def getShopItem(index)
    @shopList[index]
  end
  
  def clearShopItem
    @shopList.clear
  end

  def passable?(x, y, d)
    new_x = x +(d == 6 ?  1 : d == 4 ?  -1 : 0)
    new_y = y +(d == 2 ?  1 : d == 8 ?  -1 : 0)
    unless Game.map.valid?(new_x, new_y)
      return false
    end
    super
  end

  def center(x, y)
    max_x =(Game.map.width - 20) * 128
    max_y =(Game.map.height - 15) * 128
    Game.map.display_x = [0, [x * 128 - CENTER_X, max_x]. min]. max
    Game.map.display_y = [0, [y * 128 - CENTER_Y, max_y]. min]. max
  end

  def moveto(x, y)
    super
    center(x, y)
  end

  def refresh
    @character_name = @image
    @character_hue = 0
    @opacity = 255
    @blend_type = 0
  end

  def update
    last_moving = moving?
    unless moving?
      case Key.dir4
      when 2
        move_down
      when 4
        move_left
      when 6
        move_right
      when 8
        move_up
      end
    end
    last_real_x = @real_x
    last_real_y = @real_y
    super
    if @real_y > last_real_y and @real_y - Game.map.display_y > CENTER_Y
      Game.map.scroll_down(@real_y - last_real_y)
    end
    if @real_x < last_real_x and @real_x - Game.map.display_x < CENTER_X
      Game.map.scroll_left(last_real_x - @real_x)
    end
    if @real_x > last_real_x and @real_x - Game.map.display_x > CENTER_X
      Game.map.scroll_right(@real_x - last_real_x)
    end
    if @real_y < last_real_y and @real_y - Game.map.display_y < CENTER_Y
      Game.map.scroll_up(last_real_y - @real_y)
    end
  end
  
  def turn_down(send = false)
    unless @direction_fix
      @direction = 2
      @stop_count = 0
      Socket.send({'header' => CTSHeader::TURN_CHARACTER, 'type' => 2}) if send
    end
  end

  def turn_left(send = false)
    unless @direction_fix
      @direction = 4
      @stop_count = 0
      Socket.send({'header' => CTSHeader::TURN_CHARACTER, 'type' => 4}) if send
    end
  end

  def turn_right(send = false)
    unless @direction_fix
      @direction = 6
      @stop_count = 0
      Socket.send({'header' => CTSHeader::TURN_CHARACTER, 'type' => 6}) if send
    end
  end

  def turn_up(send = false)
    unless @direction_fix
      @direction = 8
      @stop_count = 0
      Socket.send({'header' => CTSHeader::TURN_CHARACTER, 'type' => 8}) if send
    end
  end
  
  def move_down(turn_enabled = true)
    if passable?(@x, @y, 2)
      Socket.send({'header' => CTSHeader::MOVE_CHARACTER, 'type' => 2})
      turn_down
      @y += 1
    elsif turn_enabled
      turn_down(true)
    end
  end

  def move_left(turn_enabled = true)
    if passable?(@x, @y, 4)
      Socket.send({'header' => CTSHeader::MOVE_CHARACTER, 'type' => 4})
      turn_left
      @x -= 1
    elsif turn_enabled
      turn_left(true)
    end
  end

  def move_right(turn_enabled = true)
    if passable?(@x, @y, 6)
      Socket.send({'header' => CTSHeader::MOVE_CHARACTER, 'type' => 6})
      turn_right
      @x += 1
    elsif turn_enabled
      turn_right(true)
    end
  end

  def move_up(turn_enabled = true)
    if passable?(@x, @y, 8)
      Socket.send({'header' => CTSHeader::MOVE_CHARACTER, 'type' => 8})
      turn_up
      @y -= 1
    elsif turn_enabled
      turn_up(true)
    end
  end
  
  def update_stop
    @pattern = @original_pattern
    return
  end
end
