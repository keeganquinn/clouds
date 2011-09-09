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
    it "assigns all of a user's posts as @posts" do
      User.stub(:find_by_param).with("someone").and_return(mock_user)
      mock_user.posts.stub_chain(:top, :paginate).and_return([mock_post])

      get :index, :user_id => "someone"
      assigns(:user).should eq(mock_user)
      assigns(:posts).should eq([mock_post])
    end

    it "assigns all posts as @posts" do
      Post.stub_chain(:top, :paginate).and_return([mock_post])

      get :index
      assigns(:posts).should eq([mock_post])
    end

    it 'renders HTML when the html format is requested' do
      get :index, :format => :html
      response.should render_template("index")
    end

    it 'renders JSON when the json format is requested' do
      get :index, :format => :json
      response.content_type.should eq("application/json")
    end

    it 'renders XML when the xml format is requested' do
      get :index, :format => :xml
      response.content_type.should eq("application/xml")
    end
  end

  describe "GET show" do
    it "assigns the requested post as @post" do
      User.stub(:find_by_param).with("someone").and_return(mock_user)
      mock_user.posts.stub(:find_by_param).with("37").and_return(mock_post)

      get :show, :user_id => "someone", :id => "37"
      assigns(:post).should be(mock_post)
    end

    it 'renders HTML when the html format is requested' do
      User.stub(:find_by_param).with("someone").and_return(mock_user)
      mock_user.posts.stub(:find_by_param).with("37").and_return(mock_post)

      get :show, :user_id => "someone", :id => "37", :format => :html
      response.should render_template("show")
    end

    it 'renders JSON when the json format is requested' do
      User.stub(:find_by_param).with("someone").and_return(mock_user)
      mock_user.posts.stub(:find_by_param).with("37").and_return(mock_post)

      get :show, :user_id => "someone", :id => "37", :format => :json
      response.content_type.should eq("application/json")
    end

    it 'renders XML when the xml format is requested' do
      User.stub(:find_by_param).with("someone").and_return(mock_user)
      mock_user.posts.stub(:find_by_param).with("37").and_return(mock_post)

      get :show, :user_id => "someone", :id => "37", :format => :xml
      response.content_type.should eq("application/xml")
    end
  end

  describe "GET new" do
    it "requires that a user is signed in" do
      get :new
      response.should redirect_to(new_user_session_path)
    end

    it "assigns a new top-level post as @post" do
      controller.sign_in mock_user
      mock_user.posts.stub(:new).and_return(mock_post)

      get :new
      assigns(:post).should be(mock_post)
    end

    it "assigns a new reply post as @post" do
      controller.sign_in mock_user
      mock_user.posts.stub(:new).and_return(mock_post)

      Post.stub(:find).with("23").and_return(mock_post)
      mock_post.should_receive(:in_reply_to_post=).with(mock_post)

      get :new, :in_reply_to_post_id => "23"
      assigns(:post).should be(mock_post)
    end

    it "renders HTML when the html format is requested" do
      controller.sign_in mock_user
      mock_user.posts.stub(:new).and_return(mock_post)

      get :new, :format => :html
      response.should render_template("new")
    end

    it "renders JSON when the json format is requested" do
      controller.sign_in mock_user
      mock_user.posts.stub(:new).and_return(mock_post)

      get :new, :format => :json
      response.content_type.should eq("application/json")
    end

    it "renders XML when the xml format is requested" do
      controller.sign_in mock_user
      mock_user.posts.stub(:new).and_return(mock_post)

      get :new, :format => :xml
      response.content_type.should eq("application/xml")
    end
  end

  describe "GET edit" do
    it "requires that a user is signed in" do
      get :edit, :user_id => "someone", :id => "37"
      response.should redirect_to(new_user_session_path)
    end

    it "assigns the requested post as @post" do
      controller.sign_in mock_user
      mock_user.posts.stub(:find_by_param).with("37").and_return(mock_post)

      get :edit, :user_id => "someone", :id => "37"
      assigns(:post).should be(mock_post)
    end

    it "renders HTML template" do
      controller.sign_in mock_user
      mock_user.posts.stub(:find_by_param).with("37").and_return(mock_post)

      get :edit, :user_id => "someone", :id => "37"
      response.should render_template("edit")
    end
  end

  describe "POST create" do
    it "requires that a user is signed in" do
      post :create, :post => {}
      response.should redirect_to(new_user_session_path)
    end

    it "assigns a newly created post as @post" do
      controller.sign_in mock_user
      mock_user.posts.stub(:new).and_return(mock_post)

      post :create, :post => {}
      assigns(:post).should be(mock_post)
    end

    it "attempts to save the new post" do
      controller.sign_in mock_user
      mock_user.posts.should_receive(:new).with({}).and_return(mock_post)

      post :create, :post => {}
    end

    describe "with valid params" do
      it "redirects to the created post when the html format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:new).and_return(mock_post(:save => true))

        post :create, :post => {}
        response.should redirect_to(user_post_path(mock_user, mock_post))
      end

      it "provides a success code when the json format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:new).and_return(mock_post(:save => true))

        post :create, :post => {}, :format => :json
        response.response_code.should eq(201)
        response.content_type.should eq("application/json")
      end

      it "provides a success code when the xml format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:new).and_return(mock_post(:save => true))

        post :create, :post => {}, :format => :xml
        response.response_code.should eq(201)
        response.content_type.should eq("application/xml")
      end
    end

    describe "with invalid params" do
      it "re-renders the 'new' template when the html format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:new).and_return(mock_post(:save => false))

        post :create, :post => {}, :format => :html
        response.should render_template("new")
      end

      it "provides an error code when the json format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:new).and_return(mock_post(:save => false))

        post :create, :post => {}, :format => :json
        response.response_code.should eq(422)
        response.content_type.should eq("application/json")
      end

      it "provides an error code when the xml format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:new).and_return(mock_post(:save => false))

        post :create, :post => {}, :format => :xml
        response.response_code.should eq(422)
        response.content_type.should eq("application/xml")
      end
    end
  end

  describe "PUT update" do
    it "requires that a user is signed in" do
      put :update, :user_id => "joe", :id => "37", :post => {}
      response.should redirect_to(new_user_session_path)
    end

    it "assigns the requested post as @post" do
      controller.sign_in mock_user
      mock_user.posts.stub(:find_by_param).and_return(mock_post(:update_attributes => true))

      put :update, :user_id => "joe", :id => "1", :post => {}
      assigns(:post).should be(mock_post)
    end

    it "attempts to update the requested post" do
      controller.sign_in mock_user
      mock_user.posts.stub(:find_by_param).and_return(mock_post)
      mock_post.should_receive(:update_attributes).with({}).and_return(true)

      put :update, :user_id => "joe", :id => "1", :post => {}
    end

    describe "with valid params" do
      it "redirects to the updated post when the html format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:find_by_param).and_return(mock_post(:update_attributes => true))

        put :update, :user_id => "joe", :id => "1", :post => {}, :format => :html
        response.should redirect_to(user_post_path(mock_user, mock_post))
      end

      it "provides a success code when the json format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:find_by_param).and_return(mock_post(:update_attributes => true))

        put :update, :user_id => "joe", :id => "1", :post => {}, :format => :json
        response.response_code.should eq(200)
        response.content_type.should eq("application/json")
      end

      it "provides a success code when the xml format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:find_by_param).and_return(mock_post(:update_attributes => true))

        put :update, :user_id => "joe", :id => "1", :post => {}, :format => :xml
        response.response_code.should eq(200)
        response.content_type.should eq("application/xml")
      end
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template when the html format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:find_by_param).and_return(mock_post(:update_attributes => false))

        put :update, :user_id => "joe", :id => "1", :post => {}, :format => :html
        response.should render_template("edit")
      end

      it "provides an error code when the json format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:find_by_param).and_return(mock_post(:update_attributes => false))

        put :update, :user_id => "joe", :id => "1", :post => {}, :format => :json
        response.response_code.should eq(422)
        response.content_type.should eq("application/json")
      end

      it "provides an error code when the xml format is requested" do
        controller.sign_in mock_user
        mock_user.posts.stub(:find_by_param).and_return(mock_post(:update_attributes => false))

        put :update, :user_id => "joe", :id => "1", :post => {}, :format => :xml
        response.response_code.should eq(422)
        response.content_type.should eq("application/xml")
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
      mock_user.posts.should_receive(:find_by_param).with("37").and_return(mock_post)
      mock_post.should_receive(:destroy)

      delete :destroy, :user_id => "joe", :id => "37"
    end

    it "redirects to the posts list when the html format is requested" do
      controller.sign_in mock_user
      mock_user.posts.stub(:find_by_param).and_return(mock_post)

      delete :destroy, :user_id => "joe", :id => "37", :format => :html
      response.should redirect_to(user_posts_path(mock_user))
    end

    it "provides a success code when the json format is requested" do
      controller.sign_in mock_user
      mock_user.posts.stub(:find_by_param).and_return(mock_post)

      delete :destroy, :user_id => "joe", :id => "37", :format => :json
      response.response_code.should eq(200)
      response.content_type.should eq("application/json")
    end

    it "provides a success code when the xml format is requested" do
      controller.sign_in mock_user
      mock_user.posts.stub(:find_by_param).and_return(mock_post)

      delete :destroy, :user_id => "joe", :id => "37", :format => :xml
      response.response_code.should eq(200)
      response.content_type.should eq("application/xml")
    end
  end
end
