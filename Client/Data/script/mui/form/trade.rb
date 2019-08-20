# encoding: utf-8
# filename mui/form/trade.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Trade
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 2. 20
# --------------------------------------------------------------------------
# Description
# 
#    상대방과 거래를 하는 폼 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Trade < MUI::Form
  attr_reader :user
  
  def initialize(user)
    super('center', 'center', 285, 280)
    self.close = false
    # [0]:me, [1]:partner
    @user = user
    @myStatus = 0
    @partnerStatus = 0
    @myItem = {}
    @partnerItem = {}
    
    @pic_window = []
    @pic_window[0] = MUI::PictureBox.new(24, 60, 100, 124) 
    @pic_window[0].picture = "Graphics/MUI/Trade/" + "window.png"
    addControl(@pic_window[0])

    @pic_window[1] = MUI::PictureBox.new(160, 60, 100, 124) 
    @pic_window[1].picture = "Graphics/MUI/Trade/" + "window.png"
    addControl(@pic_window[1])
    
    @lbl_name = []
    @lbl_name[0] = MUI::Label.new(24, 42, 100, 14)
    @lbl_name[0].text = Game.player.name
    @lbl_name[0].color = Color.system
    @lbl_name[0].align = 1
    addControl(@lbl_name[0])
    
    @lbl_name[1] = MUI::Label.new(160, 42, 100, 14)
    @lbl_name[1].text = @user.name
    @lbl_name[1].color = Color.system
    @lbl_name[1].align = 1
    addControl(@lbl_name[1])
    
    @lbl_gold = []
    @lbl_gold[0] = MUI::Label.new(24, 166, 95, 20)
    @lbl_gold[0].text = Math.unitMoney("0")
    @lbl_gold[0].align = 2
    addControl(@lbl_gold[0])
    
    @lbl_gold[1] = MUI::Label.new(160, 166, 95, 20)
    @lbl_gold[1].text = Math.unitMoney("0")
    @lbl_gold[1].align = 2
    addControl(@lbl_gold[1])
    
    @pic_gold = []
    @pic_gold[0] = MUI::PictureBox.new(27, 167, 14, 14)
    @pic_gold[0].picture = "Graphics/MUI/Trade/gold.png"
    addControl(@pic_gold[0])
    @pic_gold[1] = MUI::PictureBox.new(163, 167, 14, 14)
    @pic_gold[1].picture = "Graphics/MUI/Trade/gold.png"
    addControl(@pic_gold[1])
    
    @pic_state = []
    @pic_state[0] = MUI::PictureBox.new(62, 13, 24, 24)
    @pic_state[0].picture = "Graphics/MUI/Trade/wait.png"
    addControl(@pic_state[0])
    @pic_state[1] = MUI::PictureBox.new(197, 14, 24, 24)
    @pic_state[1].picture = "Graphics/MUI/Trade/wait.png"
    addControl(@pic_state[1])
    
    @pic_icon = []
    @pic_icon[0] = []
    @pic_icon[1] = []
    for i in 1..9
      @pic_icon[0][i] = MUI::PictureBox.new(
      @pic_window[0].x + 5 + ((i - 1) % 3) * (33),
      @pic_window[0].y + 5 + ((i - 1) / 3) * (33), 32, 32)
      addControl(@pic_icon[0][i])
      
      @pic_icon[1][i] = MUI::PictureBox.new(
      @pic_window[1].x + 5 + ((i - 1) % 3) * (33),
      @pic_window[1].y + 5 + ((i - 1) / 3) * (33), 32, 32)
      addControl(@pic_icon[1][i])
    end
    
    @lbl_num = []
    @lbl_num[0] = []
    @lbl_num[1] = []
    for n in 1..9
      @lbl_num[0][n] = MUI::Label.new(
      @pic_window[0].x + ((n - 1) % 3) * (33),
      @pic_window[0].y + ((n - 1) / 3) * (33) + 20, 32, 14)
      @lbl_num[0][n].color = Color.white
      @lbl_num[0][n].color2 = Color.black
      @lbl_num[0][n].align = 2
      @lbl_num[0][n].size -= 1
      addControl(@lbl_num[0][n])
      
      @lbl_num[1][n] = MUI::Label.new(
      @pic_window[1].x + ((n - 1) % 3) * (33),
      @pic_window[1].y + ((n - 1) / 3) * (33) + 20, 32, 14)
      @lbl_num[1][n].color = Color.white
      @lbl_num[1][n].color2 = Color.black
      @lbl_num[1][n].align = 2
      @lbl_num[1][n].size -= 1
      addControl(@lbl_num[1][n])
    end
    
    @btn = MUI::Button.new(25, 194, 234, 30)
    @btn.style = "Black"
    @btn.text = "거래 준비"
    addControl(@btn)
    
    refreshData
  end
  
  def addMyItem(index, item)
    @myItem[index] = item
    refreshData
  end
  
  def removeMyItem(index)
    return if not @myItem.has_key?(index)
    @myItem.delete(index)
    refreshData
  end
  
  def addPartnerItem(index, item)
    @partnerItem[index] = item
    refreshData
  end
  
  def removePartnerItem(index)
    return if not @partnerItem.has_key?(index)
    @partnerItem.delete(index)
    refreshData
  end
  
  def setGold(no, amount)
    @lbl_gold[no == Game.player.no ? 0 : 1].text = Math.unitMoney(amount.to_s)
  end
  
  def acceptTrade(no)
    if no == Game.player.no
      @pic_state[0].picture = "Graphics/MUI/Trade/accept.png"
      @myStatus = 1
    else
      @pic_state[1].picture = "Graphics/MUI/Trade/accept.png"
      @partnerStatus = 1
    end
    if isFinish
      dispose
    end
  end
  
  def isFinish
    return (@myStatus == @partnerStatus && @myStatus == 1) ? true : false
  end
  
  def refreshData
    for i in 1..9
      @pic_icon[0][i].clear
      @pic_icon[1][i].clear
      @lbl_num[0][i].text = ""
      @lbl_num[1][i].text = ""
      if @myItem.has_key?(i)
        @pic_icon[0][i].picture = "Graphics/Icons/" + Game.getItem(@myItem[i].itemNo).image
        @lbl_num[0][i].text = @myItem[i].amount.to_s
      end
      if @partnerItem.has_key?(i)
        @pic_icon[1][i].picture = "Graphics/Icons/" + Game.getItem(@partnerItem[i].itemNo).image
        @lbl_num[1][i].text = @partnerItem[i].amount.to_s
      end
    end
  end
  
  def refresh
    super
    setTitle("거래")
  end
  
  def update
    super
    if @btn.click
      Socket.send({'header' => CTSHeader::FINISH_TRADE})
    elsif @lbl_gold[0].click
      dialog = MUI_Dialog.new(Dialog::ITEM_AMOUNT, "액수 입력", "원하는 액수를 입력하세요.", ["확인", "취소"], ["액수 입력"]) do
        if dialog.value == 0
          amount = dialog.textbox[0].text
          if amount != nil && amount != ""
            amount = amount.to_i
            Socket.send({'header' => CTSHeader::CHANGE_TRADE_GOLD, 'amount' => amount})
          end
          dialog.dispose
        elsif dialog.value == 1
          dialog.dispose
        end
      end
    end
    if Mouse.trigger?
      return if not MUI.dragItem.is_a?(Item)
      for i in 1..9
        if @pic_icon[0][i].isSelected
          index = MUI.dragItem.index
          tradeIndex = i
          dialog = MUI_Dialog.new(Dialog::ITEM_AMOUNT, "갯수 입력", "아이템 갯수를 입력하세요.", ["확인", "취소"], ["갯수 입력"]) do
            if dialog.value == 0
              amount = dialog.textbox[0].text
              if amount != nil && amount != ""
                amount = amount.to_i
                Socket.send({'header' => CTSHeader::LOAD_TRADE_ITEM, 'index' => index, 'tradeIndex' => tradeIndex,
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
      end
      MUI.dragItem = nil
    elsif Mouse.trigger?(1)
      for i in 1..9
        if @pic_icon[0][i].isSelected
          Socket.send({'header' => CTSHeader::DROP_TRADE_ITEM, 'index' => i})
        end
      end
    else
      for i in 1..9
        if @pic_icon[0][i].isSelected && @myItem.has_key?(i)
          MUI::ItemInfo.set(@myItem[i])
          return
        elsif @pic_icon[1][i].isSelected && @partnerItem.has_key?(i)
          MUI::ItemInfo.set(@partnerItem[i])
          return
        end
      end
    end
    MUI::ItemInfo.clear
  end
  
  def dispose
    super
    Socket.send({'header' => CTSHeader::CANCEL_TRADE}) if !isFinish
    MUI::ItemInfo.clear
  end
end
