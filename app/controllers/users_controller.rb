class UsersController < ApplicationController
  respond_to :html, :json, :xml

  # GET /users
  # GET /users.json
  # GET /users.xml
  def index
    @users = User.with_profile.paginate(:page => params[:page])
    respond_with(@users)
  end

  # GET /users/id
  # GET /users/id.json
  # GET /users/id.xml
  def show
    @user = User.find_by_param(params[:id])
    respond_with(@user)
  end
end
