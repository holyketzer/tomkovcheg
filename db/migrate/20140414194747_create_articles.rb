class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.references :category, index: true
      t.string :title
      t.text :abstract
      t.text :body
      t.boolean :approved, default: false
      t.boolean :published, default: false
      t.boolean :comments_enabled, default: false
      t.boolean :voting_enabled, default: false
      t.boolean :members_only, default: false

      t.timestamps
    end
  end
end
