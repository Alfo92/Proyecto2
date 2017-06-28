require 'test_helper'

class ListingsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get step2" do
    get :step2
    assert_response :success
  end

  test "should get step3" do
    get :step3
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
