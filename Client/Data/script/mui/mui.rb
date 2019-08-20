# encoding: utf-8

#────────────────────────────────────────────────────────────────────────────
# ▶ MUI3
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2013
# --------------------------------------------------------------------------
# Description
# 
#    Mu User Interface 3 메인 클래스입니다.
#────────────────────────────────────────────────────────────────────────────

class MUI
  def self.init
    @inputs = []
    @forms = []
    @focus = nil
    @dragItem = nil
    @dragItemSprite = Sprite.new
    @dragItemSprite.z = 999999
    @cursor = MUI::Cursor.new
    ItemInfo.init
    SkillInfo.init
    @z = 99999
  end
  
  def self.addForm(form)
    @forms.push(form)
    self.setFocus(form)
    @z += 1
    form.z = @z
  end
  
  def self.deleteForm(form)
    @forms.delete(form)
    self.findFocus
  end
  
  def self.addInput(ime)
    @inputs.push(ime)
  end
  
  def self.deleteInput(ime)
    @inputs.delete(ime)
  end
  
  def self.nowTyping?
    for input in @inputs
      return true if input.focus
    end
    return false
  end
  
  def self.getFocus
    return @focus
  end
  
  def self.setFocus(form)
    @focus.disposeToolTip if @focus
    @focus = form
    @forms.delete(form)
    @forms.push(form)
    @z += 1
    form.z = @z
  end
  
  def self.findFocus
    @focus = @forms.size > 0 ? @forms[@forms.size - 1] : nil
  end
  
  def self.message
    return @message
  end
  
  def self.getForm(ui)
    for form in @forms
      return form if form.is_a?(ui)
    end
  end
  
  def self.include?(ui)
    for form in @forms
      return true if form.is_a?(ui)
    end
    return false
  end
  
  def self.checkFocus
    if Mouse.trigger? || Mouse.trigger?(1)
      for i in 0...@forms.size
        if @forms[@forms.size - i - 1].isMouseOver
          setFocus(@forms[@forms.size - i - 1]) if @focus != @forms[@forms.size - i - 1]
          break
        end
      end
    end
  end
  
  def self.dragItem; @dragItem end
  def self.dragItem=(value)
    return if @dragItem == value
    @dragItem = value
    if value.is_a?(Item)
      @cursor.setImage(RPG::Cache.icon(Game.getItem(@dragItem.itemNo).image))
    elsif value.is_a?(Skill)
      @cursor.setImage(RPG::Cache.icon(Game.getSkill(@dragItem.no).image))
    elsif value.is_a?(NilClass)
      @cursor.setDefaultImage
    end
  end
    
  def self.update
    Key.update
    Input.update
    Mouse.update
    checkFocus
    @focus.update if @focus
    if Mouse.x && Mouse.y
      @cursor.update
      ItemInfo.update
      SkillInfo.update
      if @dragItem
        @dragItemSprite.x = Mouse.x
        @dragItemSprite.y = Mouse.y
      end
    end
  end
end