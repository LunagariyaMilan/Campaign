require 'test_helper'

class Spree::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get spree_admin_categories_create_url
    assert_response :success
  end

  test "should get index" do
    get spree_admin_categories_index_url
    assert_response :success
  end

  test "should get new" do
    get spree_admin_categories_new_url
    assert_response :success
  end

  test "should get edit" do
    get spree_admin_categories_edit_url
    assert_response :success
  end

end
