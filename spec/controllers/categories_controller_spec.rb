require 'spec_helper'

describe CategoriesController do
  login_as_admin

  describe 'GET show' do
    it 'returns pusblished and approved articles' do
      category = create(:category)
      article = create(:article, category: category)
      unpublished_article = create(:article, published: false, category: category)

      get :show, id: category.id
      expect(assigns(:articles)).to include(article)
      expect(assigns(:articles)).to_not include(unpublished_article)
    end
  end
end