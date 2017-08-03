module ApplicationTools

  # 计算摘要
  def calc_hash(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 生成随机令牌
  def generate_token
    SecureRandom.urlsafe_base64
  end

  # 验证令牌
  def hash_authed?(string, hash)
    if hash.blank?
      return false
    end
    BCrypt::Password.new(hash).is_password?(string)
  end
end
