# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Quest
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2014. 3. 9
# --------------------------------------------------------------------------
# Description
# 
#    퀘스트를 관리하는 폼 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI_Quest < MUI::Form
  def initialize
    super(200, 200, 400, 300)
    # 픽쳐_윈도우
    @pic_win = MUI::PictureBox.new(150, 210, 170, 34)
    @pic_win.picture = "Graphics/MUI/Quest/" + "window.png"
    addControl(@pic_win)
    @lbl_index = []
    for i in 0..4
      @lbl_index[i] = MUI::Label.new(28, 20+i*16, 100, 20)
      @lbl_index[i].text = "퀘스트 #{i}"
      @lbl_index[i].color = Color.gray
      addControl(@lbl_index[i])
    end
    # 라벨_제목
    @lbl_title = MUI::Label.new(150, 20, 224, 20)
    @lbl_title.text = "제목을 입력하세요."
    @lbl_title.color = Color.system
    @lbl_title.size += 6
    addControl(@lbl_title)
    # 라벨_미션
    @lbl_mission = MUI::Label.new(150, 50, 224, 20)
    @lbl_mission.text = "다람쥐를 잡아라"
    @lbl_mission.size += 2
    addControl(@lbl_mission)
    # 라벨_내용
    @lbl_subject = MUI::Label.new(150, 75, 224, 100)
    @lbl_subject.text = "다람쥐를 잡아서 구워먹자 허허허허허ㅓ헣ㄹㅇㅎㅇㅀㄹㅇㄹ"*5
    @lbl_subject.color = Color.gray
    addControl(@lbl_subject)
    # 라벨_보상
    @lbl_reward = MUI::Label.new(150, 190, 1, 1)
    @lbl_reward.text = "보상 내역"
    @lbl_reward.color = Color.system
    addControl(@lbl_reward)
    @lbl_reward.autoSize
    # 보상 아이콘
    @pic_icon = []
    for i in 0..4
      @pic_icon[i] = MUI::PictureBox.new(155+i*34, 215, 24, 24)
      @pic_icon[i].picture = "Graphics/Icons/" + "042-Item11.png"
      addControl(@pic_icon[i])
    end
  end

  def refresh
    super
    setTitle("임무 (Quest)")
  end
  
  def update
    super
    for i in 0..4
      if @lbl_index[i].click
        @lbl_title.text = "퀘스트제목 #{i}"
        @lbl_mission.text = "퀘스트미션 #{i}"
        @lbl_subject.text = "퀘스트내용 #{i}"
      end
    end
  end
end