class ArticlesController < InheritedResources::Base
  respond_to :html

  def create
    create!(notice: t('activerecord.successful.messages.article_saved'))
  end

  def update
    update!(notice: t('activerecord.successful.messages.article_saved'))
  end

  private
    def build_resource_params
      [params.fetch(:article, {}).permit(:title, :abstract, :body, :category_id)]
    end
end