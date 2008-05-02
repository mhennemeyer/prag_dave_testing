require 'test_helper'

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
