class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    @users = User.all(:conditions => "login IS NOT NULL")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find_by_login(params[:id]) || User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
end
