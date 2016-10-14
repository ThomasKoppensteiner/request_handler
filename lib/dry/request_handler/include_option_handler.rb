# frozen_string_literal: true
require "dry/request_handler/option_handler"
require "dry/request_handler/error"
module Dry
  module RequestHandler
    class IncludeOptionHandler < OptionHandler
      def run
        options = params.fetch("include") { "" }
        raise InvalidArgumentError.new("include", "contains a space") if options.include? " "
        options.split(",").map do |option|
          begin
            allowed_options_type.call(option) if allowed_options_type
          rescue Types::ConstraintError
            raise OptionNotAllowedError.new(option)
          end
          option.to_sym
        end
      end
    end
  end
end
