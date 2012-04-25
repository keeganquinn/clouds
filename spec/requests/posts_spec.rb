require 'spec_helper'

describe "Posts workflow" do
  login_user

  it "redirects properly after a Post is created and updated" do
    get new_post_path
    response.should render_template(:new)

    post posts_path, post: { code: '', subject: 'Test', body: 'Just a test!' }
    response.should redirect_to(user_post_path(@user, assigns(:post)))

    follow_redirect!
    response.should render_template(:show)
    response.body.should include("created successfully")

    put user_post_path(@user, assigns(:post)), post: { body: 'Slightly different test.' }
    response.should redirect_to(user_post_path(@user, assigns(:post)))

    follow_redirect!
    response.should render_template(:show)
    response.body.should include("updated successfully")
  end
end
