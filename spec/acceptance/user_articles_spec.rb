require 'spec_helper'

feature 'User can view articles', %q{
  In order to get information
  As an user
  I want to be able to read articles
 } do
  let(:image) { create(:image) }
  let(:article) { create(:article, images: [image]) }

  scenario 'user reads an article' do
    visit article_path(article)

    within "#article-#{article.id}" do
      expect(page).to have_content article.title
      expect(page).to have_content article.created_at.to_date
      expect(page).to have_content article.body
      article.images.each { |image| expect(page).to have_image image.thumb_url }

      expect(page).to_not have_link 'Изменить', href: edit_article_path(article)
      expect(page).to_not have_link 'Удалить', href: article_path(article)
    end
  end
end