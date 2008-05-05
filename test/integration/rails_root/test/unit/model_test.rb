require File.dirname(__FILE__) + '/../test_helper'

testing "model" do
  
  Model.destroy_all
  @model = Model.create!
  
  expect(Model.find(:first)) == @model
  
  expect(Model.count) == 1
  testing "" do
  end

  expect(@model) == Model.find(:first)
  # expect(Model.find(:first)) == @model # why does this fail???
  
end