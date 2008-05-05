require File.dirname(__FILE__) + '/../test_helper'

functional_test :models_controller do
  
  Model.destroy_all
  2.times { Model.create! }
  
  testing "get index" do
    get 'index'
    expect(@response.response_code) <= 399
    expect(@response.assigns) != nil
    puts @response.instance_variables
    puts @response.body
  end
  
  # testing "post create" do
  #    post 'create', :model => { }
  #    expect(@response.response_code) <= 399
  #  end
  
end


# class ModelsControllerTest < ActionController::TestCase
#   def test_should_get_index
#     get :index
#     assert_response :success
#     assert_not_nil assigns(:models)
#   end
# 
#   def test_should_get_new
#     get :new
#     assert_response :success
#   end
# 
#   def test_should_create_model
#     assert_difference('Model.count') do
#       post :create, :model => { }
#     end
# 
#     assert_redirected_to model_path(assigns(:model))
#   end
# 
#   def test_should_show_model
#     get :show, :id => models(:one).id
#     assert_response :success
#   end
# 
#   def test_should_get_edit
#     get :edit, :id => models(:one).id
#     assert_response :success
#   end
# 
#   def test_should_update_model
#     put :update, :id => models(:one).id, :model => { }
#     assert_redirected_to model_path(assigns(:model))
#   end
# 
#   def test_should_destroy_model
#     assert_difference('Model.count', -1) do
#       delete :destroy, :id => models(:one).id
#     end
# 
#     assert_redirected_to models_path
#   end
# end
