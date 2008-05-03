require 'test_results_gatherer.rb'
require 'comparison_proxy.rb'

module PragDaveTesting
  
  Array.module_eval do
    def dump_hash
      h = {}
      self.each do |k|
        h[k] = nil
      end
    end
  end
  
  # :call-seq:
  # expect(1) == 1
  def expect(value)
    ComparisonProxy.new(TestResultsGatherer.instance, value, @__test_description)
  end
  
  def testing_block_to_macro(description, &block)
    description_method_name = ("expect_" + description.gsub(" ", "_")).to_sym
    PragDaveTesting.module_eval do 
      define_method(description_method_name,&block)
    end
  end
  
  # The setup code is run in all subsequent testing blocks
  # on the same level.
  # == Example:
  #
  #   setup do
  #     @var = 1
  #   end
  # 
  #   testing "var should eql 1" do
  #     expect(@var) == 1 
  #   end
  #  
  #   testing "with a second setup" do
  #     setup { @var = 3 }
  # 
  #     testing "var should eql 3" do
  #       expect(@var) == 3
  #     end
  # 
  #   end
  #   
  def setup(&block)
    @__setup ||= {}
    @__test_description ||= "nilnil"
    @__setup[@__test_description] = lambda(&block)
  end

  # Save any instance variables, yield to our block, then restore the instance
  # variables. We also save the test description in @__test_description. This is
  # tacky, but has the nice side effect of saving and restoring it in nested
  # testing blocks
  def testing(description,&block)
    testing_block_to_macro(description, &block)
    ivs = {}
    instance_variables.each do |iv|
      ivs[iv] = instance_variable_get(iv) unless iv == "@__setup"
    end
    @__setup && @__setup[@__test_description].call
    @__test_description = description
    yield
    @__test_description = nil
    instance_variables.each do |iv| 
      instance_variable_set(iv, nil) unless iv == "@__setup"
    end
    ivs.each do |iv, value|
      instance_variable_set(iv, value)
    end
  end
  
  # define all testing blocks inside the block associated to
  # #integration_test and you have access to all the 
  # methods from ActionController::Integration::Session
  def integration_test(&block)
    ActionController::Integration::Session.new.instance_eval &block
  end

end

include PragDaveTesting