#────────────────────────────────────────────────────────────────────────────

# ▶ MUI_Server

# --------------------------------------------------------------------------

# Author    뮤 (mu29gl@gmail.com), jubin

# Date      2014. 7. 27

# --------------------------------------------------------------------------

# Description

# 

#    서버 리스트 폼입니다.

#    Config::SERVER 변수에서 서버를 등록 및 수정할 수 있습니다.

#────────────────────────────────────────────────────────────────────────────



class MUI_Server < MUI::Form

  def initialize

    # 폼 생성 (x, y, width, height), ('center' => 가운데 위치)

    super('center', 300, 200, Config::SERVER.size * 58)

    # 드래그, 닫기 비허용

    self.drag = self.close = false

    

    # 서버 이름, 아이콘 배열 생성

    @lbl_server_name = []; @pic_server = []

    # 서버 리스트 로드

    for n in 0...Config::SERVER.size

      # 서버 이름

      @lbl_server_name[n] = MUI::Label.new(80, 14 + n*48, 100, Config::FONT_NORMAL_SIZE)

      @lbl_server_name[n].text = Config::SERVER[n][2]

      @lbl_server_name[n].color = Color.gray

      # 서버 아이콘

      @pic_server[n] = MUI::PictureBox.new(44, 8 + n*48, 24, 24)

      @pic_server[n].picture = "Graphics/Icons/" + Config::SERVER[n][3]

      # 컨트롤 생성

      addControl(@pic_server[n])

      addControl(@lbl_server_name[n])

      # 텍스트 크기 자동 조절 (생성 후 사용하세요.)

      @lbl_server_name[n].autoSize

      # 툴팁 설정

      @lbl_server_name[n].toolTip = @pic_server[n].toolTip = "#{Config::SERVER[n][2]}"

    end

  end

  

  def refresh

    super

    # 폼 타이틀

    setTitle("서버")

  end

  

  def update

    super

    # 서버 리스트 로드

    for n in 0...Config::SERVER.size

      # 서버에 마우스 올리면 컬러링, 밑줄

      @lbl_server_name[n].color = 

        @pic_server[n].isSelected || @lbl_server_name[n].isSelected ? Color.system : Color.gray

      @lbl_server_name[n].underLine = 

        @pic_server[n].isSelected || @lbl_server_name[n].isSelected

      # 서버 선택 시

      if @lbl_server_name[n].click or @pic_server[n].click

        # 선택 변수에 대입한 뒤

        select = n

        # 다이어로그 표시

        dialog = MUI_Dialog.new(Dialog::SERVER, "알림", "#{Config::SERVER[select][2]}에 입장하시겠습니까?", ["예", "아니오"]) do

          # 예를 누를 시

          if dialog.value == 0

            # 서버 접속

            Socket.connect(Config::SERVER[select][0], Config::SERVER[select][1])

            $scene = Scene_Login.new

            Graphics.transition

            dialog.dispose

          # 아니오를 누를 시

          elsif dialog.value == 1

            dialog.dispose

          end

        end        

      end

    end

  end

end