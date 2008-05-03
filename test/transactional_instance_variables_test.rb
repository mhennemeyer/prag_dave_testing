require 'test_helper'

testing "Transactional instance variables" do
  
  @var = "cat"
  expect(@var) =~ /a/
  testing("uppercase version") do
    @var.upcase!
    expect(@var) =~ /A/
    testing("reversed") do 
      @var = @var.reverse
      expect(@var) == "TAC"
    end
    expect(@var) == "CAT"
  end
  expect(@var) =~ /a/  # original value restored
  
end

testing "Transactional instance variables with instance variables" do
  
  class User
    attr_accessor :name, :id
  end
  @user = User.new
  @user.name = 'John'
  @user.id = 1
  
  expect(@user.name) == 'John'
  expect(@user.id) == 1
  testing("change the instance variable of the object") do
     @user.name = 'Jim'
     expect(@user.name) == 'Jim'
   end
   @user.name = 'John'
   expect(@user.id) == 1
end

testing "Transactional instance variables ActiveRecord" do
  # ActiveRecord models should not be cloned because they will loose their id
  
  class ActiveRecord
  end
  class Model < ActiveRecord
  end
  class Sti < Model
  end
  @model = Model.new
  @model_id = @model.object_id
  
  @sti = Sti.new
  @sti_id = @sti.object_id
  
  testing "something else" do
  end
  
  expect(@model.object_id) == @model_id
  expect(@sti.object_id)   == @sti_id
  
end
