class TestingController < ApplicationController

  def work
    params = Marshal.load($redis.get("sample_email"))

    params[:text] = "naruto137@gmail.com\nwellecks@gmail.com\n\nHello World!"
    params[:html] = "<h1>Hello World!</h1>"

    params[:from] = params[:from][/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/]
    params[:text] = params[:text].force_encoding("ISO-8859-1").encode("UTF-8")
    params[:html] = params[:html].force_encoding("ISO-8859-1").encode("UTF-8")

    unless params[:from][/@gmail.com/]
      Emailer.send_error_email(message: "Unfortunately, our service only works with GMail right now!").deliver
      return
    end

    user = User.where(email: params[:from]).first
    if user.nil?
      Emailer.send_not_registered_email.deliver
      return

    elsif params[:text].length > Email.max_chars
      Emailer.send_error_email(message: "Unfortunately your email is too long! Please try sending the email again with a shorter message!").deliver
    end

    email_params = convert_email_params(params)
    email = user.emails.new(email_params)

    if email.save
      # YAY!
    else
      Emailer.send_error_email(message: "We are still in alpha and unforuntaely our service was unable to send your email.").deliver
      return
    end

    if email.send_image_encoded_email == false
      Emailer.send_error_email(message: "We are still in alpha and unforuntaely our service was unable to send your email.").deliver
      return
    end

    if email.send_confirmation == false
      Emailer.send_error_email(message: "We are still in alpha and unforuntaely our service was unable to send your email.").deliver
      return
    end    

    Analytics.email_worker_completed
    render json: "true".to_json
  end

  def convert_email_params(params)
    email_params = HashWithIndifferentAccess.new

    body_hash = EmailHelper.parse_email_body(params[:text])
    email_params[:original_text_body] = body_hash[:body]
    to_recipients = body_hash[:to]



    email_params[:from] = params[:from]
    email_params[:to] = to_recipients
    email_params[:reply_to] = params[:from]
    email_params[:subject] = params[:subject]
    email_params[:original_html_body] = params[:html]


    return email_params
  end
end