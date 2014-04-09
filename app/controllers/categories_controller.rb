class CategoriesController < InheritedResources::Base
  respond_to :html

  def create
    create!(notice: t('activerecord.successful.messages.category_saved'))
  end

  private
    def build_resource_params
    [params.fetch(:category, {}).permit(:title, :description, :priority)]
  end
end
