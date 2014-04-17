require 'spec_helper'

describe ArticlesController do
  describe 'GET index' do
    it 'returns pusblished and approved articles' do
      active_article = create(:article)
      published_only_article = create(:article, published: true, approved: false)
      approved_only_article = create(:article, published: false, approved: true)

      get :index
      expect(assigns(:articles)).to eq([active_article])
    end
  end
end