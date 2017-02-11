class Timer < Sprite

  #--------------------------------------------------------------------------

  # ● 오브젝트 초기화

  #--------------------------------------------------------------------------

  def initialize

    super

    self.bitmap = Bitmap.new(88, 48)

    self.bitmap.font.name = "Arial"

    self.bitmap.font.size = 32

    self.x = 640 - self.bitmap.width

    self.y = 0

    self.z = 500

    update

  end

  #--------------------------------------------------------------------------

  # ● 해방

  #--------------------------------------------------------------------------

  def dispose

    if self.bitmap != nil

      self.bitmap.dispose

    end

    super

  end

  #--------------------------------------------------------------------------

  # ● 프레임 갱신

  #--------------------------------------------------------------------------

  def update

    super

    # 타이머 작동중이라면 가시로 설정

    self.visible = Game.system.timer_working

    # 타이머를 재묘화 할 필요가 있는 경우

    if Game.system.timer / Graphics.frame_rate != @total_sec

      # 윈도우 내용을 클리어

      self.bitmap.clear

      # 토탈초수를 계산

      @total_sec = Game.system.timer / Graphics.frame_rate

      # 타이머 표시용의 문자열을 작성

      min = @total_sec / 60

      sec = @total_sec % 60

      text = sprintf("%02d:%02d", min, sec)

      # 타이머를 묘화

      self.bitmap.font.color.set(255, 255, 255)

      self.bitmap.draw_text(self.bitmap.rect, text, 1)

    end

  end

end

