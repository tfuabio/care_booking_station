require "test_helper"

class CareManager::UsePlansControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get care_manager_use_plans_new_url
    assert_response :success
  end

  test "should get show" do
    get care_manager_use_plans_show_url
    assert_response :success
  end

  test "should get edit" do
    get care_manager_use_plans_edit_url
    assert_response :success
  end

  test "should get index" do
    get care_manager_use_plans_index_url
    assert_response :success
  end
end
