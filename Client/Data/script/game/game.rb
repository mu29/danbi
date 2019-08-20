# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ Game
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 8
#────────────────────────────────────────────────────────────────────────────
module Game
  module_function
  def init
    @item = []
    @skill = []
    @title = []
    @gameScreen = Screen.new
    @gameSystem = System.new
    @gamePlayer = Player.new
    @gameMap = Map.new
    @slot = Slot.new
    @cooltime = Cooltime.new
    Damage.loadCache
  end
  
  def screen
    return @gameScreen
  end
  
  def system
    return @gameSystem
  end
  
  def player
    return @gamePlayer
  end
  
  def map
    return @gameMap
  end
  
  def slot
    return @slot
  end
  
  def cooltime
    return @cooltime
  end
  
  def load
    loadItem
    loadSkill
  end

  def loadItem
    file = File.open("./GameData/item.txt")
    itemList = file.read.split("\n")
    for item in itemList
      next if item == "" || item == nil
      data = item.split("|")
      @item[data[0].to_i] = ItemData.new(data)
    end
  end

  def loadSkill
    file = File.open("./GameData/skill.txt")
    skillList = file.read.split("\n")
    for skill in skillList
      next if skill == "" || skill == nil
      data = skill.split("|")
      @skill[data[0].to_i] = SkillData.new(data)
    end
  end
  
  def getItem(id)
    return @item[id]
  end
  
  def getSkill(id)
    return @skill[id]
  end
  
  def getTitle(id)
    return "" if not @title.include?(id)
    return @title[id]
  end
      
  def getJob(n)
    case n
    when 0
      return "공용"
    when 1
      return "전사"
    when 2
      return "마법사"
    when 3
      return "도적"
    else
      return "시민"
    end
  end
  
  module CharacterType
    USER = 0
    NPC = 1
    ENEMY = 2
  end
  
  module ItemType
    WEAPON = 0
    SHIELD = 1
		HELMET = 2
		ARMOR = 3
		CAPE = 4
		SHOES = 5
		ACCESSORY = 6
		ITEM = 7
  end
  
  def getItemType(type)
    case type
    when ItemType::WEAPON
      return "무기"
    when ItemType::SHIELD
      return "방패"
    when ItemType::HELMET
      return "투구"
    when ItemType::ARMOR
      return "갑옷"
    when ItemType::CAPE
      return "망토"
    when ItemType::SHOES
      return "신발"
    when ItemType::ACCESSORY
      return "보조"
    when ItemType::ITEM
      return "일반"
    end
  end
  
  module StatusType
		TITLE = 0
		IMAGE = 1
		JOB = 2
		STR = 3
		DEX = 4
		AGI = 5
		CRITICAL = 6
		AVOID = 7
		HIT = 8
		STAT_POINT = 9
		SKILL_POINT = 10
		HP = 11
		MAX_HP = 12
		MP = 13
		MAX_MP = 14
		LEVEL = 15
		EXP = 16
		MAX_EXP = 17
    GOLD = 18
    WEAPON = 19
    SHIELD = 20
    HELMET = 21
    ARMOR = 22
    CAPE = 23
    SHOES = 24
    ACCESSORY = 25
  end
  
  def getStatus(n)
    case n
    when StatusType::TITLE
      return "타이틀"
    when StatusType::IMAGE
      return "이미지"
    when StatusType::JOB
      return "직업"
    when StatusType::STR
      return "힘"
    when StatusType::DEX
      return "민첩"
    when StatusType::AGI
      return "지능"
    when StatusType::CRITICAL
      return "크리티컬"
    when StatusType::AVOID
      return "회피율"
    when StatusType::HIT
      return "명중률"
    when StatusType::STAT_POINT
      return "스텟 포인트"
    when StatusType::SKILL_POINT
      return "스킬 포인트"
    when StatusType::HP
      return "체력"
    when StatusType::MAX_HP
      return "최대 체력"
    when StatusType::MP
      return "마력"
    when StatusType::MAX_MP
      return "최대 마력"
    when StatusType::LEVEL
      return "레벨"
    when StatusType::EXP
      return "경험치"
    when StatusType::MAX_EXP
      return "최대 경험치"
    when StatusType::GOLD
      return "골드"
    when StatusType::WEAPON
      return "무기"
    when StatusType::SHIELD
      return "방패"
    when StatusType::HELMET
      return "투구"
    when StatusType::ARMOR
      return "갑옷"
    when StatusType::CAPE
      return "망토"
    when StatusType::SHOES
      return "신발"
    when StatusType::ACCESSORY
      return "보조"
    end
  end
end