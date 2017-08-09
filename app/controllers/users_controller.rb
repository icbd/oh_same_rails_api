class UsersController < ApplicationController

  # PATCH
  def update
    uid = redis_token_auth(must: true)
    user = User.find(uid)

    if user.update_attributes(update_user_params)
      success user
    else
      failed 4, user.errors.full_messages
    end

  end


  private


  def update_user_params
    params.require(:user).permit(:name, :avatar)
  end
end
