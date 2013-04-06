class Email
  include Mongoid::Document
  self.mass_assignment_sanitizer = :strict
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :key, type: String
  before_save :before_save_hook
  def before_save_hook
    self.set_key
    self.set_images
  end

  def set_key
    self.key = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless ModelName.where(token: random_token).exists?
    end
  end




end