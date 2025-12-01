class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, comment: "名前"
      t.string :email, comment: "メールアドレス"

      t.timestamps
    end
  end
end
