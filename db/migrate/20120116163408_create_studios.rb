class CreateStudios < ActiveRecord::Migration
  def change
    create_table :studios do |t|
      t.string :name
      t.string :address
      t.float :lat
      t.float :lng
      t.string :photo_url
      t.string :studio_url

      t.timestamps
    end
    add_index :studios, :name, :unique => true
    add_index :studios, :studio_url, :unique => true
  end
end
