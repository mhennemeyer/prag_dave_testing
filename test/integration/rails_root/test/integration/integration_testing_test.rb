require File.dirname(__FILE__) + '/../test_helper'

integration_test do
  
  testing "Transactional instance variables with ActiveRecord" do
    # ActiveRecord models should not be cloned because they will loose their id
    
    @model = Model.create
    @model_id = @model.id

    @sti = Sti.create
    @sti_id = @sti.object_id
    
    get "/models"

    testing "something else" do
      expect(@response.response_code) <= 399
      expect(@model.id) == @model_id
    end

    expect(@model.id) == @model_id
    expect(@sti.object_id)   == @sti_id

  end
  
end
