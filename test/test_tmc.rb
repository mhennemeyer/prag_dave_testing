require 'test_helper'


testing "Regular tests" do
  
  expect(1) == 1 
  expect(1) < 3
  expect("cat") =~ /[aeiou]/
  
end
  

testing "groups of tests" do
  
  testing("negative numbers") do
    expect(-3) <= -3
    expect(-1) > -1000
    testing("negative floating point numbers") do
      expect(-3.0) <= -3
    end
  end
  
end

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



testing "negated comparison" do 

  testing "with !=" do
  
    result = run { expect(1) != 1 }
    expect(result) =~ /but\s1\s==\s1/

  end

  testing "with !~" do
  
    result = run { expect("Horst") !~ /Horst/ }
    expect(result) =~ /but\s\"Horst\"\s=~\s\/Horst\//
  
  end

  testing "should ignore negations in comments" do
  
    result = run {
      expect("Horst") =~ /Horst/ # HERE IS A BAD != 
    }
    expect(result) == ""
  
  end
end

