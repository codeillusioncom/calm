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
            obj = Calm.routes.routes.select { |r| r.path == context.request.path && r.type.upcase == context.request.method }
            if !obj.nil? && obj.size == 1
              # TODO: JSON
              context.response.content_type = "text/html"

              context.check_permission!

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
