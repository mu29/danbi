$:.unshift File.expand_path(File.dirname(__FILE__))

require 'superators/version'
require 'superators/macro'
require 'superators/monkey_patch'

include SuperatorMixin