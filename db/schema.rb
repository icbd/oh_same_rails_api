# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170818090958) do

  create_table "channels", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "title", null: false, comment: "频道名称"
    t.text "description", comment: "频道简介"
    t.string "icon", comment: "频道图标"
    t.integer "channel_type", default: 0, null: false, comment: "频道类型: 0,图文;1,文字;2,语音;3,音乐;4,电影;5,打卡;6,视频;7,投票;"
    t.integer "comment_type", default: 0, null: false, comment: "评论类型: 0,私密聊天;1,公开评论;"
    t.integer "intimity", default: 0, null: false, comment: "公开类型: 0,完全公开;1,完全不公开;2,部分公开;"
    t.integer "posts_count", default: 0, null: false, comment: "频道下帖子计数器"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: true
    t.index ["user_id"], name: "index_channels_on_user_id"
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.text "content", null: false, comment: "评论正文"
    t.text "attachment", comment: "评论附件,JSON"
    t.boolean "published", default: true, comment: "是否公开"
    t.bigint "posts_id"
    t.bigint "users_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["posts_id"], name: "index_comments_on_posts_id"
    t.index ["users_id"], name: "index_comments_on_users_id"
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.text "content", comment: "帖子正文文本,最多1000字"
    t.text "attachment", comment: "帖子附件,JSON"
    t.integer "attach_type", null: false, comment: "附件类型, copy from channel_type"
    t.boolean "published", default: true, comment: "是否公开"
    t.bigint "channel_id"
    t.bigint "user_id"
    t.integer "views_count", default: 0, comment: "浏览量计数"
    t.integer "sames_count", default: 0, comment: "同感量计数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comments_count", default: 0
    t.index ["channel_id"], name: "index_posts_on_channel_id"
    t.index ["created_at"], name: "index_posts_on_created_at"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "email", null: false, comment: "唯一/非空/加索引"
    t.string "name", null: false, comment: "用户昵称"
    t.string "password_hash"
    t.string "login_token", comment: "登陆令牌: 随机码+ID"
    t.boolean "actived", default: false
    t.string "activation_hash"
    t.string "reset_password_hash"
    t.string "avatar", comment: "头像"
    t.integer "sex", default: -1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "channels_count", default: 0
    t.integer "posts_count", default: 0
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "channels", "users"
  add_foreign_key "comments", "posts", column: "posts_id"
  add_foreign_key "comments", "users", column: "users_id"
  add_foreign_key "posts", "channels"
  add_foreign_key "posts", "users"
end
