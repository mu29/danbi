# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ Scene_Map
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2015
#────────────────────────────────────────────────────────────────────────────
class Scene_Map
  attr_accessor :hud
  
  def initialize
    @map_sprite = MapSprite.new
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
    @map_sprite.dispose
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
    @map_sprite.update
    if Mouse.trigger?(1)
      for netplayer in Game.map.netplayers.values
        if netplayer.x == Mouse.map_x && netplayer.y == Mouse.map_y
          MUI.getForm(MUI_ClickMenu).dispose if MUI.include?(MUI_ClickMenu)
          MUI_ClickMenu.new(netplayer.no)
        end
      end
    end
    return if MUI.nowTyping?
    if Key.trigger?(Key::KB_U)
      if MUI.include?(MUI_Status)
        MUI.getForm(MUI_Status).dispose
      else
        MUI_Status.new
      end
    elsif Key.trigger?(Key::KB_I)
      if MUI.include?(MUI_Inventory)
        MUI.getForm(MUI_Inventory).dispose
      else
        MUI_Inventory.new
      end
    elsif Key.trigger?(Key::KB_K)
      if MUI.include?(MUI_Skill)
        MUI.getForm(MUI_Skill).dispose
      else
        MUI_Skill.new
      end
    elsif Key.trigger?(Key::KB_SPACE)
      Socket.send({'header' => CTSHeader::ACTION})
    elsif Key.trigger?(Key::KB_Z)
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
    @map_sprite.dispose
    @map_sprite = MapSprite.new
    #if Game.screen.transition_processing
    #  Game.screen.transition_processing = false
    #  Graphics.transition(20)
    #end
    Game.map.autoplay
    Graphics.frame_reset
    Input.update
  end
end