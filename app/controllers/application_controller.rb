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
      info = "登录过期,请重新登录."
    else
      info = ex.message
    end

    render json: {
        code: 2,
        info: info
    }
  end

  # 类比PHP die()
  rescue_from DiyExceptions::RenderAndDie do |ex|

    msg = JSON(ex.message) rescue [1, "RenderAndDie"]

    resp = {
        code: msg[0],
        info: msg[1]
    }

    render json: resp

    logger.debug ">>>\n#{resp.to_json}<<<\n"
  end


  # 完全成功的请求
  # 直接结束请求
  def success(info)
    raise DiyExceptions::RenderAndDie, [0, info].to_json
  end


  # 业务上失败的请求, code > 0
  # 直接结束请求
  def failed(code, info)
    raise DiyExceptions::RenderAndDie, [code, info].to_json
  end


  # Redis token 身份认证
  # 认证通过返回 uid, 否则返回false
  def redis_token_auth(login_token=nil, uid=nil, must: true)
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
      redis_key = redisKey(:auth_token, login_token)
      if uid == redis.get(redis_key).to_i
        ans = uid
      else
        ans = false
      end
    end

    # 抛异常, 直接终止后续操作
    if must && !ans
      raise DiyExceptions::AuthMustLogin, "身份认证失败,请登录"
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
