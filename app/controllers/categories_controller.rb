class CategoriesController < InheritedResources::Base
  respond_to :html

  def new
    @category = Category.new
    @category.build_image
  end

  def index
    @categories = Category.order(:priority)
  end

  def create
    create!(notice: t('activerecord.successful.messages.category_saved'))
  end

  def update
    update!(notice: t('activerecord.successful.messages.category_saved'))
  end

  private
    def build_resource_params
      [params.fetch(:category, {}).permit(:title, :description, :priority, image_attributes: [:id, :imageable_id, :source])]
    end
end
