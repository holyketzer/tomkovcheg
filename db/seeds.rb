# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

categories = [
  { id: 1, title: 'Новости', description: '' },
  { id: 2, title: 'Общее', description: 'Основные статьи' },
  { id: 3, title: 'Полезная информация', description: '' },
  { id: 4, title: 'Сенсорная комната', description: '' },
  { id: 5, title: 'Служба ранней помощи', description: '' },
  { id: 6, title: 'Наши педагоги', description: '' },
  { id: 7, title: 'Календарь событий', description: '' },
  { id: 8, title: 'Духовные импульсы', description: '' },
  { id: 9, title: 'Главная страница', description: 'Для отображения на главной странице' },
  { id: 10, title: 'Благодарности', description: '' },
]

categories.each do |category_hash|
  category = Category.find_by_id(category_hash[:id])

  if category.present?
    category.update!(category_hash)
  else
    category = Category.create!(category_hash)
  end

  Rails.logger.debug "Category #{category.title} was initialized"
end