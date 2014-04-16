class CategoriesController < InheritedResources::Base
  respond_to :html

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
      [params.fetch(:category, {}).permit(:title, :description, :priority)]
    end
end
