#────────────────────────────────────────────────────────────────────────────

# ▶ MUI_Status

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2014. 11. 22

# --------------------------------------------------------------------------

# Description

# 

#    유저의 상태를 보여주는 폼 클래스입니다.

#────────────────────────────────────────────────────────────────────────────



class MUI_Status < MUI::Form

  def initialize

    @kind = []

    # TODO : getStatus 방식 수정 요망

    (0..5).each { |i| @kind[i] = Game.getStatus(i + 3)}

    @data = [Game.player.str, Game.player.dex, Game.player.agi, 

            Game.player.critical, Game.player.hit, Game.player.avoid]

    @old = {}

    @old['hp'] = 0

    @old['mp'] = 0

    @old['exp'] = 0

    super('center', 100, 292, 250)

    @drag = true

    # 베이스

    @pic_base = MUI::PictureBox.new(20, 20, 252, 170)

    @pic_base.picture = "Graphics/MUI/Status/" + "window_base.png"

    addControl(@pic_base)

    # 캐릭터

    @pic_char = MUI::PictureBox.new(0, 0, 1, 1)

    addControl(@pic_char)

    # 레벨

    @lbl_level = MUI::Label.new(99+25, 26, 34, 14)

    @lbl_level.size = 12

    @lbl_level.align = 1

    @lbl_level.color = Color.system

    addControl(@lbl_level)

    # 포인트량

    @lbl_point = MUI::Label.new(191, 26, 30, 14)

    @lbl_point.size = 12

    @lbl_point.align = 1

    @lbl_point.color = Color.system

    addControl(@lbl_point)

    # 장비

    @pic_weapon = MUI::PictureBox.new(28, 161, 24, 24)

    @pic_shield = MUI::PictureBox.new(28 + 33 * 1, 161, 24, 24)

    @pic_helmet = MUI::PictureBox.new(41 + 33 * 2, 161, 24, 24)

    @pic_armor = MUI::PictureBox.new(41 + 33 * 3, 161, 24, 24)

    @pic_cape = MUI::PictureBox.new(41 + 33 * 4, 161, 24, 24)

    @pic_shoes = MUI::PictureBox.new(41 + 33 * 5, 161, 24, 24)

    @pic_accessory = MUI::PictureBox.new(41 + 33 * 6, 161, 24, 24)

    addControl(@pic_weapon)

    addControl(@pic_shield)

    addControl(@pic_helmet)

    addControl(@pic_armor)

    addControl(@pic_cape)

    addControl(@pic_shoes)

    addControl(@pic_accessory)

    

    # 능력치

    # 종류별 이름

    @lbl_kind = []

    @kind.each_index do |i|

      x = i >= 3 ? 170 : 26

      y = (i >= 3 ? 29 : 92) + 21 * i

      @lbl_kind[i] = MUI::Label.new(x, y, 1, 1)

      @lbl_kind[i].text = @kind[i]

      @lbl_kind[i].color = Color.gray

      addControl(@lbl_kind[i])

      @lbl_kind[i].autoSize

    end

    

    # 값

    @lbl_value = []

    @data.each_index do |i|

      x = i >= 3 ? 234 : 90

      y = (i >= 3 ? 29 : 92) + 21 * i

      @lbl_value[i] = MUI::Label.new(x, y, 32, 14)

      @lbl_value[i].color = Color.system

      @lbl_value[i].align = 2

      addControl(@lbl_value[i])

    end

    

    # 게이지바

    @pic_bar_hp = MUI::PictureBox.new(96, 44, 170, 8)

    @pic_bar_mp = MUI::PictureBox.new(96, 56, 170, 8)

    @pic_bar_exp = MUI::PictureBox.new(96, 68, 170, 8)

    @pic_bar_hp.picture = "Graphics/MUI/Status/" + "bar_hp.png"

    @pic_bar_mp.picture = "Graphics/MUI/Status/" + "bar_mp.png"

    @pic_bar_exp.picture = "Graphics/MUI/Status/" + "bar_exp.png"

    addControl(@pic_bar_hp)

    addControl(@pic_bar_mp)

    addControl(@pic_bar_exp)

    

    # 포인트

    # -

    @pic_minus = MUI::PictureBox.new(225, 24, 21, 16)

    @pic_minus.picture = "Graphics/MUI/Status/" + "-.png"

    addControl(@pic_minus)

    

    # +

    @pic_plus = MUI::PictureBox.new(245, 24, 21, 16)

    @pic_plus.picture = "Graphics/MUI/Status/" + "+.png"

    addControl(@pic_plus)

    refreshData

  end



  def refresh

    super

    # 이름 (직업)

    setTitle("#{Game.player.name} (#{Game.getJob(Game.player.job)})", 1)

    if @controls.size > 2

      refreshData

    end

  end

  

  def refreshData

    icon = "Graphics/Icons/"

    @pic_weapon.picture = Game.player.weapon > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.weapon).itemNo).image : ""

    @pic_shield.picture = Game.player.shield > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.shield).itemNo).image : ""

    @pic_helmet.picture = Game.player.helmet > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.helmet).itemNo).image : ""

    @pic_armor.picture = Game.player.armor > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.armor).itemNo).image : ""

    @pic_cape.picture = Game.player.cape > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.cape).itemNo).image : ""

    @pic_shoes.picture = Game.player.shoes > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.shoes).itemNo).image : ""

    @pic_accessory.picture = Game.player.accessory > 0 ? icon + Game.getItem(Game.player.getItem(Game.player.accessory).itemNo).image : ""

    @lbl_level.text = Game.player.level.to_s

    @lbl_point.text = Game.player.statPoint.to_s

    @data[0] = Game.player.str

    @data[1] = Game.player.dex

    @data[2] = Game.player.agi

    @data[3] = Game.player.critical

    @data[4] = Game.player.hit

    @data[5] = Game.player.avoid

    @pic_char.picture = "Graphics/Characters/" + Game.player.image

    @pic_char.width = @pic_char.picture.width / 4

    @pic_char.height = @pic_char.picture.height / 4

    @pic_char.x = 20 + (64 - @pic_char.picture.width / 4) / 2

    @pic_char.y = 20 + (64 - @pic_char.picture.height / 4) / 2

    @data.each_index do |i|

      @lbl_value[i].text = @data[i].to_s

    end

  end



  def update

    super

    drawGaugeBar

    @pic_minus.picture = "Graphics/MUI/Status/" + (@pic_minus.isSelected ? "-2.png" : "-.png")

    @pic_plus.picture = "Graphics/MUI/Status/" + (@pic_plus.isSelected ? "+2.png" : "+.png")

    

    if Mouse.trigger?

      @selectOtherArea = true

      for i in 0...@data.size

        if not @lbl_kind[i].isSelected

          @lbl_kind[i].color = Color.gray

        end

        if @lbl_kind[i].click

          @index = i

          @lbl_kind[@index].color = Color.red

          @selectOtherArea = false

        end

      end

    elsif Mouse.trigger?(1)

      if @pic_weapon.click(1)

        if Game.player.weapon > 0

          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::WEAPON})

          refreshData

        end

      elsif @pic_shield.click(1)

        if Game.player.shield > 0

          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::SHIELD})

          refreshData

        end

      elsif @pic_helmet.click(1)

        if Game.player.helmet > 0

          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::HELMET})

          refreshData

        end

      elsif @pic_armor.click(1)

        if Game.player.armor > 0

          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::ARMOR})

          refreshData

        end

      elsif @pic_cape.click(1)

        if Game.player.cape > 0

          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::CAPE})

          refreshData

        end

      elsif @pic_shoes.click(1)

        if Game.player.shoes > 0

          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::SHOES})

          refreshData

        end

      elsif @pic_accessory.click(1)

        if Game.player.accessory > 0

          Socket.send({'header' => CTSHeader::REMOVE_EQUIP_ITEM, 'type' => Game::ItemType::ACCESSORY})

          refreshData

        end

      end

    else

      item = nil

      if @pic_weapon.isSelected

        item = Game.player.getItem(Game.player.weapon) if Game.player.weapon > 0

      elsif @pic_shield.isSelected

        item = Game.player.getItem(Game.player.shield) if Game.player.shield > 0

      elsif @pic_helmet.isSelected

        item = Game.player.getItem(Game.player.helmet) if Game.player.helmet > 0

      elsif @pic_armor.isSelected

        item = Game.player.getItem(Game.player.armor) if Game.player.armor > 0

      elsif @pic_cape.isSelected

        item = Game.player.getItem(Game.player.cape) if Game.player.cape > 0

      elsif @pic_shoes.isSelected

        item = Game.player.getItem(Game.player.shoes) if Game.player.shoes > 0

      elsif @pic_accessory.isSelected

        item = Game.player.getItem(Game.player.accessory) if Game.player.accessory > 0

      end

      item == nil ? MUI::ItemInfo.clear : MUI::ItemInfo.set(item)

    end



    # 포인트

    if Game.player.statPoint > 0 && @index

      if @pic_plus.click

        Socket.send({'header' => CTSHeader::USE_STAT_POINT, 'type' => @index + 3})

        @selectOtherArea = false

        @lbl_kind[@index].color = Color.red

        return

      elsif @pic_minus.click

        

      end

    end

    

    @index = nil if @selectOtherArea

  end

  

  def drawGaugeBar

    if @old['hp'] != Game.player.hp

      @pic_bar_hp.width = Game.player.hp == 0 ? 1 : @pic_bar_hp.picture.width * Game.player.hp / Game.player.maxHp

      @old['hp'] = Game.player.hp

    end

    if @old['mp'] != Game.player.mp

      @pic_bar_mp.width = Game.player.mp == 0 ? 1 : @pic_bar_mp.picture.width * Game.player.mp / Game.player.maxMp

      @old['mp'] = Game.player.mp

    end

    if @old['exp'] != Game.player.exp

      @pic_bar_exp.width = Game.player.exp == 0 ? 1 : @pic_bar_exp.picture.width * Game.player.exp / Game.player.maxExp

      @old['exp'] = Game.player.exp

    end

  end

  

  def dispose

    super

  end

end