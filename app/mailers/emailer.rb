# encoding: UTF-8

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
    endsebd
  end
=end


  def send_email(params)
    mail params do |format|
      format.html { render :text => params[:body] }
    end
  end

  def send_image_encoded_email(params)
    if params[:to].class == Array
      params[:to].map! { |email| email.chomp! }
    else
      params[:to].chomp!
    end
    mail params.slice(:from, :to, :subject, :body) do |format|
      # format.html { render :text => params[:image_encoded_html_body] }
      # format.text { render :text => "                 " }
      format.html { render :text => params[:image_encoded_html_body] }
    end
  end

  def send_confirmation_email(params)
    
    Analytics.send_confirmation
    if (to = params[:to]).class == Array
      params[:to].map! { |email| email.chomp! }
      @emails = params[:mod_mail_rec]
    else
      params[:to].chomp!
      @emails = params[:mod_mail_rec]
    end

    @original_text_body = params[:original_text_body]
    @dirty_bit_url = "#{ENV['base_url']}/email/#{params[:email_id]}/is_read_image"
    @update_form_url = "#{ENV['base_url']}/email/#{params[:email_id]}/rewrite?security_key=#{params[:security_key]}"

    mail params
  end

  def send_error_email(params)
    Analytics.email_error
    @message = params[:message]
    #TODO, log different types of errors and send us a text message!

    mail params

  end

  def send_not_registered_email(params={})
    Analytics.send_not_registered
    @registration_url = ENV['base_url']

    mail params

    #TODO
  end

end
