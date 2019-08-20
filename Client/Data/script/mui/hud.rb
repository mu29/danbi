# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_HUD
# --------------------------------------------------------------------------
# Author    jubin
# Date      2015. 2. 5
# --------------------------------------------------------------------------
# Description
# 
#    헤드 업 디스플레이를 표시합니다.
#    메뉴 클릭이 가능하며, 단축키를 등록할 수 있습니다.
#────────────────────────────────────────────────────────────────────────────
class MUI_HUD
  
  def loadCache
    @@cache = {}
    @@cache[:hud]       = RPG::Cache.hud(Config::FILE_HUD)
    @@cache[:gauge_hp]  = RPG::Cache.hud(Config::FILE_HP)
    @@cache[:gauge_mp]  = RPG::Cache.hud(Config::FILE_MP)
    @@cache[:gauge_exp] = RPG::Cache.hud(Config::FILE_EXP)
    @@cache[:menu_icon] = []
    for n in 0..5
      @@cache[:menu_icon][n] = RPG::Cache.hud("menu#{n}")
    end
  end
  
  def initialize
    # 표시
    @visible = true
    # Rect
    @rect = {}
    # 이전 값
    @old = {}
    # 캐시
    loadCache()
    # 뷰포트
    @viewport = {}
    @viewport[:hud] = Viewport.new(0, 0, Graphics.getRect[0], Graphics.getRect[1])
    @viewport[:hud].z = 999
    @viewport[:icon_shortcut] = []
    for n in 0...Config::COOLTIME_RECT.size
      @viewport[:icon_shortcut][n] = Viewport.new(Config::COOLTIME_RECT[n])
      @viewport[:icon_shortcut][n].z = 1000
    end
    # 스프라이트 생성
    @sprite = {}
    @@cache.each_key do |key|
      # 아래 캐시 제외
      next if [:gauge_hp, :gauge_mp, :gauge_exp, :menu_icon].include?(key)
      @sprite[key] = Sprite.new(@viewport[:hud])
      @sprite[key].bitmap = Bitmap.new(@@cache[key].width, @@cache[key].height)
      @sprite[key].bitmap.blt(0, 0, @@cache[key], Rect.new(0, 0, @@cache[key].width, @@cache[key].height))
    end
    # 레벨
    @sprite[:txt_lv] = Sprite.new(@viewport[:hud])
    @sprite[:txt_lv].bitmap = Bitmap.new(40, 16)
    @sprite[:txt_lv].bitmap.font.name = Config::FONT[1]
    @sprite[:txt_lv].bitmap.font.size = 14
    @sprite[:txt_lv].x = Config::LV_TEXT_X
    @sprite[:txt_lv].y = Config::LV_TEXT_Y
    @sprite[:txt_lv].z = 1
    # HP
    @sprite[:txt_hp] = Sprite.new(@viewport[:hud])
    @sprite[:txt_hp].bitmap = Bitmap.new(@@cache[:gauge_hp].width, 14)
    @sprite[:txt_hp].bitmap.font.name = Config::FONT[1]
    @sprite[:txt_hp].bitmap.font.size = 12
    @sprite[:txt_hp].x = Config::HP_TEXT_X
    @sprite[:txt_hp].y = Config::HP_TEXT_Y
    @sprite[:txt_hp].z = 1
    # MP
    @sprite[:txt_mp] = Sprite.new(@viewport[:hud])
    @sprite[:txt_mp].bitmap = Bitmap.new(@@cache[:gauge_mp].width, 14)
    @sprite[:txt_mp].bitmap.font.name = Config::FONT[1]
    @sprite[:txt_mp].bitmap.font.size = 12
    @sprite[:txt_mp].x = Config::MP_TEXT_X
    @sprite[:txt_mp].y = Config::MP_TEXT_Y
    @sprite[:txt_mp].z = 1
    # EXP
    @sprite[:txt_exp] = Sprite.new(@viewport[:hud])
    @sprite[:txt_exp].bitmap = Bitmap.new(@@cache[:gauge_exp].width, 14)
    @sprite[:txt_exp].bitmap.font.name = Config::FONT[1]
    @sprite[:txt_exp].bitmap.font.size = 12
    @sprite[:txt_exp].x = Config::EXP_TEXT_X
    @sprite[:txt_exp].y = Config::EXP_TEXT_Y
    @sprite[:txt_exp].z = 1
    # 메뉴
    @sprite[:menu_icon] = []
    for n in 0...6
      @sprite[:menu_icon][n] = Sprite.new(@viewport[:hud])
      @sprite[:menu_icon][n].bitmap = Bitmap.new(@@cache[:menu_icon][n].width, @@cache[:menu_icon][n].height)
      @sprite[:menu_icon][n].bitmap.blt(0, 0, @@cache[:menu_icon][n], Rect.new(0, 0, @@cache[:menu_icon][n].width, @@cache[:menu_icon][n].height))
      @sprite[:menu_icon][n].x = Config::MENU_ICON_X + n * Config::MENU_ICON_GAP
      @sprite[:menu_icon][n].y = Config::MENU_ICON_Y
    end
    # 단축키
    @sprite[:icon_shortcut] = []
    for n in 0...Config::SHORTCUT_RECT.size
      @sprite[:icon_shortcut][n] = Sprite.new(@viewport[:icon_shortcut][n])
    end
    # 쿨타임
    @sprite[:cool] = []
    for n in 0...Config::COOLTIME_RECT.size
      width, height = Config::COOLTIME_RECT[n].width, Config::COOLTIME_RECT[n].height
      @sprite[:cool][n] = Sprite.new(@viewport[:icon_shortcut][n])
      @sprite[:cool][n].bitmap = Bitmap.new(width, height)
      @sprite[:cool][n].zoom_y = 0
      @sprite[:cool][n].bitmap.fill_rect(0,0,32,33, Color.new(150,150,150,100)) 
    end
    # 게이지바
    barDraw(:gauge_hp, Config::HP_X, Config::HP_Y, Config::HP_BORDER)
    barDraw(:gauge_mp, Config::MP_X, Config::MP_Y, Config::MP_BORDER)
    barDraw(:gauge_exp, Config::EXP_X, Config::EXP_Y, Config::EXP_BORDER)
    barRefresh(:gauge_hp, Game.player.hp, Game.player.maxHp)
    barRefresh(:gauge_mp, Game.player.mp, Game.player.maxMp)
    barRefresh(:gauge_exp, Game.player.exp, Game.player.maxExp)
  end
  
  # 메인 업데이트
  def update
    return if not @visible # 숨김 상태에서는 중단
    barRefresh(:gauge_hp, Game.player.hp, Game.player.maxHp)
    barRefresh(:gauge_mp, Game.player.mp, Game.player.maxMp)
    barRefresh(:gauge_exp, Game.player.exp, Game.player.maxExp)
    textRefresh(:txt_lv, Game.player.level)
    textRefresh(:txt_hp, Game.player.hp)
    textRefresh(:txt_mp, Game.player.mp)
    textRefresh(:txt_exp, Game.player.exp)
    ctRefresh(:cool)
    menuSelected
    iconSelected
    keyUpdate
  end
  
  # 슬롯 작동
  def keyUpdate
    return if MUI.nowTyping?
    for i in 0...10
      next if Game.slot.getSlot(i) == -1
      if Key.trigger?(Game.slot.getKey(i))
        Socket.send({'header' => CTSHeader::USE_SKILL, 'no' => Game.getSkill(Game.slot.getSlot(i)).no})
      end
    end
  end
  
  # 게이지바 생성
  def barDraw(key, x, y, border)
    @rect[key] = []
    @viewport[key] = []
    @sprite[key] = []
    # left
    @rect[key][0] = Rect.new(0, 0, border[0], @@cache[key].height)
    # center
    @rect[key][1] = Rect.new(border[0], 0, @@cache[key].width - border[0] - border[1], @@cache[key].height)
    # right
    @rect[key][2] = Rect.new(@@cache[key].width - border[1], 0, border[1], @@cache[key].height)
    3.times do |n|
      begin
        @sprite[key][n] = Sprite.new(@viewport[:hud])
        @sprite[key][n].bitmap = Bitmap.new(@rect[key][n].width, @rect[key][n].height)
        @sprite[key][n].bitmap.blt(0, 0, @@cache[key], @rect[key][n])
        @sprite[key][n].x = x
        @sprite[key][n].y = y
      rescue
        # border == 0
      end
    end
    @sprite[key][1].x = x + @rect[key][0].width
    @sprite[key][2].x = x + @sprite[key][1].src_rect.width + @rect[key][0].width
  end
  
  # 슬롯 리프레시
  def slotRefresh(key)
    @sprite[key] ||= []
    for n in 0...10
      @sprite[key][n] ||= Sprite.new(@viewport[key][n])
      if Game.slot.getSlot(n) == -1
        @viewport[:icon_shortcut][n].visible = false
        next
      else
        @viewport[:icon_shortcut][n].visible = true
      end
      @sprite[key][n].bitmap = RPG::Cache.icon(Game.getSkill(Game.slot.getSlot(n)).image)
      #@sprite[key][n].bitmap = Bitmap.new(@viewport[key][n].rect.width, @viewport[key][n].rect.height)
      #@sprite[key][n].bitmap.blt(0, 0, RPG::Cache.icon(Game.getSkill(Game.slot.getSlot(n)).image), Rect.new(0, 0, 32, 32))
    end
  end
  
  # 쿨타임 리프레쉬
  def ctRefresh(key)
    for i in 0...10
      if Game.slot.getSlot(i) == -1
        @viewport[:icon_shortcut][i].visible = false
        next
      else
        @viewport[:icon_shortcut][i].visible = true
      end
      skill = Game.getSkill(Game.slot.getSlot(i))
      cooltime = Game.cooltime.getCool(i)
      if cooltime.nowCooltime.to_f <= 0
        @sprite[key][i].zoom_y = 0
      else
        @sprite[key][i].zoom_y = cooltime.nowCooltime.to_f / cooltime.fullCooltime.to_f
        @sprite[key][i].y = 26 - 25 * cooltime.nowCooltime.to_f / cooltime.fullCooltime.to_f
      end
    end
  end

  # 게이지바 리프레시
  def barRefresh(key, now, max)
    @old[key] ||= @sprite[key][1].src_rect.width
    if @old[key] != now
      delta = now * @sprite[key][1].bitmap.width / max.to_f - @old[key]
      barSlide(key, delta)
      @old[key] = @sprite[key][1].src_rect.width
    end
  end
  
  # 게이지바 슬라이딩
  def barSlide(key, delta)
    if delta != 0
      @sprite[key][1].src_rect.width += (delta / Config::BAR_SPEED).to_i
      if @sprite[key][1].src_rect.width > @sprite[key][1].bitmap.width
        @sprite[key][1].src_rect.width = @sprite[key][1].bitmap.width
      end
      if @sprite[key][1].src_rect.width < 0
        @sprite[key][1].src_rect.width = 0
      end
      @sprite[key][2].x = @sprite[key][1].x + @sprite[key][1].src_rect.width
    end
  end
  
  # 텍스트 리프레시
  def textRefresh(key, now)
    if @old[key] != now
      case key
      when :txt_lv
        @sprite[key].bitmap.clear
        @sprite[key].bitmap.draw_outline_text(
          0, 0, @sprite[key].bitmap.width, @sprite[key].bitmap.height,
          Game.player.level.to_s, Color.white, Color.new(255, 120, 0), 1)
      when :txt_hp
        n, m = Game.player.hp, Game.player.maxHp
        @sprite[key].bitmap.clear
        @sprite[key].bitmap.draw_outline_text(
          0, 0, @sprite[key].bitmap.width, @sprite[key].bitmap.height,
          "#{n} / #{m}", Color.white, Color.red, 1)
      when :txt_mp
        n, m = Game.player.mp, Game.player.maxMp
        @sprite[key].bitmap.clear
        @sprite[key].bitmap.draw_outline_text(
        0, 0, @sprite[key].bitmap.width, @sprite[key].bitmap.height,
        "#{n} / #{m}", Color.white, Color.new(0, 128, 224), 1)
      when :txt_exp
        n, m = Game.player.exp, Game.player.maxExp
        @sprite[key].bitmap.clear
        @sprite[key].bitmap.draw_outline_text(
        0, 0, @sprite[key].bitmap.width, @sprite[key].bitmap.height,
        "#{n} / #{m} (#{n * 100 / m}%)", Color.white, Color.black(128), 1)
      end
      @old[key] = now
    end
  end
  
  # 메뉴 선택
  def menuSelected
    if (n = menuIndex)
      @sprite[:menu_icon][n].opacity = 128 if @sprite[:menu_icon][n].opacity != 128
      if Mouse.trigger?
        case n
        when 0
          MUI.include?(MUI_Status)    ? MUI.getForm(MUI_Status).dispose    : MUI_Status.new
        when 1
          MUI.include?(MUI_Skill)     ? MUI.getForm(MUI_Skill).dispose     : MUI_Skill.new
        when 2
          MUI.include?(MUI_Inventory) ? MUI.getForm(MUI_Inventory).dispose : MUI_Inventory.new
        when 3
          MUI.include?(MUI_Quest)     ? MUI.getForm(MUI_Quest).dispose     : MUI_Quest.new
        when 4
          MUI.include?(MUI_Community) ? MUI.getForm(MUI_Community).dispose      : MUI_Community.new
        when 5
          MUI.include?(MUI_Option)    ? MUI.getForm(MUI_Option).dispose    : MUI_Option.new
        end
      end
    else
      for n in 0..5
        @sprite[:menu_icon][n].opacity = 255 if @sprite[:menu_icon][n].opacity != 255
      end
    end
  end
  
  # 단축키 선택
  def iconSelected
    if (n = iconIndex)
      # Info
      if Mouse.trigger?(0) && MUI.dragItem
        # 단축키 등록
        if MUI.dragItem.is_a?(Skill)
          Socket.send({'header' => CTSHeader::SET_SLOT, 'index' => iconIndex, 'itemidx' => Game.getSkill(MUI.dragItem.no).no})
        else
          Socket.send({'header' => CTSHeader::SET_SLOT, 'index' => iconIndex, 'itemidx' => MUI.dragItem.index})
        end
        MUI.dragItem = nil
      elsif Mouse.trigger?(1)
        Socket.send({'header' => CTSHeader::DEL_SLOT, 'index' => iconIndex})
        slotRefresh(:icon_shortcut)
      end
    end
  end
  
  # 메뉴 인덱스
  def menuIndex
    for n in 0..5
      sprite = @sprite[:menu_icon][n]
      cache = @@cache[:menu_icon][n]
      if Mouse.x >= sprite.x and Mouse.x <= sprite.x + cache.width and
        Mouse.y >= sprite.y and Mouse.y <= sprite.y + cache.height
        select = n
      end
    end
    return select
  end
  
  # 단축키 인덱스
  def iconIndex
    for n in 0...Config::SHORTCUT_RECT.size
      viewport = @viewport[:icon_shortcut][n]
      if Mouse.x >= viewport.rect.x and Mouse.x <= viewport.rect.x + viewport.rect.width and
        Mouse.y >= viewport.rect.y and Mouse.y <= viewport.rect.y + viewport.rect.height
        select = n
      end
    end
    return select
  end
  
  # 표시
  def visible; @visible end
  def visible=(value)
    return unless value.is_a?(TrueClass) or value.is_a?(FalseClass)
    # 뷰포트
    @viewport.each_key do |key|
      if @viewport[key].is_a?(Array)
        @viewport[key].each_index { |n| @viewport[key][n].visible = value }
      else
        @viewport[key].visible = value
      end
    end
    # 스프라이트
    @sprite.each_key do |key|
      if @sprite[key].is_a?(Array)
        @sprite[key].each_index { |n| @sprite[key][n].visible = value }
      else
        @sprite[key].visible = value
      end
    end
    @visible = value
  end
end