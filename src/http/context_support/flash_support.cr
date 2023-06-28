module Calm
  module Http
    module FlashSupport
      property flash = Array(Flash).new

      def flash(type, message)
        flash << Flash.new(type, message)
      end
    end
  end
end
