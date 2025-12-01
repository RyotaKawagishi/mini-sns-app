class AddRememberDigestToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :remember_digest, :string, comment: "記憶トークンのハッシュ"
  end
end
