require 'spec_helper'

feature 'User can view categories', %q{
  In order to find articles
  As an user
  I want to be able to view categories
 } do
  let(:category) { create(:category) }
  let!(:articles) { create_list(:article, 5, category: category) }

  scenario 'User views articles in the category' do
    visit category_path(category)

    expect(page).to have_content category.title
    expect(page).to_not have_content category.description

    expect(page).to_not have_link 'Изменить', href: edit_category_path(category)
    expect(page).to_not have_link 'Удалить', href: category_path(category)

    articles.each do |article|
      within "#article-#{article.id}" do
        expect(page).to have_content article.title
        expect(page).to have_content article.created_at.to_date
        expect(page).to have_content article.abstract

        expect(page).to_not have_link 'Изменить', href: edit_article_path(article)
        expect(page).to_not have_link 'Удалить', href: article_path(article)
      end
    end
  end
end