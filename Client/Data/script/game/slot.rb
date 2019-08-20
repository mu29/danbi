# encoding: utf-8

class Slot
  attr_accessor :slot
  
  def initialize
    @slot = []
    
    for i in 0...10
      @slot[i] = -1
    end
  end
  
  def setSlot(index, slot)
    @slot[index] = slot
  end
  
  def getSlot(n)
    return @slot[n]
  end
  
  def getKey(n)
    return Key::SLOT[n]
  end
end