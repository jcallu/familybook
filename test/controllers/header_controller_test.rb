require 'test_helper'

class HeaderControllerTest < ActionController::TestCase
  test "should get _header" do
    get :_header
    assert_response :success
  end

end
