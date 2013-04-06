# encoding: utf-8
# Use until we use a newer mail gem
# This is from '/mail/check_delivery_params.rb'
module Mail

  module CheckDeliveryParams

    def self.included(klass)
      klass.class_eval do

        def check_params(mail)
          envelope_from = mail.return_path ||
                          mail.sender ||
                          mail.from_addrs.first
          if envelope_from.blank?
            err = 'A sender (Return-Path, Sender or From) required'
            raise ArgumentError.new(err)
          end

          destinations = mail.destinations if mail.respond_to?(:destinations)
          if destinations.blank?
            err = 'At least one recipient (To, Cc or Bcc) is required'
            raise ArgumentError.new(err)
          end

          message ||= mail.encoded if mail.respond_to?(:encoded)
          if message.blank?
            err = 'A encoded content is required'
            raise ArgumentError.new(err)
          end

          [envelope_from, destinations, message]
        end

      end
    end
  end
end
