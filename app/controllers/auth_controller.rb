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
      success(user.to_json)
    else
      errorMsgs = user.errors.full_messages
      failed(1, errorMsgs)
    end
  end

  def logout
    render json: {
        action: "logout"
    }
  end
end
