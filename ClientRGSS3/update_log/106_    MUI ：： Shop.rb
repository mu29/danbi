#────────────────────────────────────────────────────────────────────────────

# ▶ MUI_Shop

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2015. 2. 16

# --------------------------------------------------------------------------

# Description

# 

#    아이템을 사고 파는 상점 폼 클래스입니다.

#────────────────────────────────────────────────────────────────────────────



class MUI_Shop < MUI::Form

  def initialize

    # 인벤토리 실행

    MUI_Inventory.new unless MUI.include?(MUI_Inventory)

    super('center', 'center', 230, 260)

    @pic_window = MUI::PictureBox.new(32, 32, 166, 166)

    @pic_window.picture = "./Graphics/MUI/Shop/" + "Window.png"

    addControl(@pic_window)

    @pic_item = []

    for n in 1..25

      @pic_item[n] = MUI::PictureBox.new(

      @pic_window.x + 5 + ((n - 1) % 5) * (33),

      @pic_window.y + 5 + ((n - 1) / 5) * (33), 32, 32)

      addControl(@pic_item[n])

    end

    refreshData

  end

  

  def refresh

    super

    setTitle("상점")

  end

  

  def refreshData

    # 상점 아이템 아이콘

    for i in 1..25

      @pic_item[i].clear

      if Game.player.getShopItem(i)

        @pic_item[i].picture = "./Graphics/Icons/" + Game.getItem(Game.player.getShopItem(i).itemNo).image

      end

    end

  end

  

  def update

    super

    if Mouse.trigger?

      for i in 1..25

        if @pic_item[i].isSelected && Game.player.getShopItem(i)

          index = i

          dialog = MUI_Dialog.new(Dialog::ITEM_AMOUNT, "갯수 입력", "아이템 갯수를 입력하세요.", ["확인", "취소"], ["갯수 입력"]) do

            if dialog.value == 0

              amount = dialog.textbox[0].text

              if amount != nil && amount != ""

                amount = amount.to_i

                Socket.send({'header' => CTSHeader::BUY_SHOP_ITEM, 'shopNo' => Game.player.shopNo, 'index' => index,

                            'amount' => amount}) if amount > 0

              end

              dialog.dispose

            elsif dialog.value == 1

              dialog.dispose

            end

          end

        end

      end

    end

    for i in 1..25

      if @pic_item[i].isSelected && Game.player.getShopItem(i)

        MUI::ItemInfo.set(Game.player.getShopItem(i))

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