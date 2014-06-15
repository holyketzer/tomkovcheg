class SiteController < ApplicationController
  authorize_resource class: :site, only: [:manage]

  def index
    # find articles from 'Main page category'
    @articles = Article.where(category_id: 9).visible
    @news = Article.where(category_id: 1).visible.first(3)
  end

  def manage
  end
end
