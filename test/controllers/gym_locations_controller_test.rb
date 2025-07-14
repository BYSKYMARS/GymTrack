require "test_helper"

class GymLocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gym_location = gym_locations(:one)
  end

  test "should get index" do
    get gym_locations_url
    assert_response :success
  end

  test "should get new" do
    get new_gym_location_url
    assert_response :success
  end

  test "should create gym_location" do
    assert_difference("GymLocation.count") do
      post gym_locations_url, params: { gym_location: { address: @gym_location.address, city_id: @gym_location.city_id, name: @gym_location.name } }
    end

    assert_redirected_to gym_location_url(GymLocation.last)
  end

  test "should show gym_location" do
    get gym_location_url(@gym_location)
    assert_response :success
  end

  test "should get edit" do
    get edit_gym_location_url(@gym_location)
    assert_response :success
  end

  test "should update gym_location" do
    patch gym_location_url(@gym_location), params: { gym_location: { address: @gym_location.address, city_id: @gym_location.city_id, name: @gym_location.name } }
    assert_redirected_to gym_location_url(@gym_location)
  end

  test "should destroy gym_location" do
    assert_difference("GymLocation.count", -1) do
      delete gym_location_url(@gym_location)
    end

    assert_redirected_to gym_locations_url
  end
end
