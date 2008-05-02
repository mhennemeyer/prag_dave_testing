require 'test_results_gatherer.rb'
require 'comparison_proxy.rb'

module PragDaveTesting
  
  def expect(value)
    ComparisonProxy.new(TestResultsGatherer.instance, value, @__test_description)
  end

  # Save any instance variables, yield to our block, then restore the instance
  # variables. We also save the test description in @__test_description. This is
  # tacky, but has the nice side effect of saving and restoring it in nested
  # testing blocks
  def testing(description,&block)
    # puts description_method_name = ("expect_" + description.gsub(" ", "_")).to_sym
    # puts self.class
    # PragDaveTesting.module_eval do 
    #   define_method(description_method_name,&block)
    # end
    ivs = {}
    instance_variables.each do |iv|
      ivs[iv] = instance_variable_get(iv)
    end
    saved = Marshal.dump(ivs)
    @__test_description = description
    yield
    @__test_description = nil
    instance_variables.each { |iv| instance_variable_set(iv, nil) }
    ivs = Marshal.load(saved)
    ivs.each do |iv, value|
      instance_variable_set(iv, value)
    end
  end

end

include PragDaveTesting