class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.references :likable, polymorphic: true, index: true
      t.belongs_to :user

      t.timestamps
    end
  end
end

