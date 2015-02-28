require 'test_helper'

class NfesControllerTest < ActionController::TestCase
  setup do
    @nfe = nfes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nfes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nfe" do
    assert_difference('Nfe.count') do
      post :create, nfe: { number: @nfe.number, sender_id: @nfe.sender_id, series: @nfe.series, signed_xml: @nfe.signed_xml }
    end

    assert_redirected_to nfe_path(assigns(:nfe))
  end

  test "should show nfe" do
    get :show, id: @nfe
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nfe
    assert_response :success
  end

  test "should update nfe" do
    patch :update, id: @nfe, nfe: { number: @nfe.number, sender_id: @nfe.sender_id, series: @nfe.series, signed_xml: @nfe.signed_xml }
    assert_redirected_to nfe_path(assigns(:nfe))
  end

  test "should destroy nfe" do
    assert_difference('Nfe.count', -1) do
      delete :destroy, id: @nfe
    end

    assert_redirected_to nfes_path
  end
end
