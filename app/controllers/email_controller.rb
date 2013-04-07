class EmailController < ApplicationController

  def rewrite
    email = Email.find(params[:id])
    if email.security_key != params[:security_key]
      render :text => "Oh no, you're trying to hack us : ("
      return
    end

    if email.rewrite(params[:body])
      render :text => "Ok! You're email is all set!\n"
      return
    else
      render :text => "Oh no! Something went wrong!"
      return
    end
  end

  def is_read_image
    email = Email.find(params[:id])
    if email.security_key != params[:security_key]
      render :text => "Oh no, you're trying to hack us : ("
      return
    end

    if email.is_read?
      redirect_to "http://i.imgur.com/cp3KrvI.png"
    else
      redirect_to "http://i.imgur.com/u9DOmjq.png"
    end
  end


end