class AddCategoryToPhoto < ActiveRecord::Migration[7.0]
  def change
    add_column :photos, :category, :integer
  end
end
