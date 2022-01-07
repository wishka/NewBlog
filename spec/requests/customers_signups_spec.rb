require 'rails_helper'

RSpec.describe "CustomersSignups", type: :request do
  describe "GET /customers_signups" do

    def setup
      ActionMailer::Base.deliveries.clear
    end

    it "invalid signup information" do
      get signup_path
      assert_no_difference 'Customer.count' do
        post customers_path, customer: { name:  "",
                                email: "customer@invalid",
                                password:              "foo",
                                password_confirmation: "bar" }
      end
      assert_template 'customers/new'
    end

    it "valid signup information with account activation" do
      get signup_path
      assert_difference 'Customer.count', 1 do
        post customers_path, customer: { name:  "Example Customer",
                                                email: "customer@example.com",
                                                password:              "password",
                                                password_confirmation: "password" }
      end
      assert_equal 1, ActionMailer::Base.deliveries.size
      customer = assigns(:customer)
      assert_not customer.activated?
      # Попытка войти до активации
      log_in_as(customer)
      assert_not is_logged_in?
      # Невалидный активационный токен
      get edit_account_activation_path("invalid token")
      assert_not is_logged_in?
      # Валидный токен, неверный адрес электронной почты
      get edit_account_activation_path(customer.activation_token, email: 'wrong')
      assert_not is_logged_in?
      # Валидный активационный токен и адрес почты
      get edit_account_activation_path(customer.activation_token, email: customer.email)
      assert customer.reload.activated?
      follow_redirect!
      assert_template 'customers/show'
      assert is_logged_in?
    end
  end
end
