class EmailController < ApplicationController

  def rewrite
    email = Email.find(params[:email_id])
    if email.rewrite(params[:edited_message])
      email.send_confirmation.deliver
      render :text => email.original_text_body
      return
    else
      render :text => "Oh no! Something went wrong!"
      return
    end
  end

  def is_read_image
    email = Email.find(params[:email_id])
    if email.is_read?
      redirect_to "http://i.imgur.com/cp3KrvI.png"
    else
      redirect_to "http://i.imgur.com/u9DOmjq.png"
    end
  end


end