require "test_helper"

class Admin::DataAccessRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:one)
    @admin.update(admin: true)
    sign_in @admin
    @request = data_access_requests(:one)
  end

  test "should get index" do
    get admin_data_access_requests_url
    assert_response :success
  end

  test "should update data access request" do
    patch admin_data_access_request_url(@request, locale: I18n.default_locale), params: { status: "approved" }
    assert_redirected_to admin_data_access_requests_url(locale: I18n.default_locale)
  end
end
