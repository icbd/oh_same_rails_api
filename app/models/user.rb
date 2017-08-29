class User < ApplicationRecord
  has_many :channels
  has_many :posts
  has_many :comments

  # 昵称
  validates :name,
            presence: true,
            length: {maximum: 100}

  # 邮箱
  before_save :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  # 密码
  attr_accessor :password
  before_create :password_hash_init
  validates :password,
            length: {minimum: 6},
            :if => :password

  # 性别
  enum sex: {
      secret: -1,
      girl: 0,
      boy: 1
  }
  validates :sex, inclusion: sexes.keys

  # 用户邮箱激活
  attr_accessor :activation_token
  before_create :init_user


  # 用户token, 每次登陆更新一次, 仅允许最新单一设备在线.
  # Controller中的 /auth/auth仅仅验证Redis中的token, 允许多设备通过.
  def update_login_token
    login_token = "#{generate_token}_#{self.id}"
    update_attribute(:login_token, login_token)

    redis_key = redisKey(:auth_token, self.login_token)
    redis.set(redis_key, self.id)
    redis.expire(redis_key, 7.days.to_i)
  end

  # 验证login_token是否有效
  # 默认强制需要
  def auth(must=true)
    user_id = redis.get(redisKey(:auth_token, self.login_token)).to_i
    if must && user_id==0
      raise DiyExceptions::AuthMustLogin, "请您先登录"
    end

    user_id
  end


  # 用户不涉密的基本信息
  def basic_info
    self.attributes.select do |key, value|
      ['id', 'name', 'avatar', 'created_at'].include?(key)
    end
  end


  private


  # 新用户初始化
  def init_user
    self.actived = false
    self.activation_token = generate_token
    self.activation_hash = calc_hash(self.activation_token)
  end


  # DB内全部以小写存储
  def downcase_email
    self.email = self.email.downcase
  end

  def password_hash_init
    self.password_hash = calc_hash(self.password)
  end
end
