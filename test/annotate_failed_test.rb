require 'test_helper'

testing "annotation of failed tests" do

  result = run {
    # this comment will annotate the following failed test
    expect(1) == 2
  }

  expect(result) =~ /this\scomment\swill\sannotate\sthe\sfollowing\sfailed\stest/

  result = run { 
    expect(2) == 3  # so will this one
  }
  
  expect(result) =~ /so\swill\sthis\sone/
  
end
