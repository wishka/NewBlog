require 'rails_helper'

RSpec.describe "BlogPages", type: :request do
  it "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Home | Blog with BlackList"
  end

  it "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | Blog with BlackList"
  end

  it "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | Blog with BlackList"
  end

  it "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | Blog with BlackList"
  end
end
