#────────────────────────────────────────────────────────────────────────────

# ▶ MUI_Dialog

# --------------------------------------------------------------------------

# Author    jubin

# Date      2014. 2. 12

# --------------------------------------------------------------------------

# Description

# 

#    대화상자를 띄우는 폼 클래스입니다.

#────────────────────────────────────────────────────────────────────────────



module Dialog

  SERVER = 0

  LOGIN = 1

  REGISTER = 2

  ITEM_AMOUNT = 3

  TRADE_REQUEST = 4

  PARTY_INVITE = 5

  GUILD_CREATE = 6

  GUILD_INVITE = 7

  RESOLUTION = 101

end



class MUI_Dialog < MUI::Form

  @@id = Array.new

  

  def initialize(id, title, text, button=nil, textbox=nil, &block)

    @id, @title, @text, @button, @textbox = id, title, text, button, textbox

    @@id.include?(@id) ? return : @@id.push(@id)

    # 프록

    @proc = Thread.new do

      loop do

        sleep 0.05

        if @value != nil

          block.call

          break

        end

      end

    end

    

    # 사이즈

    case @id

    when Dialog::LOGIN

      super('center', 'center', 300, 150)

    else

      super('center', 'center', 300, 150)

    end

    

    # Label

    @lbl = MUI::Label.new(0, 0, 1, 1)

    @lbl.text = @text.to_s

    @lbl.color = Color.gray

    addControl(@lbl)

    @lbl.x = 0

    @lbl.y = 10

    @lbl.autoSize

    @lbl.width = self.width

    line = @lbl.baseSprite.bitmap.get_divided_text(@lbl.width, @text).size

    @lbl.height = line * @lbl.size + 2

    @lbl.align = 1

    

    formHeight = getTitleViewport.rect.height + @lbl.y + @lbl.height

    

    # TextBox

    if !@textbox.nil? and @textbox.size > 0

      @tb = Array.new

      gap = @lbl.size * 1.4

      width = @width - gap * 5

      height = @lbl.size * 1.5

      x = (@width - width) / 2

      @textbox.each_index do |i|

        y = formHeight - height

        y += i * (gap + 4)

        @tb[i] = MUI::TextBox.new(x, y, width, height)

        addControl(@tb[i])

      end

      formHeight += (@textbox.size) * height + gap

    end

    

  # Button

    if !@button.nil? and @button.size > 0

      @btn = Array.new

      gap = @lbl.size * 1.4

      width = @width - (gap * 2 + (@button.size - 1) * gap)

      width /= @button.size

      height = @lbl.size * 2

      y = formHeight - height

      @button.each_index do |i|

        x = gap + i * (width + gap)

        @btn[i] = MUI::Button.new(x, y, width, height)

        @btn[i].text = @button[i].to_s

        addControl(@btn[i])

      end

      formHeight += height + gap

    end

    

    self.height = formHeight

  end



  def refresh

    super

    setTitle(@title, 0)

  end



  def update

    super

    @button.each_index do |i|

      if @btn[i].click

        @value = i

      end

    end

  end

  

  def value; @value end

  def button; @btn end

  def textbox; @tb end

  

  def dispose

    super

    @@id.delete(@id) if @@id.include?(@id)

    @proc.kill

  end

end