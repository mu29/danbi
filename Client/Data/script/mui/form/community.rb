# encoding: utf-8
# filename mui/form/community.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Community
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 2. 17
# --------------------------------------------------------------------------
# Description
# 
#    유저에게 등록되어 있는 다른 유저들을 관리하는 폼입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Community < MUI::Form
  def initialize
    @btn = {}
    super('center', 'center', 214, 287)
    # 탭페이지
    @tab = MUI::TabPage.new(2, 0, @width - 4, 32)
    @tab.item = ["파티", "길드", "친구"]
    addControl(@tab)
    # 유저 리스트
    @pic_user_list = []
    @pic_user_image = []
    @lbl_user_info = []
    @btn_user_delete = []
    for i in 0...4
      @pic_user_list[i] = MUI::PictureBox.new(7, 39 + 46 * i, 200, 40)
      @pic_user_list[i].picture = "Graphics/MUI/Community/" + "item_win.png"
      @pic_user_list[i].visible = false
      addControl(@pic_user_list[i])
      @pic_user_image[i] = MUI::PictureBox.new(11, 43 + 46 * i, 32, 32)
      addControl(@pic_user_image[i])
      @lbl_user_info[i] = MUI::Label.new(46, 43 + 46 * i, 162, 14)
      addControl(@lbl_user_info[i])
      @btn_user_delete[i] = MUI::Button.new(171, 42 + 46 * i, 34, 34)
      @btn_user_delete[i].text = "X"
      @btn_user_delete[i].visible = false
      addControl(@btn_user_delete[i])
    end
    ## 페이지
    @page = 0
    # 파티
    @btn_party_create = MUI::Button.new(8, 222, 50, 24)
    @btn_party_create.text = "생성"
    @tab.tab[0].addControl(@btn_party_create)
    @btn_party_quit = MUI::Button.new(156, 222, 50, 24)
    @btn_party_quit.text = "탈퇴"
    @tab.tab[0].addControl(@btn_party_quit)
    # 길드
    @lbl_guild_page = MUI::Label.new(0, 226, @width, 14)
    @lbl_guild_page.align = 1
    @tab.tab[1].addControl(@lbl_guild_page)
    @btn_guild_page_left = MUI::Button.new(8, 222, 24, 24)
    @btn_guild_page_left.text = "◀"
    @tab.tab[1].addControl(@btn_guild_page_left)
    @btn_guild_page_right = MUI::Button.new(182, 222, 24, 24)
    @btn_guild_page_right.text = "▶"
    @tab.tab[1].addControl(@btn_guild_page_right)
    # 친구
    @lbl_friend_page = MUI::Label.new(0, 226, @width, 14)
    @lbl_friend_page.align = 1
    @tab.tab[2].addControl(@lbl_friend_page)
    @btn_friend_page_left = MUI::Button.new(8, 222, 24, 24)
    @btn_friend_page_left.text = "◀"
    @tab.tab[2].addControl(@btn_friend_page_left)
    @btn_friend_page_right = MUI::Button.new(182, 222, 24, 24)
    @btn_friend_page_right.text = "▶"
    @tab.tab[2].addControl(@btn_friend_page_right)
    @tab.set
    refreshData
  end
  
  def refreshData
    case @tab.page
    when 0
      @user_list = Game.player.party_member
    when 1
      @user_list = Game.player.guild_member
      @lbl_guild_page.text = (@page + 1).to_s + " / " +((@user_list.size - 1) / 4 + 1).to_s
    when 2
      @user_list = Game.player.friend
      @lbl_friend_page.text = (@page + 1).to_s + " / " +((@user_list.size - 1) / 4 + 1).to_s
    end
    for i in (@page * 4)...(@page * 4 + 4)
      user = @user_list[i]
      index = i - @page * 4
      @pic_user_list[index].visible = false
      @pic_user_image[index].clear
      @lbl_user_info[index].text = ""
      @btn_user_delete[index].visible = false
      next if not user
      @pic_user_list[index].visible = true
      bitmap = Bitmap.new(32, 32)
      bitmap.blt(0, 0, RPG::Cache.load_bitmap("Graphics/Characters/", user.image), Rect.new(0, 0, 32, 32))
      @pic_user_image[index].picture = bitmap
      @lbl_user_info[index].text = user.name + "(Lv. " + user.level.to_s + " " + Game.getJob(user.job) + ")"
      @btn_user_delete[index].visible = true
    end
  end
  
  def refresh
    super
    setTitle("커뮤니티")
  end
  
  def update
    super
    #if @btn['friend_add'].click
    #  @lst.removeItem 0
      #@lst.clear
    #end
    if Mouse.trigger?
      if @tab.isSelected
        @page = 0
        refreshData
      end
      case @tab.page
      when 0
        if @btn_party_create.click
          Socket.send({'header' => CTSHeader::CREATE_PARTY}) if Game.player.partyNo == 0
        elsif @btn_party_quit.click
          Socket.send({'header' => (Game.player.partyNo == Game.player.no ? 
            CTSHeader::BREAK_UP_PARTY : CTSHeader::QUIT_PARTY)}) if Game.player.partyNo > 0
        end
        for i in (@page * 4)...(@page * 4 + 4)
          user = @user_list[i]
          index = i - @page * 4
          next if not user
          if @btn_user_delete[index].click && Game.player.partyNo == Game.player.no
            Socket.send({'header' => CTSHeader::KICK_PARTY, 'member' => user.no})
          end
        end
      when 1
        if @btn_guild_page_left.click
          if @page > 0
            @page -= 1
            refreshData
          end
        elsif @btn_guild_page_right.click
          if (@user_list.size - 1) / 4 > @page
            @page += 1 
            refreshData
          end
        end
        for i in (@page * 4)...(@page * 4 + 4)
          user = @user_list[i]
          index = i - @page * 4
          next if not user
          if @btn_user_delete[index].click
            if Game.player.no == Game.player.guildNo
              Socket.send({'header' => CTSHeader::KICK_GUILD, 'member' => user.no})
            elsif Game.player.no == user.no
              Socket.send({'header' => CTSHeader::QUIT_GUILD})
            end
          end
        end
      when 2
        if @btn_friend_page_left.click
          if @page > 0
            @page -= 1
            refreshData
          end
        elsif @btn_friend_page_right.click
          if (@user_list.size - 1) / 4 > @page
            @page += 1 
            refreshData
          end
        end
      end
    end
  end
end