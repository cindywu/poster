class UploadsController < ApplicationController
  before_action :set_upload, only: [
    :show, :edit, :update, :destroy, :extract_images
  ]
  # skip_before_filter :verify_authenticity_token, only: [:file]
  protect_from_forgery except: :file

  def show
  end

  def new
    @upload = Upload.new
  end

  def edit
  end

  def create
    if current_user
      @upload = current_user.uploads.new(upload_params)
      @post = current_user.posts.create!
      @upload.post = @post
    else
      @upload = Upload.new(upload_params)
      @post = Post.create!
      @upload.post = @post
    end

    respond_to do |format|
      if @upload.save!
        format.html { redirect_to @upload.post, notice: 'Upload was successfully created. Please refresh the page!' }
        format.json { render :show, status: :created, location: @upload }
      else
        format.html { render :new }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @upload.update(upload_params)
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { render :show, status: :ok, location: @upload }
      else
        format.html { render :edit }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  def file
    if current_user
      @post = current_user.posts.new
      @upload = current_user.uploads.new
      @upload.post = @post
    else
      @post = Post.new
    	@upload = Upload.new
      @upload.post = @post
    end

    if params[:file_id]
			file = Shrine.uploaded_file(storage: :store, id: params[:file_id])
			file.refresh_metadata!
			@upload.file_attacher.set(file)
		end

    respond_to do |format|
      if @upload.save!
        redirect = current_user.present? ? short_user_post_path(current_user, @upload.post) : post_path(@upload.post)
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { render json: { redirect_to: redirect }, status: :ok, notice: "hooray" }
      else
        format.html { render :edit }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @upload.destroy
    respond_to do |format|
      format.html { redirect_to uploads_url, notice: 'Upload was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def extract_images
    FiguresExtractService.extract(@upload.id)
    redirect_to upload_path(@upload), notice: "Queued upload for figure extraction"
  end

  private
    def set_upload
      @upload ||= begin
        Upload.find(params[:id] || params[:upload_id])
      rescue ActiveRecord::RecordNotFound => e
        raise e
      end
    end

    def upload_params
      params.require(:upload).permit(:file, :user).to_h
    end
end
