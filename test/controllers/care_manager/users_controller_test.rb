require "test_helper"

class CareManager::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get care_manager_users_new_url
    assert_response :success
  end

  test "should get index" do
    get care_manager_users_index_url
    assert_response :success
  end

  test "should get show" do
    get care_manager_users_show_url
    assert_response :success
  end

  test "should get edit" do
    get care_manager_users_edit_url
    assert_response :success
  end
end
