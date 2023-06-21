module Calm
  class Route
    getter path
    getter callback
    alias ParamsHash = String | Int32
    property view : Proc(Hash(String, ParamsHash), String)

    def initialize(@path : String, &@callback : HTTP::Server::Context -> String)
      @view = Proc(Hash(String, String | Int32), String).new { |args| "" }
    end
  end

  class Routes
    getter routes

    def initialize
      @routes = [] of Calm::Route
    end

    def draw
      with self yield
      Calm.routes = self
    end

    macro get(route, mapping)
      route = Calm::Route.new({{route}}) do |context|
        {{mapping.receiver}}.new.{{mapping.name}}(context)
      end
     
      route.view = ->(context : Hash(String, String | Int32)){({{mapping.receiver}}View.new.{{mapping.name}}(context)) || "" }
      routes << route
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
              # TODO: Template
              context.response.content_type = "text/html"

              # HomeView.new.show
              # render_class(self.class.to_s.split("Handler")[0])
              # ApplicationHandler.get_class("#{self.class.to_s.split("Handler")[0]}View").new.show

              controller_content = obj[0].callback.call context

              template_content = ApplicationView.new.index do
                controller_content
                # HomeView.new.show
                # render_class(self.class.to_s.split("Handler")[0])
                # ApplicationHandler.get_class("#{self.class.to_s.split("Handler")[0]}View").new.show
              end
              if 1 == 1
                context.response.print template_content
              else
                context.response.print controller_content
              end
            end
          end
        end
      end
    end
  end
end
