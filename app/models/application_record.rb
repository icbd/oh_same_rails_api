class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # 在model中使用全局tools
  include ::ApplicationTools
end
