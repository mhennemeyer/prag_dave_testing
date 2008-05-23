require 'test_helper'

dir = File.dirname(__FILE__)
Dir[File.expand_path("#{dir}/all_*.rb")].uniq.each do |file|
  require file
end