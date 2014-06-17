require 'spec_helper'

feature 'User can post comments in articles', %q{
  In order to share my opinion
  As an user
  I want to be able to post comments
 } do
  let(:article) { create(:article) }
  let(:user) { create(:user) }

  before { login_as user }

  scenario 'user posts a comment' do
    visit article_path(article)

    comment = build(:comment)
    within ".new-comment" do
      fill_in 'Комментарий', with: comment.body
      click_on 'Отправить'
    end

    expect(current_path).to eq article_path(article)
    comment = Comment.find_by_body comment.body
    within "#comment-#{comment.id}" do
      expect(page).to have_content comment.body
      expect(page).to have_content comment.user.nickname
      expect(page).to have_content comment.created_at
    end
  end
end