require 'spec_helper'

describe UsersController do
  def mock_user(stubs={})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all users as @users" do
      User.stub_chain(:paginate).and_return([mock_user])

      get :index
      assigns(:users).should eq([mock_user])
    end

    it 'renders HTML when the html format is requested' do
      get :index, format: :html
      response.should render_template("index")
    end

    it 'renders JSON when the json format is requested' do
      get :index, format: :json
      response.content_type.should eq("application/json")
    end

    it 'renders XML when the xml format is requested' do
      get :index, format: :xml
      response.content_type.should eq("application/xml")
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      User.stub(:find_by_param).with("37").and_return(mock_user)

      get :show, id: "37"
      assigns(:user).should be(mock_user)
    end

    it 'renders HTML when the html format is requested' do
      get :index, format: :html
      response.should render_template("index")
    end

    it 'renders JSON when the json format is requested' do
      get :index, format: :json
      response.content_type.should eq("application/json")
    end

    it 'renders XML when the xml format is requested' do
      get :index, format: :xml
      response.content_type.should eq("application/xml")
    end
  end
end
