require "spec_helper"

describe "ConfirmationMailer" do
  it "sends the email" do
    email = "naruto137@gmail.com"
    user = User.where(email: email).first
    raise "unable to find user" if user.nil?
    token = user.google_credential.token
    email_params = {
      from_name: "Jonathan Leung",
      to: "naruto137@gmail.com", 
      subject: "This is the Subject", 
      body: "<htm<h1>Hello Body</h1>", 
      
      authing_email: email,
      token: token,

    }
    EmailSender.send_email(email, email, token, email_params)

    # response = ConfirmationMailer.send_confirmation.deliver
    # debugger

  end

end


# require "spec_helper"

# describe ConfirmationMailer do
#   describe "send_confirmation" do
#     let(:mail) { ConfirmationMailer.send_confirmation }

#     it "renders the headers" do
#       mail.subject.should eq("Send confirmation")
#       mail.to.should eq(["to@example.org"])
#       mail.from.should eq(["from@example.com"])
#     end

#     it "renders the body" do
#       mail.body.encoded.should match("Hi")
#     end
#   end

# end
