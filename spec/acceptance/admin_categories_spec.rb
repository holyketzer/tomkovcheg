require 'spec_helper'

feature 'Admin can manage categories', %q{
  In order to classify articles
  As an admin
  I want to be able to manage categories
 } do

  let(:admin) { create(:admin) }
  let(:path) { categories_path }
  let!(:category) { create(:category) }

  background do
    login_as admin
  end

  scenario 'Admin views categories list' do
    visit path

    expect(page).to have_link 'Создать', href: new_category_path

    expect(page).to have_content 'Категории'
    within '.list-header' do
      expect(page).to have_content 'Название'
      expect(page).to have_content 'Описание'
      expect(page).to have_content 'Приоритет'
    end

    expect_to_have_category(category, with_link: true, with_priority: true)

    expect(page).to have_link 'Изменить', href: edit_category_path(category)
    expect(page).to have_link 'Удалить', href: category_path(category)
  end

  scenario 'Admin creates new category' do
    new_category = build(:category)
    visit new_category_path

    expect(page).to have_content 'Новая категория'

    fill_fields_for new_category, build(:image_path)
    expect { click_on 'Сохранить' }.to change(Category, :count).by(1)

    expect_category_page Category.last, { with_image: true }
    expect(page).to have_content 'Категория сохранена'
  end

  scenario 'Admin updates existing category' do
    new_category = build(:category)
    visit edit_category_path(category)

    expect(page).to have_content 'Редактирование категории'
    expect(page).to have_field 'Название', with: category.title
    expect(page).to have_field 'Описание', with: category.description
    expect(page).to have_field 'Приоритет', with: category.priority

    fill_fields_for new_category, build(:image_path)
    expect { click_on 'Сохранить' }.to change(Category, :count).by(0)

    expect_category_page category.reload, { with_image: true }
    expect(page).to have_content 'Категория сохранена'
  end

  scenario 'Admin updates existing category without image changing' do
    category = create(:category, image: create(:image))

    visit edit_category_path(category)
    expect(page).to have_image category.image.thumb_url

    new_category = build(:category)
    fill_fields_for new_category
    expect { click_on 'Сохранить' }.to change(Category, :count).by(0)

    expect_category_page category.reload, { with_image: true }
    expect(page).to have_content 'Категория сохранена'
  end

  scenario 'Admin deletes existing category' do
    visit category_path(category)

    expect(page).to have_content category.title
    expect { click_on 'Удалить' }.to change(Category, :count).by(-1)

    expect(current_path).to match(categories_path)
    expect(page).to_not have_content category.title
  end

  private

  def expect_to_have_category(category, params = {})
    within "#category-#{category.id}" do
      expect(page).to have_link category.title, href: category_path(category) if params[:with_link]
      expect(page).to have_content category.title
      expect(page).to have_content category.description
      expect(page).to have_content category.priority if params[:with_priority]
      if params[:with_image]
        expect(category.image).to_not be_nil
        expect(page).to have_image category.image.thumb_url
      end
    end
  end

  def expect_category_page(category, params = {})
    expect(current_path).to match(category_path(category))

    expect_to_have_category category, params
  end

  def fill_fields_for(category, image_path = nil)
    fill_in 'Название', with: category.title
    fill_in 'Описание', with: category.description
    fill_in 'Приоритет', with: category.priority
    attach_file 'Новая картинка', image_path if image_path
  end
end