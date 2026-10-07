require "test_helper"

class SalesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @sale = sales(:one)
    @sale.update(user: @user)
  end

  test "should get index" do
    get sales_url
    assert_response :success
  end

  test "should get new" do
    get new_sale_url
    assert_response :success
  end

  test "should create sale" do
    assert_difference("Sale.count") do
      post sales_url, params: { sale: { date: @sale.date, product_id: @sale.product_id, quantity: @sale.quantity, total_price: @sale.total_price, user_id: @user.id } }
    end

    assert_redirected_to sale_url(Sale.last, locale: I18n.default_locale)
  end

  test "should show sale" do
    get sale_url(@sale, locale: I18n.default_locale)
    assert_response :success
  end

  test "should get edit" do
    get edit_sale_url(@sale, locale: I18n.default_locale)
    assert_response :success
  end

  test "should update sale" do
    patch sale_url(@sale, locale: I18n.default_locale), params: { sale: { date: @sale.date, product_id: @sale.product_id, quantity: @sale.quantity, total_price: @sale.total_price, user_id: @user.id } }
    assert_redirected_to sale_url(@sale, locale: I18n.default_locale)
  end

  test "should destroy sale" do
    assert_difference("Sale.count", -1) do
      delete sale_url(@sale, locale: I18n.default_locale)
    end

    assert_redirected_to sales_url
  end
end
