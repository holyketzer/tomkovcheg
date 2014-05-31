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

#endregion

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).