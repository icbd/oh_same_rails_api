class PostsController < ApplicationController

  # GET
  # /posts/
  def index
    posts_list = Post
                     .unscoped
                     .includes(:user)
                     .offset((@page - 1) * @per_page).limit(@per_page)
                     .order("created_at DESC")
    posts_total = Post.unscoped.count

    success render_to_string json: {list: posts_list, total: posts_total}, include: {:user => {only: [:id, :name, :avatar]}}
  end

  # POST
  # /posts/
  def create
    uid = redis_token_auth(must: true)

    user = User.find(uid)
    posts = user.posts.build(create_posts_params)
    if posts.save
      success render_to_string json: posts, include: {:user => {only: [:id, :name, :avatar]}}
    else
      failed 4, posts.errors.full_messages
    end
  end


  private

  def create_posts_params
    params.require(:post).permit(:content, :attachment, :attach_type, :available, :channel_id)
  end
end
