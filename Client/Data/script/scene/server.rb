# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ Scene_Server
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 2
#────────────────────────────────────────────────────────────────────────────
class Scene_Server
  def initialize
    Game.system.bgm_play(RPG::AudioFile.new("Rain.mp3"))
    @cache = RPG::Cache.title("title.png"), RPG::Cache.title("cloud.png")
    @sprite = []
    # title
    @sprite[0] = Sprite.new
    @sprite[0].bitmap = @cache[0]
    # sun
    @sprite[1] = Sprite.new
    @sprite[1].ox = @cache[1].width / 2
    @sprite[1].oy = @cache[1].height / 2
    @sprite[1].x = 400
    @sprite[1].y = 85
    @sprite[1].bitmap = @cache[1]
    @sprite[1].opacity = 0
    @viewport = Viewport.new(390, 135, 25, 25)
    # rain
    @rain = true
    @sprite[2] = Sprite.new(@viewport)
    @sprite[2].bitmap = Bitmap.new(25, @viewport.rect.height * 2)
    @sprite[2].opacity = 0
    # comment
    @sprite[3] = Sprite.new
    @sprite[3].y = 212
    @sprite[3].opacity = 0
    @sprite[3].bitmap = Bitmap.new(800, 20)
    @sprite[3].bitmap.font.name = Config::FONT[0]
    @sprite[3].bitmap.font.size = 20
    @sprite[3].bitmap.draw_multi_text(0, 0, @sprite[3].bitmap.width, @sprite[3].bitmap.height,
    "RPGXP 온라인 엔진", 1)
    MUI_Server.new
  end
  
  def main
    $data_tilesets = load_data("Data/Tilesets.rxdata")
    $data_animations = load_data("Data/Animations.rxdata")
    Graphics.transition
    loop do
      slide
      animation
      Socket.update
      MUI.update
      Graphics.update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @sprite.each_index { |n| @sprite[n].bitmap.dispose; @sprite[n].dispose }
    #@cache.each_index { |n| @cache[n].dispose }
    MUI.getForm(MUI_Server).dispose
  end
  
  def slide
    @sprite[1].y += (115 - @sprite[1].y + @sprite[1].oy) / 10.0
    if @sprite[1].opacity < 255
      @sprite[1].opacity += 5
    else
      return if @sprite[3].opacity >= 255
      @sprite[3].opacity += 2
    end
  end
  
  def rain
    return if !@rain
    @sprite[2].bitmap.clear
    32.times do
      @sprite[2].bitmap.fill_rect(rand(@sprite[2].bitmap.width) - 1,
      - 24 + rand(@sprite[2].bitmap.height) * 3,
      1,
      3 + rand(2), Color.white(128))
    end
  end
  
  def animation
    if Mouse.x >= @sprite[1].x - @sprite[1].ox and Mouse.x <= @sprite[1].x - @sprite[1].ox + @sprite[1].bitmap.width and
      Mouse.y >= @sprite[1].y - @sprite[1].oy and Mouse.y <= @sprite[1].y - @sprite[1].oy + @sprite[1].bitmap.height
      @sprite[1].zoom_x += (1.2 - @sprite[1].zoom_x) / 10.0
      @sprite[1].zoom_y += (1.2 - @sprite[1].zoom_y) / 10.0
      if Mouse.trigger?
        @rain = @rain ? false : true
      end
    else
      @sprite[1].zoom_x += (1 - @sprite[1].zoom_x) / 10.0
      @sprite[1].zoom_y += (1 - @sprite[1].zoom_y) / 10.0
    end
    if @rain
      if Graphics.frame_count % 1 == 0
        @sprite[2].y += 1
        @sprite[2].opacity += 10
        if @sprite[2].y >= @sprite[2].bitmap.height / 4
          @sprite[2].y = 0
          rain
        end
      end
    else
      @sprite[2].y += 1 if @sprite[2].opacity >= 0
      @sprite[2].opacity -= 10 if @sprite[2].opacity >= 0
      @sprite[2].bitmap.clear if @sprite[2].opacity <= 0
    end
  end
end