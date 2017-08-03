class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|

      t.string :email, null: false, index: true, unique: true, comment: "唯一/非空/加索引"
      t.string :name, null: false, comment: "用户昵称"
      t.string :password_hash
      t.string :login_token, comment: "登陆令牌: 随机码+ID"
      t.boolean :actived, default: false
      t.string :activation_hash
      t.string :reset_password_hash
      t.string :avatar, comment: "头像"
      t.integer :sex, default: -1 # -1:未知, 0:女生, 1:男生

      t.timestamps
    end
  end
end
