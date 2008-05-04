require File.dirname(__FILE__) + '/../test_helper'

testing "model" do
  
  @model = Model.create
  expect(Model.count) == 1
  
end