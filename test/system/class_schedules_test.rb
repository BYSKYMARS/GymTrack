require "application_system_test_case"

class ClassSchedulesTest < ApplicationSystemTestCase
  setup do
    @class_schedule = class_schedules(:one)
  end

  test "visiting the index" do
    visit class_schedules_url
    assert_selector "h1", text: "Class schedules"
  end

  test "should create class schedule" do
    visit class_schedules_url
    click_on "New class schedule"

    fill_in "Activity", with: @class_schedule.activity_id
    fill_in "End time", with: @class_schedule.end_time
    fill_in "Room", with: @class_schedule.room_id
    fill_in "Start time", with: @class_schedule.start_time
    fill_in "Trainer", with: @class_schedule.trainer_id
    fill_in "Weekday", with: @class_schedule.weekday
    click_on "Create Class schedule"

    assert_text "Class schedule was successfully created"
    click_on "Back"
  end

  test "should update Class schedule" do
    visit class_schedule_url(@class_schedule)
    click_on "Edit this class schedule", match: :first

    fill_in "Activity", with: @class_schedule.activity_id
    fill_in "End time", with: @class_schedule.end_time.to_s
    fill_in "Room", with: @class_schedule.room_id
    fill_in "Start time", with: @class_schedule.start_time.to_s
    fill_in "Trainer", with: @class_schedule.trainer_id
    fill_in "Weekday", with: @class_schedule.weekday
    click_on "Update Class schedule"

    assert_text "Class schedule was successfully updated"
    click_on "Back"
  end

  test "should destroy Class schedule" do
    visit class_schedule_url(@class_schedule)
    click_on "Destroy this class schedule", match: :first

    assert_text "Class schedule was successfully destroyed"
  end
end
