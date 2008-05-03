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
  testing "nothing" do
    expect(1) == 1
  end
end


# Try a deep nesting

testing "with a second setup" do
  setup { @var = 3 }
  
  testing "var should eql 3" do
    expect(@var) == 3
    testing "nothing again" do
      expect(1) == 1
      testing "one more level" do
        expect(12) < 13
        testing "and more" do 
          setup { @var = 12 }
          testing "var should eql 12" do
            expect(@var) == 12
          end
        end
      end
    end
  end
  
  # running the named testing block again shouldn't trigger the setup
  @var = 1
  expect_var_should_eql_1
  @var = 12
  expect_var_should_eql_12
end
