class CreateChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :channels do |t|

      t.string :title, null: false, unique: true, comment: "频道名称"
      t.text :description, comment: "频道简介"
      t.string :icon, comment: "频道图标"

      t.integer :channel_type, null: false, default: 0, comment: "频道类型: 0,基本;1,音乐引用;2,电影引用;3,图书引用;4,打卡;5,投票;"
      t.integer :comment_type, null: false, default: 0, comment: "评论类型: 0,私密聊天;1,公开评论;"
      t.integer :intimity, null: false, default: 0, comment: "公开类型: 0,完全公开;1,完全不公开;2,部分公开;"

      t.integer :posts_count, null: false, default: 0, comment: "频道下帖子计数器"

      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
