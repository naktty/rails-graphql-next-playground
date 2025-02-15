class CreatePhotoTags < ActiveRecord::Migration[7.0]
  def change
    create_table :photo_tags do |t|
      t.references :photo, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :photo_tags, [:photo_id, :user_id], unique: true
  end
end
