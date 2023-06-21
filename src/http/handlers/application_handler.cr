module Calm
  module Handler
    alias ParamsHash = Hash(String, Routing::Parameter::Types)
    alias SupportedTypes = String | Int32 | Int64 | Float32 | Float64 | Bool

    abstract class ApplicationHandler
      @@view_classes = Hash(String, Calm::Http::BaseView.class).new

      def self.get_class(name)
        return @@view_classes[name]
      end

      def self.view_classes
        @@view_classes
      end

      # #include Calm::Handler::ApplicationHelper
      include Calm::Mime

      HTTP_METHOD_NAMES = %w(get post put patch delete head options trace)

      @@http_method_names : Array(String) = HTTP_METHOD_NAMES
      @matcher : Calm::Routing::Match
      @format : String
      @page : Int32

      class_getter http_method_names
      getter request
      getter response

      macro method_missing(call)
        def {{call.name}}
          false
        end
      end

      def initialize(@context : HTTP::Server::Context, @matcher)
        @request = @context.request
        @response = @context.response
        @format = @matcher.format
        @params = ParamsHash.new
        @object = Hash(String, String | Hash(String, String)).new
        @matcher.kwargs.each { |key, value| @params[key.to_s] = value }
        @page = (@request.query_params.has_key?("page") ? @request.query_params["page"].to_i32 : 1)

        boundary = @request.headers["Content-Type"]?.try { |header| MIME::Multipart.parse_boundary(header) }
        HTTP::FormData.parse(@request) do |part|
          add_part_name_to_params(part.name, part.body.gets_to_end)
        end if !boundary.nil? && !@request.body.nil?
      end

      def [](variable)
        {% for ivar in @type.instance_vars %}
        if @@STRUCT.keys.includes? {{ivar.stringify}}
          if "{{ivar.id}}" == variable.to_s
            return @{{ivar}}
          elsif "{{ivar.id}}_old" == variable.to_s
          end
        end
        {% end %}
      end

      def call_method(method_name)
        # pp methods
      end

      def default
        # TODO: not implemented
      end

      private def handle_http_method_not_allowed
        Http::Response::MethodNotAllowed.new(self.class.http_method_names)
      end

      def redirect_to(location : String | URI, status : HTTP::Status = :found)
        @response.redirect(location, status)
      end

      protected def add_part_name_to_params(name : String, value : String)
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
