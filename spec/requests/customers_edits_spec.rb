require 'rails_helper'

RSpec.describe "CustomersEdits", type: :request do
  describe "GET /customers_edits" do
    it "unsuccessful edit" do
      log_in_as(@customer)
      get edit_customer_path(@customer)
      assert_template 'customers/edit'
      patch customer_path(@customer), customer: { name:  "",
                                   email: "foo@invalid",
                                   password:              "foo",
                                   password_confirmation: "bar" }
      assert_template 'customers/edit'
    end

    it "successful edit" do
      get edit_customer_path(@customer)
      log_in_as(@customer)
      assert_redirected_to edit_customer_path(@customer)
      name  = "Foo Bar"
      email = "foo@bar.com"
      patch customer_path(@customer), customer: { name:  name,
                                      email: email,
                                      password:              "",
                                      password_confirmation: "" }
      assert_not flash.empty?
      assert_redirected_to @customer
      @customer.reload
      assert_equal name,  @customer.name
      assert_equal email, @customer.email
    end
  end
end
