# encoding: utf-8

#==============================================================================
# Viewport
#==============================================================================

class Viewport
  alias dispose_xpa_sprite_fix dispose
  def dispose
    if @_sprites != nil
      @_sprites.clone.each {|sprite| sprite.dispose if !sprite.disposed? }
      @_sprites = []
    end
    dispose_xpa_sprite_fix
  end
  
  def register_sprite(sprite)
    @_sprites ||= []
    @_sprites.push(sprite)
  end
  
  def unregister_sprite(sprite)
    @_sprites ||= []
    @_sprites.delete(sprite)
  end
end