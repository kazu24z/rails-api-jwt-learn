class SessionsController < ApplicationController
  def create
    # トークン発行処理
    # メールアドレスからユーザーを取得
    user = User.find_by(email: params['email'])
    # ユーザー存在 かつ パスワード一致の場合、トークンを発行
    ## user_idとjtiを含める
    if user && user&.authenticate(params[:password])
      jti = user.jti
      payload = {jti: jti, user_id: user.id}
      token = JWT.encode(payload, Rails.application.credentials[:secret_key_base])
    end
    render json: {token: token}
  end

  def delete
    # トークン解読処理

    render json: {message: 'test'}
  end
end
