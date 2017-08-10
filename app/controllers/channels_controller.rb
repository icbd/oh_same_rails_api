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
  def show
    uid = redis_token_auth(must: false)

    channelID = params['id'].to_i rescue failed(3, 'need channel_id')

    channel = Channel.find(channelID) rescue failed(3, 'not found this channel')

    success channel
  end


  private


  def create_channel_params
    params.require(:channel).permit(:title, :introduction, :channel_type, :comment_type, :intimity)
  end
end
