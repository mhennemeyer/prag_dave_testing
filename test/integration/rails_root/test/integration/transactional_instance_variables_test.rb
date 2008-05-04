require File.dirname(__FILE__) + '/../test_helper'

integration_test do
  
  setup { Model.destroy_all }
  
  testing "Transactional instance variables with ActiveRecord" do
    # ActiveRecord models should not be cloned because they will loose their id
    
    post "/models", 'model' => {}
    @model = Model.find :first
    @model_id = @model.id

    testing "something else" do
      expect(@response.response_code) <= 399
      expect(@model.id) == @model_id
      @model.id = @model_id + 1
    end

    expect(@model.id) == @model_id # this will fail
  end
  
end
