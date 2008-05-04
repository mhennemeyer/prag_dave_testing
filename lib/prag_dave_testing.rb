require File.dirname(__FILE__) + '/test_results_gatherer.rb'
require File.dirname(__FILE__) + '/comparison_proxy.rb'

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
  
  # Don't look at this code !!! # this is my fault (m.hennemeyer) and i will refactor it tomorrow
  def set_environment
    # Really! Don't look !
    dbdump = "dump the database in memory! if rails test else nil "
    ivs = {}
    @__env ||= []
    instance_variables.each do |iv|
      val = instance_variable_get(iv)
      unless iv == "@__setup" || iv == "@__env"
        begin
          if (val.class.superclass.to_s =~ /ActiveRecord/) || (val.class.superclass.superclass.to_s =~ /ActiveRecord/)
            id = val.id || nil
            ivs[iv] = val.clone
            ivs[iv].id = id
          else
            ivs[iv] = val.clone
          end
        rescue TypeError
          ivs[iv] = val
        end
      end
    end
    @__env.push({:vars => ivs, :db => dbdump})
  end
  
  def get_environment
    env = @__env.pop
    dbwrite = env[:db]
    env[:vars]
  end

  # Save any instance variables, yield to our block, then restore the instance
  # variables. We also save the test description in @__test_description. This is
  # tacky, but has the nice side effect of saving and restoring it in nested
  # testing blocks
  def testing(description,&block)
    testing_block_to_macro(description, &block)
    set_environment

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