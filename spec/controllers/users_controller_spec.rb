require 'spec_helper'

describe UsersController do
  let!(:user) { create(:user) }

  subject { response }

  describe "GET index" do
    describe "with default format" do
      before { get :index }
      it { assigns(:users).should include(user) }
      it { should render_template("index") }
    end

    describe "with json format" do
      before { get :index, format: :json }
      it { assigns(:users).should include(user) }
      its(:content_type) { should == "application/json" }
    end

    describe "with xml format" do
      before { get :index, format: :xml }
      it { assigns(:users).should include(user) }
      its(:content_type) { should == "application/xml" }
    end
  end

  describe "GET show" do
    describe "with default format" do
      before { get :show, id: user.username }
      it { assigns(:user).should == user }
      it { should render_template("show") }
    end

    describe "with json format" do
      before { get :show, id: user.username, format: :json }
      it { assigns(:user).should == user }
      its(:content_type) { should == "application/json" }
    end

    describe "with xml format" do
      before { get :show, id: user.username, format: :xml }
      it { assigns(:user).should == user }
      its(:content_type) { should == "application/xml" }
    end
  end

  describe "POST follow" do
    describe "when not authorized" do
      before { post :follow }
      it { should redirect_to(new_user_session_path) }
    end

    describe "when authorized" do
      before { sign_in follower }

      let(:follower) { create(:user) }

      describe "with default format" do
        before { post :follow, id: user.username }
        it { assigns(:user).should == user }
        it { follower.should be_following(user) }
        it { should redirect_to(user) }
      end

      describe "with json format" do
        before { post :follow, id: user.username, format: :json }
        it { assigns(:user).should == user }
        it { follower.should be_following(user) }
        its(:response_code) { should == 201 }
        its(:content_type) { should == "application/json" }
      end

      describe "with xml format" do
        before { post :follow, id: user.username, format: :xml }
        it { assigns(:user).should == user }
        it { follower.should be_following(user) }
        its(:response_code) { should == 201 }
        its(:content_type) { should == "application/xml" }
      end

      describe "unfollowing" do
        before { follower.follow!(user) }

        describe "with default format" do
          before { post :follow, id: user.username }
          it { assigns(:user).should == user }
          it { follower.should_not be_following(user) }
          it { should redirect_to(user) }
        end

        describe "with json format" do
          before { post :follow, id: user.username, format: :json }
          it { assigns(:user).should == user }
          it { follower.should_not be_following(user) }
          its(:response_code) { should == 201 }
          its(:content_type) { should == "application/json" }
        end

        describe "with xml format" do
          before { post :follow, id: user.username, format: :xml }
          it { assigns(:user).should == user }
          it { follower.should_not be_following(user) }
          its(:response_code) { should == 201 }
          its(:content_type) { should == "application/xml" }
        end
      end
    end
  end
end
