# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_ItemInfo
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 2. 22
# --------------------------------------------------------------------------
# Description
# 
#    아이템의 정보를 띄우는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────
class MUI
  class ItemInfo
    def self.init
      @viewport = Viewport.new(0, 0, 10, 10)
      @viewport.z = 999999 + 1
      @sprite = Sprite.new(@viewport)
      @sprite.bitmap = Bitmap.new(@viewport.rect.width, @viewport.rect.height)
    end
    
    def self.set(item)
      return if not item
      return if @item == item
      clear
      @item = item
      @itemData = Game.getItem(item.itemNo)
      width = 200
      @section = {}
      # 이미지
      @section['@image'] = Bitmap.new(width, 36)
      icon = RPG::Cache.icon(@itemData.image)
      @section['@image'].fill_rect(0, 0, @section['@image'].width, @section['@image'].height, Color.black(128))
      @section['@image'].blt(
        (@section['@image'].width - icon.width) / 2,
        (@section['@image'].height - icon.height) / 2,
        icon, Rect.new(0, 0, icon.width, icon.height))
      
      # 이름 (타입)
      name = @item.reinforce == 0 ? @itemData.name : @itemData.name + " + " + @item.reinforce.to_s
      @section['@name'] = Bitmap.new(width, 24)
      @section['@name'].fill_rect(0, 0, @section['@name'].width, @section['@name'].height, Color.black(192))
      @section['@name'].font.name = Config::FONT[1]
      @section['@name'].font.size = 15
      @section['@name'].draw_text(0, (@section['@name'].height - @section['@name'].font.size) / 2, 
        @section['@name'].width, @section['@name'].font.size, name, 1)
      
      # 설명
      @section['@description'] = Bitmap.new(1, 1)
      line = @section['@description'].get_divided_text(width - 12, @itemData.description).size
      @section['@description'] = Bitmap.new(width, line * 14 + 20)
      @section['@description'].fill_rect(0, 0, @section['@description'].width, @section['@description'].height, Color.black(128))
      @section['@description'].draw_multi_outline_text(
        6, 10, @section['@description'].width - 18, @section['@description'].height,
        @itemData.description, Color.white, Color.black(128))
      
      # 타입
      @section['@type'] = Bitmap.new(width, 16) 
      @section['@type'].fill_rect(0, 0, @section['@type'].width, @section['@type'].height, Color.black(128))
      @section['@type'].draw_outline_text(
        0, 0, @section['@type'].width, @section['@type'].height,
        "(" + Game.getItemType(@itemData.type) + " 아이템)",
        Color.white, Color.black(128), 1)
        
      # 사용 여부
      @section['@consume'] = Bitmap.new(width, 16) 
      @section['@consume'].fill_rect(0, 0, @section['@consume'].width, @section['@consume'].height, Color.black(128))
      @section['@consume'].draw_outline_text(
        0, 0, @section['@consume'].width, @section['@consume'].height,
        @itemData.consume.zero? ? "사용 불가" : "사용 가능",
        @itemData.consume.zero? ? Color.new(255, 160, 0) : Color.white, Color.black(128), 1)
      
      # 거래 여부
      @section['@trade'] = Bitmap.new(width, 16) 
      @section['@trade'].fill_rect(0, 0, @section['@trade'].width, @section['@trade'].height, Color.black(128))
      @section['@trade'].draw_outline_text(
        0, 0, @section['@trade'].width, @section['@trade'].height,
        @itemData.trade.zero? ? "거래 불가" : "거래 가능",
        @itemData.trade.zero? ? Color.new(255, 160, 0) : Color.white, Color.black(128), 1)
        
      # 사용 가능 레벨
      @section['@limitLevel'] = Bitmap.new(width, 20) 
      @section['@limitLevel'].fill_rect(0, 0, @section['@limitLevel'].width, @section['@limitLevel'].height, Color.black(128))
      @section['@limitLevel'].draw_outline_text(
        0, 0, @section['@limitLevel'].width - 5, @section['@limitLevel'].height,
        @itemData.limitLevel.to_s + " 레벨 이상 사용 가능",
        Color.white, Color.black(128), 2)
  
      # 가격
      @section['@price'] = Bitmap.new(width, 20) 
      @section['@price'].fill_rect(0, 0, @section['@price'].width, @section['@price'].height, Color.black(128))
      @section['@price'].draw_outline_text(
        0, 0, @section['@price'].width - 5, @section['@price'].height,
        "\\" + Math.unitMoney(@itemData.price),
        Color.white, Color.black(128), 2)
      
      # STR
      @section['@str'] = Bitmap.new(width, 20) 
      @section['@str'].fill_rect(0, 0, @section['@str'].width, @section['@str'].height, Color.black(128))
      @section['@str'].font.name = Config::FONT[0]
      @section['@str'].draw_outline_text(
        12, 0, @section['@str'].width, @section['@str'].height,
        "STR",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@str'].draw_outline_text(
        0, 0, @section['@str'].width - 12, @section['@str'].height,
        @itemData.str.to_s + " ( +" + @item.str.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # DEX
      @section['@dex'] = Bitmap.new(width, 20)
      @section['@dex'].fill_rect(0, 0, @section['@dex'].width, @section['@dex'].height, Color.black(128))
      @section['@dex'].font.name = Config::FONT[0]
      @section['@dex'].draw_outline_text(
        12, 0, @section['@dex'].width, @section['@dex'].height,
        "DEX",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@dex'].draw_outline_text(
        0, 0, @section['@dex'].width - 12, @section['@dex'].height,
        @itemData.dex.to_s + " ( +" + @item.dex.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # AGI
      @section['@agi'] = Bitmap.new(width, 20)
      @section['@agi'].fill_rect(0, 0, @section['@agi'].width, @section['@agi'].height, Color.black(128))
      @section['@agi'].font.name = Config::FONT[0]
      @section['@agi'].draw_outline_text(
        12, 0, @section['@agi'].width, @section['@agi'].height,
        "AGI",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@agi'].draw_outline_text(
        0, 0, @section['@agi'].width - 12, @section['@agi'].height,
        @itemData.agi.to_s + " ( +" + @item.agi.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # 크리티컬
      @section['@critical'] = Bitmap.new(width, 20)
      @section['@critical'].fill_rect(0, 0, @section['@critical'].width, @section['@critical'].height, Color.black(128))
      @section['@critical'].font.name = Config::FONT[0]
      @section['@critical'].draw_outline_text(
        12, 0, @section['@critical'].width, @section['@critical'].height,
        "크리티컬",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@critical'].draw_outline_text(
        0, 0, @section['@critical'].width - 12, @section['@critical'].height,
        @itemData.critical.to_s + " ( +" + @item.critical.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # 회피율
      @section['@avoid'] = Bitmap.new(width, 20)
      @section['@avoid'].fill_rect(0, 0, @section['@avoid'].width, @section['@avoid'].height, Color.black(128))
      @section['@avoid'].font.name = Config::FONT[0]
      @section['@avoid'].draw_outline_text(
        12, 0, @section['@avoid'].width, @section['@avoid'].height,
        "회피율",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@avoid'].draw_outline_text(
        0, 0, @section['@avoid'].width - 12, @section['@avoid'].height,
        @itemData.avoid.to_s + " ( +" + @item.avoid.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # 명중율
      @section['@hit'] = Bitmap.new(width, 20)
      @section['@hit'].fill_rect(0, 0, @section['@hit'].width, @section['@hit'].height, Color.black(128))
      @section['@hit'].font.name = Config::FONT[0]
      @section['@hit'].draw_outline_text(
        12, 0, @section['@hit'].width, @section['@hit'].height,
        "명중율",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@hit'].draw_outline_text(
        0, 0, @section['@hit'].width - 12, @section['@hit'].height,
        @itemData.hit.to_s + " ( +" + @item.hit.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
      
      # 딜레이
      @section['@delay'] = Bitmap.new(width, 20)
      @section['@delay'].fill_rect(0, 0, @section['@delay'].width, @section['@delay'].height, Color.black(128))
      @section['@delay'].font.name = Config::FONT[0]
      @section['@delay'].draw_outline_text(
        12, 0, @section['@delay'].width, @section['@delay'].height,
        "딜레이",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@delay'].draw_outline_text(
        0, 0, @section['@delay'].width - 12, @section['@delay'].height,
        @itemData.delay.to_s,
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # 물리공격력
      @section['@damage'] = Bitmap.new(width, 20)
      @section['@damage'].fill_rect(0, 0, @section['@damage'].width, @section['@damage'].height, Color.black(128))
      @section['@damage'].font.name = Config::FONT[0]
      @section['@damage'].draw_outline_text(
        12, 0, @section['@damage'].width, @section['@damage'].height,
        "물리공격력",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@damage'].draw_outline_text(
        0, 0, @section['@damage'].width - 12, @section['@damage'].height,
        @itemData.damage.to_s + " ( +" + @item.damage.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
  
      # 마법공격력
      @section['@magic_damage'] = Bitmap.new(width, 20)
      @section['@magic_damage'].fill_rect(0, 0, @section['@magic_damage'].width, @section['@magic_damage'].height, Color.black(128))
      @section['@magic_damage'].font.name = Config::FONT[0]
      @section['@magic_damage'].draw_outline_text(
        12, 0, @section['@magic_damage'].width, @section['@magic_damage'].height,
        "마법공격력",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@magic_damage'].draw_outline_text(
        0, 0, @section['@magic_damage'].width - 12, @section['@magic_damage'].height,
        @itemData.magicDamage.to_s + " ( +" + @item.magicDamage.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
        
      # 물리방어력
      @section['@defense'] = Bitmap.new(width, 20)
      @section['@defense'].fill_rect(0, 0, @section['@defense'].width, @section['@defense'].height, Color.black(128))
      @section['@defense'].font.name = Config::FONT[0]
      @section['@defense'].draw_outline_text(
        12, 0, @section['@defense'].width, @section['@defense'].height,
        "물리방어력",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@defense'].draw_outline_text(
        0, 0, @section['@defense'].width - 12, @section['@defense'].height,
        @itemData.defense.to_s + " ( +" + @item.defense.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
  
      # 마법방어력
      @section['@magic_defense'] = Bitmap.new(width, 20)
      @section['@magic_defense'].fill_rect(0, 0, @section['@magic_defense'].width, @section['@magic_defense'].height, Color.black(128))
      @section['@magic_defense'].font.name = Config::FONT[0]
      @section['@magic_defense'].draw_outline_text(
        12, 0, @section['@magic_defense'].width, @section['@magic_defense'].height,
        "마법방어력",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@magic_defense'].draw_outline_text(
        0, 0, @section['@magic_defense'].width - 12, @section['@magic_defense'].height,
        @itemData.magicDefense.to_s + " ( +" + @item.magicDefense.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)      
        
      # HP
      @section['@hp'] = Bitmap.new(width, 20)
      @section['@hp'].fill_rect(0, 0, @section['@hp'].width, @section['@hp'].height, Color.black(128))
      @section['@hp'].font.name = Config::FONT[0]
      @section['@hp'].draw_outline_text(
        12, 0, @section['@hp'].width, @section['@hp'].height,
        "HP",
        Color.new(0, 192, 255), Color.black(128), 0)      
      @section['@hp'].draw_outline_text(
        0, 0, @section['@hp'].width - 12, @section['@hp'].height,
        @itemData.hp.to_s + " ( +" + @item.hp.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)      
        
      # MP
      @section['@mp'] = Bitmap.new(width, 20)
      @section['@mp'].fill_rect(0, 0, @section['@mp'].width, @section['@mp'].height, Color.black(128))
      @section['@mp'].font.name = Config::FONT[0]
      @section['@mp'].draw_outline_text(
        12, 0, @section['@mp'].width, @section['@mp'].height,
        "MP",
        Color.new(0, 192, 255), Color.black(128), 0)
      @section['@mp'].draw_outline_text(
        0, 0, @section['@mp'].width - 12, @section['@mp'].height,
        @itemData.mp.to_s + " ( +" + @item.mp.to_s + " )",
        Color.new(0, 192, 255), Color.black(128), 2)
      # 섹션 합체
      @viewport = Viewport.new(0, 0, width, Graphics.getRect[1])
      @viewport.z = 999999 + 1
      @sprite = Sprite.new(@viewport)
      @sprite.bitmap = Bitmap.new(@viewport.rect.width, @viewport.rect.height)
      blt(0, 0, '@name')
      blt(0, 24, '@image')
      blt(0, 60, '@type')
      blt(0, 76, '@consume')
      blt(0, 92, '@trade')
      blt(0, 109, '@description')
      h = @section['@description'].height
      batch = ['@str', '@dex', '@agi', '@critical', '@avoid', '@hit', '@delay', '@damage', '@magic_damage', '@defense', '@magic_defense', '@hp', '@mp']
      n = 0
      for i in 0...batch.size
        if @itemData.instance_variable_get(batch[i]) != 0
          blt(0, h + 110 + n * 20, batch[i])
          n += 1
        end
      end
      h2 = h + 110 + n * 20 + 1
      blt(0, h2, '@price')
      blt(0, h2 + 20, '@limitLevel')
    end
    
    def self.blt(x, y, key)
      if @itemData.instance_variable_get(key) != 0 or ['@type', '@consume', '@trade', '@price', '@limitLevel'].include?(key)
        @sprite.bitmap.blt(x, y, @section[key], Rect.new(0, 0, @section[key].width, @section[key].height))
      end
    end
    
    def self.update
      @viewport.rect.x = Mouse.x
      @viewport.rect.y = Mouse.y
    end
    
    def self.clear
      return if not @item
      @item = nil
      @sprite.bitmap.clear
    end
  end
end