class AddGithubTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :github_token, :string, after: :github_login
  end
end
