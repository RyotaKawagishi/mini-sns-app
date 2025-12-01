class AddResetToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :reset_digest, :string, comment: "パスワードリセットトークンのハッシュ"
    add_column :users, :reset_sent_at, :datetime, comment: "パスワードリセットメール送信日時"
  end
end
