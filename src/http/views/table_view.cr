module Calm
  module Http
    abstract class TableView < Calm::Http::BaseView
      def index(context, vars)
        context.ui do
          h1 t(".title")

          use_var("objects", Array(Machine), "columns", Array(String)) do
            table_from_models objects, columns: columns
          end
        end
      end
    end
  end
end
