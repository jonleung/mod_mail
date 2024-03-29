# encoding: UTF-8

class HostedCharImage

	def self.r
		@@r ||= Nest.new(self.class.to_s.underscore)
	end

	def initialize(char)
		raise "Invalid char #{char} for HostedCharImage." unless char.class == String && char.length <= 1
		@r = HostedCharImage.r
		@char = char
		@hosted_image_url = generate_hosted_image_url(char)
	end

	def char
		@char
	end

	def hosted_image_url
		return @r[@char].get if @r[char].get.present?
		@hosted_image_url
	end

	def hosted_image_url=(value)
		@r[@char].set(value)
		@hosted_image_url = value
	end

	def generate_hosted_image_url(char)
		file = TTFunk::File.open("./fonts/arial.ttf")
		twelve_px_spacer_url = "http://i.imgur.com/Ffh4ZC6.png"
		one_pixel_gif = "http://i.imgur.com/xr80qqX.gif"
		bucket = "charmander"

		case char
		when ""
			self.hosted_image_url = one_pixel_gif
  		# get the blank image and do something
	  	when "\n"
	  		self.hosted_image_url = twelve_px_spacer_url
	  	when " "
	  		image = MagickTitle.say("_", color: '#ffffff')
	  		add_img_to_s3(image, bucket) unless @r["blank"].get.present?
	  	else
	  		if char.in?(%w{p g y q j})
	  			image = MagickTitle.say(char, color: "#000000")
	  		else
	  			descent_height = (file.descent/1000.0*MagickTitle.options[:font_size]).abs
	  			image = MagickTitle.say(char, color: "#000000", bottom_padding: 3)
	  		end
	  		add_img_to_s3(image, bucket) unless @r[char].get.present?
  		end
  		self.hosted_image_url
  	end

  	def add_img_to_s3(image, bucket)
  		AWS::S3::S3Object.store(image.filename, open(image.full_path), bucket, {content_type: 'image/png', :access => :public_read})
		self.hosted_image_url = "http://s3.amazonaws.com/#{bucket}/#{image.filename}"
  	end

end