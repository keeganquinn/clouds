require 'spec_helper'

describe "posts/index" do
  let(:user) { create(:user) }
  let!(:posts) { [ create(:post, user: user), create(:post, user: user) ] }

  it "renders a list of posts" do
    assign :posts, Post.top.paginate(page: 1)

    render

    posts.each do |post|
      rendered.should =~ /#{post.code}/
    end
  end
end
