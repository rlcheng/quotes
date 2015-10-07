class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    token = auth.credentials.token
    email = auth.info.email
    
    user = User.find_or_create_by(email: email)
    session = Session.create(oauth_token: token, user_id: user.id)
    render json: session
  end

  def auth_failed
    render json: "400", status: 400
  end

  def destroy
    session = Session.find_by(id: params[:id])
    session.destroy

    head 204
  end
end
