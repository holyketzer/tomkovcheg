require 'spec_helper'

describe ArticlesController do
  describe 'GET index' do
    it 'returns all articles' do
      article = create(:article)
      unpublished_article = create(:article, published: false)

      get :index
      expect(assigns(:articles)).to include(article, unpublished_article)
    end
  end
end