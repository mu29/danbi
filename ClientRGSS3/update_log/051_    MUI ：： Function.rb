#────────────────────────────────────────────────────────────────────────────

# ▶ MUI::Function

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com)

# Date      2013

# --------------------------------------------------------------------------

# Description

# 

#    MUI 에서 사용하는 함수를 담당하는 클래스입니다.

#────────────────────────────────────────────────────────────────────────────

module RPG

  module Cache

    def self.mui(filename)

      self.load_bitmap("Graphics/MUI/", filename)

    end



    def self.form(filename)

      self.load_bitmap("Graphics/MUI/Form/", filename)

    end

    

    def self.button(filename)

      self.load_bitmap("Graphics/MUI/Button/", filename)

    end

    

    def self.textBox(filename)

      self.load_bitmap("Graphics/MUI/TextBox/", filename)

    end

    

    def self.checkBox(filename)

      self.load_bitmap("Graphics/MUI/CheckBox/", filename)

    end

    

    def self.radioBox(filename)

      self.load_bitmap("Graphics/MUI/RadioBox/", filename)

    end

    

    def self.vScroll(filename)

      self.load_bitmap("Graphics/MUI/VScroll/", filename)

    end

    

    def self.hScroll(filename)

      self.load_bitmap("Graphics/MUI/HScroll/", filename)

    end

    

    def self.tab(filename)

      self.load_bitmap("Graphics/MUI/Tab/", filename)

    end

    

    def self.hud(filename)

      self.load_bitmap("Graphics/MUI/HUD/", filename)

    end

    

    def self.damage(filename)

      self.load_bitmap("Graphics/Damage/", filename)

    end

  end

end



def comment_include(*args)

  list = *args[0].list

  trigger = *args[1]

  split = *args[2]

  return nil if list == nil

  return nil unless list.is_a?(Array)

  for item in list

    next if item.code != 108

    if split

      par = item.parameters[0].split(' | ')

      return item.parameters[0] if par[0] == trigger

    else

      return item.parameters[0] if item.parameters[0] == trigger

    end

  end

  return nil

end



def create_sprite(c)

  if $scene.is_a?(Scene_Map)

    $scene.instance_eval do

      @mapSprite.instance_eval do

        return if not @character_sprites

        @character_sprites.each do |v|

          if v.character == c

            return v

          end

        end

        sprite = CharacterSprite.new(@viewport1, c) #해상도

        @character_sprites.push(sprite)

      end

    end

  end

  return nil

end



def remove_sprite(c)

  if $scene.is_a?(Scene_Map)

    $scene.instance_eval do

      @mapSprite.instance_eval do

        delv = nil

        @character_sprites.each do |v|

          if v.character == c

            v.erase = 1

            break

          end

        end

      end

    end

  end

  return nil

end