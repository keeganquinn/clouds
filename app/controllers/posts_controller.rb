class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml
  def index
    unless params[:user_id].blank?
      @user = User.find_by_param(params[:user_id])
      @posts = @user.posts.all(:conditions => "in_reply_to_post_id IS NULL")
    else
      @posts = Post.all(:conditions => "in_reply_to_post_id IS NULL")
    end

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @user = User.find_by_param(params[:user_id])
    @post = @user.posts.find_by_param(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    redirect_to(new_user_session) unless user_signed_in?

    @user = User.find_by_param(params[:user_id])
    redirect_to(new_user_post(current_user)) unless @user.id == current_user.id

    @post = @user.posts.new

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
    redirect_to(new_user_session) unless user_signed_in?

    @user = User.find_by_param(params[:user_id])
    redirect_to(new_user_post(current_user)) unless @user.id == current_user.id

    @post = @user.posts.find_by_param(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    redirect_to(new_user_session) unless user_signed_in?

    @user = User.find_by_param(params[:user_id])
    redirect_to(new_user_post(current_user)) unless @user.id == current_user.id

    @post = @user.posts.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to(user_post_path(@user, @post), :notice => 'Post was successfully created.') }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    redirect_to(new_user_session) unless user_signed_in?

    @user = User.find_by_param(params[:user_id])
    redirect_to(new_user_post(current_user)) unless @user.id == current_user.id

    @post = @user.posts.find_by_param(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(user_post_path(@user, @post), :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    redirect_to(new_user_session) unless user_signed_in?

    @user = User.find_by_param(params[:user_id])
    redirect_to(new_user_post(current_user)) unless @user.id == current_user.id

    @post = @user.posts.find_by_param(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(user_posts_url(@user)) }
      format.xml  { head :ok }
    end
  end
end
