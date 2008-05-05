require File.dirname(__FILE__) + '/../test_helper'

testing "Sti" do
  @sti = Sti.create!
  testing "with name" do
    expect(@sti.update_attributes(:name => 'Horst')) == true
  end
end
    