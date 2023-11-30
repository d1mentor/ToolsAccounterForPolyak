require "test_helper"

class ActsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @act = acts(:one)
  end

  test "should get index" do
    get acts_url
    assert_response :success
  end

  test "should get new" do
    get new_act_url
    assert_response :success
  end

  test "should create act" do
    assert_difference("Act.count") do
      post acts_url, params: { act: { comment: @act.comment, company_id: @act.company_id, images: @act.images, instrument_id: @act.instrument_id, intstrument_state: @act.intstrument_state, previous_act_id: @act.previous_act_id, user_id: @act.user_id } }
    end

    assert_redirected_to act_url(Act.last)
  end

  test "should show act" do
    get act_url(@act)
    assert_response :success
  end

  test "should get edit" do
    get edit_act_url(@act)
    assert_response :success
  end

  test "should update act" do
    patch act_url(@act), params: { act: { comment: @act.comment, company_id: @act.company_id, images: @act.images, instrument_id: @act.instrument_id, intstrument_state: @act.intstrument_state, previous_act_id: @act.previous_act_id, user_id: @act.user_id } }
    assert_redirected_to act_url(@act)
  end

  test "should destroy act" do
    assert_difference("Act.count", -1) do
      delete act_url(@act)
    end

    assert_redirected_to acts_url
  end
end
