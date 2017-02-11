#────────────────────────────────────────────────────────────────────────────

# ▶ MUI_Message

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2015. 1. 25

# --------------------------------------------------------------------------

# Description

#

#    NPC 와의 대화상자를 띄우는 폼 클래스입니다. 

#────────────────────────────────────────────────────────────────────────────



class MUI_Message < MUI::Form

  def initialize(no)

    super(48, 350, Graphics.getRect[0] - 200, 200)

    self.style = "Black"

    self.opacity /= 1.1

    @msg = File.open("./GameData/npc/" + "#{no}.txt").readlines

    for i in 0...@msg.size

      msg = @msg[i].to_u

      @msg[i] = msg

    end

    # 드래그, 닫기 비허용

    @drag = @close = false

    @lbl_text = MUI::Label.new(24, 24, 50, 50)

    @lbl_text.text = ""

    @lbl_text.size = 20

    @lbl_text.color = Color.white

    addControl(@lbl_text)

    @btn = MUI::Button.new(24, 120, 96, 32)

    @btn.style = "Black"

    @btn.text = "닫기"

    addControl(@btn)

    @lbl_selects = []

    drawFace

  end

  

  def set(line, selects)

    text = ""

    for i in 1...5

      text += @msg[line + i]

    end

    for label in @lbl_selects

      label.dispose

    end

    @btn.visible = true

    case selects

    when -1

      @btn.text = "닫기"

    when 0

      @btn.text = "다음"

    else

      for i in 0...selects

        @lbl_selects[i] = MUI::Label.new(24, 24, 50, 50)

        @lbl_selects[i].text = @msg[line + 4 - i].gsub("\n", "")

        @lbl_selects[i].size = 20

        @lbl_selects[i].color = Color.yellow

        addControl(@lbl_selects[i])

        @lbl_selects[i].y = 120 - i * 20

        @lbl_selects[i].autoSize

      end

      text = ""

      for i in 1...(5 - selects)

        text += @msg[line + i]

      end

      @btn.visible = false

    end

    @lbl_text.text = text

    @lbl_text.autoSize

    setTitle(@msg[line], 0)

  end

  

  def refresh

    super

    setTitle("대화", 0)

  end

  

  def drawFace

    @bitmap = Bitmap.new("Graphics/Pictures/togi.png")

    @sprite = Sprite.new

    @sprite.z = 999999

    @sprite.x = Graphics.getRect[0] - @bitmap.width

    @sprite.y = Graphics.getRect[1] - @bitmap.height

    @sprite.bitmap = @bitmap

  end

  

  def update

    super

    if Mouse.trigger?

      if @btn.click

        Socket.send({'header' => CTSHeader::SELECT_MESSAGE, 'select' => 0})

      end

      for i in 0...@lbl_selects.size

        if @lbl_selects[i].click

          Socket.send({'header' => CTSHeader::SELECT_MESSAGE, 'select' => i})

        end

      end

    end

    for select in @lbl_selects

      select.color = select.isSelected ? Color.red : Color.yellow

    end

  end

end