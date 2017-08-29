class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :content, null: false, comment: "评论正文"
      t.text :attachment, comment: "评论附件,JSON"
      t.boolean :published, default: true, comment: "是否公开"

      t.references :posts, foreign_key: true, index: true, comment: "挂载在哪个帖子下面"
      t.references :users, foreign_key: true, index: true, comment: "评论发起人"

      t.integer :reply_to, index: true, comment: "评论回复给谁(可选).为空时即为留言."

      t.timestamps
    end

  end
end
