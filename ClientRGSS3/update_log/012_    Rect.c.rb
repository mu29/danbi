#────────────────────────────────────────────────────────────────────────────

# * Rect, jubin

#────────────────────────────────────────────────────────────────────────────



class Rect

  def to_a

    [self.x, self.y, self.width, self.height]

  end

  

  def src_rect

    Rect.new(0, 0, self.width, self.height)

  end

end