# filename game/map_sprite.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ MapSprite
# --------------------------------------------------------------------------
# Author    EnterBrain
# Modify    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 7
#────────────────────────────────────────────────────────────────────────────
class MapSprite
  def initialize
    @viewport1 = Viewport.new(0, 0, 640, 480)
    @viewport2 = Viewport.new(0, 0, 640, 480)
    @viewport3 = Viewport.new(0, 0, 640, 480)
    @viewport2.z = 200
    @viewport3.z = 5000
    @tilemap = Tilemap.new(@viewport1)
    @tilemap.tileset = RPG::Cache.tileset(Game.map.tileset_name)
    for i in 0..6
      autotile_name = Game.map.autotile_names[i]
      @tilemap.autotiles[i] = RPG::Cache.autotile(autotile_name)
    end
    @tilemap.map_data = Game.map.data
    @tilemap.priorities = Game.map.priorities
    @panorama = Plane.new(@viewport1)
    @panorama.z = -1000
    @fog = Plane.new(@viewport1)
    @fog.z = 3000
    @character_sprites = []
    for i in Game.map.events.keys.sort
      sprite = CharacterSprite.new(@viewport1, Game.map.events[i])
      @character_sprites.push(sprite)
    end
    @character_sprites.push(CharacterSprite.new(@viewport1, Game.player))
    @weather = RPG::Weather.new(@viewport1)
    @timer_sprite = Timer.new
    update
  end

  def dispose
    @tilemap.tileset.dispose
    for i in 0..6
      @tilemap.autotiles[i].dispose
    end
    @tilemap.dispose
    @panorama.dispose
    @fog.dispose
    for sprite in @character_sprites
      sprite.dispose
    end
    @weather.dispose
    @timer_sprite.dispose
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
  end

  def update
    if @panorama_name != Game.map.panorama_name or
       @panorama_hue != Game.map.panorama_hue
      @panorama_name = Game.map.panorama_name
      @panorama_hue = Game.map.panorama_hue
      if @panorama.bitmap != nil
        @panorama.bitmap.dispose
        @panorama.bitmap = nil
      end
      if @panorama_name != ""
        @panorama.bitmap = RPG::Cache.panorama(@panorama_name, @panorama_hue)
      end
      Graphics.frame_reset
    end
    if @fog_name != Game.map.fog_name or @fog_hue != Game.map.fog_hue
      @fog_name = Game.map.fog_name
      @fog_hue = Game.map.fog_hue
      if @fog.bitmap != nil
        @fog.bitmap.dispose
        @fog.bitmap = nil
      end
      if @fog_name != ""
        @fog.bitmap = RPG::Cache.fog(@fog_name, @fog_hue)
      end
      Graphics.frame_reset
    end
    @tilemap.ox = Game.map.display_x / 4
    @tilemap.oy = Game.map.display_y / 4
    @tilemap.update
    @panorama.ox = Game.map.display_x / 8
    @panorama.oy = Game.map.display_y / 8
    @fog.zoom_x = Game.map.fog_zoom / 100.0
    @fog.zoom_y = Game.map.fog_zoom / 100.0
    @fog.opacity = Game.map.fog_opacity
    @fog.blend_type = Game.map.fog_blend_type
    @fog.ox = Game.map.display_x / 4 + Game.map.fog_ox
    @fog.oy = Game.map.display_y / 4 + Game.map.fog_oy
    @fog.tone = Game.map.fog_tone
    for sprite in @character_sprites
      sprite.update
      if sprite.erase > 255
        sprite.dispose
        @character_sprites.delete(sprite)
      end
    end
    @weather.type = Game.screen.weather_type
    @weather.max = Game.screen.weather_max
    @weather.ox = Game.map.display_x / 4
    @weather.oy = Game.map.display_y / 4
    @weather.update
    @timer_sprite.update
    @viewport1.tone = Game.screen.tone
    @viewport1.ox = Game.screen.shake
    @viewport3.color = Game.screen.flash_color
    @viewport1.update
    @viewport3.update
  end
end
