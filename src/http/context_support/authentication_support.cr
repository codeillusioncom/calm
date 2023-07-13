module Calm
  module Http
    module AuthenticationSupport
      property username : String?

      def sign_out
        response.headers.add("Set-Cookie", "token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT")
        @username = nil
      end

      def check_permission!(object : Calm::Db::Base? = nil)
        raise Calm::AccessDeniedException.new unless check_permission(object)
      end

      def check_permission(object : Calm::Db::Base? = nil)
        route = Calm::Http::Handler::Routing.get_route(request.path, self)
        pp "route:"
        pp route
        if route
          puts "yes"
          pp route.access
          route.access.call(username, object)
        else
          puts "no"
          false
        end
      end
    end
  end
end
