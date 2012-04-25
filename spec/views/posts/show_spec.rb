require 'spec_helper'

describe "posts/show" do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }

  it "renders a post" do
    assign :post, post

    render

    rendered.should =~ /#{post.body}/
  end
end
