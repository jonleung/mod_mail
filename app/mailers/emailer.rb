class Emailer < ActionMailer::Base
  default from: "hello@ujumbo.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.hello_mailer.subject
  #
=begin
  def sample_send(params)
    mail params do |format|
      format.html { render :text => params[:html_body] }
    end
  end
=end

  def send_confirmation_email(params)
    #TODO
  end

  def send_error_email(params)
    #TODO
  end

  def send_not_registered_email(params)
    #TODO
  end

end