class ArticlesController < ApplicationController
  respond_to :html
  inherit_resources

  layout 'two_columns', only: [:new, :edit]

  def new
    @article = Article.new
    @images = @article.images.build
  end

  def index
    @articles = Article.active
  end

  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        create_images
        format.html { redirect_to @article, notice: t('activerecord.successful.messages.article_saved') }
      else
        format.html { render action: 'new' }
      end
    end
  end


  def edit
    @article = Article.find(params[:id])
    @article.images.build
  end

  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update(article_params)
        create_images
        format.html { redirect_to @article, notice: t('activerecord.successful.messages.article_saved') }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def create_images
    if params[:images]
      params[:images]['source'].each do |i|
        @article.images.create!(source: i, imageable_id: @article.id)
      end
    end
  end

  def show
    show! do |format|
      format.html { redirect_to articles_path unless @article.active? }
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :abstract, :body, :category_id, :published, :approved, images_attributes: [:id, :imageable_id, :source])
  end
end