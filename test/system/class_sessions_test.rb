require "application_system_test_case"

class ClassSessionsTest < ApplicationSystemTestCase
  setup do
    @class_session = class_sessions(:one)
  end

  test "visiting the index" do
    visit class_sessions_url
    assert_selector "h1", text: "Class sessions"
  end

  test "should create class session" do
    visit class_sessions_url
    click_on "New class session"

    fill_in "Activity", with: @class_session.activity_id
    fill_in "Class schedule", with: @class_session.class_schedule_id
    fill_in "Ends at", with: @class_session.ends_at
    fill_in "Max participants", with: @class_session.max_participants
    fill_in "Room", with: @class_session.room_id
    fill_in "Starts at", with: @class_session.starts_at
    fill_in "Trainer", with: @class_session.trainer_id
    click_on "Create Class session"

    assert_text "Class session was successfully created"
    click_on "Back"
  end

  test "should update Class session" do
    visit class_session_url(@class_session)
    click_on "Edit this class session", match: :first

    fill_in "Activity", with: @class_session.activity_id
    fill_in "Class schedule", with: @class_session.class_schedule_id
    fill_in "Ends at", with: @class_session.ends_at.to_s
    fill_in "Max participants", with: @class_session.max_participants
    fill_in "Room", with: @class_session.room_id
    fill_in "Starts at", with: @class_session.starts_at.to_s
    fill_in "Trainer", with: @class_session.trainer_id
    click_on "Update Class session"

    assert_text "Class session was successfully updated"
    click_on "Back"
  end

  test "should destroy Class session" do
    visit class_session_url(@class_session)
    click_on "Destroy this class session", match: :first

    assert_text "Class session was successfully destroyed"
  end
end
