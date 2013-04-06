require 'net/smtp.rb'
require 'gmail_xoauth'


module EmailSender

  def self.format_addresses(addresses)
    raise "addesses must be passed in as array of hashes" if addresses.class != Array

    output = ""

    addresses.each_with_index do |params, i|
      raise "each address must be a Hash" unless params.class.in? [Hash, HashWithIndifferentAccess]
      raise "params must have a :name & :email" unless :name.in?(params.keys) && :email.in?(params.keys)
      raise "params" if params[:email].nil?

      output << %Q{"#{params[:name]}" } if params[:name]
      output << "<#{params[:email]}>"

      output << ", " unless params == addresses.last 
    end

    output
  end

  def self.send_email(from, authing_email, token, params)
    
    params[:from]        ||= 'authing_email'
    params[:from_name]   ||= 'Example Emailer'
    params[:subject]     ||= "You need to see this"
    params[:body]        ||= "Important stuff!"

    params.slice(:from, :body, :to).each do |k, v|
      raise "#{k} is not passed in." if (v == nil)
    end
    #TODO make all to interpret from array


    message = <<-MESSAGE_END.gsub(/^ {6}/, '')
      From: 
      To: #{format_addresses params[:to]}
      MIME-Version: 1.0
      Content-type: text/html
      Subject: #{params[:subject]}

      #{params[:body]}
    MESSAGE_END

    msg = "
      From: #{params[:from_alias]} <#{params[:from]}>
      To: <#{params[:to]}>
      Subject: #{params[:subject]}

      #{params[:body]}
    "
    debugger

    net_smtp = Net::SMTP.new('smtp.gmail.com', 587)
    net_smtp.enable_starttls_auto

    net_smtp.start('gmail.com', authing_email, token, :xoauth2) do |smtp|
      debugger
      response = smtp.send_message params[:body], params[:from], params[:to]
      debugger
    end

  end

end