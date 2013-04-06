class GmailController < ApplicationController

  def omniauth_success_callback
    data = HashWithIndifferentAccess.new(request.env["omniauth.auth"])
    
    user_params = HashWithIndifferentAccess.new
    user_params[:google_uid] = data[:uid]
    user_params[:email] = data[:info][:email]
    user_params[:first_name] = data[:info][:first_name]
    user_params[:last_name] = data[:info][:last_name]
    user_params[:photo] = data[:info][:image]

    user_params[:verified_email] = data[:extra][:raw_info][:verified_email]
    user_params[:google_plus] = data[:extra][:raw_info][:link]
    user_params[:gender] = data[:extra][:raw_info][:gender]
    user_params[:locale] = data[:extra][:raw_info][:locale]

    credential_params = HashWithIndifferentAccess.new
    credential_params[:token] = data[:credentials][:token]
    credential_params[:refresh_token] = data[:credentials][:refresh_token]
    credential_params[:expires_at] = data[:credentials][:expires_at]
    credential_params[:expires] = data[:credentials][:expires]

    omniauth_params = {
      :user_params => user_params,
      :credential_params => credential_params,
    }
    user = User.from_omniauth(omniauth_params)

    render :text => "Alrighty #{user_params[:first_name]}, you're all setup!"
  end

  def omniauth_failure_callback
    render :text => "Uh no! You didn't allow access!"
  end

  
end