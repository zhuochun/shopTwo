require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get view" do
    get :view
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get employee" do
    get :employee
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

end
