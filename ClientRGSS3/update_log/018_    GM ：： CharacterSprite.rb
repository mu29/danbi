#────────────────────────────────────────────────────────────────────────────

# ▶ CharacterSprite

# --------------------------------------------------------------------------

# Author    EnterBrain

# Modify    뮤 (mu29gl@gmail.com)

# Date      2015. 1. 7

#────────────────────────────────────────────────────────────────────────────

class CharacterSprite < RPG::Sprite

  attr_accessor :character

  attr_accessor :erase



  def initialize(viewport, character = nil)

    super(viewport)

    @character = character

    @guild = ""

    @title = ""

    @name = ""

    @info_width = 200

    @info_height = 60

    @character_info = Sprite.new(viewport)

    @character_info.bitmap = Bitmap.new(@info_width, @info_height)

    @erase = 0

    refresh

    update

  end

  

  def refresh

    return unless @character.is_a?(Player) or @character.is_a?(Netplayer)

    @character_info.bitmap.clear

    @character_info.bitmap.font.size = Config::FONT_SMALL_SIZE

    #@character_info.bitmap.draw_outline_text(0, 0, 200, 20, @character.guild, Color.white, Color.black, 1) Game.getTitle(@character.title), 1)

    @character_info.bitmap.draw_outline_text(0, 14, 200, 20, @character.guild, Color.white, Color.red, 1)

    @character_info.bitmap.draw_outline_text(0, 28, 200, 20, @character.name, Color.white, Color.black, 1)

  end



  def update

    super

    for damage in @character.damages

      damage.update

    end

    if @tile_id != @character.tile_id or

       @character_name != @character.character_name or

       @character_hue != @character.character_hue

      @tile_id = @character.tile_id

      @character_name = @character.character_name

      @character_hue = @character.character_hue

      if @tile_id >= 384

        self.bitmap = RPG::Cache.tile(Game.map.tileset_name,

          @tile_id, @character.character_hue)

        self.src_rect.set(0, 0, 32, 32)

        self.ox = 16

        self.oy = 32

        @character_info.ox = self.ox

        @character_info.oy = self.oy

      else

        if @character.isIcon

          self.bitmap = RPG::Cache.icon(@character.character_name)

          @cw = bitmap.width

          @ch = bitmap.height

        else

          self.bitmap = RPG::Cache.character(@character.character_name, @character.character_hue)

          @cw = bitmap.width / 4

          @ch = bitmap.height / 4

        end

        self.ox = @cw / 2

        self.oy = @ch

        @character_info.ox = self.ox

        @character_info.oy = self.oy

      end

    end

    self.visible = (not @character.transparent)

    if @tile_id == 0

      sx = @character.pattern * @cw

      sy = (@character.direction - 2) / 2 * @ch

      self.src_rect.set(sx, sy, @cw, @ch)

    end

    self.x = @character.screen_x

    self.y = @character.screen_y

    self.z = @character.screen_z(@ch)

    @character_info.x = self.x - (@info_width - @cw) / 2

    @character_info.y = self.y - 42

    @character_info.z = self.z

    @erase += 5 if @erase > 0

    self.opacity = @character.opacity - @erase

    self.blend_type = @character.blend_type

    self.bush_depth = @character.bush_depth

    if @character.animation_id != 0

      animation = $data_animations[@character.animation_id]

      animation(animation, true)

      @character.animation_id = 0

    end

    return unless @character.is_a?(Player) or @character.is_a?(Netplayer)

    if @guild != @character.guild or

      @title != Game.getTitle(@character.title) or

      @name != @character.name

      @guild = @character.guild

      @title = Game.getTitle(@character.title)

      @name = @character.name

      refresh

    end

  end

  

  def dispose

    super

    @character_info.bitmap.clear

    @character_info.dispose

  end

end