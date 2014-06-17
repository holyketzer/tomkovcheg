require 'spec_helper'

feature 'Admin can manage roles', %q{
  In order to grant permissions
  As an admin
  I want to be able to manage roles
 } do

  let(:path) { roles_path }

  let!(:admin) { create(:admin) }
  let(:roles) { Role.all }
  let(:admin_role) { Role.find_by name: 'admin' }
  let(:moderator_role) { Role.find_by name: 'moderator' }
  let(:permissions) { Permission.all }

  before { login_as admin }

  scenario 'Admin views roles list' do
    visit path

    within '.header' do
      expect(page).to have_content 'Роли'
    end

    within '.list-header' do
      expect(page).to have_content 'Название'
    end

    roles.each do |role|
      expect(page).to have_content role.name
      expect(page).to have_link 'Изменить', href: role_permissions_path(role)
    end
  end

  scenario 'Admin views particular role' do
    roles.each do |role|
      visit role_path role

      within '.header' do
        expect(page).to have_content role.name
      end

      role.permissions.each do |permission|
        expect(page).to have_content permission.name
      end
    end
  end

  scenario 'Admin grants all permissions to moderator' do
    visit role_permissions_path(moderator_role)

    within '.header' do
      expect(page).to have_content 'Настройка роли'
      expect(page).to have_content moderator_role.name.downcase
    end

    within '.permissions' do
      expect(page).to have_content 'Права'
      expect(page).to have_content 'Состояние'

      permissions.each do |permission|
        unless moderator_role.permissions.include?(permission)
          within("##{permission.id}") { click_on 'Включить' }
        end
      end

      visit role_path(moderator_role)
      permissions.each { |permission| expect(page).to have_content permission.name }
    end
  end

  scenario 'Admin can not change admin role permissions' do
    visit role_permissions_path(admin_role)

    expect(current_path).to eq path
    expect(page).to have_content 'Невозможно изменить права для администратора'
  end
end