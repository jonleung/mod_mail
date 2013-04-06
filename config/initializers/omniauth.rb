OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = Proc.new do |env|
  "GmailController".constantize.action(:omniauth_failure_callback).call(env)
end

ENV['GOOGLE_KEY'] = "437562178340.apps.googleusercontent.com"
ENV['GOOGLE_SECRET'] = "KCYeiLoRVTQe5pYLO_HR4j_F"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {
    :scope => "https://mail.google.com/,https://www.googleapis.com/auth/userinfo.profile,https://www.googleapis.com/auth/userinfo.email",
    :approval_prompt => "auto"
  }
end

#TODO, add back persmission