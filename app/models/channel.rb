class Channel < ApplicationRecord
  belongs_to :user

  # 标题
  validates :title,
            presence: true,
            length: {in: 1..15}

  validates :description,
            length: {maximum: 200}
  

end
