class HelloController < ApplicationController
  def index
    render json: {
        "version" => "0.0.1"
    }
  end
end
