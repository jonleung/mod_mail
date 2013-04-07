class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_cache_buster

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

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
