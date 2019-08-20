# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ System
# --------------------------------------------------------------------------
# Author    EnterBrain
# Modify    뮤 (mu29gl@gmail.com)
# Date      2015. 1. 7
#────────────────────────────────────────────────────────────────────────────
class System
  
  include Config
  
  attr_accessor :timer
  attr_accessor :timer_working
  attr_accessor :optKey
  
  def initialize
    @timer = 0
    @timer_working = false
    # 옵션 키
    @optKey = {}
    @optKey[:fullscreen] = self.fullscreen_load
    @optKey[:bgm]        = self.bgm_load
    @optKey[:bgs]        = self.bgs_load
    @optKey[:me]         = self.me_load
    @optKey[:se]         = self.se_load
  end

  def fullscreen_load
    File.iniGet(OPTION_PATH, OPTION_KEY, "fullscreen", false, 10)
  end
  
  def fullscreen_save(value)
    File.iniWrite(OPTION_PATH, OPTION_KEY, "fullscreen", value)
    @optKey[:fullscreen] = value
  end
  
  def bgm_load
    File.iniGet(OPTION_PATH, OPTION_KEY, "bgm", 100, 6)
  end
  
  def bgm_save(volume)
    File.iniWrite(OPTION_PATH, OPTION_KEY, "bgm", volume)
    @optKey[:bgm] = volume
    bgm_play(@playing_bgm)
  end
  
  def bgs_load
    File.iniGet(OPTION_PATH, OPTION_KEY, "bgs", 100, 6)
  end
  
  def bgs_save(volume)
    File.iniWrite(OPTION_PATH, OPTION_KEY, "bgs", volume)
    @optKey[:bgs] = volume
    bgs_play(@playing_bgs)
  end
  
  def me_load
    File.iniGet(OPTION_PATH, OPTION_KEY, "me", 100, 6)
  end
  
  def me_save(volume)
    File.iniWrite(OPTION_PATH, OPTION_KEY, "me", volume)
    @optKey[:me] = volume
  end
  
  def se_load
    File.iniGet(OPTION_PATH, OPTION_KEY, "se", 100, 6)
  end
  
  def se_save(volume)
    File.iniWrite(OPTION_PATH, OPTION_KEY, "se", volume)
    @optKey[:se] = volume
  end

  def bgm_play(bgm)
    @playing_bgm = bgm
    if bgm != nil and bgm.name != ""
      Audio.bgm_play("Audio/BGM/" + bgm.name, @optKey[:bgm], bgm.pitch)
    else
      Audio.bgm_stop
    end
    Graphics.frame_reset
  end

  def bgm_stop
    Audio.bgm_stop
  end

  def bgm_fade(time)
    @playing_bgm = nil
    Audio.bgm_fade(time * 1000)
  end

  def bgm_memorize
    @memorized_bgm = @playing_bgm
  end

  def bgm_restore
    bgm_play(@memorized_bgm)
  end

  def bgs_play(bgs)
    @playing_bgs = bgs
    if bgs != nil and bgs.name != ""
      Audio.bgs_play("Audio/BGS/" + bgs.name, @optKey[:bgs], bgs.pitch)
    else
      Audio.bgs_stop
    end
    Graphics.frame_reset
  end

  def bgs_fade(time)
    @playing_bgs = nil
    Audio.bgs_fade(time * 1000)
  end

  def bgs_memorize
    @memorized_bgs = @playing_bgs
  end

  def bgs_restore
    bgs_play(@memorized_bgs)
  end

  def me_play(me)
    if me != nil and me.name != ""
      Audio.me_play("Audio/ME/" + me.name, @optKey[:me], me.pitch)
    else
      Audio.me_stop
    end
    Graphics.frame_reset
  end

  def se_play(se)
    if se != nil and se.name != ""
      Audio.se_play("Audio/SE/" + se.name, @optKey[:se], se.pitch)
    end
  end

  def se_stop
    Audio.se_stop
  end

  def playing_bgm
    return @playing_bgm
  end

  def playing_bgs
    return @playing_bgs
  end

  def update
    if @timer_working and @timer > 0
      @timer -= 1
    end
  end
end