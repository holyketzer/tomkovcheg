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

# Roles and permissions
# You sould execute RolePermission.delete_all if you want to refill the role permissions

user_permissions = [
  { name: 'Просмотр cтатей', action: :read, subject: 'Article' },
  { name: 'Профиль', action: :manage, subject: :account }
]

moderator_permissions = user_permissions + [
  { name: 'Статьи', action: :manage, subject: 'Article' }
]

admin_permissions = moderator_permissions + [
  { name: 'Категории', action: :manage, subject: 'Category' },
  { name: 'Пользователи', action: :manage, subject: 'User' },
  { name: 'Права', action: :manage, subject: 'Permission' }
]

all_permissions = admin_permissions

# Recreate permissions
all_permissions.each do |permission|
  name = permission.delete(:name)
  p = Permission.where(permission).first
  if p.present?
    p.update(name: name)
  else
    Permission.create!(permission.merge(name: name))
  end
end

roles = [
  { name: 'admin' },
  { name: 'moderator' },
  { name: 'user' }
]

roles.each do |role_hash|
  role = Role.where(role_hash).first
  role = Role.create!(role_hash) unless role.present?
  Rails.logger.debug "Role #{role.name}"

  if role.permissions.empty?
    permissions = eval("#{role.name}_permissions")
    permissions.each do |permission_hash|
      permission = Permission.where(permission_hash).first
      role.permissions << permission
      Rails.logger.debug "   granted permission #{permission.name}"
    end
  end
end