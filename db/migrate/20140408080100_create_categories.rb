class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :priority, default: 0
      t.string :description

      t.timestamps
    end
  end
end
