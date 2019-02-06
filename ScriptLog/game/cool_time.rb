# filename game/cool_time.rb
class Cool
  attr_accessor :nowCooltime
  attr_accessor :fullCooltime
  
  def initialize(nowCooltime, fullCooltime)
    @nowCooltime = nowCooltime
    @fullCooltime = fullCooltime
  end
end

class Cooltime
  attr_accessor :slot
  
  def initialize
    @slot = []
    
    for i in 0...10
      @slot[i] = Cool.new(0, 0)
    end
  end
  
  def setCool(i, nowCooltime, fullCooltime)
    @slot[i].nowCooltime = nowCooltime
    @slot[i].fullCooltime = fullCooltime
  end
  
  def getCool(i)
    return @slot[i]
  end
end