class ChannelsController < ApplicationController


  # POST
  def create
    uid = redis_token_auth

    user = User.find(uid)
    channel = user.channels.build(create_channel_params)
    if channel.save
      success channel
    else
      failed 4, channel.errors.full_messages
    end


  end


  private


  def create_channel_params
    params.require(:channel).permit(:name, :introduction, :channel_type, :comment_type, :intimity)
  end
end
