class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.with_profile.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @users }
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find_by_param(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @user }
      format.json { render :json => @user }
    end
  end
end
