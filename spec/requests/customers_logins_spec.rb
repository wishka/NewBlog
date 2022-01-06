require 'rails_helper'

RSpec.describe "CustomersLogins", type: :request do
  describe "GET /customers_logins" do
    def setup
      @customer = customers(:michael)
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
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path,      count: 0
      assert_select "a[href=?]", customer_path(@customer), count: 0
    end
  end
end
