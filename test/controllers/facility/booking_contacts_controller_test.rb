require "test_helper"

class Facility::BookingContactsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get facility_booking_contacts_index_url
    assert_response :success
  end

  test "should get show" do
    get facility_booking_contacts_show_url
    assert_response :success
  end

  test "should get reply" do
    get facility_booking_contacts_reply_url
    assert_response :success
  end
end
