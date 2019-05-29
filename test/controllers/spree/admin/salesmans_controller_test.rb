require 'test_helper'

class Spree::Admin::SalesmansControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get spree_admin_salesmans_create_url
    assert_response :success
  end

  test "should get new" do
    get spree_admin_salesmans_new_url
    assert_response :success
  end

  test "should get edit" do
    get spree_admin_salesmans_edit_url
    assert_response :success
  end

end
