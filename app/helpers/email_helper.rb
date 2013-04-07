module EmailHelper

  #Syntax: Email addresses seperated by newlines
  #Syntax: Body seperated from emails by double newline
  def self.parse_email_body(body)
    email_regex = /.+@.+\..+/
    to = []
    text = ""
    emails = body.split("\n\n")[0]
    emails.split("\n").each do |line|
      if line[email_regex]
        to << line
      end
    end
    
    if emails.length < 1
      raise ""    
    else
      text = body.split("\n\n")[1..-1].join("\n\n")
    end
    return { :to => to, :text => text }
  end

end
