require 'test_helper'


testing "closure style macro" do
  
  class List
    attr_accessor :list_items
  end
  @list = List.new
  @list.list_items = [1,2,3]
  
  
  # this testing block will be saved as expect_has_list_items to call it again
  testing "has list_items" do             
    expect(@list.list_items) != [] 
  end                                     
  
  # call it again and it passes:                                                           
  expect_has_list_items 
  
  # now the context changes and @list has no list_items any longer:                                                       
  @list.list_items.clear
  
  # catch error messages (we expect an error)                                        
  result = run { expect_has_list_items } 
  
  # the output proofes that expect_has_list_items has failed:
  expect(result) =~ /but\s\[\]\s==\s\[\]/ 

  testing "several macros at once" do
   # redefine a testing block: 
    testing "has list_items" do             
      expect(@list.list_items) != nil # it passes
      @var = 1
      testing "var should eql one" do
        expect(@var) == 1
      end 
    end
    # Variables are not exposed from inner to outer blocks: 
    result = run { expect_var_should_eql_one }
    expect(result) =~ /but\snil\s!=\s1/
  end
  
  testing "macros should behave transactional too" do
    @var = 1
    testing "change var to 5" do
      @var = 5
    end
    expect_change_var_to_5
    expect(@var) == 1
  end
  
  testing "macros should raise if called in their defining test" do
    result = run {expect_macros_should_raise_if_called_in_their_defining_test}
    expect(result) == "This would be a long loop"
  end
end