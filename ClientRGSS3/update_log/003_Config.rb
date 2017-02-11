#────────────────────────────────────────────────────────────────────────────

# * Config

#────────────────────────────────────────────────────────────────────────────



module Config # 시스템 설정

  # 서버

  SERVER =

  ["127.0.0.1", 50000, "뮤", "1.png"],

  ["58.127.170.60", 50000, "다람쥐", "2.png"],

  ["172.30.1.3", 50000, "서버 3", "3.png"],

  ["172.30.1.4", 50000, "서버 4", "4.png"]



  # 해상도 (너비, 높이)

  WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

  

  # Alt+Enter 사용 여부

  USE_ALT_ENTER = true



  # 폰트

  FONT = ["나눔고딕", "나눔고딕 ExtraBold"]

  FONT_SMALL_SIZE = 13

  FONT_NORMAL_SIZE = 14

  

  # 커서 그래픽

  MOUSE = "cursor.png"

  

  # 결정 SE

  DECISION_SE = RPG::AudioFile.new("032-Switch01", 100, 100)#002-System02

  

  # 취소 SE

  BUZZER_SE   = RPG::AudioFile.new("021-Dive01", 100, 100)#004-System04

  

  # 디버그 콘솔 제목

  CONSOLE_TITLE = "Debug"

  CONSOLE_RECT = Rect.new(32, 32, 256, 480)

  

  # 옵션값 저장 경로

  OPTION_PATH = "./User.ini"

  # 옵션 키

  OPTION_KEY = "Option"

  

  # 외부 라이브러리 경로

  DLL_PATH = './Library/'

  

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

  

  # 단축키 윈도우 위치

  SHORTCUT_WINDOW_X = 213

  SHORTCUT_WINDOW_Y = 557

  

  # 단축키 아이콘 위치

  SHORTCUT_ICON_X = 6

  SHORTCUT_ICON_Y = 6

  

  HP_BORDER = [1, 1]

  MP_BORDER = [1, 1]

  EXP_BORDER = [1, 1]

  

  BAR_SPEED = 5

  

  SHORTCUT_RECT = []

  COOLTIME_RECT = []

  for n in 0...10

    SHORTCUT_RECT[n] = Rect.new(214 + n * 30, 558, 24, 24)

  end

  for n in 0...10

    COOLTIME_RECT[n] = Rect.new(214 + n * 30, 557, 24, 25)

  end

end



module Config # 채팅창 설정

  # 채팅창 RECT 설정 (x, y, width, height)

  RECT_CHATBOX = Rect.new(490, 425, 300, 94)

  RECT_INPUT = Rect.new(490, 520, 300, 20)

  # 채팅창 그래픽

  FILE_CHAT = "chatbox.png"

end



module Config # 스위치

  # 맵 파일 추출

  EXTRACT_MAP = false

end