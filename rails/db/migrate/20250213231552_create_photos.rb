class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.string :description

      t.timestamps
    end
  end
end
