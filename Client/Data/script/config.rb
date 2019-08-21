# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# * Config
#────────────────────────────────────────────────────────────────────────────

module Config
  
  # 서버 리스트를 작성해 보세요.
  SERVER = [
    ["127.0.0.1", 50000, "뮤", "1.png"],
    ["58.127.170.60", 50000, "다람쥐", "2.png"],
    ["172.30.1.3", 50000, "서버 3", "3.png"],
    ["172.30.1.4", 50000, "서버 4", "4.png"]
  ]
  
  # 게임 해상도를 설정하세요. (너비, 높이 순)
  WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600
  
  # "Alt + Enter" 키 사용의 허용 여부를 설정하세요.
  USE_ALT_ENTER = true

  # 폰트를 설정하세요.
  FONT = ["나눔고딕", "나눔고딕 ExtraBold"]
  FONT_SMALL_SIZE = 13
  FONT_NORMAL_SIZE = 14
  
  # 마우스 커서의 파일명을 입력하세요.
  # 파일은 Graphics/Icons 폴더에서 불러옵니다.
  MOUSE = "cursor.png"
  
  # 결정 SE(사운드 이펙트)를 설정하세요.
  DECISION_SE = RPG::AudioFile.new("002-System02", 100, 100)#032-Switch01
  # 취소 SE를 설정하세요.
  BUZZER_SE   = RPG::AudioFile.new("004-System04", 100, 100)#021-Dive01
  
  # 디버그 콘솔의 제목과 위치를 설정하세요.
  CONSOLE_TITLE = "Debug"
  CONSOLE_RECT = Rect.new(128, 128, 256, 480)
  
  # 옵션값 저장 경로를 설정하세요.
  OPTION_PATH = "./User.ini"
  # 옵션 키 이름을 입력하세요.
  OPTION_KEY = "Option"
  
  # 부활 위치
  ReBirth_ID = 4
  ReBirth_X = 9
  ReBirth_Y = 7
end

module Config # HUD 설정
  
  # 파일명
  FILE_HUD = "HUD.png"
  FILE_HP = "HPBAR.png"
  FILE_MP = "MPBAR.png"
  FILE_EXP = "EXPBAR.png"
  FILE_B_HP = "hp_balloon.png"
  FILE_B_MP = "mp_balloon.png"
  
  # 게이지바 위치
  HP_X = 70; HP_Y = 557
  MP_X = 70; MP_Y = 574
  EXP_X = 0; EXP_Y = 593
  # 왼쪽, 오른쪽 게이지바 굵기
  HP_BORDER = [1, 1]
  MP_BORDER = [1, 1]
  EXP_BORDER = [1, 1]
  # 게이지바 속도
  BAR_SPEED = 5
  
  # 레벨 텍스트 위치
  LV_TEXT_X = 12
  LV_TEXT_Y = 560
  # HP 텍스트 위치
  HP_TEXT_X = 70
  HP_TEXT_Y = 553
  # MP 텍스트 위치
  MP_TEXT_X = 70
  MP_TEXT_Y = 570
  # EXP 텍스트 위치
  EXP_TEXT_X = 0
  EXP_TEXT_Y = 588
  
  # 메뉴 아이콘 위치, 간격
  MENU_ICON_X = 560
  MENU_ICON_Y = 558
  MENU_ICON_GAP = 40

  # 단축키 위치, 크기
  SHORTCUT_RECT = []
  COOLTIME_RECT = []
  for n in 0...10
    SHORTCUT_RECT[n] = Rect.new(214 + n * 30, 558, 24, 24)
    COOLTIME_RECT[n] = Rect.new(214 + n * 30, 557, 24, 25)
  end
end

module Config # 채팅창 설정
  # 채팅창 RECT 설정 (x, y, width, height)
  RECT_CHATBOX = Rect.new(11, 403, 300, 94)
  RECT_INPUT   = Rect.new(11, 503, 300, 29)
  # 채팅창 그래픽
  FILE_CHAT = "chatbox.png"
end