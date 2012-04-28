class UsersController < ApplicationController
  before_filter :authenticate_user!, only: [ :follow ]
  respond_to :html, :json, :xml

  # GET /users
  # GET /users.json
  # GET /users.xml
  def index
    @users = User.paginate(page: params[:page])
    respond_with(@users)
  end

  # GET /users/id
  # GET /users/id.json
  # GET /users/id.xml
  def show
    @user = User.find_by_param(params[:id])
    respond_with(@user)
  end

  # POST /users/id/follow
  # POST /users/id/follow.json
  # POST /users/id/follow.xml
  def follow
    @user = User.find_by_param(params[:id])

    if current_user.following?(@user)
      current_user.unfollow!(@user)
    else
      current_user.follow!(@user)
    end

    respond_with(@user, head: :ok) do |format|
      format.html { redirect_to(@user) }
    end
  end
end
