require File.dirname(__FILE__) + '/../test_helper'

testing "model" do
  
  Model.destroy_all
  @model = Model.create!
  
  expect(Model.find(:first)) == @model
  
  expect(Model.count) == 1
  testing "" do
  end

  expect(@model) == Model.find(:first)
  
end

testing "Save a model object referenced by an instance variable after a transactional testing block" do
  Model.destroy_all
  @model = Model.create!
  testing "" do
  end
  expect(@model.save!) == true
end

