require File.dirname(__FILE__) + '/../test_helper'

class ModelsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:models)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_model
    assert_difference('Model.count') do
      post :create, :model => { }
    end

    assert_redirected_to model_path(assigns(:model))
  end

  def test_should_show_model
    get :show, :id => models(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => models(:one).id
    assert_response :success
  end

  def test_should_update_model
    put :update, :id => models(:one).id, :model => { }
    assert_redirected_to model_path(assigns(:model))
  end

  def test_should_destroy_model
    assert_difference('Model.count', -1) do
      delete :destroy, :id => models(:one).id
    end

    assert_redirected_to models_path
  end
end
