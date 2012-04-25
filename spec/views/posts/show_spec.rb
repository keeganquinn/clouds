require 'spec_helper'

describe "posts/show" do
  it "renders a post" do
    assign :post, stub_model(Post, subject: "Test", body: "Just a test.", created_at: Time.now, user: stub_model(User, username: 'test'))

    render

    rendered.should =~ /Just a test/
  end
end
