image = MagickTitle.say("jonathanrocks")

bucket = 'charmander'
filename = image.filename

object = AWS::S3::S3Object.store(filename, open(image.full_path), 'ImageChars', {content_type: 'image/png', :access => :public_read} )
url = "http://s3.amazonaws.com/#{bucket}/#{filename}"


