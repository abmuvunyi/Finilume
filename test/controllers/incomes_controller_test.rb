require "test_helper"

class IncomesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @income = incomes(:one)
    @income.update(user: @user)
  end

  test "should get index" do
    get incomes_url
    assert_response :success
  end

  test "should get new" do
    get new_income_url
    assert_response :success
  end

  test "should create income" do
    assert_difference("Income.count") do
      post incomes_url, params: { income: { amount: @income.amount, category: @income.category, date: @income.date, name: @income.name, user_id: @user.id } }
    end

    assert_redirected_to income_url(Income.last, locale: I18n.default_locale)
  end

  test "should show income" do
    get income_url(@income, locale: I18n.default_locale)
    assert_response :success
  end

  test "should get edit" do
    get edit_income_url(@income, locale: I18n.default_locale)
    assert_response :success
  end

  test "should update income" do
    patch income_url(@income, locale: I18n.default_locale), params: { income: { amount: @income.amount, category: @income.category, date: @income.date, name: @income.name, user_id: @user.id } }
    assert_redirected_to income_url(@income, locale: I18n.default_locale)
  end

  test "should destroy income" do
    assert_difference("Income.count", -1) do
      delete income_url(@income, locale: I18n.default_locale)
    end

    assert_redirected_to incomes_url
  end
end
