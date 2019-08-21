# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ Bitmap
# --------------------------------------------------------------------------
# Author    jubin
# Date      2016. 01. 10
# --------------------------------------------------------------------------
# Description
# 
#    확장된 함수가 추가된 비트맵 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class Bitmap
  alias :_initialize_ :initialize if !$@
  def initialize(*args)
    if args.size == 1 && args[0].is_a?(String)
      args[0] = RPG::Path::RTP(args[0])
    end
    _initialize_(*args)
  end
  
  # 테두리 텍스트
  def draw_outline_text(x, y, width, height, str,
                       color = Color.white, color2 = Color.black, align = 0, multi = false)
    font.color = color2
    str = str.to_s if !str.is_a?(String)
    for i in -1..1
      for j in -1..1
        if i*j == 0 and i+j != 0
          multi ? draw_multi_text(x + i, y + j, width, height, str, align) : 
            draw_text(x + i, y + j, width, height, str, align)
        end
      end
    end
    font.color = color
    multi ? draw_multi_text(x, y, width, height, str, align) : draw_text(x, y, width, height, str, align)
  end
  
  # 멀티라인(\n) 테두리 텍스트
  def draw_multi_outline_text(x, y, width, height, str, color = Color.white, color2 = Color.black, align = 0)
    draw_outline_text(x, y, width, height, str, color, color2, align, true)
  end
  
  # 텍스트 덩어리
  # esn : Escape Sequence '\n' 으로 나누거나(true), 혹은 width에 맞추거나(false)
  def get_divided_text(width, str, esn = false)
    line, text, x = Array.new, String.new, 0
    return line if not str
    for char in str.split(//)
      # \n은 문자열에 더하고, 사이즈는 더하지 않는다.
      text += char
      # 개행문자 빼고 더함
      if char != "\n"
        rect = text_size(char)
        x += rect.width
      end
      if esn
        if char == "\n"
          text.gsub!("\n", "")
          line.push(text)
          text = ""
          x = 0
        end
      elsif !esn
        if x + rect.width > width or char == "\n"
          text.gsub!("\n", "")
          line.push(text)
          text = ""
          x = 0
        end
      end      
    end
    line.push(text)
    return line
  end
  
  # 멀티라인(\n) 텍스트
  def draw_multi_text(x, y, width, height, str, align = 0, esn = false)
    text = if str.is_a?(Array)
      str
    else
      get_divided_text(width, str, esn)
    end
    text.each_index do |n|
      next if text[n] == ""
      # 비트맵 세로 크기보다 크면 중단
      return if y + n * text_size(text[n]).height > height
      draw_text(x, y + n * text_size(text[n]).height,
      width, text_size(text[n]).height, text[n], align)
=begin
      # 정렬 변수
      xa = case align
      when 0; x
      when 1; (width - text_size(text[n]).width) / 2.0
      when 2; width - text_size(text[n]).width end
      # 비트맵 세로 크기보다 크면 중단
      return if y + n * text_size(text[n]).height >= height
      # 텍스트 생성
      draw_text(
        x + xa, y + n * text_size(text[n]).height,
        text_size(text[n]).width + 1, text_size(text[n]).height, text[n])
=end
    end
  end
  
  # xalign // 0 : 왼, 1 : 중간, 2 : 오른
  # yalign // 0 : 위, 1 : 중간, 2 : 아래
  # 선
  def fill_line(str, color = Color.new(0, 0, 0), xalign = 0, yalign = 2, esn = false)
    return if color.nil?
    # 굵기
    thick = (text_size(str).height / 12.0).round
    thick = 1 if thick == 0
    # 글자
    text = get_divided_text(self.width, str, esn)
    text.each_index do |n|
      # 정렬
      xa = case xalign
      when 0; 0
      when 1; (width - text_size(text[n]).width) / 2.0
      when 2; width - text_size(text[n]).width end
      ya = case yalign
      when 0; 0
      when 1; text_size(text[n]).height / 2.0
      when 2; text_size(text[n]).height - thick end
      # 선 그리기
      fill_rect(
        xa, 
        ya + n * text_size(text[n]).height,
        text_size(text[n]).width,
        thick,
        color)
    end
  end
end