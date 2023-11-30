require "test_helper"

class CutawaysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cutaways_index_url
    assert_response :success
  end

  test "should get profile" do
    get cutaways_profile_url
    assert_response :success
  end

  test "should get blog" do
    get cutaways_blog_url
    assert_response :success
  end

  test "should get pricing" do
    get cutaways_pricing_url
    assert_response :success
  end
end
