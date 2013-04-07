# encoding: UTF-8

require 'action_mailer'
require 'active_support'
require 'gmail_xoauth'


class ImagePlaygroundController < ApplicationController


  def playground
    system ("rm -rf ./public/system")

    one_px_spacer_url = "http://i.imgur.com/ED0Q4pg.png"
    twelve_px_spacer_url = "http://i.imgur.com/Ffh4ZC6.png"

    MagickTitle.options[:width] = 23
    MagickTitle.options[:font_size] = 15
    MagickTitle.options[:kerning] = 0
    MagickTitle.options[:height] = nil
    MagickTitle.options[:background_color] = '#8bba3e'
    MagickTitle.options[:log_command] = true

    file = TTFunk::File.open("/Volumes/h/Dropbox/dev/rails/mod_mail/fonts/arial.ttf")

    string = params[:string]
    if string.nil?
      string = "Tiramisu bear claw ice cream carrot cake marzipan cupcake candy wafer tart. Candy jelly beans sugar plum candy canes chocolate cake candy croissant cheesecake. Bear claw cookie pudding halvah. Icing sweet roll jelly beans applicake brownie. Fruitcake chocolate cake bonbon tootsie roll. Lemon drops donut cupcake faworki applicake dessert bonbon. Gummi bears sweet roll donut jelly-o toffee. Biscuit pastry jelly beans caramels brownie apple pie. Cheesecake gummi bears sesame snaps jelly-o caramels apple pie. Biscuit powder jelly-o jelly beans icing dragée. Sesame snaps marshmallow macaroon. Wypas cotton candy gummies. Gingerbread sweet muffin gummies gummies pudding. Chupa chups fruitcake candy.\nDessert tiramisu chocolate tart oat cake gingerbread tiramisu liquorice. Ice cream biscuit cheesecake topping oat cake powder danish dessert cake. Cupcake tiramisu sesame snaps tootsie roll bear claw dragée. Tart sugar plum lollipop. Icing applicake fruitcake soufflé. Bear claw lollipop soufflé pudding cookie sugar plum topping. Tiramisu wypas jelly-o fruitcake tiramisu sweet roll applicake ice cream. Muffin halvah bonbon. Jelly-o powder sesame snaps applicake marshmallow. Gummies pastry chocolate bar halvah jujubes ice cream sugar plum apple pie jelly. Cookie ice cream lemon drops pudding muffin chocolate bar sesame snaps faworki wypas. Gummi bears croissant chocolate bar fruitcake.\n"
      # string = " please"
    end
    # string = "hy"
    html = "<html><body>"
    string.split("").each do |char|

      case char
      when " "
        char = "_"
        image = MagickTitle.say(char, color: '#ffffff')

        bucket = 'charmander'
        filename = image.filename

        if image_url = $redis.get("image:#{filename}")
          image_html = "<img src='#{image_url}'>"
          puts "FOUND #{char}"
        else

          puts "Uploading '#{char}'' to Amazon"
          object = AWS::S3::S3Object.store(filename, open(image.full_path), 'ImageChars', {content_type: 'image/png', :access => :public_read} )
          puts "UPLOADED "
          image_url = "http://s3.amazonaws.com/#{bucket}/#{filename}"

          $redis.set("image:#{filename}", image_url)

          image_html = "<img src='#{image_url}'>"
        end

      when "\n"
        image_html = "<img src='#{twelve_px_spacer_url}'>"
      else
        if char.in?(%w{p g y q j})
          image = MagickTitle.say(char, color: "#000000")
        else
          descent_height = (file.descent/1000.0*MagickTitle.options[:font_size]).abs
          puts "descent height = #{descent_height}"
          image = MagickTitle.say(char, color: "#000000", bottom_padding: 3)
        end

        bucket = 'charmander'
        filename = image.filename

        if image_url = $redis.get("image:#{filename}")
          image_html = "<img src='#{image_url}'>"
          puts "FOUND #{char}"
        else

          puts "Uploading '#{char}'' to Amazon"
          object = AWS::S3::S3Object.store(filename, open(image.full_path), 'ImageChars', {content_type: 'image/png', :access => :public_read} )
          puts "UPLOADED "
          image_url = "http://s3.amazonaws.com/#{bucket}/#{filename}"

          $redis.set("image:#{filename}", image_url)

          image_html = "<img src='#{image_url}'>"
        end

      end

      html << '<span>'+ image_html + '</span>'
    end

    html << "</body></html>"

    send_gmail_email(html)

    render :text => html
  end

  def send_email(html)
    puts "ABOUT TO SEND EMAIL!"

    body = {
        api_user: "modmail",
        api_name: "modmail",
        api_key: "ayakasayslessismore",
        to: "naruto137@gmail.com",
        html: html,
        from: "confirmation@modmail.cc",
        toname: "Jonathan Leung",
        subject: "Hello7"
      }


    options = { 
      body: body
    }
    response = HTTParty.post("https://sendgrid.com/api/mail.send.json", options).to_hash
    puts "SENDGRID RESPONSE:\n#{response}"
  end

  def send_gmail_email(html)
    the_params = {
      from: "hi@modmail.cc",
      to: "wellecks@gmail.com",
      subject: "THE SUBJECT",
      body: html
    }

    response = Emailer.send_email(the_params).deliver
    puts "EMAIL RESPONSE = #{response}"

  end

  def debug
    debugger
    redirect_to '/p'
  end

end