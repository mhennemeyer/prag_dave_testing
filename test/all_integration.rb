require 'test_helper'

dir = File.dirname(__FILE__)
Dir[File.expand_path("#{dir}/integration/rails_root/test/integration/*.rb")].uniq.each do |file|
  require file
end