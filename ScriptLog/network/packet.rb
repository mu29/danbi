# filename network/packet.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ Packet
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2014
# --------------------------------------------------------------------------
# Description
# 
#    각종 패킷을 받아 처리를 담당하는 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class Socket
  include Game
  def self.recv(recv)
    #begin
    return if not recv
    case recv["header"]
    when STCHeader::LOGIN
      case recv["type"]
      when 0
        Game.player.no = recv["no"]
        Game.player.id = recv["id"]
        Game.player.name = recv["name"]
        Game.player.title = recv["title"]
        Game.player.image = recv["image"]
        Game.player.job = recv["job"]
        Game.player.guild = recv["guild"]
        Game.player.guildNo = recv["guildNo"]
        Game.player.statPoint = recv["statPoint"]
        Game.player.skillPoint = recv["skillPoint"]
        Game.player.str = recv["str"]
        Game.player.dex = recv["dex"]
        Game.player.agi = recv["agi"]
        Game.player.critical = recv["critical"]
        Game.player.hit = recv["hit"]
        Game.player.avoid = recv["avoid"]
        Game.player.hp = recv["hp"]
        Game.player.maxHp = recv["maxHp"]
        Game.player.mp = recv["mp"]
        Game.player.maxMp = recv["maxMp"]
        Game.player.level = recv["level"]
        Game.player.exp = recv["exp"]
        Game.player.maxExp = recv["maxExp"]
        Game.player.gold = recv["gold"]
        Game.player.map = recv["map"]
        Game.player.x = recv["x"]
        Game.player.y = recv["y"]
        Game.player.direction = recv["direction"]
        # Equip
        Game.player.weapon = recv["weapon"]
        Game.player.shield = recv["shield"]
        Game.player.helmet = recv["helmet"]
        Game.player.armor = recv["armor"]
        Game.player.cape = recv["cape"]
        Game.player.shoes = recv["shoes"]
        Game.player.accessory = recv["accessory"]
        Game.map.setup(Game.player.map)
        Game.player.moveto(Game.player.x, Game.player.y)
        Game.player.refresh
        Game.map.autoplay
        $scene = Scene_Map.new
        Game.map.update
      when 1
        dialog = MUI_Dialog.new(Dialog::LOGIN, "로그인 실패", "아이디와 비밀번호를 확인해주세요.", ["닫기"]) do
          dialog.dispose if dialog.value == 0
        end
      end
    when STCHeader::REGISTER
      case recv["type"]
      when 0
        dialog = MUI_Dialog.new(Dialog::REGISTER, "가입 성공", "가입이 완료되었습니다.", ["닫기"]) do
          dialog.dispose if dialog.value == 0
        end
      when 1
        dialog = MUI_Dialog.new(Dialog::REGISTER, "가입 실패", "이미 존재하는 아이디입니다.", ["닫기"]) do
          dialog.dispose if dialog.value == 0
        end
      when 2
        dialog = MUI_Dialog.new(Dialog::REGISTER, "가입 실패", "이미 존재하는 닉네임입니다.", ["닫기"]) do
          dialog.dispose if dialog.value == 0
        end
      when 3
        dialog = MUI_Dialog.new(Dialog::REGISTER, "가입 실패", "알 수 없는 오류입니다.", ["닫기"]) do
          dialog.dispose if dialog.value == 0
        end
      end
    when STCHeader::CREATE_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; Game.map.addNetplayer(recv["no"], Netplayer.new)
      when CharacterType::NPC; Game.map.addNPC(recv["no"], NPC.new)
      when CharacterType::ENEMY; Game.map.addEnemy(recv["no"], Enemy.new) end
      return if not character
      character.no = recv["no"]
      character.name = recv["name"]
      character.image = recv["image"]
      character.hp = recv["hp"]
      character.maxHp = recv["maxHp"]
      character.moveto(recv["x"], recv["y"])
      character.direction = recv["d"]
      character.setGraphic(recv["image"], 0)
      if recv["type"] == 0
        character.title = recv["title"]
        character.guild = recv["guild"]
      end
      create_sprite(character)
      character.refresh
    when STCHeader::REMOVE_CHARACTER
      case recv["type"]
      when 0
        character = Game.map.getNetplayer(recv["no"])
        Game.map.removeNetplayer(recv["no"])
      when 1
        character = Game.map.getNPC(recv["no"])
        Game.map.removeNPC(recv["no"])
      when 2
        character = Game.map.getEnemy(recv["no"])
        Game.map.removeEnemy(recv["no"])
      end
      remove_sprite(character)
    when STCHeader::MOVE_CHARACTER
      case recv["type"]
      when 0
        netplayer = Game.map.getNetplayer(recv["no"])
        return if not netplayer
        netplayer.addMove(recv["d"])
        netplayer.finalX = recv["x"]
        netplayer.finalY = recv["y"]
        netplayer.startSync = true
      when 1
        p "npc"
      when 2
        enemy = Game.map.getEnemy(recv["no"])
        return if not enemy
        case recv["d"]
        when 2
          enemy.move_down
        when 4
          enemy.move_left
        when 6
          enemy.move_right
        when 8
          enemy.move_up
        end
        enemy.finalX = recv["x"]
        enemy.finalY = recv["y"]
      end
    when STCHeader::TURN_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; Game.map.getNetplayer(recv["no"])
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      case recv["d"]
      when 2
        character.turn_down
      when 4
        character.turn_left
      when 6
        character.turn_right
      when 8
        character.turn_up
      end
    when STCHeader::REFRESH_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; (Game.player.no == recv["no"] ? Game.player : Game.map.getNetplayer(recv["no"]))
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      character.moveto(recv["x"], recv["y"])
      character.direction = recv["d"]
      character.refresh
      
    when STCHeader::JUMP_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; (Game.player.no == recv["no"] ? Game.player : Game.map.getNetplayer(recv["no"]))
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      character.jumpTo(recv["x"], recv["y"])
      character.refresh
      
    when STCHeader::ANIMATION_CHARACTER
      
      character = case recv["type"]
      when CharacterType::USER; (Game.player.no == recv["no"] ? Game.player : Game.map.getNetplayer(recv["no"]))
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      character.animation_id = recv["ani"]
      
      
    when STCHeader::UPDATE_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; Game.map.getNetplayer(recv["no"])
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      character.title = recv["#{StatusType::TITLE}"] if recv["#{StatusType::TITLE}"]
      character.job = recv["StatusType::JOB"] if recv["StatusType::JOB"]
      character.image = recv["StatusType::IMAGE"] if recv["StatusType::IMAGE"]
      character.maxHp = recv["StatusType::MAX_HP"] if recv["StatusType::MAX_HP"]
      character.level = recv["#{StatusType::LEVEL}"] if recv["#{StatusType::LEVEL}"]
      character.hp = recv["#{StatusType::HP}"] if recv["#{StatusType::HP}"]
    when STCHeader::DAMAGE_CHARACTER
      character = case recv["type"]
      when CharacterType::USER; (Game.player.no == recv["no"] ? Game.player : Game.map.getNetplayer(recv["no"]))
      when CharacterType::NPC; Game.map.getNPC(recv["no"])
      when CharacterType::ENEMY; Game.map.getEnemy(recv["no"]) end
      return if not character
      Damage.new(character, recv["value"], !recv["critical"].nil?)
    when STCHeader::LOAD_DROP_ITEM
      item = Game.map.addItem(recv["no"], Character.new)
      return if not item
      item.isIcon = true
      item.setGraphic(recv["image"], 0)
      item.moveto(recv["x"], recv["y"])
      create_sprite(item)
    when STCHeader::LOAD_DROP_GOLD
      item = Game.map.addItem(recv["no"], Character.new)
      return if not item
      item.isIcon = true
      item.setGraphic("032-Item01", 0)
      item.moveto(recv["x"], recv["y"])
      create_sprite(item)
    when STCHeader::REMOVE_DROP_ITEM
      item = Game.map.getItem(recv["no"])
      Game.map.removeItem(recv["no"])
      remove_sprite(item)
    when STCHeader::REMOVE_DROP_GOLD
      item = Game.map.getItem(recv["no"])
      Game.map.removeItem(recv["no"])
      remove_sprite(item)
    when STCHeader::NOTIFY
    when STCHeader::MOVE_MAP
      return if !$scene.is_a?(Scene_Map)
      Game.player.new_map_id = recv["map"]
      Game.player.new_x = recv["x"]
      Game.player.new_y = recv["y"]
      Game.player.transferring = true
      $scene.transfer_player
    when STCHeader::CHAT_NORMAL
      color1 = Color.new(recv["r"], recv["g"], recv["b"]) if recv["r"]
      color2 = Color.new(recv["r2"], recv["g2"], recv["b2"]) if recv["r2"]
      MUI::Console.write(recv["message"], color1 ? color1 : Color.white, color2 ? color2 : Color.black)
      if Game.player.no == recv["no"]
        Game.player.chatBalloonText = recv["message"]
        Game.player.chatBalloonVisible = true
      end
      if netplayer = Game.map.getNetplayer(recv["no"])
        netplayer.chatBalloonText = recv["message"]
        netplayer.chatBalloonVisible = true
      end
    when STCHeader::CHAT_WHISPER, STCHeader::CHAT_PARTY, STCHeader::CHAT_GUILD
      color1 = Color.new(recv["r"], recv["g"], recv["b"]) if recv["r"]
      color2 = Color.new(recv["r2"], recv["g2"], recv["b2"]) if recv["r2"]
      MUI::Console.write(recv["message"], color1 ? color1 : Color.white, color2 ? color2 : Color.black)
    #when STCHeader::CHAT_PARTY
    #when STCHeader::CHAT_GUILD
    when STCHeader::CHAT_ALL
      color1 = Color.new(recv["r"], recv["g"], recv["b"]) if recv["r"]
      color2 = Color.new(recv["r2"], recv["g2"], recv["b2"]) if recv["r2"]
      MUI::Console.write(recv["message"], color1 ? color1 : Color.white, color2 ? color2 : Color.black)
      if Game.player.no == recv["no"]
        Game.player.chatBalloonText = recv["message"]
        Game.player.chatBalloonVisible = true
      end
      if netplayer = Game.map.getNetplayer(recv["no"])
        netplayer.chatBalloonText = recv["message"]
        netplayer.chatBalloonVisible = true
      end
    when STCHeader::CHAT_BALLOON_END
      if Game.player.no == recv["no"]
        Game.player.chatBalloonVisible = false
      end
      if netplayer = Game.map.getNetplayer(recv["no"])
        netplayer.chatBalloonVisible = false
      end
    when STCHeader::OPEN_REGISTER_WINDOW
      MUI_Register.new(recv["image"], recv["job"])
    when STCHeader::UPDATE_STATUS
      Game.player.title = recv["#{StatusType::TITLE}"] if recv["#{StatusType::TITLE}"]
      Game.player.image = recv["#{StatusType::IMAGE}"] if recv["#{StatusType::IMAGE}"]
      Game.player.job = recv["#{StatusType::JOB}"] if recv["#{StatusType::JOB}"]
      Game.player.str = recv["#{StatusType::STR}"] if recv["#{StatusType::STR}"]
      Game.player.dex = recv["#{StatusType::DEX}"] if recv["#{StatusType::DEX}"]
      Game.player.agi = recv["#{StatusType::AGI}"] if recv["#{StatusType::AGI}"]
      Game.player.critical = recv["#{StatusType::CRITICAL}"] if recv["#{StatusType::CRITICAL}"]
      Game.player.avoid = recv["#{StatusType::AVOID}"] if recv["#{StatusType::AVOID}"]
      Game.player.hit = recv["#{StatusType::HIT}"] if recv["#{StatusType::HIT}"]
      Game.player.statPoint = recv["#{StatusType::STAT_POINT}"] if recv["#{StatusType::STAT_POINT}"]
      Game.player.skillPoint = recv["#{StatusType::SKILL_POINT}"] if recv["#{StatusType::SKILL_POINT}"]
      Game.player.hp = recv["#{StatusType::HP}"] if recv["#{StatusType::HP}"]
      Game.player.maxHp = recv["#{StatusType::MAX_HP}"] if recv["#{StatusType::MAX_HP}"]
      Game.player.mp = recv["#{StatusType::MP}"] if recv["#{StatusType::MP}"]
      Game.player.maxMp = recv["#{StatusType::MAX_MP}"] if recv["#{StatusType::MAX_MP}"]
      Game.player.level = recv["#{StatusType::LEVEL}"] if recv["#{StatusType::LEVEL}"]
      Game.player.exp = recv["#{StatusType::EXP}"] if recv["#{StatusType::EXP}"]
      Game.player.maxExp = recv["#{StatusType::MAX_EXP}"] if recv["#{StatusType::MAX_EXP}"]
      if recv["#{StatusType::GOLD}"]
        Game.player.gold = recv["#{StatusType::GOLD}"]
        MUI.getForm(MUI_Inventory).refreshData if MUI.include?(MUI_Inventory)
      end
      Game.player.weapon = recv["#{StatusType::WEAPON}"] if recv["#{StatusType::WEAPON}"]
      Game.player.shield = recv["#{StatusType::SHIELD}"] if recv["#{StatusType::SHIELD}"]
      Game.player.helmet = recv["#{StatusType::HELMET}"] if recv["#{StatusType::HELMET}"]
      Game.player.armor = recv["#{StatusType::ARMOR}"] if recv["#{StatusType::ARMOR}"]
      Game.player.cape = recv["#{StatusType::CAPE}"] if recv["#{StatusType::CAPE}"]
      Game.player.shoes = recv["#{StatusType::SHOES}"] if recv["#{StatusType::SHOES}"]
      Game.player.accessory = recv["#{StatusType::ACCESSORY}"] if recv["#{StatusType::ACCESSORY}"]
      MUI.getForm(MUI_Status).refreshData if MUI.include?(MUI_Status)
    when STCHeader::SET_ITEM
      item = Item.new(recv["userNo"], recv["itemNo"], 
                      recv["amount"], recv["index"], 
                      recv["damage"], recv["magicDamage"], 
                      recv["defense"], recv["magicDefense"], 
                      recv["str"], recv["dex"], 
                      recv["agi"], recv["hp"], 
                      recv["mp"], recv["critical"], 
                      recv["avoid"], recv["hit"], 
                      recv["reinforce"], recv["trade"],
                      recv["equipped"])
      Game.player.addItem(recv["index"], item)
      MUI.getForm(MUI_Inventory).refreshData if MUI.include?(MUI_Inventory)
    when STCHeader::UPDATE_ITEM
      case recv["type"]
      when 0
        Game.player.removeItem(recv["index"])
      when 1
        Game.player.updateItem(recv["index"], recv["amount"],
                              recv["damage"], recv["magicDamage"], 
                              recv["defense"], recv["magicDefense"], 
                              recv["str"], recv["dex"], 
                              recv["agi"], recv["hp"], 
                              recv["mp"], recv["critical"], 
                              recv["avoid"], recv["hit"], 
                              recv["reinforce"], recv["trade"],
                              recv["equipped"])
      end
      MUI.getForm(MUI_Inventory).refreshData if MUI.include?(MUI_Inventory)
    when STCHeader::SET_SKILL
      skill = Skill.new(recv["no"], recv["rank"])
      Game.player.addSkill(skill)
      MUI.getForm(MUI_Skill).refreshData if MUI.include?(MUI_Skill)
    when STCHeader::UPDATE_SKILL
      case recv["type"]
      when 0
        Game.player.removeSkill(recv["no"])
      when 1
        Game.player.updateSkill(recv["no"], recv["rank"])
      end
    when STCHeader::REQUEST_TRADE
      partner = Game.map.getNetplayer(recv["partnerNo"])
      return if not partner
      dialog = MUI_Dialog.new(Dialog::TRADE_REQUEST, "거래 요청", partner.name + " 님이 거래를 요청하셨습니다.", ["수락", "거절"]) do
        if dialog.value == 0
          Socket.send({"header" => CTSHeader::RESPONSE_TRADE, "type" => 0, "partner" => partner.no})
          dialog.dispose
        elsif dialog.value == 1
          Socket.send({"header" => CTSHeader::RESPONSE_TRADE, "type" => 1, "partner" => partner.no})
          dialog.dispose
        end
      end
    when STCHeader::OPEN_TRADE_WINDOW
      partner = Game.map.getNetplayer(recv["partnerNo"])
      return if not partner
      MUI_Trade.new(partner)
    when STCHeader::LOAD_TRADE_ITEM
      item = Item.new(recv["userNo"], recv["itemNo"], 
                      recv["amount"], recv["index"], 
                      recv["damage"], recv["magicDamage"], 
                      recv["defense"], recv["magicDefense"], 
                      recv["str"], recv["dex"], 
                      recv["agi"], recv["hp"], 
                      recv["mp"], recv["critical"], 
                      recv["avoid"], recv["hit"], 
                      recv["reinforce"], 1, 0)
      if MUI.include?(MUI_Trade)
        MUI.getForm(MUI_Trade).addMyItem(recv["index"], item) if Game.player.no == recv["userNo"]
        MUI.getForm(MUI_Trade).addPartnerItem(recv["index"], item) if MUI.getForm(MUI_Trade).user.no == recv["userNo"]
      end
    when STCHeader::DROP_TRADE_ITEM
      if MUI.include?(MUI_Trade)
        MUI.getForm(MUI_Trade).removeMyItem(recv["index"]) if Game.player.no == recv["no"]
        MUI.getForm(MUI_Trade).removePartnerItem(recv["index"]) if MUI.getForm(MUI_Trade).user.no == recv["no"]
      end
    when STCHeader::CHANGE_TRADE_GOLD
      MUI.getForm(MUI_Trade).setGold(recv["no"], recv["amount"]) if MUI.include?(MUI_Trade)
    when STCHeader::FINISH_TRADE
      MUI.getForm(MUI_Trade).acceptTrade(recv["no"]) if MUI.include?(MUI_Trade)
    when STCHeader::CANCEL_TRADE
      MUI.getForm(MUI_Trade).dispose if MUI.include?(MUI_Trade)
    when STCHeader::OPEN_MESSAGE_WINDOW
      MUI_Message.new(recv["no"]) if !MUI.include?(MUI_Message)
      MUI.getForm(MUI_Message).set(recv["message"], recv["select"])
    when STCHeader::CLOSE_MESSAGE_WINDOW
      MUI.getForm(MUI_Message).dispose if MUI.include?(MUI_Message)
    when STCHeader::OPEN_SHOP_WINDOW
      Game.player.shopNo = recv["no"]
      Game.player.clearShopItem
      MUI_Shop.new 
    when STCHeader::SET_SHOP_ITEM
      return if !MUI.include?(MUI_Shop)
      item = Item.new(0, recv["no"], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
      Game.player.addShopItem(item)
      MUI.getForm(MUI_Shop).refreshData
    when STCHeader::SET_PARTY
      Game.player.partyNo = recv["no"]
      if Game.player.partyNo == 0
        Game.player.party_member = []
        MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
      end
    when STCHeader::SET_PARTY_MEMBER
      member = Netplayer.new
      member.no = recv["no"]
      member.name = recv["name"]
      member.image = recv["image"]
      member.level = recv["level"]
      member.job = recv["job"]
      member.hp = recv["hp"]
      member.maxHp = recv["maxHp"]
      Game.player.party_member.push(member)
      MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
    when STCHeader::REMOVE_PARTY_MEMBER
      for member in Game.player.party_member
        if member.no == recv["no"]
          Game.player.party_member.delete(member)
          break
        end
      end
      MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
    when STCHeader::INVITE_PARTY
      partyNo = recv["partyNo"]
      dialog = MUI_Dialog.new(Dialog::PARTY_INVITE, "파티 초대", recv["master"] + " 님의 파티에 가입하시겠습니까?", ["수락", "거절"]) do
        if dialog.value == 0
          Socket.send({"header" => CTSHeader::RESPONSE_PARTY, "type" => 0, "partyNo" => partyNo})
          dialog.dispose
        elsif dialog.value == 1
          Socket.send({"header" => CTSHeader::RESPONSE_PARTY, "type" => 1, "partyNo" => partyNo})
          dialog.dispose
        end
      end
    when STCHeader::CREATE_GUILD
      dialog = MUI_Dialog.new(Dialog::GUILD_CREATE, "길드 생성", "길드를 생성합니다.", ["수락", "거절"], ["길드 이름을 입력하세요."]) do
        if dialog.value == 0
          Socket.send({"header" => CTSHeader::CREATE_GUILD, "name" => dialog.textbox[0].text}) if dialog.textbox[0].text != ""
          dialog.dispose
        elsif dialog.value == 1
          dialog.dispose
        end
      end
    when STCHeader::SET_GUILD
      Game.player.guildNo = recv["no"]
      if Game.player.guildNo == 0
        Game.player.guild_member = []
        MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
      end
    when STCHeader::SET_GUILD_MEMBER
      member = Netplayer.new
      member.no = recv["no"]
      member.name = recv["name"]
      member.image = recv["image"]
      member.level = recv["level"]
      member.job = recv["job"]
      member.hp = recv["hp"]
      member.maxHp = recv["maxHp"]
      Game.player.guild_member.push(member)
      MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
    when STCHeader::REMOVE_GUILD_MEMBER
      for member in Game.player.guild_member
        if member.no == recv["no"]
          Game.player.guild_member.delete(member)
          break
        end
      end
      MUI.getForm(MUI_Community).refreshData if MUI.include?(MUI_Community)
    when STCHeader::INVITE_GUILD
      guildNo = recv["guildNo"]
      dialog = MUI_Dialog.new(Dialog::GUILD_INVITE, "길드 초대", recv["master"] + " 님의 길드에 가입하시겠습니까?", ["수락", "거절"]) do
        if dialog.value == 0
          Socket.send({"header" => CTSHeader::RESPONSE_GUILD, "type" => 0, "guildNo" => guildNo})
          dialog.dispose
        elsif dialog.value == 1
          Socket.send({"header" => CTSHeader::RESPONSE_GUILD, "type" => 1, "guildNo" => guildNo})
          dialog.dispose
        end
      end
    when STCHeader::SET_SLOT
      Game.slot.setSlot(recv["index"], recv["slot"])
      $scene.hud.slotRefresh(:icon_shortcut) if $scene.is_a?(Scene_Map)
    when STCHeader::SET_COOLTIME
      Game.cooltime.setCool(recv['index'], recv['nowCooltime'], recv['fullCooltime'])
    end
    #rescue
    #  p $!
    #end
  end
end