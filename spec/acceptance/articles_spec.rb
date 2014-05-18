require 'spec_helper'

feature 'Admin can manage articles', %q{
  In order to publish information
  As an admin
  I want to be able to manage articles
 } do
  let(:path) { articles_path }
  let(:image) { create(:image) }
  let!(:article) { create(:article, images: [image]) }

  scenario 'Admin views articles list' do
    visit path

    expect(page).to have_link 'Создать', href: new_article_path

    expect_to_have_article(article, with_link: true, with_edit_delete: true)
  end

  scenario 'Admin creates new article' do
    new_article = build(:article)
    visit new_article_path

    expect(page).to have_content 'Новая статья'

    fill_fields_for new_article, ['spec/support/images/tiger.jpg', 'spec/support/images/another image.jpg']
    expect { click_on 'Сохранить' }.to change(Article, :count).by(1)

    article = Article.last
    expect(article.images.size).to eq 2
    expect_article_page article
    expect(page).to have_content 'Статья сохранена'
  end

  scenario 'Admin creates unpublished article' do
    new_article = build(:article, published: false)
    visit new_article_path

    fill_fields_for new_article
    expect { click_on 'Сохранить' }.to change(Article, :count).by(1)

    visit article_path(Article.last)
    expect(current_path).to eq(articles_path)
    expect(page).to_not have_content Article.last.title
  end

  scenario 'Admin updates existing article' do
    new_article = build(:article)
    visit edit_article_path(article)

    expect(page).to have_content 'Редактирование статьи'
    expect(page).to have_select 'Категория', selected: article.category.title
    expect(page).to have_field 'Заголовок', with: article.title
    expect(page).to have_field 'Краткое содержание', with: article.abstract
    expect(page).to have_field 'Статья', with: article.body
    expect(page).to have_image article.images.first.thumb_url

    fill_fields_for new_article, ['spec/support/images/another image.jpg']
    expect { click_on 'Сохранить' }.to change(Article, :count).by(0)

    article.reload
    expect(article.images.size).to eq 2
    expect_article_page article
    expect(page).to have_content 'Статья сохранена'
  end

  scenario 'Admin deletes existing article' do
    visit article_path(article)

    expect(page).to have_content article.title
    expect { click_on 'Удалить' }.to change(Article, :count).by(-1)

    expect(current_path).to match(articles_path)
    expect(page).to_not have_content article.title
  end

  private

  def expect_to_have_article(article, params = {})
    within "#article-#{article.id}" do
      expect(page).to have_link article.title, href: article_path(article) if params[:with_link]
      expect(page).to have_content article.title
      expect(page).to have_content article.created_at.to_date

      article.images.each do |image|
        expect(page).to have_image image.thumb_url
      end

      if params[:full]
        expect(page).to have_content article.category.title
        expect(page).to have_content article.body
      else
        expect(page).to have_content article.abstract
      end

      if params[:with_edit_delete]
        expect(page).to have_link 'Изменить', href: edit_article_path(article)
        expect(page).to have_link 'Удалить', href: article_path(article)
      end
    end
  end

  def expect_article_page(article)
    expect(current_path).to match(article_path(article))

    expect_to_have_article article, full: true
  end

  def fill_fields_for(article, images = [])
    select article.category.title, from: 'Категория'
    fill_in 'Заголовок', with: article.title
    fill_in 'Краткое содержание', with: article.abstract
    fill_in 'Статья', with: article.body
    set_check 'Опубликована', article.published
    set_check 'Одобрена', article.approved
    attach_file 'Иллюстрации', images
  end

  def set_check name, value
    if value
      check name
    else
      uncheck name
    end
  end
end