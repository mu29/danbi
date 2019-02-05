# filename chatting_balloon.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ ChattingBalloon
# --------------------------------------------------------------------------
# Author    jubin-park
# Date      2017. 7. 31
# --------------------------------------------------------------------------
# Description
# 
#    말풍선을 띄우는 클래스입니다.
#
#    @chatb = ChattingBalloon.new([viewport[, font]])
#    @chatb.talk("할 말")
#
#────────────────────────────────────────────────────────────────────────────

class ChattingBalloon
  
  # 말풍선 최대 너비
  MAX_WIDTH = 171
  # 말풍선 최대 줄 수
  MAX_LINE = 2
  # 말풍선 최대 투명도 (0~255)
  MAX_OPACITY = 192
  
  # 말풍선 텍스트 최대 너비
  MAX_TEXT_WIDTH = MAX_WIDTH - 16
  # 말풍선 텍스트 x, y, z
  TX = 8;  TY = 5;  TZ = 1
  
  def initialize(viewport = nil, fnt = nil)
    @src = RPG::Cache.picture("balloon-2.png")
    create_parts(@src)
    @fnt = fnt
    # 기본 폰트 설정
    if @fnt.nil?
      @fnt = Font.new
      @fnt.outline = false
      @fnt.name = Config::FONT[0]
      @fnt.size = Config::FONT_NORMAL_SIZE
      @fnt.color = Color.black
      @fnt.bold = false
      @fnt.italic = false
    end
    @balloonSprite = Sprite.new(viewport)
    @textSprite = Sprite.new(viewport)
    self.x = 0
    self.y = 0
    self.z = 1
    @balloonSprite.opacity = MAX_OPACITY
  end
  
  def talk(text)
    return if text == ""
    return if text.nil?
    if (@baseBitmap.is_a?(Bitmap) && !@baseBitmap.disposed?)
      @baseBitmap.dispose
      @baseBitmap = nil
    end
    if (@textBitmap.is_a?(Bitmap) && !@textBitmap.disposed?)
      @textBitmap.dispose
      @textBitmap = nil
    end
    new_arr_text = get_new_str(text, @fnt)
    @str_height = @line * @fnt.size
    draw_balloon(new_arr_text)
    @balloonSprite.bitmap = @baseBitmap
    @textSprite.bitmap = @textBitmap
  end
    
  def width
    return 0 if @baseBitmap.nil?
    return @baseBitmap.width
  end
  
  def height
    return 0 if @baseBitmap.nil?
    return @baseBitmap.height
  end
  
  def opacity
    @textSprite.opacity
  end
  
  def opacity=(v)
    @balloonSprite.opacity = v >= MAX_OPACITY ? MAX_OPACITY : v
    @textSprite.opacity = v
  end
  
  def x=(v)
    @balloonSprite.x = v
    @textSprite.x = v + TX
  end
  
  def y=(v)
    @balloonSprite.y = v
    @textSprite.y = v + TY
  end
  
  def ox=(v)
    @balloonSprite.ox = v
    @textSprite.ox = v
  end
  
  def oy=(v)
    @balloonSprite.oy = v
    @textSprite.oy = v
  end
  
  def z=(v)
    @balloonSprite.z = v
    @textSprite.z = v + TZ
  end
  
  def visible
    @balloonSprite.visible && @textSprite.visible
  end
  
  def visible=(v)
    @balloonSprite.visible = v
    @textSprite.visible = v
  end
  
  def dispose
    @baseBitmap.dispose if @baseBitmap.is_a?(Bitmap) && !@baseBitmap.disposed?
    @textBitmap.dispose if @textBitmap.is_a?(Bitmap) && !@textBitmap.disposed?
    @balloonSprite.dispose if @balloonSprite.is_a?(Sprite) && !@balloonSprite.disposed?
    @textSprite.dispose if @textSprite.is_a?(Sprite) && !@textSprite.disposed?
    @baseBitmap = nil
    @textBitmap = nil
    @balloonSprite = nil
    @textSprite = nil
  end
    
  protected
  
  def draw_balloon(arr_str)
    bitmap_w = @line > 1 ? MAX_WIDTH : @w + @rect[:UL].width + @rect[:UR].width + TX
    bitmap_tw = @line > 1 ? MAX_TEXT_WIDTH : @w
    # 말풍선 그리기
    @baseBitmap = Bitmap.new(bitmap_w, @line * (@fnt.size + 1) + @rect[:UL].height + @rect[:DL].height + @rect[:ARROW].height)
    w = @baseBitmap.width
    h = @baseBitmap.height - @rect[:ARROW].height + 2
    @baseBitmap.blt(0, 0, @bmp[:UL], @rect[:UL].src_rect)
    @baseBitmap.stretch_blt(Rect.new(@bmp[:UL].width, 0, w - (@bmp[:UR].width + @bmp[:UL].width), @bmp[:UM].height), @bmp[:UM], @rect[:UM].src_rect)
    @baseBitmap.blt(w - @bmp[:UR].width, 0, @bmp[:UR], @rect[:UR].src_rect)
    @baseBitmap.stretch_blt(Rect.new(0, @bmp[:UL].height, @bmp[:ML].width, h - (@bmp[:UL].height + @bmp[:DL].height)), @bmp[:ML], @rect[:ML].src_rect)
    @baseBitmap.stretch_blt(Rect.new(@bmp[:ML].width, @bmp[:UL].height, w - (@bmp[:ML].width + @bmp[:MR].width), h - (@bmp[:UM].height + @bmp[:DM].height)), @bmp[:MM], @rect[:MM].src_rect)
    @baseBitmap.stretch_blt(Rect.new(w - @bmp[:MR].width, @bmp[:UR].height, @bmp[:MR].width, h - (@bmp[:UR].height + @bmp[:DR].height)), @bmp[:MR], @rect[:MR].src_rect)
    @baseBitmap.blt(0, h - @bmp[:DL].height, @bmp[:DL], @rect[:DL].src_rect)
    @baseBitmap.stretch_blt(Rect.new(@bmp[:DL].width, h - @bmp[:DM].height, w - (@bmp[:DR].width + @bmp[:DL].width), @bmp[:DM].height), @bmp[:DM], @rect[:DM].src_rect)
    @baseBitmap.blt(w - @bmp[:DR].width, h - @bmp[:DR].height, @bmp[:DR], @rect[:DR].src_rect)
    x = w - @rect[:ARROW].width
    x /= 2
    y = h - 2
    @baseBitmap.fill_rect(x, y, @rect[:ARROW].width, @rect[:ARROW].height, Color.new(0, 0, 0, 0))
    @baseBitmap.blt(x, y, @bmp[:ARROW], @rect[:ARROW].src_rect)
    # 텍스트 그리기
    @textBitmap = Bitmap.new(bitmap_tw, @line * @fnt.size)
    @textBitmap.font = @fnt
    #@textBitmap.fill_rect(0, 0, @textBitmap.width, @textBitmap.height, Color.red(64))
    @textBitmap.draw_multi_text(0, 0, bitmap_tw+1, @str_height, arr_str)
  end
  
  def create_parts(src_bmp)
    @rect = Hash.new
    # 파츠 영역 설정
    @rect[:UL] = Rect.new(0, 0, 4, 4)
    @rect[:UM] = Rect.new(33, 0, 1, 4)
    @rect[:UR] = Rect.new(60, 0, 4, 4)
    @rect[:ML] = Rect.new(0, 19, 4, 1)
    @rect[:MM] = Rect.new(31, 19, 1, 1)
    @rect[:MR] = Rect.new(60, 19, 4, 1)
    @rect[:DL] = Rect.new(0, 38, 4, 4)
    @rect[:DM] = Rect.new(31, 38, 1, 4)
    @rect[:DR] = Rect.new(60, 38, 4, 4)
    @rect[:ARROW] = Rect.new(4, 42, 9, 6)
    # 비트맵 파츠 생성
    @bmp = Hash.new
    @rect.each_key do |parts|
      r = @rect[parts]
      @bmp[parts] = Bitmap.new(r.width, r.height)
      @bmp[parts].blt(0, 0, src_bmp, r) 
    end
    src_bmp.dispose if !src_bmp.disposed?
  end
  
  def get_str_last_index(bitmap, arr_text, std_width)
    return if arr_text.nil?
    @w = 0
    arr = arr_text.split(//)
    for i in 0...arr.size
      next if arr[i].empty?
      @w += bitmap.text_size(arr[i]).width
      return i if @w >= std_width
    end
    return nil
  end
  
  def get_new_str(old_str, font)
    # 임시 비트맵 생성
    tmp_b = Bitmap.new(1, 1)
    tmp_b.font = font
    # 청킹
    arr_text = tmp_b.get_divided_text(MAX_TEXT_WIDTH, old_str)
    arr_text.pop if arr_text[-1] == ""
    # 청크 개수
    @line = arr_text.size
    # 라인 수가 최대값을 넘어가면 꼬리는 자른다
    full = false
    if @line >= MAX_LINE
      arr_text.pop while arr_text.size != MAX_LINE
      full = true if @line > MAX_LINE
      @line = MAX_LINE
    end
    # 마지막 라인에서 초과하기 전 문자열의 인덱스를 검색한다.
    index = get_str_last_index(tmp_b, arr_text[@line-1], MAX_TEXT_WIDTH)
    # (해당 인덱스 + 1 ~ 마지막) 문자열 제거
    if !index.nil?
      arr_text[@line-1].slice!(index+1, arr_text[@line-1].size)
    end
    # 글자 표시 영역을 초과하면 ... 으로 표시
    if full
      if arr_text.last[-1].force_encoding("UTF-8").ascii_only?
        arr_text.last[-1] = "."
        if arr_text.last[-2].force_encoding("UTF-8").ascii_only?
          arr_text.last[-2] = "."
          arr_text.last[-3] = "."
        else
          arr_text.last[-2] = ".."
        end
      else
        arr_text.last[-1] = ".."
        arr_text.last[-3] = '.'
      end
    end
    return arr_text
  end

end