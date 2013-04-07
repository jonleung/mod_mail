class RedirectMapping
  def image_tag_uri
    @image_tag_uri
  end

  def url
    ENV['base_url']+"/p/#{self.image_tag_uri}"
  end

  def self.char
    return @r[image_tag_uri]
  end

  def self.char=(value)
    @r[image_tag_uri].set(value)
  end

  def initialize
    @r = Nest.new(self.class.to_s.underscore)
    @image_tag_uri = self.generate_image_tag_uri
  end

  def generate_image_tag_uri
    tag_uri = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless @r[random_token].present?
    end
    return tag_uri
  end

  def self.create(params)
    raise "cur_char must be a one letter string" unless params[:char].class == String && params[:char].length == 1 && params[:char] != "nil"
    char = params[:char]
    self.char = char
  end

private

  def image_tag_uri=(value)
    @image_tag_uri = value
  end

end