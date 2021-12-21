require 'rails_helper'

RSpec.describe "Customers", type: :request do
  it "should get new" do
    get "/customers/new"
    assert_response :success
  end
end
