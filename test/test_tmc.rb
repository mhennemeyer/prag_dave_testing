require 'test_helper'

testing "negated comparison with !=" do
  
  result = run { expect(1) != 1 }
  expect(result) =~ /but\s1\s==\s1/
  
  result = run {expect("Horst") !~ /Horst/}
  expect(result) =~ /but\s\"Horst\"\s=~\s\/Horst\//
  
  result = run {
    expect("Horst") =~ /Horst/ # HERE IS A BAD != 
  }
  expect(result) == ""
  
end
