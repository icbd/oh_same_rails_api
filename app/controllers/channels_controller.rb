class ChannelsController < ApplicationController


  # POST
  def create
    uid = redis_token_auth(must: true)

    user = User.find(uid)
    channel = user.channels.build(create_channel_params)
    if channel.save
      success channel
    else
      failed 4, channel.errors.full_messages
    end
  end


  # GET
  def index
    channel_list = Channel.unscoped.order("created_at DESC")
    channel_total = Channel.unscoped.count

    success({list: channel_list, total: channel_total})
  end


  # GET
  def show
    uid = redis_token_auth(must: false)

    channelID = params['id'].to_i rescue failed(3, ['need channel_id'])

    channel = Channel.find(channelID) rescue failed(3, ['not found this channel'])

    success channel
  end


  # GET
  # pure posts list
  # /channels/:id/posts
  def posts
    uid = redis_token_auth(must: false)

    page = Integer(params[:page]) rescue 1
    per_page = Integer(params[:per_page]) rescue 5
    channel_id = Integer(params[:id]) rescue failed(3, ["缺少channel_id"])


    posts_list = Post.unscoped.includes(:user).where(channel_id: channel_id)
                     .offset((page - 1)*per_page).limit(per_page)
                     .order("created_at DESC")

    posts_total = Post.unscoped.where(channel_id: channel_id).count

    success render_to_string json: {list: posts_list, total: posts_total}, include: {:user => {only: [:id, :name, :avatar]}}
  end


  private


  def create_channel_params
    params.require(:channel).permit(:title, :introduction, :channel_type, :comment_type, :intimity)
  end
end
