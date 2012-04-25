require 'spec_helper'

describe "posts/edit" do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }

  it "renders the edit post form" do
    assign :post, post

    render

    assert_select 'form', action: user_post_path(user, post), method: 'post' do
      assert_select 'input', name: 'commit', type: 'submit', value: 'Save'
    end
  end
end
