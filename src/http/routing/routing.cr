module Calm
  module Http
    module Handler
      class Routing
        include HTTP::Handler

        def self.route_matches(path, context)
          path_split = path.split("/")
          request_split = context.request.path.split("/")
          return false unless path_split.size == request_split.size

          res = {} of String => String

          match = false

          path_split.each_with_index do |r, i|
            if r != request_split[i] && !r.includes?(":")
              return false
            else
              if r.includes?(":")
                context.path_params[r] = request_split[i]
              end
              res[r] = request_split[i]
            end
          end

          return true
        end

        def call(context : HTTP::Server::Context)
          path_parts = Path[context.request.resource].normalize.parts
          if path_parts.size > 2 && path_parts[1] == "public"
            call_next(context)
          else
            # obj = Calm.routes.routes.select { |r| r.path.match(context.request.path) && r.type.upcase == context.request.method }
            obj = Calm.routes.routes.select { |r| Calm::Http::Handler::Routing.route_matches(r.path, context) && r.type.upcase == context.request.method }
            if !obj.nil? && obj.size >= 1
              # TODO: JSON
              context.response.content_type = "text/html"
              # if it is here, do we need in controllers?
              context.check_permission!
              controller_content = obj.last.callback.call context

              template_content = ApplicationView.new.index(context, &-> : String { controller_content })

              if context.request.headers.has_key?("HX-Request")
                context.response.print controller_content unless context.response.closed?
              else
                context.response.print template_content unless context.response.closed?
              end
              # TODO: if dev env
              context.response.headers.add("Cache-Control", "no-cache, max-age=0, must-revalidate")
            end
          end
        end

        def self.get_route(path, context)
          # TODO: type
          selected_routes = Calm.routes.routes.select { |r| route_matches(r.path, context) && r.type.upcase == context.request.method }
          if selected_routes.size >= 1
            return selected_routes.last
          else
            return nil
          end
        end
      end
    end
  end
end
