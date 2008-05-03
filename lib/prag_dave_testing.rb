require 'test_results_gatherer.rb'
require 'comparison_proxy.rb'

module PragDaveTesting
  
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
  
  # Don't look at this code !!!
  def set_environment
    # Really! Don't look !
    ivs = {}
    @__env ||= []
    instance_variables.each do |iv|
      val = instance_variable_get(iv)
      unless iv == "@__setup" || iv == "@__env"
        begin
          unless val.class.superclass.to_s =~ /ActiveRecord/ || val.class.superclass.superclass.to_s =~ /ActiveRecord/
            ivs[iv] = val.clone
          else
            ivs[iv] = val
          end
        rescue TypeError
          ivs[iv] = val
        end
      end
    end
    @__env.push ivs
  end
  
  def get_environment
    @__env.pop
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
    set_environment
    @__setup && @__setup[@__test_description] && @__setup[@__test_description].call
    @__test_description = description
    
    yield
    @__test_description = nil
    
    instance_variables.each do |iv| 
      instance_variable_set(iv, nil) unless iv == "@__setup" || iv == "@__env"
    end
    
    get_environment.each do |iv, value|
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