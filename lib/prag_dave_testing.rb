require File.dirname(__FILE__) + '/test_results_gatherer.rb'
require File.dirname(__FILE__) + '/comparison_proxy.rb'



module PragDaveTesting
  
  def active_record?(var)
    (var.class.superclass.to_s =~ /ActiveRecord/) || (var.class.superclass.superclass.to_s =~ /ActiveRecord/)
  end
  
  def dbread
    File.open(RAILS_ROOT + "/db/test.sqlite3") do |f|
      f.readlines
    end
  end
  
  def db_write(lines)
    File.open(RAILS_ROOT + "/db/test.sqlite3", "w") do |f|
      f.rewind
      lines.each do |line|
        f.write line
      end
    end
  end
  
  # :call-seq:
  # expect(1) == 1
  def expect(value)
    ComparisonProxy.new(TestResultsGatherer.instance, value, @__test_description)
  end
  
  def testing_block_to_macro(description, &block)
    description_method_name = ("expect_" + description.downcase.gsub(" ", "_")).to_sym
    testing_block = lambda do
      raise StandardError.new("This would be a long loop") if @__test_description == description
      testing(description + "_macro", &block)
    end
    PragDaveTesting.module_eval do 
      define_method(description_method_name,&testing_block)
    end
  end
  
  # Don't look at this code !!! # this is my fault (m.hennemeyer) and i will refactor it tomorrow
  def save_environment!
    # Really! Don't look !
    db = []
    db = dbread if rails_test?
    ivs = {}
    @__env ||= []
    instance_variables.each do |iv|
      val = instance_variable_get(iv)
      unless iv == "@__env"
        begin
          ivs[iv] = val.dup
          # active_record?(val) && val.reload
        rescue TypeError
          ivs[iv] = val
        end
      end
    end
    @__env.push({:vars => ivs, :db => db})
  end
  
  def set_environment!
    instance_variables.each do |iv| 
      instance_variable_set(iv, nil) unless iv == "@__env"
    end
    get_environment!.each do |iv, value|
      var = instance_variable_set(iv, value)
      active_record?(var) && var.reload
    end
  end
  
  def get_environment!
    env = @__env.pop
    db_write(env[:db]) if rails_test?
    env[:vars]
  end
  
  def rails_test?
    defined? RAILS_ROOT
  end

  # Save any instance variables, yield to our block, then restore the instance
  # variables. We also save the test description in @__test_description. This is
  # tacky, but has the nice side effect of saving and restoring it in nested
  # testing blocks
  def testing(description,&block)
    
    testing_block_to_macro(description, &block)
    
    save_environment!

    @__test_description = description
    begin
      yield
    rescue Exception => e
      raise e
    ensure
      @__test_description = nil
      set_environment!
    end
  end
  
  # define all testing blocks inside the block associated to
  # #integration_test and you have access to all the 
  # methods from ActionController::Integration::Session
  def integration_test
    return unless rails_test?
    require 'action_controller'
    require 'action_controller/integration'
    include ActionController::Integration::Runner
    begin
      yield if block_given?
    rescue Test::Unit::AssertionFailedError => test_unit_error
      expect(test_unit_error.message) == ""
    end
  end
  

end

include PragDaveTesting