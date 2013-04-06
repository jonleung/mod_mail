require 'spec_helper'

describe "email parsing spec" do

  it "should be saved in redis" do
      params = Marshal.load($redis.get "Email:1")

      puts "IGNORERING" if params[:to] != ENV['main_email']
      email = HashWithIndifferentAccess.new
      email[:subject] = params[:subject]
      email[:html] = params[:html]
      email[:text] = params[:text]


  end

end