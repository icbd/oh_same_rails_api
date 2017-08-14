class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :content, comment: "帖子正文文本,最多1000字"
      t.text :attachment, comment: "帖子附件,JSON"
      t.integer :attach_type, null: false, comment: "附件类型, copy from channel_type"
      t.boolean :published, default: true, comment: "是否公开"

      t.references :channel, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true

      t.integer :views_count, default: 0, comment: "浏览量计数"
      t.integer :sames_count, default: 0, comment: "同感量计数"

      t.timestamps
    end

    add_index :posts, [:created_at]
  end
end
