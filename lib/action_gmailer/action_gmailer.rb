# encoding: utf-8
require 'action_mailer'
require 'active_support'
require 'gmail_xoauth'
require_relative 'ext/check_delivery_params'

module ActionGmailer

  class DeliveryError < StandardError
  end

  class DeliveryMethod
    include Mail::CheckDeliveryParams # for check_params(...)

    attr_reader :settings

    attr_accessor :smtp_host, :smtp_port
    attr_accessor :helo_domain, :auth_type
    attr_accessor :account, :oauth2_token

    def initialize(settings)
      self.settings = settings
    end

    def settings=(settings)
      @settings = settings
      set_accessors_from_settings!
    end

    def deliver!(mail)
      envelope_from, destinations, message = check_params(mail)

      smtp = Net::SMTP.new(smtp_host, smtp_port)
      smtp.enable_starttls_auto
      smtp.start(helo_domain, account, oauth2_token, auth_type) do
        smtp.sendmail(message, envelope_from, destinations)
      end
    rescue StandardError => exp
      raise DeliveryError, exp.message
    end

    private

    def default_smtp_host
      'smtp.gmail.com'
    end

    def default_smtp_port
      587
    end

    def default_helo_domain
      'gmail.com'
    end

    def default_auth_type
      :xoauth2
    end

    def set_accessors_from_settings!
      @smtp_host    = settings[:smtp_host]    || default_smtp_host
      @smtp_port    = settings[:smtp_port]    || default_smtp_port
      @helo_domain  = settings[:helo_domain]  || default_helo_domain
      @auth_type    = settings[:auth_type]    || default_auth_type
      @oauth2_token = settings.fetch(:oauth2_token)
      @account      = settings.fetch(:account)
    rescue KeyError
      raise DeliveryError, 'Missing required setting'
    end

  end
end

ActionMailer::Base.add_delivery_method(:action_gmailer,
                                       ActionGmailer::DeliveryMethod)
