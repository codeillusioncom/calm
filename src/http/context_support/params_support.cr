module Calm
  module Http
    module ParamsSupport
      @object = Hash(String, String | Hash(String, String)).new
      @object_initialized = false

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
