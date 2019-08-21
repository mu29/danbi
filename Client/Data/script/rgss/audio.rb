# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# * Audio, joe59491
#────────────────────────────────────────────────────────────────────────────

module Audio
  class << self
    alias :bgm_play_path :bgm_play if !$@
    alias :bgs_play_path :bgs_play if !$@
    alias :se_play_path :se_play if !$@
    alias :me_play_path :me_play if !$@
  end
  
  module_function
  
  def bgm_play(filename, volume=100, pitch=1)
    path = filename
    path = RPG::Path::RTP(path)
    bgm_play_path(path, volume.to_i, pitch)
  end
  
  def bgs_play(filename, volume=100, pitch=1)
    path = filename
    path = RPG::Path::RTP(path)
    bgs_play_path(path, volume.to_i, pitch)
  end
  
  def me_play(filename, volume=100, pitch=1)
    path = filename
    path = RPG::Path::RTP(path)
    me_play_path(path, volume.to_i, pitch)
  end
  
  def se_play(filename, volume=100, pitch=1)
    path = filename
    path = RPG::Path::RTP(path)
    se_play_path(path, volume.to_i, pitch)
  end
end