# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Option
# --------------------------------------------------------------------------
# Author    jubin
# Date      2016. 01. 11
# --------------------------------------------------------------------------
# Description
# 
#    게임의 환경설정을 도와주는 폼 클래스입니다.
#    옵션값은 Config::OPTION_PATH 경로에 저장됩니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Option < MUI::Form
  def initialize
    super('center', 'center', 250, 200)
    # 레이블
    @lbl = {}
    # BGM
    @lbl[:bgm] = MUI::Label.new(35, 24, 1, 1)
    @lbl[:bgm].text = "BGM"
    @lbl[:bgm].color = Color.gray
    addControl(@lbl[:bgm])
    @lbl[:bgm].autoSize
    # BGS
    @lbl[:bgs] = MUI::Label.new(35, 24+25, 1, 1)
    @lbl[:bgs].text = "BGS"
    @lbl[:bgs].color = Color.gray
    addControl(@lbl[:bgs])
    @lbl[:bgs].autoSize
    # ME
    @lbl[:me] = MUI::Label.new(35, 24+50, 1, 1)
    @lbl[:me].text = "ME"
    @lbl[:me].color = Color.gray
    addControl(@lbl[:me])
    @lbl[:me].autoSize
    # SE
    @lbl[:se] = MUI::Label.new(35, 24+75, 1, 1)
    @lbl[:se].text = "SE"
    @lbl[:se].color = Color.gray
    addControl(@lbl[:se])
    @lbl[:se].autoSize
    # 풀스크린
    @lbl[:fullscreen] = MUI::Label.new(35, 74+50, 1, 1)
    @lbl[:fullscreen].text = "풀스크린"
    @lbl[:fullscreen].color = Color.gray
    addControl(@lbl[:fullscreen])
    @lbl[:fullscreen].autoSize
    # on
    @lbl[:fullscreen_on] = MUI::Label.new(110, 75+50, 1, 1)
    @lbl[:fullscreen_on].text = "On"
    @lbl[:fullscreen_on].color = Color.gray
    addControl(@lbl[:fullscreen_on])
    @lbl[:fullscreen_on].autoSize
    # off
    @lbl[:fullscreen_off] = MUI::Label.new(170, 75+50, 1, 1)
    @lbl[:fullscreen_off].text = "Off"
    @lbl[:fullscreen_off].color = Color.gray
    addControl(@lbl[:fullscreen_off])
    @lbl[:fullscreen_off].autoSize
    
    # 수평 스크롤바
    @hs = {}
    # BGM
    @hs[:bgm] = MUI::HScroll.new(@lbl[:bgm].x + 55, @lbl[:bgm].y+1, 120, 13)
    @hs[:bgm].max, @hs[:bgm].min = 100, 0
    @hs[:bgm].value = Game.system.bgm_load
    addControl(@hs[:bgm])
    # BGS
    @hs[:bgs] = MUI::HScroll.new(@lbl[:bgs].x + 55, @lbl[:bgs].y+1, 120, 13)
    @hs[:bgs].max, @hs[:bgs].min = 100, 0
    @hs[:bgs].value = Game.system.bgs_load
    addControl(@hs[:bgs])
    # ME
    @hs[:me] = MUI::HScroll.new(@lbl[:me].x + 55, @lbl[:me].y+1, 120, 13)
    @hs[:me].max, @hs[:me].min = 100, 0
    @hs[:me].value = Game.system.me_load
    addControl(@hs[:me])
    # SE
    @hs[:se] = MUI::HScroll.new(@lbl[:se].x + 55, @lbl[:se].y+1, 120, 13)
    @hs[:se].max, @hs[:se].min = 100, 0
    @hs[:se].value = Game.system.se_load
    addControl(@hs[:se])
    
    # 라디오 박스
    @rb = {}
    # 풀스크린 on
    @rb[:fullscreen_on] = MUI::RadioBox.new(@lbl[:fullscreen].x + 55, @lbl[:fullscreen].y+1, 14, 14)
    addControl(@rb[:fullscreen_on])
    # 풀스크린 off
    @rb[:fullscreen_off] = MUI::RadioBox.new(@rb[:fullscreen_on].x + 60, @lbl[:fullscreen].y+1, 14, 14)
    addControl(@rb[:fullscreen_off])
    # 그룹화
    @rb[:fullscreen_off].group = @rb[:fullscreen_on].group = 'fullscreen'
    if Game.system.fullscreen_load
      @rb[:fullscreen_on].value = true
    else
      @rb[:fullscreen_off].value = true
    end
  end
  
  def refresh
    super
    setTitle("옵션")
  end
  
  def update
    super
    @hs[:bgm].toolTip = @hs[:bgm].value.to_i.to_s if @hs[:bgm].isSelected
    @hs[:bgs].toolTip = @hs[:bgs].value.to_i.to_s if @hs[:bgs].isSelected
    @hs[:me].toolTip = @hs[:me].value.to_i.to_s if @hs[:me].isSelected
    @hs[:se].toolTip = @hs[:se].value.to_i.to_s if @hs[:se].isSelected
    if @bgm != @hs[:bgm].value.to_i
      Game.system.bgm_save(@hs[:bgm].value.to_i)
      @bgm = @hs[:bgm].value.to_i
    end
    if @bgs != @hs[:bgs].value.to_i
      Game.system.bgs_save(@hs[:bgs].value.to_i)
      @bgs = @hs[:bgs].value.to_i
    end
    if @me != @hs[:me].value.to_i
      Game.system.me_save(@hs[:me].value.to_i)
      @me = @hs[:me].value.to_i
    end
    if @se != @hs[:se].value.to_i
      Game.system.se_save(@hs[:se].value.to_i)
      @se = @hs[:se].value.to_i
    end
    
    if @rb[:fullscreen_on].click && @rb[:fullscreen_on].value
      if not Graphics.isFullScreen
        b = Graphics.resize_screen2(Graphics.width, Graphics.height, true)
        Game.system.fullscreen_save(b)
        if b
          @rb[:fullscreen_on].value = true
        else
          @rb[:fullscreen_off].value = true
        end
      end
    elsif @rb[:fullscreen_off].click && @rb[:fullscreen_off].value
      if Graphics.isFullScreen
        b = Graphics.resize_screen2(Graphics.width, Graphics.height)
        Game.system.fullscreen_save(b)
        if b
          @rb[:fullscreen_on].value = true
        else
          @rb[:fullscreen_off].value = true
        end
      end
    end
  end
  
  def updateData
    
  end
end