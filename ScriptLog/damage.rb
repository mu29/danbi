# filename damage.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ CharacterSprite
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 31
# --------------------------------------------------------------------------
# Description
# 
#    데미지를 표시하는 클래스입니다.
#    사용 전 Damage.loadCache를 호출하여 캐시를 불러와야 합니다.
#    업데이트는 CharacterSprite에서 수행합니다.
#────────────────────────────────────────────────────────────────────────────
class Damage < Sprite
  @@cache = {}
  
  def initialize(character, value, critical)
    super()
    @character = character
    @direction = rand(3) - 1
    @x_plus, @y_plus = 0, 0
    if value.is_a?(Fixnum)
      damage_width = 0
      file = value > 0 ? 'DAMAGE' : 'RECOVER'
      data = value.to_s.split(//)
      data = data[value > 0 ? 0 : 1, data.size]
      digit_width = @@cache[file].width / 10
      for num in data
        damage_width += digit_width
      end
      x, y = 0, 0
      if critical
        x = (@@cache['CRITICAL'].width - damage_width) / 2
        y = @@cache['CRITICAL'].height
        width = @@cache['CRITICAL'].width if @@cache['CRITICAL'].width > damage_width
        self.bitmap = Bitmap.new(width, y + @@cache[file].height)
        self.bitmap.blt(damage_width > @@cache['CRITICAL'].width ? x : 0, 0, @@cache['CRITICAL'], 
            Rect.new(0, 0, @@cache['CRITICAL'].width, @@cache['CRITICAL'].height))
        x = 0 if damage_width > @@cache['CRITICAL'].width
      else
        width = damage_width
        begin
          self.bitmap = Bitmap.new(width, y + @@cache[file].height)
        rescue
          self.bitmap = Bitmap.new(1, 1)
        end
      end
      for num in data
        self.bitmap.blt(x, y, @@cache[file], 
          Rect.new(num.to_i * digit_width, 0, digit_width, @@cache[file].height))
        x += digit_width
      end
      self.opacity = 255
    elsif value.is_a?(String)
      if @@cache.has_key?(value)
        self.bitmap = @@cache[value]
      end
    end
    self.x = @character.screen_x - self.bitmap.width / 2
    self.y = @character.screen_y - 50
    character.damages.push(self)
  end
  
  def update
    self.x = @character.screen_x - self.bitmap.width / 2 + @x_plus
    self.y = @character.screen_y - 50 + @y_plus
    self.opacity -= 10 if self.opacity > 0
    @x_plus += @direction
    if self.opacity > 150
      @y_plus -= (self.opacity - 105) / 30
    else
      @y_plus += (255 - self.opacity) / 30
    end
    dispose if self.opacity <= 0
  end
  
  def dispose
    self.bitmap.clear
    @character.damages.delete(self)
    super
  end
  
  def self.loadCache
    @@cache['CRITICAL'] = RPG::Cache.damage("CRITICAL")
    @@cache['MISS'] = RPG::Cache.damage("MISS")
    @@cache['DAMAGE'] = RPG::Cache.damage("DAMAGE")
    @@cache['RECOVER'] = RPG::Cache.damage("RECOVER")
  end
end