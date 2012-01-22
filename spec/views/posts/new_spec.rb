require 'spec_helper'

describe "posts/new" do
  it "renders the new post form" do
    assign :post, stub_model(Post).as_new_record

    render

    assert_select "form", :action => posts_path, :method => "post" do
      assert_select "input", :name => "commit", :type => "submit", :value => "Create"
    end
  end
end
