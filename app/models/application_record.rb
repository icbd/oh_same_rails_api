class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # 在model中使用全局tools
  include ::ApplicationTools

  # 自定义异常
  included ::DiyExceptions

  # redis keys, 全局统一管理
  include ::RedisKeys
end
