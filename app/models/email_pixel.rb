class EmailPixel
  # include ActiveModel::Model

  attr_reader :key
  attr_accessor :image_key

  def initialize
    @r = Nest.new(self.class.to_s)
  end


  def url
    "/p/#{@key}"
  end

  def write_image_key(image_key)
    @key = loop do
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

end