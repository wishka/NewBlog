require 'rails_helper'

RSpec.describe "Customers", type: :request do
  before do
    customer = create(:customer)
  end

  it "should redirect index when not logged in" do
    get "/customers"
    assert_redirected_to login_url
  end

  it "should get new" do
    get "/customers/new"
    assert_response :success
  end

  it "should redirect edit when not logged in" do
    get :edit, @customer.id
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  it "should redirect update when not logged in" do
    patch :update, @customer.id, customer: { name: @customer.name, email: @customer.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  it "should redirect edit when logged in as wrong customer" do
    log_in_as(@other_customer)
    get :edit, id: @customer
    assert flash.empty?
    assert_redirected_to root_url
  end

  it "should redirect update when logged in as wrong customer" do
    log_in_as(@other_customer)
    patch :update, id: @customer, customer: { name: @customer.name, email: @customer.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  it "should redirect destroy when not logged in" do
    assert_no_difference 'Customer.count' do
      delete :destroy, id: @customer
    end
    assert_redirected_to login_url
  end

  it "should redirect destroy when logged in as a non-admin" do
    log_in_as(@customer)
    assert_no_difference 'Customer.count' do
      delete :destroy, id: @customer
    end
    assert_redirected_to root_url
  end
end
