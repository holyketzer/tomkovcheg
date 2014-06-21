class GalleriesController < ApplicationController
  respond_to :html
  inherit_resources
  authorize_resource

  layout 'two_columns', only: [:new, :create, :edit, :update]

  def index
    @galleries = Gallery.page params[:page]
  end

  private

  def build_resource_params
    [params.fetch(:gallery, {}).permit(:title, images_attributes: [:id, :imageable_id, :source])]
  end
end