# encoding: utf-8

#===============================================================================
# Proper Graphics Disposal
# Author: Blizzard
# Version: 1.0
#-------------------------------------------------------------------------------
# [ Description ]
# RPG Maker VX Ace came with a somewhat unknown problem revolving around sprites
# assigned to viewports. If a viewport is disposed before disposing the sprites
# on it, it can lead to unexpected crashes. This was normally handled in RMXP
# but this can cause memory leaks in RMVXA. As such, this script ensures that
# any sprites attached to a viewport are disposed first before the viewport is
# disposed.
#
# For more information, please read the topic discussion:
#   http://forums.rpgmakerweb.com/index.php?/topic/17400-hidden-gameexe-crash-
#   debugger-graphical-object-global-reference-ace/
#
# [ Instructions ]
# There is nothing to do here.
# Please keep this script in its current location.
#
# It is highly advised to not modify this script unless you know what you are
# doing.
#===============================================================================
#==============================================================================
# Sprite
#==============================================================================

class Sprite
  class << Sprite
    alias new_xpa_sprite_fix new
    def new(*args)
      object = new_xpa_sprite_fix(*args)
      if !object.disposed? && object.viewport != nil
        object.viewport.register_sprite(object)
      end
      return object
    end
  end 
  
  alias dispose_xpa_sprite_fix dispose
  def dispose
    if !self.disposed? && self.viewport != nil
      self.viewport.unregister_sprite(self)
    end
    dispose_xpa_sprite_fix
  end
end

class Sprite
  def isPointInRect?(_x, _y)
    return false unless self.visible
    return false unless self.opacity > 0
    return false unless (_x + self.ox >= self.x && _x + self.ox < self.x + self.width)
    return false unless (_y + self.oy >= self.y && _y + self.oy < self.y + self.height)
    return true
  end
end