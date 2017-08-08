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
    if redis_token_auth(must: true)
      success "验证通过"
    end
  end


  # POST
  def logout
    render json: {
        action: "logout"
    }
  end


  # POST
  def uptoken
    uid = redis_token_auth(must: true)

    bucket = 'oh-same'
    key = nil

    put_policy = Qiniu::Auth::PutPolicy.new(
        bucket, # 存储空间
        key, # 指定上传的资源名，如果传入 nil，就表示不指定资源名，将使用默认的资源名
        600 # token 过期时间，默认为 600 秒
    )

    uptoken = Qiniu::Auth.generate_uptoken(put_policy)

    success uptoken
  end


end
