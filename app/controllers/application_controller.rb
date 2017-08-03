class ApplicationController < ActionController::API
  after_action :log_response

  # 引入全局helper
  include ::ApplicationTools

  # redis keys, 全局统一管理
  include ::RedisKeys

  # 自定义异常
  included ::DiyExceptions
  rescue_from DiyExceptions::AuthMustLogin do |ex|
    failed(2, ex.message)
  end


  # 完全成功的请求
  def success(info)
    render json: {
        code: 0,
        info: info
    }
  end

  # 业务上失败的请求, code > 0
  def failed(code, info)
    render json: {
        code: code,
        info: info
    }
  end

  private

  # 开发模式下, 打印响应结果
  def log_response
    if Rails.env.development?
      Rails.logger.info("\n>>>\n" + response_body.to_json + "\n<<<\n")
    end
  end
end
