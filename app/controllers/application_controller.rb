class ApplicationController < ActionController::API
  before_action :verify_token

  private

  def verify_token
    token = request.headers['Authorization'].split(" ")[1]

    unless token.present?
      render json: { error: 'Authorization header is missing' }, status: :unauthorized
      return
    end
    begin
      # トークンをデコード
      decoded = HashWithIndifferentAccess.new (
        JWT.decode(token, Rails.application.credentials[:secret_key_base])[0]
      )

      # expが切れているかチェック
      if decoded[:exp].nil? || decoded[:exp] < Time.now.to_i
        render json: { error: 'Token has expired' }, status: :unauthorized
        return
      end
      # userが存在するかチェック
      @current_user = User.find_by(id: decoded[:user_id])
      unless @current_user
        render json: { error: 'Invalid token' }, status: :unauthorized
        return
      end
      # jtiが有効かチェック
      unless decoded[:jti] == @current_user.jti
        render json: { error: 'Invalid token' }, status: :unauthorized
        return
      end
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

end
