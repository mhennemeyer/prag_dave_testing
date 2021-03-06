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




