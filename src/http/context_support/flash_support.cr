require "base64"
require "json"

module Calm
  module Http
    module FlashSupport
      property flash = Array(Flash).new

      def load_flash_messages
        cookies = HTTP::Cookies.from_client_headers(request.headers)
        if cookies.has_key?("flash") && cookies["flash"]
          @flash = Array(Flash).from_json(URI.decode_www_form(cookies["flash"].value))
          response.headers.add("Set-Cookie", "flash=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT")
        end
      end

      def persist_flash_messages
        flash_str = URI.encode_www_form(flash.to_json)
        response.headers.add("Set-Cookie", "flash=#{flash_str}; path=/; HttpOnly=true;")
      end

      def flash(type, message)
        flash << Flash.new(type, message)
        persist_flash_messages
      end
    end
  end
end
