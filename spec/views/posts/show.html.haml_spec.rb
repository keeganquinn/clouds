require 'spec_helper'

describe "posts/show.html.haml" do
  it "renders a post" do
    assign :post, stub_model(Post, :subject => "Test", :body => "Just a test.", :created_at => Time.now, :user => stub_model(User))

    render

    rendered.should =~ /Just a test/
  end
end
