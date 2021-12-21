require 'rails_helper'

RSpec.describe "SiteLayouts", type: :request do
  describe "GET /site_layouts" do
    it "layout links" do
      get root_path
      assert_template 'blog_pages/home'
      assert_select "a[href=?]", root_path, count: 2
      assert_select "a[href=?]", help_path
      assert_select "a[href=?]", about_path
      assert_select "a[href=?]", contact_path
    end
  end
end
