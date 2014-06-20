crumb :root do
  link 'Главная', root_path
end

crumb :category do |category|
  link category.title, category_path(category)
end

crumb :article do |article|
  link article.title, article_path(article)
  parent :category, article.category
end

crumb :galleries do
  link 'Фотографии', galleries_path
end

crumb :gallery do |gallery|
  link gallery.title, gallery_path(gallery)
  parent :galleries
end

#region for admin

crumb :categories do
  link 'Категории', categories_path
end

crumb :edit_category do |category|
  if category.title
    link category.title, category_path(category)
  else
    link 'Новая категория', '#'
  end
  parent :categories
end

crumb :articles do
  link 'Статьи', articles_path
end

crumb :edit_article do |article|
  if article.title
    link article.title, article_path(article)
  else
    link 'Новая статья', '#'
  end
  parent :articles
end

crumb :edit_gallery do |gallery|
  if gallery && gallery.persisted?
    link 'Редактирование', edit_gallery_path(gallery.id)
    parent :gallery, gallery
  else
    link 'Новая фотогалерея', '#'
    parent :galleries
  end
end

#endregion

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).