class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :image
      t.datetime :date
      t.string :location
      t.string :street
      t.string :city
      t.string :number
      t.string :zip_code
      t.string :country
      t.float :lat
      t.float :lon
      t.timestamps null: false
    end
  end
end
