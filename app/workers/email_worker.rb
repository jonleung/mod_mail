class EmailWorker
  @queue = :email_receive_queue

  def self.perform(params)
    unless params[:from][/@gmail.com/]
      Email.send_error_email(message: "Unfortunately, our service only works with GMail right now!")
      return
    end

    user = User.where(email: params[:from]).first
    if user.nil?
      Emailer.send_not_registered_email #TODO
      return

    elsif params[:text].length > Email.max_chars
      Emailer.send_error_email(message: "Unfortunately your email is too long! Please try sending the email again with a shorter message!") #TODO
    end

    email_params = convert_email_params(params)
    email = user.emails.new(email_params)
    email.save

    if email.errors
      Emailer.send_error_email(message: "We are still in alpha and unforuntaely our service was unable to send your email.")
      return
    end

    if email.deliver == false
      Emailer.send_error_email(message: "We are still in alpha and unforuntaely our service was unable to send your email.")
      return
    end

    if email.deliver_confirmation == false
      Emailer.send_error_email(message: "We are still in alpha and unforuntaely our service was unable to send your email.")
      return
    end

    

    

    user.google_credential.refresh #todo, smartly do this
    user.token

    # if user is not authenticated, 
    # Emailer.send_not_registered_email

    # Send Error Email

    # Send Too Many Charachters Email


    email = HashWithIndifferentAccess.new
    email[:subject] = params[:subject]
    email[:text] = params[:text]
    email[:from] params[:from]

  end

  def convert_email_params(params)
    email_params = HashWithIndifferentAccess.new

    body_hash = EmailHelper.parse_recipients_from_body(params[:text])
    email_params[:plain_text_body] = body_hash[:body]
    to_recipients = body_hash[:to]

    email_params[:reply_to] = params[:from]
    email_params[:subject] = params[:subject]
    email_params[:html] = params[:html]

    return email_params
  end




end