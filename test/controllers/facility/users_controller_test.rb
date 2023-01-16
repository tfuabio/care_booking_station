require "test_helper"

class Facility::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get facility_users_index_url
    assert_response :success
  end

  test "should get show" do
    get facility_users_show_url
    assert_response :success
  end
end
