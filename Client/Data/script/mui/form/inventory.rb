# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Inventory
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014. 11. 16
# --------------------------------------------------------------------------
# Description
# 
#    유저의 소지품을 보여주는 폼 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Inventory < MUI::Form
  def initialize
    @pic_item = []
    @horizontal = 5; @vertical = 7
    @num = @horizontal * @vertical
    super('center', 'center', 206, 320)
    @pic_window = MUI::PictureBox.new(20, 25, 166, 232) 
    @pic_window.picture = "Graphics/MUI/Inventory/" + "window_item.png"
    addControl(@pic_window)
    for i in 1..35
      @pic_item[i] = MUI::PictureBox.new(
      25 + ((i - 1) % @horizontal) * (33),
      30 + ((i - 1) / @horizontal) * (33), 34, 34)
      #if Game.player.getItem(i)
      #  @pic_item[i].picture = "Graphics/Icons/" + Game.getItem(Game.player.getItem(i).itemNo).image
      #end
      addControl(@pic_item[i])
    end
    
    @lbl_gold = MUI::Label.new(0, 5, 1, 1)
    @lbl_gold.color = Color.new(255, 170, 0)
    addControl(@lbl_gold)
    
    @pic_gold = MUI::PictureBox.new(0, 5, 14, 14)
    @pic_gold.picture = "Graphics/MUI/Inventory/" + "gold.png"
    addControl(@pic_gold)
    
    @lbl_num = []
    for n in 1..35
      @lbl_num[n] = MUI::Label.new(
      @pic_window.x + (n - 1) % @horizontal * 33,
      @pic_window.y + (n - 1) / @horizontal * 33 + 20, 32, 14)
      @lbl_num[n].color = Color.white
      @lbl_num[n].color2 = Color.black
      @lbl_num[n].align = 2
      @lbl_num[n].size -= 1
      #@lbl_num[n].text = Game.player.getItem(n).amount.to_s if Game.player.getItem(n)
      ##puts @lbl_num[n].text
      addControl(@lbl_num[n])
    end
    
    refreshData
  end

  def refresh
    super
    setTitle("소지품", 1)
  end
  
  def refreshData
    for i in 1..35
      @pic_item[i].clear
      @lbl_num[i].text = ""
      if Game.player.getItem(i)
        @pic_item[i].picture = "Graphics/Icons/" + Game.getItem(Game.player.getItem(i).itemNo).image
        @pic_item[i].opacity = Game.player.getItem(i).equipped ? 150 : 255
        @lbl_num[i].text = Game.player.getItem(i).amount.to_s
      end
    end
    @lbl_gold.text = Math.unitMoney(Game.player.gold.to_s)
    @lbl_gold.autoSize
    @lbl_gold.x = @pic_window.x + @pic_window.width - @lbl_gold.width
    @pic_gold.x = @lbl_gold.x - @pic_gold.width - 3
  end

  def update
    super
    if Mouse.trigger?
      if MUI.dragItem.is_a?(Item)
        for i in 1..35
          if @pic_item[i].isSelected
            next if Game.player.getItem(i) && Game.player.getItem(i).equipped
            Socket.send({'header' => CTSHeader::CHANGE_ITEM_INDEX, 'type' => 0, 
                        'index1' => MUI.dragItem.index, 'index2' => i})
            MUI.dragItem = nil
            return
          end
        end
        return if MUI.include?(MUI_Trade)
        if !isMouseOver
          index = MUI.dragItem.index
          dialog = MUI_Dialog.new(Dialog::ITEM_AMOUNT, "갯수 입력", "아이템 갯수를 입력하세요", ["확인", "취소"], ["갯수 입력"]) do
            if dialog.value == 0
              amount = dialog.textbox[0].text
              if amount != nil && amount != ""
                amount = amount.to_i
                Socket.send({'header' => CTSHeader::DROP_ITEM, 'index' => index, 
                            'amount' => amount}) if amount <= Game.player.getItem(index).amount
              end
              dialog.dispose
              MUI.dragItem = nil
            elsif dialog.value == 1
              dialog.dispose
              MUI.dragItem = nil
            end
          end
        end
        MUI.dragItem = nil
      else
        for i in 1..35
          if @pic_item[i].isSelected
            next if Game.player.getItem(i) && Game.player.getItem(i).equipped
            MUI.dragItem = Game.player.getItem(i)
            return
          end
        end
      end
    elsif Mouse.trigger?(1)
      for i in 1..35
        if @pic_item[i].isSelected
            Socket.send({'header' => CTSHeader::USE_ITEM, 'index' => i, 'amount' => 1})
            MUI.dragItem = nil
            return
        end
      end
    end
    for i in 1..35
      if @pic_item[i].isSelected && Game.player.getItem(i)
        MUI::ItemInfo.set(Game.player.getItem(i))
        return
      end
    end
    MUI::ItemInfo.clear
  end
  
  def dispose
    super
    MUI::ItemInfo.clear
  end
end