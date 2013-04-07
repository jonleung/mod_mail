class SendgridController < ApplicationController

  def callback
    debugger
    render_error "Invalid security token"  unless params[:security_token] == SendGrid.security_token
    debugger
    Resque.enqueue(EmailWorker, params)
    render :json => true
  end

end