module HTTP
  class Server
    class Context
      property username : String?
      property flash = Array(Flash).new

      def self.html(&block)
        yield
      end
    end
  end
end
