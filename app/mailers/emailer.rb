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

  def send_email(params)
    Analytics.no_gmail
    
    mail params do |format|
      format.html { render :html => params[:html_body] }
    end
  end

  def send_confirmation_email(params)
    Analytics.send_confirmation
    @emails = params[:to_emails_array].join(", ")
    @original_text_body = params[:text_body]
    @update_form_url = "/email/#{params[:email_id]}/update?security_token=#{params[:security_token]}"
    # TODO
  end

  def send_error_email(params)
    Analytics.email_error
    @message = params[:message]
    #TODO, log different types of errors and send us a text message!
  end

  def send_not_registered_email(params)
    Analytics.send_not_registered
    @registration_url = "/"
    #TODO
  end

  def send_image_encoded_html(params)
    mail params do |format|
      format.html { render :html => params[:html] }
    end
  end

end
