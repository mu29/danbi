# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI_Skill
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com), jubin
# Date      2015. 02. 01
# --------------------------------------------------------------------------
# Description
#
#    유저의 기술을 보여주는 폼 클래스입니다. 
#────────────────────────────────────────────────────────────────────────────

class MUI_Skill < MUI::Form
  def initialize
    super('center', 'center', 300, 220)
    @pic_window = MUI::PictureBox.new(24, 30, 251, 133) 
    @pic_window.picture = "Graphics/MUI/Skill/" + "window.png"
    addControl(@pic_window)
    
    @pic_point = MUI::PictureBox.new(@pic_window.x + @pic_window.width - 16, 6, 16, 16) 
    @pic_point.picture = "Graphics/MUI/Skill/" + "point.png"
    addControl(@pic_point)
    
    @lbl_point = MUI::Label.new(@pic_window.x, 6, @pic_window.width - 20, 14)
    @lbl_point.text = Math.unitMoney(Game.player.skillPoint)
    @lbl_point.align = 2
    @lbl_point.color = Color.system
    addControl(@lbl_point)
    
    @skill_data = []
    @pic_icon = []; @pic_plus = []; @lbl_rank = []
    for i in 1..20
    # Icon
      @pic_icon[i] = MUI::PictureBox.new(
      @pic_window.x + 5 + ((i - 1) % 5) * (50),
      @pic_window.y + 5 + ((i - 1) / 5) * (33), 32, 32)
      addControl(@pic_icon[i])
    # +
      @pic_plus[i] = MUI::PictureBox.new(
      58 + ((i - 1) % 5) * (50),
      30 + ((i - 1) / 5) * (33), 16, 16) 
      @pic_plus[i].picture = "Graphics/MUI/Skill/" + "+.png"
      addControl(@pic_plus[i])
    # Lv
      @lbl_rank[i] = MUI::Label.new(
      58 + ((i - 1) % 5) * (50),
      47 + ((i - 1) / 5) * (33), 16, 16) 
      @lbl_rank[i].align = 1
      @lbl_rank[i].size -= 2
      addControl(@lbl_rank[i])
    end
    refreshData
  end
  
  def refresh
    super
    setTitle("기술")
  end
  
  def refreshData
    n = 1
    for skill in Game.player.getSkillList.values
      @pic_icon[n].picture = RPG::Cache.icon(Game.getSkill(skill.no).image)
      @lbl_rank[n].text = skill.rank.to_s
      @skill_data[n] = skill.no
      n += 1
    end
  end
  
  def update
    super
    for i in 1..20
      if @pic_icon[i].click(0)
        MUI.dragItem = Game.player.getSkill(i)
      end
    end
    for i in 1..20
      if @pic_icon[i].isSelected && Game.player.getSkill(i)
        MUI::SkillInfo.set(Game.player.getSkill(i))
        return
      end
    end
    MUI::SkillInfo.clear
    opSelect
  end
  
  def opSelect
    if not @op.nil?
      if @pic_plus[@op].isSelected
        @pic_plus[@op].picture = "Graphics/MUI/Skill/+2.png"
        if @pic_plus[@op].click
          p "plus : #{@op}"
        end
      else
        @pic_plus[@op].picture = "Graphics/MUI/Skill/+.png"
      end
    end
  end
end