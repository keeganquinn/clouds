class PostAttachmentsController < ApplicationController
  before_filter :authenticate_user!, except: [ :show ]
  respond_to :html, :json, :xml

  # GET /users/user_id/posts/post_id/attachments/id
  def show
    user = User.find_by_param(params[:user_id])
    @post = user.posts.find_by_param(params[:post_id])
    @post_attachment = @post.post_attachments.find_by_param(params[:id])
    @post_attachment ||= @post.post_attachments.find_by_param(params[:id] + '.' + params[:format])

    send_data(@post_attachment.data, filename: @post_attachment.filename, type: @post_attachment.content_type, disposition: 'inline')
  end

  # GET /users/user_id/posts/post_id/attachments/new
  # GET /users/user_id/posts/post_id/attachments/new.json
  # GET /users/user_id/posts/post_id/attachments/new.xml
  def new
    @post = current_user.posts.find_by_param(params[:post_id])
    @post_attachment = @post.post_attachments.build

    respond_with(@post_attachment)
  end

  # POST /users/user_id/posts/post_id/attachments
  # POST /users/user_id/posts/post_id/attachments.json
  # POST /users/user_id/posts/post_id/attachments.xml
  def create
    @post = current_user.posts.find_by_param(params[:post_id])
    @post_attachment = @post.post_attachments.build(params[:post_attachment])

    if uploaded_file = params[:post_attachment][:data]
      @post_attachment.filename = uploaded_file.original_filename
      @post_attachment.content_type = uploaded_file.content_type
      @post_attachment.data = uploaded_file.read
    end

    if @post_attachment.save
      flash[:notice] = t(:create_success, thing: PostAttachment.model_name.human)
      respond_with(@post_attachment, status: :created, location: user_post_attachment_path(current_user, @post, @post_attachment)) do |format|
        format.html { redirect_to(user_post_path(current_user, @post)) }
      end
    else
      respond_with(@post_attachment, status: :unprocessable_entity, location: user_post_path(current_user, @post)) do |format|
        format.html { redirect_to(user_post_path(current_user, @post)) }
      end
    end
  end

  # DELETE /users/user_id/posts/post_id/attachments/id
  def destroy
    @post = current_user.posts.find_by_param(params[:post_id])
    @post_attachment = @post.post_attachments.find_by_param(params[:id])
    @post_attachment ||= @post.post_attachments.find_by_param(params[:id] + '.' + params[:format])
    @post_attachment.destroy

    flash[:notice] = t(:delete_success, thing: PostAttachment.model_name.human)
    redirect_to(user_post_path(current_user, @post))
  end
end
