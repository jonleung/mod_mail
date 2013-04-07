class Email
  include Mongoid::Document
  self.mass_assignment_sanitizer = :strict
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :to, type: Array
  field :subject, type: String
  
  field :original_text_body, type: String
  field :original_html_body, type: String

  field :security_key, type: String

  field :redirect_mappings, type: Array
  field :image_encoded_html_body, type: String
  field :dirty_bit_key, type: String

  def self.max_chars
    9001
  end

  before_save :before_save
  def before_save_callback
    self.generate_security_key
    self.generate_dirty_bit
    self.generate_redirect_mapping_array
    # Use Email.parse_email_body and store things properly
  end

  def generate_redirect_mapping_array
  end

  def generate_security_key
  end

  def generate_dirty_bit
  end

  def is_read?
  end

  def rewrite(new_plain_text_body, security_key)
  end

  def deliver
  end

  def deliver_confirmation
  end


  def set_key
    self.security_token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless ModelName.where(token: random_token).exists?
    end
  end




end