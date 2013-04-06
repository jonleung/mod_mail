class ConfirmationMailer < ActionMailer::Base
  include SendGrid
  sendgrid_category :use_subject_lines
  sendgrid_enable   :ganalytics, :opentrack, :clicktrack

  default from: "from@example.com"

  def send_confirmation
    mail :to => "naruto137@gmail.com", :subject => "Your email has been scheduled!"
  end
end
