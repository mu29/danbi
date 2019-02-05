# filename scene/map.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ Scene_Map
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015
#────────────────────────────────────────────────────────────────────────────
class Scene_Map
  attr_accessor :hud
  
  def initialize
    @mapSprite = MapSprite.new
    @hud = MUI_HUD.new
    MUI::Console.init
    MUI::ChatBox.init
  end
  
  def main
    Graphics.transition
    loop do
      Graphics.update
      Socket.update
      MUI.update
      MUI::ChatBox.update
      @hud.update
      update
      if $scene != self
        break
      end
    end
    Graphics.freeze
    @mapSprite.dispose
  end

  def update
    loop do
      Game.map.update
      Game.player.update
      Game.system.update
      Game.screen.update
      unless Game.player.transferring
        break
      end
      transfer_player
      if Game.screen.transition_processing
        break
      end
    end
    if Game.screen.transition_processing
      Game.screen.transition_processing = false
      if Game.screen.transition_name == ""
        Graphics.transition(20)
      else
        Graphics.transition(40, "Graphics/Transitions/" +
          Game.screen.transition_name)
      end
    end
    @mapSprite.update
    if Mouse.trigger?(1)
      for netplayer in Game.map.netplayers.values
        #puts "mouse:"
        #puts [Mouse.map_x, Mouse.map_y].inspect
        #puts "netplayer"
        #puts [netplayer.x, netplayer.y].inspect
        if netplayer.x == Mouse.map_x && netplayer.y == Mouse.map_y
          MUI.getForm(MUI_ClickMenu).dispose if MUI.include?(MUI_ClickMenu)
          MUI_ClickMenu.new(netplayer.no)
        end
      end
    end
    return if MUI.nowTyping?
    if Key.trigger?(KEY_U)
      if MUI.include?(MUI_Status)
        MUI.getForm(MUI_Status).dispose
      else
        MUI_Status.new
      end
    elsif Key.trigger?(KEY_I)
      if MUI.include?(MUI_Inventory)
        MUI.getForm(MUI_Inventory).dispose
      else
        MUI_Inventory.new
      end
    elsif Key.trigger?(KEY_K)
      if MUI.include?(MUI_Skill)
        MUI.getForm(MUI_Skill).dispose
      else
        MUI_Skill.new
      end
    elsif Key.trigger?(KEY_SPACE)
      Socket.send({'header' => CTSHeader::ACTION})
    elsif Key.trigger?(KEY_Z)
      Socket.send({'header' => CTSHeader::PICK_ITEM})
    end
  end

  def transfer_player
    Game.player.transferring = false
    if Game.map.map_id != Game.player.new_map_id
      Game.map.setup(Game.player.new_map_id)
    end
    Game.player.moveto(Game.player.new_x, Game.player.new_y)
    case Game.player.new_direction
    when 2  # 하
      Game.player.turn_down
    when 4  # 왼쪽
      Game.player.turn_left
    when 6  # 오른쪽
      Game.player.turn_right
    when 8  # 상
      Game.player.turn_up
    end
    Game.player.straighten
    Game.map.update
    @mapSprite.dispose
    @mapSprite = MapSprite.new
    #if Game.screen.transition_processing
    #  Game.screen.transition_processing = false
    #  Graphics.transition(20)
    #end
    Game.map.autoplay
    Graphics.frame_reset
    Input.update
  end
end