class Post < ApplicationRecord
  belongs_to :channel, :counter_cache => true
  belongs_to :user, :counter_cache => true

  # 正文
  validates :content,
            length: {maximum: 1000}

end
