require "test_helper"

class CareManager::CareManagersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get care_manager_care_managers_show_url
    assert_response :success
  end

  test "should get edit" do
    get care_manager_care_managers_edit_url
    assert_response :success
  end

  test "should get unsubscribe" do
    get care_manager_care_managers_unsubscribe_url
    assert_response :success
  end
end
