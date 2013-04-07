OmniAuth.config.logger = Rails.logger

OmniAuth.config.on_failure = Proc.new do |env|
  "GmailController".constantize.action(:omniauth_failure_callback).call(env)
end

ENV['GOOGLE_KEY'] = "306831549813-3bjr78a7u8fgld0pkc56t7pr77c3i487.apps.googleusercontent.com"
ENV['GOOGLE_SECRET'] = "5GT8Fcd-zXNhBTa3TKEKliIg"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {
    :scope => "https://mail.google.com/,https://www.googleapis.com/auth/userinfo.profile,https://www.googleapis.com/auth/userinfo.email",
    :approval_prompt => "auto"
  }
end

#TODO, add back persmission