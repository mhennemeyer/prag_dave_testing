require File.dirname(__FILE__) + '/../test_helper'

class StisControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:stis)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_sti
    assert_difference('Sti.count') do
      post :create, :sti => { }
    end

    assert_redirected_to sti_path(assigns(:sti))
  end

  def test_should_show_sti
    get :show, :id => stis(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => stis(:one).id
    assert_response :success
  end

  def test_should_update_sti
    put :update, :id => stis(:one).id, :sti => { }
    assert_redirected_to sti_path(assigns(:sti))
  end

  def test_should_destroy_sti
    assert_difference('Sti.count', -1) do
      delete :destroy, :id => stis(:one).id
    end

    assert_redirected_to stis_path
  end
end
