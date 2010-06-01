require 'test_helper'

class ExternalUsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:external_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create external_user" do
    assert_difference('ExternalUser.count') do
      post :create, :external_user => { }
    end

    assert_redirected_to external_user_path(assigns(:external_user))
  end

  test "should show external_user" do
    get :show, :id => external_users(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => external_users(:one).to_param
    assert_response :success
  end

  test "should update external_user" do
    put :update, :id => external_users(:one).to_param, :external_user => { }
    assert_redirected_to external_user_path(assigns(:external_user))
  end

  test "should destroy external_user" do
    assert_difference('ExternalUser.count', -1) do
      delete :destroy, :id => external_users(:one).to_param
    end

    assert_redirected_to external_users_path
  end
end
