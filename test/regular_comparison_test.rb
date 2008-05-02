require 'test_helper'


testing "Regular tests" do
  
  expect(1) == 1 
  expect(1) < 3
  expect("cat") =~ /[aeiou]/
  expect([1,2,3].map {|i| i + 1}) == [2,3,4]
  expect([1,2,3]) != 1
  expect(:name => "horst") != 1
  expect([]) == []
  
end
  








