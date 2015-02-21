class Object
  
  attr_reader :superator_queue
  
  def -@
    extend SuperatorFlag
    @superator_queue ||= []
    @superator_queue.unshift '-'
    self
  end
  
  def +@
    extend SuperatorFlag
    @superator_queue ||= []
    @superator_queue.unshift '+'
    self
  end
  
  def ~@
    extend SuperatorFlag
    @superator_queue ||= []
    @superator_queue.unshift '~'
    self
  end
  
end