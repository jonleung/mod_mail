class HostedCharImage

	def initialize(char)
		raise "Invalid char #{char} for HostedCharImage." unless char.class == String &&  (char.length == 1 || char == "nil")
		@r = Nest.new(self.class.to_s.underscore)
		@char = char
		@hosted_image_url = generate_hosted_image_url(char)
	end

	def char
		@char
	end

	def hosted_image_url
		@hosted_image_url
	end

	def hosted_image_url=(value)
		@r[@char].set(value)
		@hosted_image_url = value
	end

	def generate_hosted_image_url(char)
		file = TTFunk::File.open("/Volumes/h/Dropbox/dev/rails/mod_mail/fonts/arial.ttf")
		twelve_px_spacer_url = "http://i.imgur.com/Ffh4ZC6.png"
		bucket = "charmander"

		case char
		when "nil"
  		# get the blank image and do something
	  	when "\n"
	  		self.hosted_image_url = twelve_px_spacer_url
	  	when " "
	  		image = MagickTitle.say("_", color: '#ffffff')
	  		add_img_to_s3(image, bucket) unless @r["blank"].present?
	  	else
	  		if char.in?(%w{p g y q j})
	  			image = MagickTitle.say(char, color: "#000000")
	  		else
	  			descent_height = (file.descent/1000.0*MagickTitle.options[:font_size]).abs
	  			image = MagickTitle.say(char, color: "#000000", bottom_padding: descent_height)
	  		end
	  		add_img_to_s3(image, bucket) unless @r[char].present?
  		end
  	end

  	def add_img_to_s3(image, bucket)
  		AWS::S3::S3Object.store(image.filename, open(image.full_path), bucket, {content_type: 'image/png', :access => :public_read})
		self.hosted_image_url = "http://s3.amazonaws.com/#{bucket}/#{image.filename}"
  	end

end