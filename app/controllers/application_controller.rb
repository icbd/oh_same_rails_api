class ApplicationController < ActionController::API
  after_action :log_response


  # 引入全局helper
  include ::ApplicationTools


  # redis keys, 全局统一管理
  include ::RedisKeys


  # 自定义异常
  included ::DiyExceptions
  rescue_from DiyExceptions::AuthMustLogin do |ex|
    if ex.message == 'DiyExceptions::AuthMustLogin'
      msg = "登录过期,请重新登录."
    else
      msg = ex.message
    end

    failed(2, msg)
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


  # Redis token 身份认证
  # 认证通过返回 uid, 否则返回false
  def redis_token_auth(login_token=nil, uid=nil, must: false)
    ans = false

    if login_token.nil?
      login_token = params[:login_token].strip rescue ""
    else
      login_token = login_token.strip rescue ""
    end

    if uid.nil?
      uid = params[:uid].to_i rescue 0
    else
      uid = uid.to_i rescue 0
    end


    if login_token.blank? || (uid==0)
      ans = false
    else
      redis_key = redisKey("auth_token", login_token)
      if uid == redis.get(redis_key).to_i
        ans = uid
      else
        ans = false
      end
    end

    # 抛异常, 直接终止后续操作
    if must && !ans
      raise DiyExceptions::AuthMustLogin
    end

    ans
  end


  private


  # 开发模式下, 打印响应结果
  def log_response
    if Rails.env.development?
      Rails.logger.info("\n>>>\n" + response_body.to_json + "\n<<<\n")
    end
  end
end
