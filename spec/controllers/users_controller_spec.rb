require 'spec_helper'

describe UsersController do
  let(:user) { create(:user) }

  describe "GET index" do
    it "assigns all users as @users" do
      get :index
      assigns(:users).should include(user)
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
    it "assigns the requested user as @user" do
      get :show, id: user.username
      assigns(:user).should == user
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
end
