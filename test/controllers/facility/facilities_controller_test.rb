require "test_helper"

class Facility::FacilitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get facility_facilities_show_url
    assert_response :success
  end

  test "should get edit" do
    get facility_facilities_edit_url
    assert_response :success
  end

  test "should get unsubscribe" do
    get facility_facilities_unsubscribe_url
    assert_response :success
  end
end
