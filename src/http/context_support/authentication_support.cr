module Calm
  module Http
    module AuthenticationSupport
      property username : String?

      def sign_out
        response.headers.add("Set-Cookie", "token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT")
        @username = nil
      end

      def check_permission!(object : Calm::Db::Base?)
        raise Calm::AccessDeniedException.new unless check_permission(object)
      end

      def check_permission(object : Calm::Db::Base?)
        route = get_route(request.path)
        if route
          route.access.call(username, object)
        else
          false
        end
      end

      private def get_route(path)
        selected_routes = Calm.routes.routes.select { |route| route.path == path }
        if selected_routes.size == 1
          return selected_routes[0]
        else
          return nil
        end
      end
    end
  end
end
