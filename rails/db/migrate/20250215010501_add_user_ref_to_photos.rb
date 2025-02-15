class AddUserRefToPhotos < ActiveRecord::Migration[7.0]
  def up
    add_reference :photos, :user, null: false, foreign_key: true
  end

  def down
    remove_reference :photos, :user, foreign_key: true
  end
end
