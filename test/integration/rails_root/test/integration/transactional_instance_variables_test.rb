require File.dirname(__FILE__) + '/../test_helper'

integration_test do
  
  
  testing "Transactional models and Integration Session" do
    # ActiveRecord models should not be cloned because they will loose their id
    
    
    Model.destroy_all
    
    post "/models", 'model' => {}
    @model = Model.find(:first)

    testing "something else" do
      # posting the new model should be no failure
      expect(@response.response_code) == 302
      
      # change the model object
      @model = "FunnyHorst!"
    end
    
    # the model should be still the original one
    expect(@model) == Model.find(:first)
     
    testing "transactional db operations" do
      post "/models", 'model' => {}
      # now there should be two models
      expect(Model.count) == 2
    end
   
   # now there should be only the one model posted at the beginning of this testing block
   expect(Model.count) == 1
   
 end
   
end
