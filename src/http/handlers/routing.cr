module Calm
  class Route
    getter path
    getter callback
    getter type
    alias ParamsHash = String | Int32
    property view : Proc(HTTP::Server::Context, Hash(String, ParamsHash), String)

    def initialize(@path : String, @type : String = "get", &@callback : HTTP::Server::Context -> String)
      @view = Proc(HTTP::Server::Context, Hash(String, String | Int32), String).new { |args| "" }
    end
  end

  class Routes
    getter routes

    def initialize
      @routes = [] of Calm::Route
    end

    macro get_post(route, mapping, type, view)
      def self.{{mapping.id.underscore.gsub(/\./, "__")}}
        {{route}}
      end

      route = Calm::Route.new({{route}}, {{type}}) do |context|
        {{mapping.receiver}}.new.{{mapping.name}}(context)
      end

      # TODO: choose view
      {% if view %}
        route.view = ->(context: HTTP::Server::Context, args : Hash(String, String | Int32)){({{view.receiver}}.new.{{mapping.name}}(context, args)) || "" }
      {% else %}
        route.view = ->(context: HTTP::Server::Context, args : Hash(String, String | Int32)){({{mapping.receiver}}View.new.{{mapping.name}}(context, args)) || "" }
      {% end %}

      Calm.routes.routes << route
    end

    macro get(route, mapping, view = nil)
      get_post({{route}}, {{mapping}}, "get", {{view}})
    end

    macro post(route, mapping, view = nil)
      get_post({{route}}, {{mapping}}, "post", {{view}})
    end
  end
end

module Calm
  module Http
    module Handler
      class Routing
        include HTTP::Handler

        def call(context : HTTP::Server::Context)
          path_parts = Path[context.request.resource].normalize.parts
          if path_parts.size > 2 && path_parts[1] == "public"
            call_next(context)
          else
            obj = Calm.routes.routes.select { |r| r.path == context.request.path }
            if !obj.nil? && obj.size == 1
              # TODO: JSON
              context.response.content_type = "text/html"

              controller_content = obj[0].callback.call context

              template_content = ApplicationView.new.index(context) do
                controller_content
              end
              if context.request.headers.has_key?("HX-Request")
                context.response.print controller_content unless context.response.closed?
              else
                context.response.print template_content unless context.response.closed?
              end
            end
          end
        end
      end
    end
  end
end
