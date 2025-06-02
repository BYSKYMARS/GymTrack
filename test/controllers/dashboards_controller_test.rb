require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get ceo" do
    get dashboards_ceo_url
    assert_response :success
  end

  test "should get user" do
    get dashboards_user_url
    assert_response :success
  end
end
