require 'resolv'
require 'debugger'


def try_localtunnel
  require 'pty'
  require 'redis'
  require 'debugger'

  $redis = Redis.new
  redis_channel = "localtunnel:url"
  $redis.set(redis_channel, "")

  #TODO: Use http://godrb.com/

  pid = fork do
    $redis = Redis.new

    cmd = "localtunnel 3000" 

    begin

      PTY.spawn( cmd ) do |stdin, stdout, pid|
        begin
          stdin.each do |line|
            if !(localtunnel_url = line[/(http:\/\/.*?\.localtunnel\.com)/]).nil?
              $redis.set(redis_channel, localtunnel_url)
              break
            end
          end
        rescue Errno::EIO
          puts "Errno:EIO error, but this probably just means " +
                "that the process has finished giving output"
        end
      end
    rescue PTY::ChildExited
      puts "The child process exited!"
    end
  end

  loop do 
    if (localtunnel_url = $redis.get(redis_channel) ).empty?
      puts "waiting for localtunnel"
      sleep 1
    else
      ENV['base_url'] = localtunnel_url
      puts "SET ENV['base_url'] = #{ENV['base_url']}"
      break
    end
  end

end

if defined?(Rails::Server)


  response = HTTParty.get('http://icanhazip.com')
  ip = response.body.gsub(/\s*/, "")
  if Resolv::IPv4::Regex.match(ip).present? || Resolv::IPv6::Regex.match(ip).present?
    ENV["ip"] = ip
    begin
      port = Rails::Server.new.options[:Port]
    rescue
      port = "3000"
    end

    ENV["base_url"] = "http://#{ip}:#{port}"
    puts "SET ENV['base_url'] = #{ENV["base_url"]}" 
    # begin
    #   response = HTTParty.get(ENV["base_url"])
    #   puts "Retrieved IP is external, ENV[\"base_url\"] = #{ENV["base_url"] }"
    # rescue
    #   puts "Unable to establish external ip!"

    #   if Rails.env.development? || Rails.env.test?
    #     puts "attempting to setup localtunnel!"
    #     try_localtunnel if ENV['try_localtunnel'] == "true"
    #   end

    # end
    
  else

    raise "Unable to get external ip from icanhazip.com!"

  end

end
