class AuthController < ApplicationController


  # POST
  def login
    email = params[:email].strip rescue ""
    password = params[:password] rescue ""
    user = User.find_by(email: email)

    if user && hash_authed?(password, user.password_hash)
      user.update_login_token
      success(user)
    else
      failed(3, ["请确认您的登录信息"])
    end
  end


  # POST
  def register
    email = params[:email].strip rescue ""
    password = params[:password] rescue ""
    name = email.split('@').first rescue "Oh-Samer"

    user = User.new(email: email, password: password, name: name)
    if user.save
      user.update_login_token
      success(user)
    else
      errorMsgs = user.errors.full_messages
      failed(1, errorMsgs)
    end
  end


  # POST
  # 仅仅验证Redis中的Token
  def auth
    login_token = params[:login_token].strip rescue ""
    uid = params[:uid].to_i rescue 0

    if redis_token_auth(login_token, uid)
      success "验证通过"
    else
      failed 2, "登录过期,请重新登录."
    end
  end


  # POST
  def logout
    render json: {
        action: "logout"
    }
  end


  # GET
  def uptoken
    login_token = params[:login_token].strip rescue ""
    uid = params[:uid].to_i rescue 0

    unless redis_token_auth(login_token, uid)
      failed 2, "登录过期,请重新登录."
      return
    end

    bucket = 'oh-same'
    key = nil

    put_policy = Qiniu::Auth::PutPolicy.new(
        bucket, # 存储空间
        key, # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
        120 # token 过期时间，默认为 120 秒
    )

    uptoken = Qiniu::Auth.generate_uptoken(put_policy)

    render json: {
        uptoken: uptoken
    }
  end

  
  private


  def redis_token_auth(login_token, uid)
    if login_token.blank? || uid.blank?
      return false
    end

    redis_key = redisKey("auth_token", login_token)
    if uid == redis.get(redis_key).to_i
      true
    else
      false
    end
  end


end
