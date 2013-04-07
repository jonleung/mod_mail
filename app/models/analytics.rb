module Analytics

  def self.r
    Nest.new(self.class.name.underscore)
  end

  def self.no_gmail
    r.incr("no_gmail")
  end

  def self.send_confirmation
    r.incr("no_gmail")
  end

  def self.email_error
    r.incr("no_gmail")
  end

  def self.not_registered
    r.incr("no_gmail")
  end

  def self.email_worker_completed
    r.incr("email_worker_completed")
  end


end