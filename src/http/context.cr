module HTTP
  class Server
    class Context
      property username : String?
      property flash = Array(Flash).new

      @object = Hash(String, String | Hash(String, String)).new
      @object_initialized = false

      def with(args = Hash(String, String).new)
        obj = Calm.routes.routes.select { |r| r.path == request.path }
        if !obj.nil? && obj.size == 1
          view_obj = obj[0].view
          unless view_obj.nil?
            args_converted = Hash(String, String | Int32).new
            args.each do |key, value|
              args_converted[key] = value
            end
            return view_obj.call self, args_converted
          end
        end
        "view error"
      end

      def table(model : Calm::Db::Base.class)
        obj = Calm.routes.routes.select { |r| r.path == request.path }
        view_obj = obj[0].view
        args = Hash(String, String | Int32).new
        return view_obj.call self, args
      end

      def ui
        ui_obj = Calm::UI.new(self)
        with ui_obj yield
        return ui_obj.lines_joined
      end

      def post_params
        request_body = @request.body

        if request_body
          return HTTP::Params.parse(request_body.gets_to_end)
        else
          return HTTP::Params.new
        end
      end

      def params
        return @object if @object_initialized

        boundary = @request.headers["Content-Type"]?.try { |header| MIME::Multipart.parse_boundary(header) }
        HTTP::FormData.parse(@request) do |part|
          add_part_name_to_params(part.name, part.body.gets_to_end)
        end if !boundary.nil? && !@request.body.nil?
        @object_initialized = true

        pp post_params

        return @object
      end

      def sign_out
        response.headers.add("Set-Cookie", "token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT")
        @username = nil
      end

      private def add_part_name_to_params(name : String, value : String)
        result = /(.*)\[(.*)\]/.match(name)
        if result && result.size == 3
          @object[result[1].to_s] = Hash(String, String).new unless @object.has_key?(result[1].to_s)
          if @object[result[1].to_s].is_a?(Hash)
            @object[result[1].to_s].as(Hash)[result[2].to_s] = value.to_s
          else
            #
          end
        else
          @object[name] = value
        end
      end
    end
  end
end
