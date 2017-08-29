class Comment < ApplicationRecord
  belongs_to :post, :counter_cache => true
  belongs_to :user

  # 正文
  validates :content,
            length: {in: 1..100}
end
