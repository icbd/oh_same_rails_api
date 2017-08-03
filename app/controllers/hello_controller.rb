class HelloController < ApplicationController
  def index
    render json: {
        "version" => "0.0.1"
    }
  end

  def t
    unless Rails.env.development?
      render json: {"hello#t" => "调试接口"} and return
    else
      p ">>>debug@hello#t<<<"
    end


    u= User.find(4)
    p u.auth

    render json: {"t" => "debug"}

    p "<<<debug@hello#t>>>"
  end
end
