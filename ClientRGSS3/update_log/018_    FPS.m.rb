#────────────────────────────────────────────────────────────────────────────

# * FPS, Zeus81, 2012. 08. 03

#   http://forums.rpgmakerweb.com/index.php?/topic/3738-fps-display-isnt-very-accurate/

#────────────────────────────────────────────────────────────────────────────



module Graphics

  @fps, @fps_tmp = 0, []

  

  class << self

    attr_reader :fps

    alias :fps_update :update unless method_defined?(:fps_update)

    def update

      t = Time.now

      fps_update

      @fps_tmp[frame_count % frame_rate] = Time.now != t

      @fps = 0

      frame_rate.times {|i| @fps += 1 if @fps_tmp[i]}

      fps_sprite.src_rect.y = @fps * 16

    end

    

    def fps_sprite

      if !@fps_sprite or @fps_sprite.disposed?

        @fps_sprite = Sprite.new

        @fps_sprite.z = 0x7FFFFFFF

        @fps_sprite.bitmap = Bitmap.new(24, 16*120)

        @fps_sprite.bitmap.font.name = "Arial"

        @fps_sprite.bitmap.font.size = 16

        @fps_sprite.bitmap.font.color.set(255, 255, 255)

        @fps_sprite.bitmap.fill_rect(@fps_sprite.bitmap.rect, Color.new(0, 0, 0, 128))

        120.times {|i|

          case i

          when 0..24

            @fps_sprite.bitmap.font.color = Color.red

          when 25..39

            @fps_sprite.bitmap.font.color = Color.new(255, 128, 0)

          else

            @fps_sprite.bitmap.font.color = Color.white

          end

          @fps_sprite.bitmap.draw_text(0, i*16, 24, 16, "% 3d"%i, 1)

        }

        @fps_sprite.src_rect.height = 16

      end

      return @fps_sprite

    end

  end

end