class SiteController < ApplicationController
  def index
    # find articles from 'Main page category'
    @articles = Article.where(category_id: 9).visible
    @news = Article.where(category_id: 1).visible.first(3)
  end
end
