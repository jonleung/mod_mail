class EmailWorker
  @queue = :email_receive_queue

  def self.perform(params)
    user = User.where(email: params[])

    # if user is not authenticated, 
    # Emailer.send_not_registered_email

    # Send Error Email

    # Send Too Many Charachters Email


    email = HashWithIndifferentAccess.new
    email[:subject] = params[:subject]
    email[:html] = params[:html]
    email[:text] = params[:text]
    email[:from] params[:from]

  end


end