class Channel < ApplicationRecord
  belongs_to :user, :counter_cache => true
  has_many :posts


  # 标题
  validates :title,
            presence: true,
            length: {in: 1..30}

  validates :description,
            length: {maximum: 200}

end
