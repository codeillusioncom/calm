module Calm
  class Routes
    getter routes

    def initialize
      @routes = [] of Calm::Route
    end

    macro get_post(route, mapping, type, view)
      {% if route.includes? ":" %}
        def self.{{mapping.id.underscore.gsub(/\./, "__")}}(*args)
          path = {{route}}

          match_data = path.match(/\/(:[a-z]+)/)

          if match_data
            args.each_with_index do |arg, index|
              path = path.gsub(match_data[index], "/#{arg}")
            end
          end

          return path
        end
      {% else %}
        def self.{{mapping.id.underscore.gsub(/\./, "__")}}
          {{route}}
        end
      {% end %}
      
      route = Calm::Route.new({{route}}, {{type}}) do |context|
        {{mapping.receiver}}.new.{{mapping.name}}(context)
      end

      route.access = ->(username : String?, object : Calm::Db::Base?){({{mapping.receiver}}Policy.new(username, object).{{mapping.name}}?)}

      # TODO: choose view
      {% if view %}
        route.view = ->(context: HTTP::Server::Context, args : Hash(String, Any)){({{view.receiver}}.new.{{mapping.name}}(context, args)) || "" }
      {% else %}
        route.view = ->(context: HTTP::Server::Context, args : Hash(String, Any)){({{mapping.receiver}}View.new.{{mapping.name}}(context, args)) || "" }
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
