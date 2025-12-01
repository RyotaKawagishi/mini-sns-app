class AddActivationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :activation_digest, :string, comment: "有効化トークンのハッシュ"
    add_column :users, :activated, :boolean, default: false, comment: "有効化フラグ"
    add_column :users, :activated_at, :datetime, comment: "有効化日時"
  end
end
