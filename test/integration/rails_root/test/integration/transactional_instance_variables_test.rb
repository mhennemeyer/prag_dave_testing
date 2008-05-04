require File.dirname(__FILE__) + '/../test_helper'

integration_test do
  
  testing "Transactional instance variables with ActiveRecord" do
    # ActiveRecord models should not be cloned because they will loose their id
    
    
    Model.destroy_all
    
    post "/models", 'model' => {}
    @model = Model.find :first
    @model_id = @model.id

    testing "something else" do
      # posting the new model should be no failure
      expect(@response.response_code) <= 399
      # the model.id should not be forgotten
      expect(@model.id) == @model_id
      @model.id = @model_id + 1
    end
    
    # the model.id should be still the original one
    expect(@model.id) == @model_id
  
    testing "transactional db operations" do
      post "/models", 'model' => {}
      # now there should be two models
      expect(Model.count) == 2
    end
   
   # now there should be only the one model posted in this testing block
   expect(Model.find(:all).size) == 1
   
 end
   
end
