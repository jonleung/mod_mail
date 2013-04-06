class EmailWorker
  @queue = :email_receive_queue

  def self.perform(params)
    user = User.where(email: params[])

    email = HashWithIndifferentAccess.new
    email[:subject] = params[:subject]
    email[:html] = params[:html]
    email[:text] = params[:text]
    email[:from] params[:from]

  end
end