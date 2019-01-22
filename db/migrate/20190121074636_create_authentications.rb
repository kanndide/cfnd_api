class CreateAuthentications < ActiveRecord::Migration[5.1]
  def change
    create_table :authentications do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.string :access_token

      t.timestamps
    end
  end
end
