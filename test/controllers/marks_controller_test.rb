require "test_helper"

class MarksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get marks_index_url
    assert_response :success
  end

  test "should get show" do
    get marks_show_url
    assert_response :success
  end
end
