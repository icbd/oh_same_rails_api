class UsersController < ApplicationController

  # GET
  # /users/:id/
  def show
    user = User.find(params['id'])
    success user.basic_info
  end


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


  # GET
  # pure posts list
  # /users/:id/posts
  def posts
    # uid = redis_token_auth(must: false)

    page = Integer(params[:page]) rescue 1
    per_page = Integer(params[:per_page]) rescue 5
    user_id = Integer(params[:id]) rescue failed(3, ["缺少user_id"])


    posts_list = Post.unscoped.includes(:user).where(user_id: user_id)
                     .offset((page - 1)*per_page).limit(per_page)
                     .order("created_at DESC")

    posts_total = Post.unscoped.where(user_id: user_id).count

    success render_to_string json: {list: posts_list, total: posts_total}, include: {:user => {only: [:id, :name, :avatar]}}
  end


  # GET
  # pure posts list
  # /users/:id/channels
  def channels
    # uid = redis_token_auth(must: false)

    page = Integer(params[:page]) rescue 1
    per_page = Integer(params[:per_page]) rescue 5
    user_id = Integer(params[:id]) rescue failed(3, ["缺少user_id"])


    channel_list = Channel.unscoped.includes(:user).where(user_id: user_id)
                       .offset((page - 1)*per_page).limit(per_page)
                       .order("created_at DESC")

    channel_total = Channel.unscoped.where(user_id: user_id).count

    success render_to_string json: {list: channel_list, total: channel_total}, include: {:user => {only: [:id, :name, :avatar]}}
  end


  private


  def update_user_params
    params.require(:user).permit(:name, :avatar)
  end
end
