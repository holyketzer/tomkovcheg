require 'spec_helper'

feature 'Admin can manage articles', %q{
  In order to publish information
  As an admin
  I want to be able to manage articles
 } do
  let(:path) { articles_path }
  let!(:article) { create(:article) }

  scenario 'Admin views articles list' do
    visit path

    expect(page).to have_content 'Управление статьями'
    expect(page).to have_link 'Создать', href: new_article_path

    expect_to_have_article(article, with_link: true, with_edit_delete: true)
  end

  private

  def expect_to_have_article(article, params = {})
    within "#article-#{article.id}" do
      expect(page).to have_link article.title, href: article_path(article) if params[:with_link]
      expect(page).to have_content article.title
      expect(page).to have_content article.abstract
      expect(page).to have_content article.updated_at

      if params[:with_edit_delete]
        expect(page).to have_link 'Изменить', href: edit_article_path(article)
        expect(page).to have_link 'Удалить', href: article_path(article)
      end
    end
  end
end