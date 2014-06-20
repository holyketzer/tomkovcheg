class GalleriesController < ApplicationController
  respond_to :html
  inherit_resources
  authorize_resource

  layout 'two_columns', only: [:new, :create, :edit, :update]

  def new
    @gallery = Gallery.new
    @images = @gallery.images.build
  end

  def index
    @galleries = Gallery.page params[:page]
  end

  def create
    @gallery = Gallery.new(gallery_params)

    respond_to do |format|
      if @gallery.save
        create_images
        format.html { redirect_to @gallery, notice: t('activerecord.successful.messages.gallery_saved') }
      else
        format.html { render action: 'new' }
      end
    end
  end


  def edit
    @gallery = Gallery.find(params[:id])
    @gallery.images.build
  end

  def update
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      if @gallery.update(gallery_params)
        create_images
        format.html { redirect_to @gallery, notice: t('activerecord.successful.messages.gallery_saved') }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def create_images
    if params[:images]
      params[:images]['source'].each do |i|
        @gallery.images.create!(source: i, imageable_id: @gallery.id)
      end
    end
  end

  private

  def gallery_params
    params.require(:gallery).permit(:title, images_attributes: [:id, :imageable_id, :source])
  end
end