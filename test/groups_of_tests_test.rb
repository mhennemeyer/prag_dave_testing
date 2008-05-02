require 'test_helper'

testing "groups of tests" do
  
  testing("negative numbers") do
    expect(-3) <= -3
    expect(-1) > -1000
    testing("negative floating point numbers") do
      expect(-3.0) <= -3
    end
  end
  
end