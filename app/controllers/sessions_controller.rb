class SessionsController < ApplicationController

  def create
    user = User.from_omaniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    render json: user.to_json
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed Out!"
  end

end