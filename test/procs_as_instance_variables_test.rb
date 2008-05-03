require 'test_helper'

testing "define a proc" do
  @proc = lambda { "Hello from proc" }
  testing "and pass it to the next level" do
    expect(@proc.call) == "Hello from proc"
  end
end