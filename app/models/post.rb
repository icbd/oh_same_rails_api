class Post < ApplicationRecord
  belongs_to :channel #, :counter_cache => true
  belongs_to :user

  # 正文
  validates :content,
            length: {maximum: 1000}

end
