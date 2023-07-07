module Calm
  module Http
    class BaseView
      macro use_var(*vars, &block)
        {% for var, index in vars %}
        {% if index % 2 == 0 %}
        {{var.id}} : {{vars[index + 1]}} = vars["{{var.id}}"].get.as({{vars[index + 1]}})
        {% end %}
        {% end %}
        {{block.body}}
      end
    end
  end
end
