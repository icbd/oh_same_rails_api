class PostsController < ApplicationController

  #POST
  def create
    uid = redis_token_auth(must: true)

    user = User.find(uid)
    posts = user.posts.build(create_posts_params)
    if posts.save
      success posts
    else
      failed 4, posts.errors.full_messages
    end
  end


  private

  def create_posts_params
    params.require(:post).permit(:content, :attachment, :attach_type, :available, :channel_id)
  end
end
