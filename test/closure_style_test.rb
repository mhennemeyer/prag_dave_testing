require 'test_helper'




testing "closure style macro testing" do
  
  class List
    attr_accessor :list_items
  end
  @list = List.new
  
  @list.list_items = [1,2,3]
  
  # this testing block will be saved as expect_has_list_items to call it again
  testing "has list_items" do             
    expect(@list.list_items) != [] # it passes   
  end                                     
                                          
  expect_has_list_items # call it again and it passes                   
                                          
  @list.list_items = [] # the context has changed!               
                                          
  result = run { expect_has_list_items } 
  
  expect(result) =~ /but\s\[\]\s==\s\[\]/ # and now it fails
  
end

# Any testing block may be evaluated again:
expect_closure_style_macro_testing

# This one too:
@list.list_items = ["something"]
expect_has_list_items