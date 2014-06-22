class ImagesController < ApplicationController
  respond_to :html, only: [:create, :destroy]
  inherit_resources
  authorize_resource

  before_filter :load_imageable, only: :create

  def create
    @image = Image.create!(resource_params[0].merge(imageable_type: @imageable_type.name, imageable_id: @imageable_id))
  end

  def destroy
    destroy! do |format|
      format.html { redirect_to :back }
    end
  end

  private

  def build_resource_params
    [params.fetch(:image, {}).permit(:id, :source)]
  end

  def load_imageable
    @imageable_type = [Article, Category, Gallery].detect { |c| params["#{c.name.underscore}_id"]}
    @imageable_id = params["#{@imageable_type.name.underscore}_id"]
    #@imageable = imageable_type.find(params["#{imageable_type.name.underscore}_id"])
  end
end