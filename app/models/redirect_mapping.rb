class RedirectMapping
  # image_tag_uri
  # char

  def image_tag_uri
    if @image_tag_uri.nil?
      @image_tag_uri = @r[:image_tag_uri]
    end
    return @image_tag_uri
  end

  def url
    ENV['base_url']+"/p/#{self.image_tag_uri}"
  end

  def char
    if @char.nil?
      @char = @r[:char]
    end
    return @char
  end

  def char=
    @r[:char].set(value)
  end

  def initialize
    @r = Nest.new(self.class.to_s.underscore)
    self.genreate_image_tag_uri
  end

  def genreate_image_tag_uri
    self.image_tag_uri = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless @r[random_token].present?
    end

    @r[@key] = image_key
  end

  def self.create(params)
    raise "cur_char must be a one letter string" unless cur_char.class == String && cur_char.length == 1
    
    char = params[:char]
    # styling = params[:styling] #TODO found with Nokogiri

    image = Image.create(cur_char)
    image_key = image.key
    
    email_pixel = EmailPixel.new
    email_pixel.write_image_key(image_key)

    return email_pixel
  end

private

  def image_tag_uri=(value)
    @r[:image_tag_uri].set(value)
  end


end