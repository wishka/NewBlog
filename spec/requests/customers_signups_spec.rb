require 'rails_helper'

RSpec.describe "CustomersSignups", type: :request do
  describe "GET /customers_signups" do
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

    it "valid signup information" do
      get signup_path
      assert_difference 'Customer.count', 1 do
        post_via_redirect customers_path, customer: { name:  "Example Customer",
                                                email: "customer@example.com",
                                                password:              "password",
                                                password_confirmation: "password" }
      end
      assert_template 'customers/show'
    end
  end
end
