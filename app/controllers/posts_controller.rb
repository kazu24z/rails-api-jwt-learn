class PostsController < ApplicationController
  def index
    # TODO: 認証処理で取得したユーザーからpostsを取得するようにする
    posts = User.find(1).posts

    render json: posts.as_json(only: [:id, :title])
  end
end
