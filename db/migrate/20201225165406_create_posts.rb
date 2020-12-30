class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.references :group, null: false, foreign_key: true
      t.string :title
      t.string :price
      t.string :location
      t.float :longitude
      t.float :latitude
      t.string :images
      t.text :text
      t.string :link

      t.timestamps
    end
  end
end
