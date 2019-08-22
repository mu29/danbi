# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Login
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014. 11. 15
# --------------------------------------------------------------------------
# Description
# 
#    로그인 폼 클래스입니다.
#    관련 패킷 헤더는 CTSHeader::LOGIN 을 참고하세요.
#────────────────────────────────────────────────────────────────────────────

class MUI_Login < MUI::Form
  def initialize
    # 폼 생성
    super('center', 300, 260, 240)
    # 드래그, 닫기 비허용
    self.drag = self.close = false
    
    ## 아이콘
    # 아이디
    @pic_id = MUI::PictureBox.new(43, 32, 9, 9)
    @pic_id.picture = "Graphics/MUI/Login/" + "icon_id"
    addControl(@pic_id)
    # 패스워드
    @pic_pw = MUI::PictureBox.new(43, 71, 9, 9)
    @pic_pw.picture = "Graphics/MUI/Login/" + "icon_pw"
    addControl(@pic_pw)
    
    ## 텍스트박스
    # 아이디
    @tb_id = MUI::TextBox.new(60, 20, 150, 32)
    @tb_id.helpText = "아이디"
    addControl(@tb_id)
    # 패스워드
    @tb_pw = MUI::TextBox.new(60, 60, 150, 32)
    @tb_pw.helpText = "패스워드"
    # 비밀번호용 문자
    @tb_pw.passwordChar = "*"
    addControl(@tb_pw)
    
    ## 버튼
    # 로그인
    @btn_login = MUI::Button.new(60, 100, 150, 32)
    @btn_login.picture = "Graphics/MUI/Login/" + "key.png"
    addControl(@btn_login)
    
    ## 체크박스
    # 아이디
    @chk_id = MUI::CheckBox.new(22, 29, 14, 14)
    # 아이디 문자열 로드
    Win32API::GetPrivateProfileString.call("User", "id", "", id = 0.chr * 20, id.size, "./User.ini")
    id = id.unpack("c*").pack("c*")
    id.gsub!(0.chr, "")
    @chk_id.value = (id != "")
    @tb_id.text = id if id != ""
    addControl(@chk_id)
    
    ## 레이블
    # 계정 생성
    @lbl_regis = MUI::Label.new(0, 160, 200, Config::FONT_NORMAL_SIZE*2)
    @lbl_regis.align = 1
    @lbl_regis.text = "계정이 없습니까?\n이곳을 클릭하십시오."
    addControl(@lbl_regis)
    # 텍스트 크기 자동 조절 후 가운데로 위치
    @lbl_regis.autoSize
    @lbl_regis.x = (self.width - @lbl_regis.width) / 2
    @lbl_regis.color = Color.gray
  end

  def refresh
    super
    # 폼 타이틀
    setTitle("로그인")
  end
  
  def update
    super
    # 컬러링, 밑줄
    @pic_id.picture = "Graphics/MUI/Login/" + "icon_id" + (@tb_id.focus ? "_sel" : "")
    @pic_pw.picture = "Graphics/MUI/Login/" + "icon_pw" + (@tb_pw.focus ? "_sel" : "")
    @lbl_regis.color = @lbl_regis.isSelected ? Color.system : Color.gray
    @lbl_regis.underLine = @lbl_regis.isSelected
    # 회원가입 레이블 누를 시
    if @lbl_regis.click
      # 회원가입 폼 띄움
      Socket.send({'header' => CTSHeader::OPEN_REGISTER_WINDOW})
      self.dispose
    # 로그인 버튼 누를 시
    elsif @btn_login.click
      if @tb_id.text == "" or @tb_pw.text == ""
        dialog = MUI_Dialog.new(Dialog::LOGIN, "로그인 실패", "아이디나 비밀번호를 입력하지 않으셨습니다.", ["닫기"]) do
          dialog.dispose if dialog.value == 0 
        end        
      else
        # 패킷 전송
        Socket.send({
          'header' => CTSHeader::LOGIN,
          'id'     => @tb_id.text,
          'pass'   => @tb_pw.text})
        # 아이디 저장
        if @chk_id.value
          Win32API::WritePrivateProfileString.call("User", "id", @tb_id.text, "./User.ini")
        end
      end
    elsif @chk_id.click
      if not @chk_id.value
        # 아이디 문자열 삭제
        Win32API::WritePrivateProfileString.call("User", "id", @tb_id.text = "", "./User.ini")
      end
    end
  end
end