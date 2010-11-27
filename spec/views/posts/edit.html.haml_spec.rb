require 'spec_helper'

describe "posts/edit.html.haml" do
  before(:each) do
    assign :post, @post = stub_model(Post, :new_record? => false, :code => 'test', :user => stub_model(User))
  end

  it "renders the edit post form" do
    render

    assert_select "form", :action => user_post_path(@post.user, @post), :method => "post" do end
  end
end
