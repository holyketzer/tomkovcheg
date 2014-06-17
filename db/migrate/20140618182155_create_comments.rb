class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :article, index: true
      t.references :user, index: true
      t.string :body

      t.timestamps
    end
  end
end
