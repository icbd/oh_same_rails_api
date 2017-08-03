class ApplicationController < ActionController::API
  after_action :log_response

  # 引入全局helper
  include ::ApplicationTools


  # 完全成功的请求
  def success(info)
    return render json: {
        code: 0,
        info: info
    }
  end

  # 业务上失败的请求, code > 0
  def failed(code, info)
    return render json: {
        code: code,
        info: info
    }
  end

  private
  def log_response
    if Rails.env.development?
      logger.info("\n>>>\n" + response_body.to_json + "\n<<<\n")
    end
  end
end
