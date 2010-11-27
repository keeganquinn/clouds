require 'spec_helper'

describe "posts/new.html.haml" do
  before(:each) do
    assign :post, stub_model(Post).as_new_record
  end

  it "renders new post form" do
    render

    assert_select "form", :action => posts_path, :method => "post" do end
  end
end
