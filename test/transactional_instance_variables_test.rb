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
