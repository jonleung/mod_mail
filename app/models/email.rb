class Email
  include Mongoid::Document
  self.mass_assignment_sanitizer = :strict
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  belongs_to :user

  field :from, type: String
  field :reply_to, type: String
  field :to, type: Array
  field :subject, type: String

  field :original_text_body, type: String
  field :original_html_body, type: String

  field :security_key, type: String

  field :redirect_mapping_uris, type: Array
  field :image_encoded_html_body, type: String
  field :dirty_bit_key, type: String


  def self.max_chars
    200
  end

  before_create :before_create_callback
  def before_create_callback
    self.generate_security_key
    true
  end

  before_save :before_save_callback
  def before_save_callback
    self.generate_dirty_bit
    self.generate_redirect_mapping_array
    self.generate_html_encoded_html_body
    # Use Email.parse_email_body and store things properly
    true
  end

  # after_initialize :chomping
  # def chomping
  #   if self.to.class == Array
  #     self.to.map! { |email| email.chomp! }
  #   else
  #     self.to.chomp!
  #   end
  # end


  def generate_dirty_bit
    dirty_bit = DirtyBit.new
    self.dirty_bit_key = dirty_bit.key
  end

  def generate_redirect_mapping_array
    self.redirect_mapping_uris = []

    raise "body is too long" if self.original_text_body.length > Email.max_chars

    self.original_text_body.split("").each do |char|
      self.redirect_mapping_uris << RedirectMapping.new(char).image_tag_uri
    end
    (Email.max_chars - self.original_text_body.length).times do
      self.redirect_mapping_uris << RedirectMapping.new("").image_tag_uri
    end
  end

  def generate_html_encoded_html_body
    self.image_encoded_html_body = ""

    img_tags_html = redirect_mapping_uris.each.map do |rmap_uri|
      rmap = RedirectMapping.find_by_image_tag_uri(rmap_uri)
      img_tag = HtmlHelper.build_and_wrap_image(rmap.url)
      self.image_encoded_html_body << img_tag
    end
    
    self.image_encoded_html_body = HtmlHelper.wrap_all_image_tags(self.image_encoded_html_body)
  end

  def is_read?
    DirtyBit.find_by_key(self.dirty_bit_key)
  end

  def rewrite(new_plain_text_body)
    self.image_encoded_html_body = ""
    self.original_text_body = ""

    i = 0
    char_array = new_plain_text_body.split("")
    redirect_mapping_uris.zip(char_array) do |uri, char|
      char = "" if char.nil?
      rmap = RedirectMapping.find_by_image_tag_uri(uri)
      rmap.char = char

      img_tag = HtmlHelper.build_and_wrap_image(rmap.url)
      # debugger if i == 0 || i == 1
      self.image_encoded_html_body << img_tag
      self.original_text_body << char
      i += 1
    end

    self.image_encoded_html_body = HtmlHelper.wrap_all_image_tags(self.image_encoded_html_body)
    self.save
  end



  def send_image_encoded_email
    Emailer.send_image_encoded_email({
      from: user.email,
      to: self.to,
      subject: self.subject,
      body: self.image_encoded_html_body,
      image_encoded_html_body: self.image_encoded_html_body
    })
  end

  def send_confirmation
    Emailer.send_confirmation_email({
      from: user.email,
      to: user.email,
      mod_mail_rec: self.to.to_s,
      subject: self.subject,
      original_text_body: self.original_text_body,
      email_id: self.id.to_s,
      security_key: security_key
    })
  end

  def generate_security_key
    self.security_key = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless Email.where(token: random_token).exists?
    end

  end

end