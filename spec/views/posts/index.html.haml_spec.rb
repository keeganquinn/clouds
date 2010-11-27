require 'spec_helper'

describe "posts/index.html.haml" do
  before(:each) do
    assign :posts, [ stub_model(Post, :code => 'test', :created_at => Time.now, :user => stub_model(User)), stub_model(Post, :code => 'test', :created_at => Time.now, :user => stub_model(User)) ]
  end

  it "renders a list of posts" do
    render
  end
end
