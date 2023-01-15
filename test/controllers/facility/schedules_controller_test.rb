require "test_helper"

class Facility::SchedulesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get facility_schedules_index_url
    assert_response :success
  end

  test "should get show" do
    get facility_schedules_show_url
    assert_response :success
  end
end
