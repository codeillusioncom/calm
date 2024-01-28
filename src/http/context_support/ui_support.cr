abstract class Any
end

class A(T) < Any
  property get

  def initialize(@get : T)
  end
end

module Calm
  module Http
    module UISupport
      def with(args = Hash(String, Any).new)
        # TODO: sok helyen van ez
        obj = Calm.routes.routes.select { |r| Calm::Http::Handler::Routing.route_matches(r.path, self) && r.type.upcase == request.method }
        if !obj.nil? && obj.size >= 1
          view_obj = obj.last.view
          unless view_obj.nil?
            # args_converted = Hash(String, String | Int32 | Calm::Db::ResultSet(Calm::Db::Base)).new
            # args.each do |key, value|
            #  args_converted[key] = value
            # end
            return view_obj.call self, args
          end
        end
        "view error"
      end

      def redirect_to(path)
        response.redirect(path)

        return ""
      end

      def ui
        ui_obj = Calm::UI.new(self)
        with ui_obj yield

        return ui_obj.lines_joined
      end
    end
  end
end
