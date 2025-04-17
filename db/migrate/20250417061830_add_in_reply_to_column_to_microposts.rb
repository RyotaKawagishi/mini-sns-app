class AddInReplyToColumnToMicroposts < ActiveRecord::Migration[7.1]
  def change
    add_column :microposts, :in_reply_to, :integer
    add_foreign_key :microposts, :users, column: :in_reply_to
    add_index :microposts, [:in_reply_to, :created_at]
  end
end
