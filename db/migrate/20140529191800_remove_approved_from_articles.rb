class RemoveApprovedFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :approved
  end
end
