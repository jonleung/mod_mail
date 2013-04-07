class RedirectMapping
  
  def self.r
    @@r ||= Nest.new(self.class.to_s.underscore)
  end

  def image_tag_uri
    @image_tag_uri
  end

  def url
    ENV['base_url']+"/p/#{self.image_tag_uri}"
  end

  def char
    return @r[image_tag_uri].get
  end

  def char=(value)
    @r[image_tag_uri].set(value)
  end

  def initialize(char)
    @r = RedirectMapping.r
    @image_tag_uri = self.generate_image_tag_uri
    raise "cur_char must be a one letter string or the empty string" unless char.class == String && char.length > 1
    self.char = char
  end

  def generate_image_tag_uri
      begin
        random_token = SecureRandom.urlsafe_base64
        return random_token unless @r[random_token].get.present?
      end
  end

  def self.find_by_image_tag_uri(uri)
    char = self.r[uri].get
    img_map = HostedCharImage.new(char)
    img_map.hosted_image_url
  end

private

  def image_tag_uri=(value)
    @image_tag_uri = value
  end

end