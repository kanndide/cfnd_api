class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.belongs_to :user
      t.belongs_to :blog
      t.integer :parent_id, index: true
      t.text :content


      t.timestamps
    end
  end
end
