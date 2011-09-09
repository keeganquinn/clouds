class PostsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :index, :show ]
  respond_to :html, :json, :xml

  # GET /posts
  # GET /posts.json
  # GET /posts.xml
  # GET /users/user_id/posts
  # GET /users/user_id/posts.json
  # GET /users/user_id/posts.xml
  def index
    if params[:user_id].blank?
      @posts = Post.top.paginate(:page => params[:page])
    else
      @user = User.find_by_param(params[:user_id])
      @posts = @user.posts.top.paginate(:page => params[:page])
    end

    respond_with(@posts)
  end

  # GET /users/user_id/posts/id
  # GET /users/user_id/posts/id.json
  # GET /users/user_id/posts/id.xml
  def show
    user = User.find_by_param(params[:user_id])
    @post = user.posts.find_by_param(params[:id])

    respond_with(@post)
  end

  # GET /posts/new
  # GET /posts/new.json
  # GET /posts/new.xml
  def new
    @post = current_user.posts.new

    unless params[:in_reply_to_post_id].blank?
      @post.in_reply_to_post = Post.find(params[:in_reply_to_post_id])
      @post.subject ||= "Re: #{@post.in_reply_to_post.subject}"
    end

    respond_with(@post)
  end

  # GET /users/user_id/posts/id/edit
  def edit
    @post = current_user.posts.find_by_param(params[:id])
  end

  # POST /posts
  # POST /posts.json
  # POST /posts.xml
  def create
    @post = current_user.posts.new(params[:post])

    if @post.save
      respond_with(@post, :status => :created,
          :location => user_post_path(current_user, @post))
    else
      respond_with(@post.errors, :status => :unprocessable_entity) do |format|
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /users/user_id/posts/id
  # PUT /users/user_id/posts/id.json
  # PUT /users/user_id/posts/id.xml
  def update
    @post = current_user.posts.find_by_param(params[:id])

    if @post.update_attributes(params[:post])
      respond_with(@post, :head => :ok,
          :location => user_post_path(current_user, @post))
    else
      respond_with(@post.errors, :status => :unprocessable_entity) do |format|
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /users/user_id/posts/id
  # DELETE /users/user_id/posts/id.json
  # DELETE /users/user_id/posts/id.xml
  def destroy
    @post = current_user.posts.find_by_param(params[:id])
    @post.destroy

    respond_with(current_user, :head => :ok, :location => user_posts_path(current_user))
  end
end
