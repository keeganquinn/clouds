require 'spec_helper'

describe PostsController do
  let(:user) { create(:user) }
  let!(:a_post) { create(:post, user: user) }

  subject { response }

  describe "GET index" do
    describe "with default format" do
      before { get :index }
      it { assigns(:posts).should == Post.top.paginate(page: nil) }
      it { should render_template("index") }
    end

    describe "with json format" do
      before { get :index, format: :json }
      it { assigns(:posts).should == Post.top.paginate(page: nil) }
      its(:content_type) { should == "application/json" }
    end

    describe "with xml format" do
      before { get :index, format: :xml }
      it { assigns(:posts).should == Post.top.paginate(page: nil) }
      its(:content_type) { should == "application/xml" }
    end

    describe "with user_id" do
      describe "with default format" do
        before { get :index, user_id: user.username }
        it { assigns(:user).should == user }
        it { assigns(:posts).should == [ a_post ] }
        it { should render_template("index") }
      end

      describe "with json format" do
        before { get :index, user_id: user.username, format: :json }
        it { assigns(:user).should == user }
        it { assigns(:posts).should == [ a_post ] }
        its(:content_type) { should == "application/json" }
      end

      describe "with xml format" do
        before { get :index, user_id: user.username, format: :xml }
        it { assigns(:user).should == user }
        it { assigns(:posts).should == [ a_post ] }
        its(:content_type) { should == "application/xml" }
      end
    end
  end

  describe "GET show" do
    describe "with default format" do
      before { get :show, user_id: user.username, id: a_post.code }
      it { assigns(:user).should == user }
      it { assigns(:post).should == a_post }
      it { should render_template("show") }
    end

    describe "with json format" do
      before { get :show, user_id: user.username, id: a_post.code, format: :json }
      it { assigns(:user).should == user }
      it { assigns(:post).should == a_post }
      its(:content_type) { should == "application/json" }
    end

    describe "with xml format" do
      before { get :show, user_id: user.username, id: a_post.code, format: :xml }
      it { assigns(:user).should == user }
      it { assigns(:post).should == a_post }
      its(:content_type) { should == "application/xml" }
    end
  end

  describe "GET new" do
    describe "when not authorized" do
      before { get :new }
      it { should redirect_to(new_user_session_path) }
    end

    describe "when authorized" do
      before { sign_in user }

      describe "with default format" do
        before { get :new }
        it { assigns(:post).should be_a(Post) }
        it { should render_template("new") }
      end

      describe "with json format" do
        before { get :new, format: :json }
        it { assigns(:post).should be_a(Post) }
        its(:content_type) { should == "application/json" }
      end

      describe "with xml format" do
        before { get :new, format: :xml }
        it { assigns(:post).should be_a(Post) }
        its(:content_type) { should == "application/xml" }
      end

      describe "reply" do
        describe "with default format" do
          before { get :new, in_reply_to_post_id: a_post.id }
          it { assigns(:post).should be_a(Post) }
          it { assigns(:post).in_reply_to_post.should == a_post }
          it { should render_template("new") }
        end

        describe "with json format" do
          before { get :new, in_reply_to_post_id: a_post.id, format: :json }
          it { assigns(:post).should be_a(Post) }
          it { assigns(:post).in_reply_to_post.should == a_post }
          its(:content_type) { should == "application/json" }
        end

        describe "with xml format" do
          before { get :new, in_reply_to_post_id: a_post.id, format: :xml }
          it { assigns(:post).should be_a(Post) }
          it { assigns(:post).in_reply_to_post.should == a_post }
          its(:content_type) { should == "application/xml" }
        end
      end
    end
  end

  describe "GET edit" do
    describe "when not authorized" do
      before { get :edit, user_id: user.username, id: a_post.code }
      it { should redirect_to(new_user_session_path) }
    end

    describe "when authorized" do
      before { sign_in user }

      describe "with default format" do
        before { get :edit, user_id: user.username, id: a_post.code }
        it { assigns(:post).should == a_post }
        it { should render_template("edit") }
      end
    end
  end

  describe "POST create" do
    describe "when not authorized" do
      before { post :create }
      it { should redirect_to(new_user_session_path) }
    end

    describe "when authorized" do
      before { sign_in user }

      describe "with default format" do
        before { post :create, post: attributes_for(:post) }
        it { assigns(:post).should be_a(Post) }
        it { should redirect_to(user_post_path(user, assigns(:post))) }
      end

      describe "with json format" do
        before { post :create, post: attributes_for(:post), format: :json }
        it { assigns(:post).should be_a(Post) }
        its(:response_code) { should == 201 }
        its(:content_type) { should == "application/json" }
      end

      describe "with xml format" do
        before { post :create, post: attributes_for(:post), format: :xml }
        it { assigns(:post).should be_a(Post) }
        its(:response_code) { should == 201 }
        its(:content_type) { should == "application/xml" }
      end

      describe "with invalid params" do
        describe "with default format" do
          before { post :create, post: {} }
          it { assigns(:post).should be_a(Post) }
          it { assigns(:post).errors.should_not be_empty }
          it { should render_template("new") }
        end

        describe "with json format" do
          before { post :create, post: {}, format: :json }
          it { assigns(:post).should be_a(Post) }
          it { assigns(:post).errors.should_not be_empty }
          its(:response_code) { should == 422 }
          its(:content_type) { should == "application/json" }
        end

        describe "with xml format" do
          before { post :create, post: {}, format: :xml }
          it { assigns(:post).should be_a(Post) }
          it { assigns(:post).errors.should_not be_empty }
          its(:response_code) { should == 422 }
          its(:content_type) { should == "application/xml" }
        end
      end
    end
  end

  describe "PUT update" do
    describe "when not authorized" do
      before { put :update, user_id: user.username, id: a_post.code, post: {} }
      it { should redirect_to(new_user_session_path) }
    end

    describe "when authorized" do
      before { sign_in user }

      describe "with default format" do
        before { put :update, user_id: user.username, id: a_post.code, post: {} }
        it { assigns(:post).should == a_post }
        it { should redirect_to(user_post_path(user, a_post)) }
      end

      describe "with json format" do
        before { put :update, user_id: user.username, id: a_post.code, post: {}, format: :json }
        it { assigns(:post).should == a_post }
        its(:response_code) { should == 204 }
        its(:content_type) { should == "application/json" }
      end

      describe "with xml format" do
        before { put :update, user_id: user.username, id: a_post.code, post: {}, format: :xml }
        it { assigns(:post).should == a_post }
        its(:response_code) { should == 204 }
        its(:content_type) { should == "application/xml" }
      end

      describe "with invalid params" do
        describe "with default format" do
          before { put :update, user_id: user.username, id: a_post.code, post: { subject: '' } }
          it { assigns(:post).should == a_post }
          it { assigns(:post).errors.should_not be_empty }
          it { should render_template("edit") }
        end

        describe "with json format" do
          before { put :update, user_id: user.username, id: a_post.code, post: { subject: '' }, format: :json }
          it { assigns(:post).should == a_post }
          it { assigns(:post).errors.should_not be_empty }
          its(:response_code) { should == 422 }
          its(:content_type) { should == "application/json" }
        end

        describe "with xml format" do
          before { put :update, user_id: user.username, id: a_post.code, post: { subject: '' }, format: :xml }
          it { assigns(:post).should == a_post }
          it { assigns(:post).errors.should_not be_empty }
          its(:response_code) { should == 422 }
          its(:content_type) { should == "application/xml" }
        end
      end
    end
  end

  describe "DELETE destroy" do
    describe "when not authorized" do
      before { delete :destroy, user_id: user.username, id: a_post.code }
      it { should redirect_to(new_user_session_path) }
    end

    describe "when authorized" do
      before { sign_in user }

      describe "with default format" do
        before { delete :destroy, user_id: user.username, id: a_post.code }
        it { assigns(:post).should == a_post }
        it { assigns(:post).should be_destroyed }
        it { should redirect_to(user_posts_path(user)) }
      end

      describe "with json format" do
        before { delete :destroy, user_id: user.username, id: a_post.code, format: :json }
        it { assigns(:post).should == a_post }
        it { assigns(:post).should be_destroyed }
        its(:response_code) { should == 204 }
        its(:content_type) { should == "application/json" }
      end

      describe "with xml format" do
        before { delete :destroy, user_id: user.username, id: a_post.code, format: :xml }
        it { assigns(:post).should == a_post }
        it { assigns(:post).should be_destroyed }
        its(:response_code) { should == 204 }
        its(:content_type) { should == "application/xml" }
      end
    end
  end
end
