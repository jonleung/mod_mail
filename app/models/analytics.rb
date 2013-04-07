module Analytics

  def self.r
    Nest.new("analytics")
  end

  def self.no_gmail
    r[:no_gmail].incr
  end

  def self.send_confirmation
    r[:no_gmail].incr
  end

  def self.email_error
    r[:no_gmail].incr
  end

  def self.not_registered
    r[:no_gmail].incr
  end

  def self.email_worker_completed
    r[:email_worker_completed].incr
  end


end