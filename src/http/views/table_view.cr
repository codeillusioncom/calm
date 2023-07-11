module Calm
  module Http
    abstract class TableView(T) < Calm::Http::BaseView
      def index(context, vars)
        context.ui do
          h1 t(".title")

          use_var("objects", Array(T), "columns", Array(String)) do
            table_from_models objects, columns: columns

            a %|class="btn btn-primary" href="/#{T.to_s.underscore}s/add"|, "Create new"
          end
        end
      end

      def add(context, vars)
        context.ui do
          h1 t(".title")

          simple_form(T.new, action: vars["action"].get) do |f|
            f.input :hostname, autofocus: true
            f.input :ip
            f.input :check_command

            f.submit
          end
        end
      end

      def create(context, vars)
      end
    end
  end
end
