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
    puts "GOT localtunnel_url = #{localtunnel_url}"  
    break
  end
end

"End Program!"