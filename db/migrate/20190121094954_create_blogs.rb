class CreateBlogs < ActiveRecord::Migration[5.1]
  def change
    create_table :blogs do |t|

      t.belongs_to :user
      t.string :title
      t.text :content
      t.string :featured_image
      t.string :category
      t.string :slug
      t.string :meta_description

      t.timestamps
    end
  end
end
