require 'spec_helper'

describe "posts/new" do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }

  it "renders the new post form" do
    assign :post, post

    render

    assert_select "form", action: posts_path, method: "post" do
      assert_select "input", name: "commit", type: "submit", value: "Create"
    end
  end
end
