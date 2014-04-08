require 'spec_helper'

feature 'Admin can manage categories', %q{
  In order to classify articles
  As an admin
  I want to be able to manage categories
 } do

  let(:path) { categories_path }
  let!(:category) { create(:category) }

  scenario 'Admin views categories list' do
    visit path

    expect(page).to have_link 'Создать', href: new_category_path

    expect(page).to have_content 'Категории'
    within '.list-header' do
      expect(page).to have_content 'Название'
      expect(page).to have_content 'Описание'
      expect(page).to have_content 'Приоритет'
    end

    expect_to_have_category(category)

    expect(page).to have_link 'Изменить', href: edit_category_path(category)
    expect(page).to have_link 'Удалить', href: category_path(category)
  end

  def expect_to_have_category(category)
    within "#category-#{category.id}" do
      expect(page).to have_content category.title
      expect(page).to have_content category.description
      expect(page).to have_content category.priority
    end
  end
end