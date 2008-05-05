require File.dirname(__FILE__) + '/../test_helper'

# TODO
# include helper : sti_path,...

functional_test :stis do
  
  Sti.destroy_all
  Sti.create! :name => 'Horst'
  Sti.create! :name => 'Heinz'
  
  testing "get index" do
    get :index
    expect(@response.response_code) <= 399
    expect(assigns(:stis)) != nil
  end
  
  testing "get new" do
    get :new
    expect(@response.response_code) <= 399
  end
  
  testing "post create" do
    Sti.destroy_all
    post :create, :sti => {  }
    expect(Sti.count) == 1
    puts @response.instance_variables
    #expect(@response.redirected_to) == sti_path(assigns(:sti))
  end
  
end



# 

# 
#     assert_redirected_to sti_path(assigns(:sti))
#   end
# 
#   def test_should_show_sti
#     get :show, :id => stis(:one).id
#     assert_response :success
#   end
# 
#   def test_should_get_edit
#     get :edit, :id => stis(:one).id
#     assert_response :success
#   end
# 
#   def test_should_update_sti
#     put :update, :id => stis(:one).id, :sti => { }
#     assert_redirected_to sti_path(assigns(:sti))
#   end
# 
#   def test_should_destroy_sti
#     assert_difference('Sti.count', -1) do
#       delete :destroy, :id => stis(:one).id
#     end
# 
#     assert_redirected_to stis_path
#   end
# end
