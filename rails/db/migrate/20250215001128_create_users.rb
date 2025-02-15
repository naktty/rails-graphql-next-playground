class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :github_login, null: false
      t.string :name
      t.string :avatar

      t.timestamps
    end
    add_index :users, :github_login, unique: true
  end
end
