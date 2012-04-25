require 'spec_helper'

describe PostsController do
  let(:user) { create(:user) }
  let(:a_post) { create(:post, user: user) }

  describe "GET index" do
    it "assigns all of a user's posts as @posts" do
      get :index, user_id: user.username
      assigns(:user).should == user
      assigns(:posts).should == [a_post]
    end

    it "assigns all posts as @posts" do
      get :index
      assigns(:posts).should == [a_post]
    end

    it 'renders HTML when the html format is requested' do
      get :index, format: :html
      response.should render_template("index")
    end

    it 'renders JSON when the json format is requested' do
      get :index, format: :json
      response.content_type.should == "application/json"
    end

    it 'renders XML when the xml format is requested' do
      get :index, format: :xml
      response.content_type.should == "application/xml"
    end
  end

  describe "GET show" do
    it "assigns the requested post as @post" do
      get :show, user_id: user.username, id: a_post.code
      assigns(:post).should == a_post
    end

    it 'renders HTML when the html format is requested' do
      get :show, user_id: user.username, id: a_post.code, format: :html
      response.should render_template("show")
    end

    it 'renders JSON when the json format is requested' do
      get :show, user_id: user.username, id: a_post.code, format: :json
      response.content_type.should == "application/json"
    end

    it 'renders XML when the xml format is requested' do
      get :show, user_id: user.username, id: a_post.code, format: :xml
      response.content_type.should == "application/xml"
    end
  end

  describe "GET new" do
    it "requires that a user is signed in" do
      get :new
      response.should redirect_to(new_user_session_path)
    end

    it "assigns a new top-level post as @post" do
      sign_in user

      get :new
      assigns(:post).should be_a(Post)
    end

    it "assigns a new reply post as @post" do
      sign_in user

      get :new, in_reply_to_post_id: a_post.id
      assigns(:post).should be_a(Post)
      assigns(:post).in_reply_to_post.should == a_post
    end

    it "renders HTML when the html format is requested" do
      sign_in user

      get :new, format: :html
      response.should render_template("new")
    end

    it "renders JSON when the json format is requested" do
      sign_in user

      get :new, format: :json
      response.content_type.should == "application/json"
    end

    it "renders XML when the xml format is requested" do
      sign_in user

      get :new, format: :xml
      response.content_type.should == "application/xml"
    end
  end

  describe "GET edit" do
    it "requires that a user is signed in" do
      get :edit, user_id: user.username, id: a_post.code
      response.should redirect_to(new_user_session_path)
    end

    it "assigns the requested post as @post" do
      sign_in user

      get :edit, user_id: user.username, id: a_post.code
      assigns(:post).should == a_post
    end

    it "renders HTML template" do
      sign_in user

      get :edit, user_id: user.username, id: a_post.code
      response.should render_template("edit")
    end
  end

  describe "POST create" do
    it "requires that a user is signed in" do
      post :create, post: {}
      response.should redirect_to(new_user_session_path)
    end

    it "assigns a newly created post as @post" do
      sign_in user

      post :create, post: {}
      assigns(:post).should be_a(Post)
    end

    describe "with valid params" do
      it "redirects to the created post when the html format is requested" do
        sign_in user

        post :create, post: attributes_for(:post)
        response.should redirect_to(user_post_path(user, assigns(:post)))
      end

      it "provides a success code when the json format is requested" do
        sign_in user

        post :create, post: attributes_for(:post), format: :json
        response.response_code.should == 201
        response.content_type.should == "application/json"
      end

      it "provides a success code when the xml format is requested" do
        sign_in user

        post :create, post: attributes_for(:post), format: :xml
        response.response_code.should == 201
        response.content_type.should == "application/xml"
      end
    end

    describe "with invalid params" do
      it "re-renders the 'new' template when the html format is requested" do
        sign_in user

        post :create, post: {}, format: :html
        response.should render_template("new")
      end

      it "provides an error code when the json format is requested" do
        sign_in user

        post :create, post: {}, format: :json
        response.response_code.should == 422
        response.content_type.should == "application/json"
      end

      it "provides an error code when the xml format is requested" do
        sign_in user

        post :create, post: {}, format: :xml
        response.response_code.should == 422
        response.content_type.should == "application/xml"
      end
    end
  end

  describe "PUT update" do
    it "requires that a user is signed in" do
      put :update, user_id: user.username, id: a_post.code, post: {}
      response.should redirect_to(new_user_session_path)
    end

    it "assigns the requested post as @post" do
      sign_in user

      put :update, user_id: user.username, id: a_post.code, post: {}
      assigns(:post).should == a_post
    end

    describe "with valid params" do
      it "redirects to the updated post when the html format is requested" do
        sign_in user

        put :update, user_id: user.username, id: a_post.code, post: {}, format: :html
        response.should redirect_to(user_post_path(user, a_post))
      end

      it "provides a success code when the json format is requested" do
        sign_in user

        put :update, user_id: user.username, id: a_post.code, post: {}, format: :json
        response.response_code.should == 204
        response.content_type.should == "application/json"
      end

      it "provides a success code when the xml format is requested" do
        sign_in user

        put :update, user_id: user.username, id: a_post.code, post: {}, format: :xml
        response.response_code.should == 204
        response.content_type.should == "application/xml"
      end
    end

    describe "with invalid params" do
      it "re-renders the 'edit' template when the html format is requested" do
        sign_in user

        put :update, user_id: user.username, id: a_post.code, post: { subject: '' }, format: :html
        response.should render_template("edit")
      end

      it "provides an error code when the json format is requested" do
        sign_in user

        put :update, user_id: user.username, id: a_post.code, post: { subject: '' }, format: :json
        response.response_code.should == 422
        response.content_type.should == "application/json"
      end

      it "provides an error code when the xml format is requested" do
        sign_in user

        put :update, user_id: user.username, id: a_post.code, post: { subject: '' }, format: :xml
        response.response_code.should == 422
        response.content_type.should == "application/xml"
      end
    end
  end

  describe "DELETE destroy" do
    it "requires that a user is signed in" do
      delete :destroy, user_id: user.username, id: a_post.code
      response.should redirect_to(new_user_session_path)
    end

    it "destroys the requested post" do
      sign_in user

      delete :destroy, user_id: user.username, id: a_post.code
      flash[:notice].should =~ /Post/
    end

    it "redirects to the posts list when the html format is requested" do
      sign_in user

      delete :destroy, user_id: user.username, id: a_post.code, format: :html
      response.should redirect_to(user_posts_path(user))
    end

    it "provides a success code when the json format is requested" do
      sign_in user

      delete :destroy, user_id: user.username, id: a_post.code, format: :json
      response.response_code.should == 204
      response.content_type.should == "application/json"
    end

    it "provides a success code when the xml format is requested" do
      sign_in user

      delete :destroy, user_id: user.username, id: a_post.code, format: :xml
      response.response_code.should == 204
      response.content_type.should == "application/xml"
    end
  end
end
