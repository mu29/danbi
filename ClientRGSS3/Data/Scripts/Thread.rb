#────────────────────────────────────────────────────────────────────────────
# * Thread Class, Yukihiro Matsumoto, @cheapmunk.naver, 2015. 02. 14
#
#   https://bugs.ruby-lang.org/issues/6647
#────────────────────────────────────────────────────────────────────────────

class << Thread
  alias :new_ :new
  def new(*args, &block)
    new_(*args) do |*args|
      begin
        block.call(*args)
      rescue Exception => e
        raise if Thread.abort_on_exception || Thread.current.abort_on_exception        
        message = e.backtrace[0].split ":"
        name = $RGSS_SCRIPTS.at(message.first.sub(/Section/, '').to_i).at(1)
        line = message[1]
        msgbox "Thread Error\n스크립트 '#{name}'의 #{line} 번째 줄에서 #{e.class}가 발생했습니다.\n#{e.message}", MB::ICONEXCLAMATION
        Kernel.exit
      end
    end
  end
end