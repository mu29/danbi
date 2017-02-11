#────────────────────────────────────────────────────────────────────────────

# ▶ MUI_ItemInfo

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), @cheapmunk.naver

# Date      2015. 2. 22

# --------------------------------------------------------------------------

# Description

# 

#    아이템의 정보를 띄우는 클래스입니다.

#────────────────────────────────────────────────────────────────────────────

class MUI

  class SkillInfo

    def self.init

      @viewport = Viewport.new(0, 0, 10, 10)

      @viewport.z = 999999 + 1

      @sprite = Sprite.new(@viewport)

      @sprite.bitmap = Bitmap.new(@viewport.rect.width, @viewport.rect.height)

    end

    

    def self.set(skill)

      return if not skill

      return if @skill == skill

      clear

      @skill = skill

      @skillData = Game.getSkill(skill.no)

      width = 200

      @section = {}

  

      # 이미지

      @section['@image'] = Bitmap.new(width, 36)

      icon = RPG::Cache.icon(@skillData.image)

      @section['@image'].fill_rect(0, 0, @section['@image'].width, @section['@image'].height, Color.black(128))

      @section['@image'].blt(

        (@section['@image'].width - icon.width) / 2,

        (@section['@image'].height - icon.height) / 2,

        icon, Rect.new(0, 0, icon.width, icon.height))

      

      # 이름 (타입)

      name = @skillData.name

      @section['@name'] = Bitmap.new(width, 24)

      @section['@name'].fill_rect(0, 0, @section['@name'].width, @section['@name'].height, Color.black(192))

      @section['@name'].font.name = Config::FONT[1]

      @section['@name'].font.size = 15

      @section['@name'].draw_text(0, (@section['@name'].height - @section['@name'].font.size) / 2, 

        @section['@name'].width, @section['@name'].font.size, name, 1)

      

      # 설명

      @section['@description'] = Bitmap.new(1, 1)

      line = @section['@description'].get_divided_text(width - 12, @skillData.description).size

      @section['@description'] = Bitmap.new(width, line * 14 + 20)

      @section['@description'].fill_rect(0, 0, @section['@description'].width, @section['@description'].height, Color.black(128))

      @section['@description'].draw_multi_outline_text(

        6, 10, @section['@description'].width - 18, @section['@description'].height,

        @skillData.description, Color.white, Color.black(128))

      

      # 타입

      @section['@type'] = Bitmap.new(width, 16) 

      @section['@type'].fill_rect(0, 0, @section['@type'].width, @section['@type'].height, Color.black(128))

      @section['@type'].draw_outline_text(

        0, 0, @section['@type'].width, @section['@type'].height,

        "(" + @skillData.type + ")",

        Color.white, Color.black(128), 1)

        

      # 사용 가능 레벨

      @section['@limitLevel'] = Bitmap.new(width, 20) 

      @section['@limitLevel'].fill_rect(0, 0, @section['@limitLevel'].width, @section['@limitLevel'].height, Color.black(128))

      @section['@limitLevel'].draw_outline_text(

        0, 0, @section['@limitLevel'].width - 5, @section['@limitLevel'].height,

        @skillData.limitLevel.to_s + " 레벨 이상 사용 가능",

        Color.white, Color.black(128), 2)

        

      # 딜레이

      @section['@delay'] = Bitmap.new(width, 20)

      @section['@delay'].fill_rect(0, 0, @section['@delay'].width, @section['@delay'].height, Color.black(128))

      @section['@delay'].font.name = Config::FONT

      @section['@delay'].draw_outline_text(

        12, 0, @section['@delay'].width, @section['@delay'].height,

        "쿨타임",

        Color.new(0, 192, 255), Color.black(128), 0)

      @section['@delay'].draw_outline_text(

        0, 0, @section['@delay'].width - 12, @section['@delay'].height,

        "#{@skillData.delay.to_f / 5}",

        Color.new(0, 192, 255), Color.black(128), 2)

      

 

      # 섹션 합체

      @viewport = Viewport.new(0, 0, width, Graphics.getRect[1])

      @viewport.z = 999999 + 1

      @sprite = Sprite.new(@viewport)

      @sprite.bitmap = Bitmap.new(@viewport.rect.width, @viewport.rect.height)

      blt(0, 0, '@name')

      blt(0, 24, '@image')

      blt(0, 60, '@type')

      blt(0, 76, '@description')

      h = @section['@description'].height

      batch = []

      batch.push('@delay') if @section['@delay']

      batch.push('@damage') if @section['@damage']

      n = 0

      for i in 0...batch.size

        if @skillData.instance_variable_get(batch[i]) != 0

          blt(0, h + 77 + n * 20, batch[i])

          n += 1

        end

      end

      h2 = h + 57 + n * 20 + 1

      blt(0, h2 + 20, '@limitLevel')

    end

    

    def self.blt(x, y, key)

      if @skillData.instance_variable_get(key) != 0 or ['@type', '@consume', '@trade', '@price', '@limitLevel'].include?(key)

        @sprite.bitmap.blt(x, y, @section[key], Rect.new(0, 0, @section[key].width, @section[key].height))

      end

    end

    

    def self.update

      @viewport.rect.x = Mouse.x

      @viewport.rect.y = Mouse.y

    end

    

    def self.clear

      return if not @skill

      @skill = nil

      @sprite.bitmap.clear

    end

  end

end