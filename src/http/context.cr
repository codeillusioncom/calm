module HTTP
  class Server
    class Context
      property username : String?
      property flash = Array(Flash).new

      def with(args)
        obj = Calm.routes.routes.select { |r| r.path == request.path }
        if !obj.nil? && obj.size == 1
          view_obj = obj[0].view
          unless view_obj.nil?
            args_converted = Hash(String, String | Int32).new
            args.each do |key, value|
              args_converted[key] = value
            end
            return view_obj.call args_converted
          end
        end
        "view error"
      end
    end
  end
end
