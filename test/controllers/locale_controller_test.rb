require "test_helper"

class LocaleControllerTest < ActionDispatch::IntegrationTest
  test "should get set_locale" do
    get locale_set_locale_url
    assert_response :success
  end
end
