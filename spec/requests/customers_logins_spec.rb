require 'rails_helper'

RSpec.describe "CustomersLogins", type: :request do
  describe "GET /customers_logins" do

    def is_logged_in?
      !session[:customer_id].nil?
    end

    def log_in_as(customer, options = {})
      password    = options[:password]    || 'password'
      remember_me = options[:remember_me] || '1'
      if integration_test?
      post login_path, session: { email:       customer.email,
                                  password:    password,
                                  remember_me: remember_me }
      else
        session[:customer_id] = customer.id
      end
    end

  private

    # Возвращает true внутри интеграционных тестов
    def integration_test?
      defined?(post_via_redirect)
    end

    it "login with invalid information" do
      get login_path
      assert_template 'sessions/new'
      post login_path, session: { email: "", password: "" }
      assert_template 'sessions/new'
      assert_not flash.empty?
      get root_path
      assert flash.empty?
    end

    it "login with valid information followed by logout" do
      get login_path
      post login_path, session: { email: @customer.email, password: 'password' }
      assert is_logged_in?
      assert_redirected_to @customer
      follow_redirect!
      assert_template 'customers/show'
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", customer_path(@customer)
      delete logout_path
      assert_not is_logged_in?
      assert_redirected_to root_url
      delete logout_path
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,      count: 0
      assert_select "a[href=?]", customer_path(@customer), count: 0
    end

    it "login with remembering" do
      log_in_as(@customer, remember_me: '1')
      assert_not_nil cookies['remember_token']
    end

    it "login without remembering" do
      log_in_as(@customer, remember_me: '0')
      assert_nil cookies['remember_token']
    end
  end
end
