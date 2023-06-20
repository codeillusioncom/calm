module Calm
  class Route
    getter path
    getter callback

    def initialize(@path : String, &@callback : HTTP::Server::Context -> String)
    end
  end

  class Routes
    getter routes

    def initialize
      @routes = [] of Calm::Route
    end

    def draw
      with self yield
      self
    end

    macro get(route, mapping)
      routes << Calm::Route.new({{route}}) do |context|
        {{mapping.receiver}}.new.{{mapping.name}}
      end
    end
  end
end

module Calm
  module Http
    module Handler
      class Routing
        include HTTP::Handler

        def self.yield_with_context(context)
          with context yield
        end

        macro capture_with_context(context, &block)
          -> { Routing.yield_with_context {{context}} {{block}} }
        end

        def call(context : HTTP::Server::Context)
          path_parts = Path[context.request.resource].normalize.parts
          if path_parts.size > 2 && path_parts[1] == "public"
            call_next(context)
          else
            obj = Calm.routes.routes.select { |r| r.path == context.request.path }
            if !obj.nil? && obj.size == 1
              # TODO: JSON
              # TODO: Template
              context.response.content_type = "text/html"
              res = ApplicationView.new.index do
                Http::Handler::Routing.yield_with_context(context) do
                  obj[0].callback.call context
                end
                # HomeView.new.show
                # render_class(self.class.to_s.split("Handler")[0])
                # ApplicationHandler.get_class("#{self.class.to_s.split("Handler")[0]}View").new.show
              end
              context.response.print res
            end
          end
        end
      end
    end
  end
end
