require 'spec_helper'

describe "posts/show.html.haml" do
  before(:each) do
    assign :post, stub_model(Post, :created_at => Time.now, :user => stub_model(User))
  end

  it "renders attributes in <p>" do
    render
  end
end
