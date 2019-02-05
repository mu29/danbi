# filename mui/form/register.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Register
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014. 11. 15
# --------------------------------------------------------------------------
# Description
# 
#    회원가입 폼 클래스입니다.
#    관련 패킷 헤더는 CTSHeader::REGISTER 을 참고하세요.
#────────────────────────────────────────────────────────────────────────────

class MUI_Register < MUI::Form
  def initialize(images, jobs)
    # 서버에서 캐릭터, 직업을 받아 저장
    @images, @jobs = images, jobs
    # 비트맵, 인덱스 변수 초기화
    @bitmap = []; @n = 0
    # 비트맵 로드
    @images.each_index { |n| @bitmap.push (Bitmap.new("Graphics/Characters/#{@images[n]}.png")) }
    
    # 폼 생성
    super('center', 'center', 260, 420)
    # 드래그, 닫기 비허용
    self.drag = self.close = false
    
    # 캐릭터 윈도우
    @pic_window = MUI::PictureBox.new(66, 12, 128, 128)
    @pic_window.picture = Bitmap.new("Graphics/MUI/Register/" + "window.png")
    addControl(@pic_window)
    # 직업 이름
    @lbl_job = MUI::Label.new(66, 110, 128, Config::FONT_NORMAL_SIZE)
    @lbl_job.align = 1 # 가운데 정렬
    @lbl_job.color = Color.gray
    addControl(@lbl_job)    
    # 캐릭터 이미지
    @pic_image = MUI::PictureBox.new(0, 0, 1, 1)
    addControl(@pic_image)
    update_character(@n) # 그래픽 업데이트
    # 왼쪽 버튼
    @pic_left = MUI::PictureBox.new(20, 50, 34, 34)
    @pic_left.picture = Bitmap.new("Graphics/MUI/Register/" + "btn_left")
    addControl(@pic_left)
    # 오른쪽 버튼
    @pic_right = MUI::PictureBox.new(@width - 54, 50, 34, 34)
    @pic_right.picture = Bitmap.new("Graphics/MUI/Register/" + "btn_right")
    addControl(@pic_right)

    ## 아이콘
    # 아이디
    @pic_id = MUI::PictureBox.new(20, 162, 9, 9)
    @pic_id.picture = Bitmap.new("Graphics/MUI/Login/" + "icon_id.png")
    addControl(@pic_id)
    # 패스워드
    @pic_pw = MUI::PictureBox.new(20, @pic_id.y + 40, 9, 9)
    @pic_pw.picture = Bitmap.new("Graphics/MUI/Login/" + "icon_pw.png")
    addControl(@pic_pw)
    # 닉네임
    @pic_name = MUI::PictureBox.new(20, @pic_pw.y + 40 - 5, 9, 13)
    @pic_name.picture = Bitmap.new("Graphics/MUI/Login/" + "icon_name.png")
    addControl(@pic_name)
    # 이메일
    @pic_email = MUI::PictureBox.new(21, @pic_name.y + 40 + 5, 9, 9)
    @pic_email.picture = Bitmap.new("Graphics/MUI/Login/" + "icon_email.png")
    addControl(@pic_email)
    
    ## 텍스트박스
    # 아이디
    @tb_id = MUI::TextBox.new(40, 150, 200, 32)
    @tb_id.helpText = "아이디" # 헬프 텍스트
    addControl(@tb_id)
    # 패스워드
    @tb_pw = MUI::TextBox.new(@tb_id.x, @tb_id.y + 40, 200, 32)
    @tb_pw.helpText = "패스워드"
    @tb_pw.passwordChar = "*"
    addControl(@tb_pw)
    # 닉네임
    @tb_name = MUI::TextBox.new(@tb_pw.x, @tb_pw.y + 40, 200, 32)
    @tb_name.helpText = "닉네임"
    addControl(@tb_name)
    # 이메일
    @tb_email = MUI::TextBox.new(@tb_name.x, @tb_name.y + 40, 200, 32)
    @tb_email.helpText = "이메일"
    addControl(@tb_email)
    
    ## 버튼
    # 생성
    @btn_apply = MUI::Button.new(20, 315, @width - 40, 32)
    @btn_apply.size = 14 # 글자 사이즈
    @btn_apply.bold = true # 굵게
    @btn_apply.picture = ("Graphics/MUI/Register/" + "apply.png")
    addControl(@btn_apply)
    
    ## 레이블
    # 로그인 폼으로
    @lbl_login = MUI::Label.new(113, 360, 34, Config::FONT_NORMAL_SIZE)
    @lbl_login.text = "로그인"
    @lbl_login.color = Color.gray
    addControl(@lbl_login)
  end

  def refresh
    super
    # 폼 타이틀
    setTitle("계정 만들기")
  end
  
  # 캐릭터 정보 업데이트
  def update_character(n)
    @pic_image.picture = @bitmap[n]
    @pic_image.width = @bitmap[n].width / 4
    @pic_image.height = @bitmap[n].height / 4
    @pic_image.x = 54 + (152 - @bitmap[n].width / 4) / 2
    @pic_image.y = @pic_window.y + (128 - @bitmap[n].height / 4) / 2
    @lbl_job.text = Game.getJob(@jobs[n])
  end
  
  def update
    super
    # 컬러링
    @pic_id.picture = "Graphics/MUI/Login/" + "icon_id" + (@tb_id.focus ? "_sel" : "")
    @pic_pw.picture = "Graphics/MUI/Login/" + "icon_pw" + (@tb_pw.focus ? "_sel" : "")
    @pic_name.picture = "Graphics/MUI/Login/" + "icon_name" + (@tb_name.focus ? "_sel" : "")
    @pic_email.picture = "Graphics/MUI/Login/" + "icon_email" + (@tb_email.focus ? "_sel" : "")
    @pic_left.picture = "Graphics/MUI/Register/" + (@pic_left.isSelected ? "btn_left2" : "btn_left")
    @pic_right.picture = "Graphics/MUI/Register/" + (@pic_right.isSelected ? "btn_right2" : "btn_right")
    @lbl_login.color = @lbl_login.isSelected ? Color.system : Color.gray
    # 왼쪽 버튼 누를 시
    if @pic_left.click
      if @n > 0
        update_character(@n -= 1)
      end
    # 오른쪽 버튼 누를 시
    elsif @pic_right.click
      if @n < @bitmap.length - 1
        update_character(@n += 1)
      end
    # 생성 버튼 누를 시
    elsif @btn_apply.click
      # 패킷 전송
      Socket.send({
        'header' => CTSHeader::REGISTER,
        'id'     => @tb_id.text,
        'pass'   => @tb_pw.text,
        'name'   => @tb_name.text,
        'mail'   => @tb_email.text,
        'no'     => @n + 1})
    # 로그인 레이블 누를 시
    elsif @lbl_login.click
      # 로그인 폼으로
      MUI_Login.new
      self.dispose
    end
  end
end