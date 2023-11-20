class PostsController < ApplicationController
  def index
    posts = @current_user.posts

    render json: posts.as_json(only: [:id, :title])
  end
end
