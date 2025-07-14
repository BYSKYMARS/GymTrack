require "application_system_test_case"

class GymLocationsTest < ApplicationSystemTestCase
  setup do
    @gym_location = gym_locations(:one)
  end

  test "visiting the index" do
    visit gym_locations_url
    assert_selector "h1", text: "Gym locations"
  end

  test "should create gym location" do
    visit gym_locations_url
    click_on "New gym location"

    fill_in "Address", with: @gym_location.address
    fill_in "City", with: @gym_location.city_id
    fill_in "Name", with: @gym_location.name
    click_on "Create Gym location"

    assert_text "Gym location was successfully created"
    click_on "Back"
  end

  test "should update Gym location" do
    visit gym_location_url(@gym_location)
    click_on "Edit this gym location", match: :first

    fill_in "Address", with: @gym_location.address
    fill_in "City", with: @gym_location.city_id
    fill_in "Name", with: @gym_location.name
    click_on "Update Gym location"

    assert_text "Gym location was successfully updated"
    click_on "Back"
  end

  test "should destroy Gym location" do
    visit gym_location_url(@gym_location)
    click_on "Destroy this gym location", match: :first

    assert_text "Gym location was successfully destroyed"
  end
end
