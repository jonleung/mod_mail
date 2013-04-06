class ApplicationController < ActionController::Base
  protect_from_forgery

   def render_error(msg=nil, code=nil, &block)
    msg ||= 'error'
    code ||= 404
    if is_error = block_given? ? yield : true
      render :json=>{ :error => { :message=>msg, :code=>code } }
      true
    end
  end

  alias_method :render_error_if, :render_error
  
  def render_success(msg=nil, &block)
    msg ||= 'success'
    if success = block_given? ? yield : true
      render :json=> { :result => { :message=>msg } }
      true
    end
  end

end
