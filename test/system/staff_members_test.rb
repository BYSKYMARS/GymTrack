require "application_system_test_case"

class StaffMembersTest < ApplicationSystemTestCase
  setup do
    @staff_member = staff_members(:one)
  end

  test "visiting the index" do
    visit staff_members_url
    assert_selector "h1", text: "Staff members"
  end

  test "should create staff member" do
    visit staff_members_url
    click_on "New staff member"

    fill_in "Email", with: @staff_member.email
    fill_in "Gym location", with: @staff_member.gym_location_id
    fill_in "Name", with: @staff_member.name
    fill_in "Role", with: @staff_member.role
    click_on "Create Staff member"

    assert_text "Staff member was successfully created"
    click_on "Back"
  end

  test "should update Staff member" do
    visit staff_member_url(@staff_member)
    click_on "Edit this staff member", match: :first

    fill_in "Email", with: @staff_member.email
    fill_in "Gym location", with: @staff_member.gym_location_id
    fill_in "Name", with: @staff_member.name
    fill_in "Role", with: @staff_member.role
    click_on "Update Staff member"

    assert_text "Staff member was successfully updated"
    click_on "Back"
  end

  test "should destroy Staff member" do
    visit staff_member_url(@staff_member)
    click_on "Destroy this staff member", match: :first

    assert_text "Staff member was successfully destroyed"
  end
end
