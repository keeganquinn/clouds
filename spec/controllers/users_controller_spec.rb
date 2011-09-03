require 'spec_helper'

describe UsersController do
  def mock_user(stubs={})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all users as @users" do
      User.stub_chain(:with_profile, :paginate).and_return([mock_user])

      get :index
      assigns(:users).should eq([mock_user])
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      User.stub(:find_by_param).with("37").and_return(mock_user)

      get :show, :id => "37"
      assigns(:user).should be(mock_user)
    end
  end
end
