require 'test_helper'

dir = File.dirname(__FILE__)
Dir[File.expand_path("#{dir}/*.rb")].uniq.select{|f| f !~ /integration/ }.each do |file|
  require file
end