# filename mui/math.rb
#────────────────────────────────────────────────────────────────────────────
# ▶ Math
# --------------------------------------------------------------------------
# Author    뮤 (mu29gl@gmail.com)
# Date      2014
#────────────────────────────────────────────────────────────────────────────
module Math
  # 원(W) 단위 절사함수 : 1000 => 1,000
  def self.unitMoney(num)
    num = num.to_s
    a = num.split(//).reverse
    result = ""
    for i in 0...a.size
      if i % 3 == 0 && i != 0
        result += ','
      end
      result += a[i]
    end
    return result.reverse.to_s
  end
end