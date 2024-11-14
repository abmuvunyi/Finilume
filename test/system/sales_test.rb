require "application_system_test_case"

class SalesTest < ApplicationSystemTestCase
  setup do
    @sale = sales(:one)
  end

  test "visiting the index" do
    visit sales_url
    assert_selector "h1", text: "Sales"
  end

  test "should create sale" do
    visit sales_url
    click_on "New sale"

    fill_in "Date", with: @sale.date
    fill_in "Product", with: @sale.product_id
    fill_in "Quantity", with: @sale.quantity
    fill_in "Total price", with: @sale.total_price
    fill_in "User", with: @sale.user_id
    click_on "Create Sale"

    assert_text "Sale was successfully created"
    click_on "Back"
  end

  test "should update Sale" do
    visit sale_url(@sale)
    click_on "Edit this sale", match: :first

    fill_in "Date", with: @sale.date.to_s
    fill_in "Product", with: @sale.product_id
    fill_in "Quantity", with: @sale.quantity
    fill_in "Total price", with: @sale.total_price
    fill_in "User", with: @sale.user_id
    click_on "Update Sale"

    assert_text "Sale was successfully updated"
    click_on "Back"
  end

  test "should destroy Sale" do
    visit sale_url(@sale)
    click_on "Destroy this sale", match: :first

    assert_text "Sale was successfully destroyed"
  end
end
