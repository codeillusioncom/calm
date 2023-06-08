module Calm
  module Http
    module Handler
      class Routing
        include HTTP::Handler

        def call(context : ::HTTP::Server::Context)
          path_parts = Path[context.request.resource].normalize.parts
          if path_parts.size > 2 && path_parts[1] == "public"
            call_next(context)
          else
            process(context)
          end
        end

        private def process(context)
          matched = Calm.routes.resolve(context.request.path)
          matched.handler.new(context, matched).process_dispatch
        end
      end
    end
  end
end
