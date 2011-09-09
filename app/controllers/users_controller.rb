class UsersController < ApplicationController
  respond_to :html, :json, :xml

  # GET /users
  # GET /users.xml
  def index
    @users = User.with_profile.paginate(:page => params[:page])
    respond_with(@users)
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find_by_param(params[:id])
    respond_with(@user)
  end
end
