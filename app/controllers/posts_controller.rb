class PostsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :index, :show ]

  # GET /posts
  # GET /posts.xml
  def index
    unless params[:user_id].blank?
      @user = User.find_by_param(params[:user_id])
      @posts = @user.posts.top.paginate(:page => params[:page])
    else
      @posts = Post.top.paginate(:page => params[:page])
    end

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    user = User.find_by_param(params[:user_id])
    @post = user.posts.find_by_param(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = current_user.posts.new

    unless params[:in_reply_to_post_id].blank?
      @post.in_reply_to_post = Post.find(params[:in_reply_to_post_id])
      @post.subject ||= "Re: #{@post.in_reply_to_post.subject}"
    end

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = current_user.posts.find_by_param(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = current_user.posts.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html {
          redirect_to(user_post_path(current_user, @post),
                      :notice => 'Post was successfully created.')
        }
        format.xml  {
          render :xml => @post, :status => :created, :location => @post
        }
      else
        format.html { render :action => "new" }
        format.xml  {
          render :xml => @post.errors, :status => :unprocessable_entity
        }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = current_user.posts.find_by_param(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html {
          redirect_to(user_post_path(current_user, @post),
                      :notice => 'Post was successfully updated.')
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  {
          render :xml => @post.errors, :status => :unprocessable_entity
        }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = current_user.posts.find_by_param(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(user_posts_path(current_user)) }
      format.xml  { head :ok }
    end
  end
end
