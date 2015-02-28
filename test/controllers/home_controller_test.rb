require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get index" do
    sign_in users(:administrator)
    get :index
    assert_response :success
    
# check logged menu
    assert_select "ul#signed_in li a", /Administrator/, "This page should contain the signed in menu."
  end
  
  test "should be redirected to sign in if not logged" do
    get :index
    assert_redirected_to new_user_session_path
    
# check logged menu
    assert_select "ul#signed_in li a", false, "This page should not contain the signed in menu."
  end
end
