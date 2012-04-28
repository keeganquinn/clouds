require 'spec_helper'

describe PostAttachmentsController do
  let(:user) { create(:user) }
  let(:a_post) { create(:post, user: user) }
  let(:post_attachment) { create(:post_attachment, post: a_post) }

  subject { response }

  describe "GET show" do
    before { get :show, user_id: user.username, post_id: a_post.code, id: post_attachment.filename }
    it { assigns(:post).should == a_post }
    it { assigns(:post_attachment).should == post_attachment }
    its(:content_type) { should == post_attachment.content_type }
    its(:body) { should == post_attachment.data }
  end

  describe "GET new" do
    describe "when not authorized" do
      before { get :new }
      it { should redirect_to(new_user_session_path) }
    end

    describe "when authorized" do
      before { sign_in user }

      describe "with default format" do
        before { get :new, user_id: user.username, post_id: a_post.code }
        it { assigns(:post_attachment).should be_a(PostAttachment) }
        it { should render_template("new") }
      end

      describe "with json format" do
        before { get :new, user_id: user.username, post_id: a_post.code, format: :json }
        it { assigns(:post_attachment).should be_a(PostAttachment) }
        its(:content_type) { should == "application/json" }
      end

      describe "with xml format" do
        before { get :new, user_id: user.username, post_id: a_post.code, format: :xml }
        it { assigns(:post_attachment).should be_a(PostAttachment) }
        its(:content_type) { should == "application/xml" }
      end
    end
  end

  describe "POST create" do
    describe "when not authorized" do
      before { post :create, post: {} }
      it { should redirect_to(new_user_session_path) }
    end

    describe "when authorized" do
      before { sign_in user }

      describe "with default format" do
        before { post :create, user_id: user.username, post_id: a_post.code, post_attachment: { data: fixture_file_upload('/test.txt', 'text/plain') } }
        it { assigns(:post_attachment).should be_a(PostAttachment) }
        it { should redirect_to(user_post_path(user, a_post)) }
      end

      describe "with json format" do
        before { post :create, user_id: user.username, post_id: a_post.code, post_attachment: { data: fixture_file_upload('/test.txt', 'text/plain') }, format: :json }
        it { assigns(:post_attachment).should be_a(PostAttachment) }
        its(:response_code) { should == 201 }
        its(:content_type) { should == "application/json" }
      end

      describe "with xml format" do
        before { post :create, user_id: user.username, post_id: a_post.code, post_attachment: { data: fixture_file_upload('/test.txt', 'text/plain') }, format: :xml }
        it { assigns(:post_attachment).should be_a(PostAttachment) }
        its(:response_code) { should == 201 }
        its(:content_type) { should == "application/xml" }
      end

      describe "with invalid params" do
        describe "with default format" do
          before { post :create, user_id: user.username, post_id: a_post.code, post_attachment: {} }
          it { assigns(:post_attachment).should be_a(PostAttachment) }
          it { assigns(:post_attachment).errors.should_not be_empty }
          it { should redirect_to(user_post_path(user, a_post)) }
        end

        describe "with json format" do
          before { post :create, user_id: user.username, post_id: a_post.code, post_attachment: {}, format: :json }
          it { assigns(:post_attachment).should be_a(PostAttachment) }
          it { assigns(:post_attachment).errors.should_not be_empty }
          its(:response_code) { should == 422 }
          its(:content_type) { should == "application/json" }
        end

        describe "with xml format" do
          before { post :create, user_id: user.username, post_id: a_post.code, post_attachment: {}, format: :xml }
          it { assigns(:post_attachment).should be_a(PostAttachment) }
          it { assigns(:post_attachment).errors.should_not be_empty }
          its(:response_code) { should == 422 }
          its(:content_type) { should == "application/xml" }
        end
      end
    end
  end

  describe "DELETE destroy" do
    describe "when not authorized" do
      before { delete :destroy, user_id: user.username, post_id: a_post.code, id: post_attachment.filename }
      it { should redirect_to(new_user_session_path) }
    end

    describe "when authorized" do
      before { sign_in user }

      before { delete :destroy, user_id: user.username, post_id: a_post.code, id: post_attachment.filename }
      it { assigns(:post_attachment).should == post_attachment }
      it { assigns(:post_attachment).should be_destroyed }
      it { should redirect_to(user_post_path(user, a_post)) }
    end
  end
end
