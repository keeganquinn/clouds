require 'spec_helper'

describe PostsController do
  def mock_post(stubs = {})
    (@mock_post ||= mock_model(Post).as_null_object).tap do |post|
      post.stub(stubs) unless stubs.empty?
    end
  end

  def mock_user(stubs = {})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(:to_hash => {:id => 1}, :to_int => 1)
      user.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all posts as @posts" do
      Post.stub_chain(:top, :paginate).and_return([mock_post])

      get :index
      assigns(:posts).should eq([mock_post])
    end
  end

  describe "GET show" do
    it "assigns the requested post as @post" do
      User.stub(:find_by_param).with("someone") { mock_user }
      mock_user.posts.stub(:find_by_param).with("37") { mock_post }

      get :show, :user_id => "someone", :id => "37"
      assigns(:post).should be(mock_post)
    end
  end

  describe "GET new" do
    it "requires that a user is signed in" do
      get :new
      response.should redirect_to(new_user_session_path)
    end

    it "assigns a new post as @post" do
      controller.sign_in mock_user
      mock_user.posts.stub(:new) { mock_post }

      get :new
      assigns(:post).should be(mock_post)
    end
  end

  describe "GET edit" do
    it "requires that a user is signed in" do
      get :edit, :user_id => "someone", :id => "37"
      response.should redirect_to(new_user_session_path)
    end

    it "assigns the requested post as @post" do
      controller.sign_in mock_user
      mock_user.posts.stub(:find_by_param).with("37") { mock_post }

      get :edit, :user_id => "someone", :id => "37"
      assigns(:post).should be(mock_post)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "requires that a user is signed in" do
        post :create, :post => {'these' => 'params'}
        response.should redirect_to(new_user_session_path)
      end

      it "assigns a newly created post as @post" do
        controller.sign_in mock_user
        mock_user.posts.stub(:new).with({'these' => 'params'}) {
          mock_post(:save => true)
        }

        post :create, :post => {'these' => 'params'}
        assigns(:post).should be(mock_post)
      end

      it "redirects to the created post" do
        controller.sign_in mock_user
        mock_user.posts.stub(:new) { mock_post(:save => true) }

        post :create, :post => {}
        response.should redirect_to(user_post_path(mock_user, mock_post))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved post as @post" do
        controller.sign_in mock_user
        mock_user.posts.stub(:new).with({'these' => 'params'}) {
          mock_post(:save => false)
        }

        post :create, :post => {'these' => 'params'}
        assigns(:post).should be(mock_post)
      end

      it "re-renders the 'new' template" do
        controller.sign_in mock_user
        mock_user.posts.stub(:new) { mock_post(:save => false) }

        post :create, :post => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "requires that a user is signed in" do
        put(:update, :user_id => "joe", :id => "37",
            :post => { 'these' => 'params' })
        response.should redirect_to(new_user_session_path)
      end

      it "updates the requested post" do
        controller.sign_in mock_user
        mock_user.posts.should_receive(:find_by_param).with("37") { mock_post }
        mock_post.should_receive(:update_attributes).with({'these' => 'params'})

        put(:update, :user_id => "joe", :id => "37",
            :post => {'these' => 'params'})
      end

      it "assigns the requested post as @post" do
        controller.sign_in mock_user
        mock_user.posts.stub(:find_by_param) {
          mock_post(:update_attributes => true)
        }

        put :update, :user_id => "joe", :id => "1"
        assigns(:post).should be(mock_post)
      end

      it "redirects to the post" do
        controller.sign_in mock_user
        mock_user.posts.stub(:find_by_param) {
          mock_post(:update_attributes => true)
        }

        put :update, :user_id => "joe", :id => "1"
        response.should redirect_to(user_post_path(mock_user, mock_post))
      end
    end

    describe "with invalid params" do
      it "assigns the post as @post" do
        controller.sign_in mock_user
        mock_user.posts.stub(:find_by_param) {
          mock_post(:update_attributes => false)
        }

        put :update, :user_id => "joe", :id => "1"
        assigns(:post).should be(mock_post)
      end

      it "re-renders the 'edit' template" do
        controller.sign_in mock_user
        mock_user.posts.stub(:find_by_param) {
          mock_post(:update_attributes => false)
        }

        put :update, :user_id => "joe", :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "requires that a user is signed in" do
      delete :destroy, :user_id => "joe", :id => "37"
      response.should redirect_to(new_user_session_path)
    end

    it "destroys the requested post" do
      controller.sign_in mock_user
      mock_user.posts.should_receive(:find_by_param).with("37") { mock_post }
      mock_post.should_receive(:destroy)

      delete :destroy, :user_id => "joe", :id => "37"
    end

    it "redirects to the posts list" do
      controller.sign_in mock_user
      mock_user.posts.stub(:find_by_param) { mock_post }

      delete :destroy, :user_id => "joe", :id => "1"
      response.should redirect_to(user_posts_path(mock_user))
    end
  end
end
