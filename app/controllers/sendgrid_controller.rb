class SendgridController < ApplicationController

  def callback
    render_error "Invalid security token"  unless params[:security_token] == SendGrid.security_token
    $redis.set("sample_email", Marshal.dump(params))
    puts "sent sample_params: #{params}"
    # debugger
    # Resque.enqueue(EmailWorker, params)
    render :json => true
  end

end