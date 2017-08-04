class AuthController < ApplicationController
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

  def auth
    login_token = params[:login_token].strip rescue ""
    uid = params[:uid] rescue 0

    if login_token.blank? || uid.blank?
      return failed 2, "请登录"
    end

    redis_key = redisKey("auth_token", login_token)
    if uid == redis.get(redis_key).to_i
      success "验证通过"
    else
      failed 2, "登录过期,请重新登录."
    end
  end

  def logout
    render json: {
        action: "logout"
    }
  end
end
