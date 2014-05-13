class ArticlesController < InheritedResources::Base
  respond_to :html

  def index
    @articles = Article.active
  end

  def create
    create!(notice: t('activerecord.successful.messages.article_saved'))
  end

  def update
    update!(notice: t('activerecord.successful.messages.article_saved'))
  end

  def show
    show! do |format|
      format.html { redirect_to articles_path unless @article.active? }
    end
  end

  private
    def build_resource_params
      [params.fetch(:article, {}).permit(:title, :abstract, :body, :category_id, :published, :approved)]
    end
end