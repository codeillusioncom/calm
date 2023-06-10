module Calm
  module Handler
    alias ParamsHash = Hash(String, Routing::Parameter::Types)
    alias SupportedTypes = String | Int32 | Int64 | Float32 | Float64 | Bool

    class ApplicationHandler
      @@view_classes = Hash(String, Calm::Http::BaseView.class).new

      def self.get_class(name)
        puts "get class..."
        pp @@view_classes
        pp @@view_classes.size
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

        puts "itt a classok"
        pp @@view_classes
      end

      macro call_method(method_name)
        {% for method in (@type.methods.map(&.name)) %}
        {% if method.stringify == method_name %}
          {{ method.id }}
        {% end %}
        {% end %}
      end

      def default
        # TODO: not implemented
      end

      def index
        default
      end

      def show
        default
      end

      def new
        default
      end

      def create
        default
      end

      def edit
        default
      end

      def update
        default
      end

      def destroy
        default
      end

      def process_dispatch
        Log.info { "Process dispatch: #{@matcher.action}" }
        begin
          case @matcher.action
          when :index
            call_method("index")
          when :show
            call_method("show")
          when :new
            call_method("new")
          when :create
            call_method("create")
          when :edit
            call_method("edit")
          when :update
            call_method("update")
          when :destroy
            call_method("destroy")
          end
          # #persist_flash
        rescue e : AccessDeniedException
          Log.info { "Access denied." }
          # TODO: other types
          # #@context.flash << HTTP::Server::Flash.new("danger", "Access denied! You don't have enough permission to view this page.")
          # @response.content_type = "text/html"
          # @response.print
          # #persist_flash
          @response.redirect("/")
        end
      end

      private def handle_http_method_not_allowed
        Http::Response::MethodNotAllowed.new(self.class.http_method_names)
      end

      def render(view_name, locals = {} of String | Symbol => SupportedTypes)
        # env = ::Crinja.new
        # controller_name = self.class.to_s.underscore.split("_").first
        # env.loader = ::Crinja::Loader::FileSystemLoader.new("src/views/#{controller_name}")

        # template = env.get_template("/#{@matcher.action}.#{@format}.j2")

        res = ApplicationView.new.index do
          # HomeView.new.show
          # render_class(self.class.to_s.split("Handler")[0])
          puts "itten veszem ki"
          ApplicationHandler.get_class("#{self.class.to_s.split("Handler")[0]}View").new.show
        end

        @response.content_type = MIME_TYPES[@format]
        # @response.print template.render(locals)
        pp res
        @response.print res
      end

      def redirect_to(location : String | URI, status : HTTP::Status = :found)
        @response.redirect(location, status)
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
