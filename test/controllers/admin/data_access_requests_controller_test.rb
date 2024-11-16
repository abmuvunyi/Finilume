require "test_helper"

class Admin::DataAccessRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_data_access_requests_index_url
    assert_response :success
  end

  test "should get update" do
    get admin_data_access_requests_update_url
    assert_response :success
  end
end
