require 'test_helper'

setup do
  @var = 1
end

testing "var should eql 1" do
  expect(@var) == 1
end

@var = 2

testing "var should not eql 2" do
  result = run { expect(@var) == 2 }
  expect(result) =~ /but\s1\s!=\s2/
end

testing "with a second setup" do
  setup { @var = 3 }
  
  testing "var should eql 3" do
    expect(@var) == 3
  end
  
  # running the named testing block again shouldn't trigger the setup
  @var = 1
  expect_var_should_eql_1
end
