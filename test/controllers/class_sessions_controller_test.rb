require "test_helper"

class ClassSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @class_session = class_sessions(:one)
  end

  test "should get index" do
    get class_sessions_url
    assert_response :success
  end

  test "should get new" do
    get new_class_session_url
    assert_response :success
  end

  test "should create class_session" do
    assert_difference("ClassSession.count") do
      post class_sessions_url, params: { class_session: { activity_id: @class_session.activity_id, class_schedule_id: @class_session.class_schedule_id, ends_at: @class_session.ends_at, max_participants: @class_session.max_participants, room_id: @class_session.room_id, starts_at: @class_session.starts_at, trainer_id: @class_session.trainer_id } }
    end

    assert_redirected_to class_session_url(ClassSession.last)
  end

  test "should show class_session" do
    get class_session_url(@class_session)
    assert_response :success
  end

  test "should get edit" do
    get edit_class_session_url(@class_session)
    assert_response :success
  end

  test "should update class_session" do
    patch class_session_url(@class_session), params: { class_session: { activity_id: @class_session.activity_id, class_schedule_id: @class_session.class_schedule_id, ends_at: @class_session.ends_at, max_participants: @class_session.max_participants, room_id: @class_session.room_id, starts_at: @class_session.starts_at, trainer_id: @class_session.trainer_id } }
    assert_redirected_to class_session_url(@class_session)
  end

  test "should destroy class_session" do
    assert_difference("ClassSession.count", -1) do
      delete class_session_url(@class_session)
    end

    assert_redirected_to class_sessions_url
  end
end
