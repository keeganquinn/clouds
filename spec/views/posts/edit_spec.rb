require 'spec_helper'

describe "posts/edit" do
  it "renders the edit post form" do
    assign :post, @post = stub_model(Post, new_record?: false, code: 'test', user: stub_model(User, username: 'test'))

    render

    assert_select 'form', action: user_post_path(@post.user, @post), method: 'post' do
      assert_select 'input', name: 'commit', type: 'submit', value: 'Save'
    end
  end
end
