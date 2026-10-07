require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @expense = expenses(:one)
    @expense.update(user: @user)
  end

  test "should get index" do
    get expenses_url
    assert_response :success
  end

  test "should get new" do
    get new_expense_url
    assert_response :success
  end

  test "should create expense" do
    assert_difference("Expense.count") do
      post expenses_url, params: { expense: { amount: @expense.amount, category: @expense.category, date: @expense.date, name: @expense.name, user_id: @user.id } }
    end

    assert_redirected_to expense_url(Expense.last, locale: I18n.default_locale)
  end

  test "should show expense" do
    get expense_url(@expense, locale: I18n.default_locale)
    assert_response :success
  end

  test "should get edit" do
    get edit_expense_url(@expense, locale: I18n.default_locale)
    assert_response :success
  end

  test "should update expense" do
    patch expense_url(@expense, locale: I18n.default_locale), params: { expense: { amount: @expense.amount, category: @expense.category, date: @expense.date, name: @expense.name, user_id: @user.id } }
    assert_redirected_to expense_url(@expense, locale: I18n.default_locale)
  end

  test "should destroy expense" do
    assert_difference("Expense.count", -1) do
      delete expense_url(@expense, locale: I18n.default_locale)
    end

    assert_redirected_to expenses_url
  end
end
