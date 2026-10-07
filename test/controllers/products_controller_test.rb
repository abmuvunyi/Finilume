require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @product = products(:one)
    @product.update(user: @user)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: { category: @product.category, name: @product.name, price: @product.price, quantity: @product.quantity, user_id: @user.id } }
    end

    assert_redirected_to product_url(Product.last, locale: I18n.default_locale)
  end

  test "should show product" do
    get product_url(@product, locale: I18n.default_locale)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product, locale: I18n.default_locale)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product, locale: I18n.default_locale), params: { product: { category: @product.category, name: @product.name, price: @product.price, quantity: @product.quantity, user_id: @user.id } }
    assert_redirected_to product_url(@product, locale: I18n.default_locale)
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      @product.sales.destroy_all; delete product_url(@product, locale: I18n.default_locale)
    end

    assert_redirected_to products_url
  end
end
