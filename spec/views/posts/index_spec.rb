require 'spec_helper'

describe "posts/index" do
  it "renders a list of posts" do
    posts = [
      stub_model(Post, code: 'test12', created_at: Time.now, user: stub_model(User, username: 'test')),
      stub_model(Post, code: 'test23', created_at: Time.now, user: stub_model(User, username: 'test'))
    ]
    posts.stub total_pages: 1
    assign :posts, posts

    render

    rendered.should =~ /test12/
    rendered.should =~ /test23/
  end
end
