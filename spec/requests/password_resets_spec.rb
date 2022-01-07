require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  describe "GET /password_resets" do
    def setup
      ActionMailer::Base.deliveries.clear
      @customer = customers(:michael)
    end

  it "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Неверный адрес электронной почты
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Правильный адрес электронной почты
    post password_resets_path, password_reset: { email: @customer.email }
    assert_not_equal @customer.reset_digest, @customer.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Форма смены пароля
    customer = assigns(:customer)
    # Неверный email
    get edit_password_reset_path(customer.reset_token, email: "")
    assert_redirected_to root_url
    # Неактивный пользователь
    customer.toggle!(:activated)
    get edit_password_reset_path(customer.reset_token, email: customer.email)
    assert_redirected_to root_url
    customer.toggle!(:activated)
    # Верный email, неправильный токен
    get edit_password_reset_path('wrong token', email: customer.email)
    assert_redirected_to root_url
    # Верный email, правильный токен
    get edit_password_reset_path(customer.reset_token, email: customer.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", customer.email
    # Невалидный пароль & подтверждение
    patch password_reset_path(customer.reset_token),
          email: customer.email,
          customer: { password:              "foobaz",
                  password_confirmation: "barquux" }
    assert_select 'div#error_explanation'
    # Пустой пароль
    patch password_reset_path(customer.reset_token),
          email: customer.email,
          customer: { password:              "",
                  password_confirmation: "" }
    assert_select 'div#error_explanation'
    # Валидный пароль & подтверждение
    patch password_reset_path(customer.reset_token),
          email: customer.email,
          customer: { password:              "foobaz",
                  password_confirmation: "foobaz" }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to customer
    end
  end
end
