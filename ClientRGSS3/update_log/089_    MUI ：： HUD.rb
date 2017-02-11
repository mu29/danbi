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

  def initialize

    # 표시

    @visible = true

    # Rect

    @rect = {}

    # 이전 값

    @old = {}

    # 캐시

    @@cache = {}

    @@cache[:hud]       = RPG::Cache.hud(Config::FILE_HUD)

    @@cache[:gauge_hp]  = RPG::Cache.hud(Config::FILE_HP)

    @@cache[:gauge_mp]  = RPG::Cache.hud(Config::FILE_MP)

    @@cache[:gauge_exp] = RPG::Cache.hud(Config::FILE_EXP)

    @@cache[:menu] = []

    for n in 0..5

      @@cache[:menu][n] = RPG::Cache.hud("menu#{n}")

    end

    # 뷰포트

    @viewport = {}

    @viewport[:hud] = Viewport.new(0, 0, Graphics.getRect[0], Graphics.getRect[1])

    @viewport[:hp]  = Viewport.new(70, 553, @@cache[:gauge_hp].width, 14)

    @viewport[:mp]  = Viewport.new(70, 570, @@cache[:gauge_mp].width, 14)

    @viewport[:exp] = Viewport.new(0, 588, @@cache[:gauge_exp].width, 14)

    @viewport[:icon] = []

    @viewport[:cool] = []

    for n in 0...Config::SHORTCUT_RECT.size

      @viewport[:icon][n] = Viewport.new(Config::SHORTCUT_RECT[n])

      @viewport[:icon][n].z = 999

    end

    for n in 0...Config::COOLTIME_RECT.size

      @viewport[:cool][n] = Viewport.new(Config::COOLTIME_RECT[n])

      @viewport[:cool][n].z = 1000

    end

    @viewport[:hud].z = 999

    @viewport[:hp].z = 1001

    @viewport[:mp].z = 1001

    @viewport[:exp].z = 1001

    # 스프라이트 생성

    @sprite = {}

    @@cache.each_key do |key|

      # 아래 캐시 제외

      next if [:gauge_hp, :gauge_mp, :gauge_exp, :menu].include?(key)

      @sprite[key] = Sprite.new(@viewport[:hud])

      @sprite[key].bitmap = Bitmap.new(@@cache[key].width, @@cache[key].height)

      @sprite[key].bitmap.blt(0, 0, @@cache[key], Rect.new(0, 0, @@cache[key].width, @@cache[key].height))

    end

    # 레벨

    @sprite[:level] = Sprite.new(@viewport[:hud])

    @sprite[:level].bitmap = Bitmap.new(40, 16)

    @sprite[:level].bitmap.font.name = Config::FONT[1]

    @sprite[:level].bitmap.font.size = 14

    @sprite[:level].x = 12

    @sprite[:level].y = 560

    # HP

    @sprite[:hp] = Sprite.new(@viewport[:hp])

    @sprite[:hp].bitmap = Bitmap.new(@viewport[:hp].rect.width, @viewport[:hp].rect.height)

    @sprite[:hp].bitmap.font.name = Config::FONT[1]

    @sprite[:hp].bitmap.font.size = 12

    # MP

    @sprite[:mp] = Sprite.new(@viewport[:mp])

    @sprite[:mp].bitmap = Bitmap.new(@viewport[:mp].rect.width, @viewport[:mp].rect.height)

    @sprite[:mp].bitmap.font.name = Config::FONT[1]

    @sprite[:mp].bitmap.font.size = 12

    # EXP

    @sprite[:exp] = Sprite.new(@viewport[:exp])

    @sprite[:exp].bitmap = Bitmap.new(@viewport[:exp].rect.width, @viewport[:exp].rect.height)

    @sprite[:exp].bitmap.font.name = Config::FONT[1]

    @sprite[:exp].bitmap.font.size = 12

    # 메뉴

    @sprite[:menu] = []

    for n in 0...6

      @sprite[:menu][n] = Sprite.new(@viewport[:hud])

      @sprite[:menu][n].bitmap = Bitmap.new(@@cache[:menu][n].width, @@cache[:menu][n].height)

      @sprite[:menu][n].bitmap.blt(0, 0, @@cache[:menu][n], Rect.new(0, 0, @@cache[:menu][n].width, @@cache[:menu][n].height))

      @sprite[:menu][n].x = 560 + n * 40

      @sprite[:menu][n].y = 558

    end

    # 단축키

    @sprite[:icon] = []

    for n in 0...Config::SHORTCUT_RECT.size

      @sprite[:icon][n] = Sprite.new(@viewport[:icon][n])

      @sprite[:icon][n].bitmap = Bitmap.new(@viewport[:icon][n].rect.width, @viewport[:icon][n].rect.height)

      @sprite[:icon][n].bitmap.blt(0, 0, Bitmap.new("Graphics/Icons/black.png"), Rect.new(0, 0, 24, 24))

    end

    # 쿨타임

    @sprite[:cool] = []

    for n in 0...Config::COOLTIME_RECT.size

      @sprite[:cool][n] = Sprite.new(@viewport[:cool][n])

      @sprite[:cool][n].bitmap = Bitmap.new(@viewport[:cool][n].rect.width, @viewport[:cool][n].rect.height)

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

    textRefresh(:level, Game.player.level)

    textRefresh(:hp, Game.player.hp)

    textRefresh(:mp, Game.player.mp)

    textRefresh(:exp, Game.player.exp)

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

      @viewport[key][n] = Viewport.new(@rect[key][n])

      @viewport[key][n].rect.x += x

      @viewport[key][n].rect.y += y

      @viewport[key][n].z = 1000

      begin

        @sprite[key][n] = Sprite.new(@viewport[key][n])

        @sprite[key][n].bitmap = Bitmap.new(@rect[key][n].width, @rect[key][n].height)

        @sprite[key][n].bitmap.blt(0, 0, @@cache[key], @rect[key][n])

      rescue

        # border == 0

      end

    end

  end

  

  # 슬롯 리프레시

  def slotRefresh(key)

    @sprite[key] = []

    for n in 0...10

      next if Game.slot.getSlot(n) == -1

      @sprite[key][n] = Sprite.new(@viewport[key][n])

      @sprite[key][n].bitmap = Bitmap.new(@viewport[key][n].rect.width, @viewport[key][n].rect.height)

      @sprite[key][n].bitmap.blt(0, 0, RPG::Cache.icon(Game.getSkill(Game.slot.getSlot(n)).image), Rect.new(0, 0, 32, 32))

    end

  end

  

  # 쿨타임 리프레쉬

  def ctRefresh(key)

    for i in 0...10

      next if Game.slot.getSlot(i) == -1

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

    @old[key] ||= @viewport[key][1].rect.width

    if @old[key] != now

      delta = now * @sprite[key][1].bitmap.width / max.to_f - @old[key]

      barSlide(key, delta)

      @old[key] = @viewport[key][1].rect.width

    end

  end

  

  # 게이지바 슬라이딩

  def barSlide(key, delta)

    if delta != 0

      @viewport[key][1].rect.width += (delta / Config::BAR_SPEED).to_i

      @viewport[key][2].rect.x = @viewport[key][1].rect.x + @viewport[key][1].rect.width

    end

  end

  

  # 텍스트 리프레시

  def textRefresh(key, now)

    if @old[key] != now

      case key

      when :level

        @sprite[key].bitmap.clear

        @sprite[key].bitmap.draw_outline_text(

          0, 0, @sprite[key].bitmap.width, @sprite[key].bitmap.height,

          Game.player.level.to_s, Color.white, Color.new(255, 120, 0), 1)

      when :hp

        n, m = Game.player.hp, Game.player.maxHp

        @sprite[key].bitmap.clear

        @sprite[key].bitmap.draw_outline_text(

          0, 0, @viewport[key].rect.width, @viewport[key].rect.height,

          "#{n} / #{m}", Color.white, Color.red, 1)

      when :mp

        n, m = Game.player.mp, Game.player.maxMp

        @sprite[key].bitmap.clear

        @sprite[key].bitmap.draw_outline_text(

        0, 0, @viewport[key].rect.width, @viewport[key].rect.height,

        "#{n} / #{m}", Color.white, Color.new(0, 128, 224), 1)

      when :exp

        n, m = Game.player.exp, Game.player.maxExp

        @sprite[key].bitmap.clear

        @sprite[key].bitmap.draw_outline_text(

        0, 0, @viewport[key].rect.width, @viewport[key].rect.height,

        "#{n} / #{m} (#{n * 100 / m}%)", Color.white, Color.black(128), 1)

      end

      @old[key] = now

    end

  end

  

  # 메뉴 선택

  def menuSelected

    if (n = menuIndex)

      @sprite[:menu][n].opacity = 128 if @sprite[:menu][n].opacity != 128

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

        @sprite[:menu][n].opacity = 255 if @sprite[:menu][n].opacity != 255

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

      end

    end

  end

  

  # 메뉴 인덱스

  def menuIndex

    for n in 0..5

      sprite = @sprite[:menu][n]

      cache = @@cache[:menu][n]

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

      viewport = @viewport[:icon][n]

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