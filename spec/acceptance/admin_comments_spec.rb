require 'spec_helper'

feature 'Admin can nmanage comments in articles', %q{
  In order to manage site
  As an user
  I want to be able to manage comments
 } do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:article) { create(:article) }
  let!(:comment) { create(:comment, article: article, user: user) }

  before do
    login_as admin
    visit article_path(article)
  end

  scenario 'admin deletes comment' do
    within "#comment-#{comment.id}" do
      click_on 'Удалить'
    end

    expect(current_path).to eq article_path(article)
    within '.comments' do
      expect(page).to_not have_content comment.body
    end
  end
end