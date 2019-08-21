# encoding: utf-8

#───────────────────────────────────────────────────────────────────────────────
# ▶ Color
# ------------------------------------------------------------------------------
# Author    jubin
# Date      2016. 01. 10
# ------------------------------------------------------------------------------
# Description
# 
#    색깔 클래스입니다. alpha는 투명도 입니다.
#───────────────────────────────────────────────────────────────────────────────

class Color
  def self.black(alpha=255)  new(0, 0, 0, alpha); end
  def self.white(alpha=255)  new(255, 255, 255, alpha); end
  def self.gray(alpha=255)   new(96, 96, 96, alpha); end
  def self.red(alpha=255)    new(255, 0, 0, alpha); end
  def self.system(alpha=255) new(0, 96, 255, alpha); end
  def self.yellow(alpha=255) new(255, 255, 0, alpha); end
end