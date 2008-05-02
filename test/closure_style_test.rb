require 'test_helper'


testing "closure style macro testing" do
  
  class List
    attr_accessor :list_items
  end
  
  @list = List.new
  @list.list_items = 2
  
  testing "has list_items" do
    expect(@list.list_items) != 1
  end
  
  @list.list_items = []
  
  result = run { expect_has_list_items }
  
  expect(result) =~ /.*/
  
end