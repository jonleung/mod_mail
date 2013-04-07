class SendgridController < ApplicationController

  def callback
    # render_error "Invalid security token"  unless params[:security_token] == SendGrid.security_token
    $redis.set("last_email", Marshal.dump(params))
    # puts "sent sample_params: #{params}"
    # debugger
    # Resque.enqueue(EmailWorker, params)

    render :text => EmailWorker.perform(params)
  end

end