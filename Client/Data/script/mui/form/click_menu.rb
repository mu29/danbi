# encoding: utf-8
# filename mui/form/click_menu.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_ClickMenu
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 2. 15
# --------------------------------------------------------------------------
# Description
# 
#    다른 유저에게 신청이나 정보를 얻을 수 있는 폼 클래스입니다.
#    오른쪽 마우스를 누르면 표시됩니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_ClickMenu < MUI::Form
  def initialize(userNo)
    super(Mouse.x, Mouse.y, 100, 230)
    @user = Game.map.getNetplayer(userNo)
    # 정보 보기
    @btn_info = MUI::Button.new(10, 10, 80, 20)
    @btn_info.text = "정보 보기"
    addControl(@btn_info)
    # 파티 초대
    @btn_party = MUI::Button.new(10, 40, 80, 20)
    @btn_party.text = "파티 초대"
    addControl(@btn_party)
    # 길드 초대
    @btn_guild = MUI::Button.new(10, 70, 80, 20)
    @btn_guild.text = "길드 초대"
    addControl(@btn_guild)
    # 친구 추가
    @btn_friend = MUI::Button.new(10, 100, 80, 20)
    @btn_friend.text = "친구 추가"
    addControl(@btn_friend)
    # 거래
    @btn_trade = MUI::Button.new(10, 130, 80, 20)
    @btn_trade.text = "거래 요청"
    addControl(@btn_trade)
    # 귓속말
    @btn_whisper = MUI::Button.new(10, 160, 80, 20)
    @btn_whisper.text = "귓속말"
    addControl(@btn_whisper)
  end
  
  def refresh
    super
    setTitle("메뉴")
  end
  
  def update
    super
    if @btn_info.click
    elsif @btn_party.click
      if Game.player.partyNo > 0
        Socket.send({'header' => CTSHeader::INVITE_PARTY, "other" => @user.no})
        dispose
      end
    elsif @btn_guild.click
      if Game.player.guildNo > 0
        Socket.send({'header' => CTSHeader::INVITE_GUILD, "other" => @user.no})
        dispose
      end
    elsif @btn_friend.click
    elsif @btn_trade.click
      Socket.send({'header' => CTSHeader::REQUEST_TRADE, "partner" => @user.no})
      dispose
    elsif @btn_whisper.click
      MUI::ChatBox.muiFrm.textNickName = @user.name
      MUI::Console.write("귓속말 상대의 닉네임이 `" + @user.name + "`로 설정됐습니다.")
      dispose
    end
  end
end