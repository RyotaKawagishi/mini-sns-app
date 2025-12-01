class CreateMicroposts < ActiveRecord::Migration[7.1]
  def change
    create_table :microposts do |t|
      t.text :content, comment: "コンテンツ"
      t.references :user, null: false, foreign_key: true, comment: "ユーザーID"

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
  end
end
