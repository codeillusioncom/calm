module Calm
  module Http
    abstract class TableView(T) < Calm::Http::BaseView
      def index(context, vars)
        context.ui do
          # h1 t(".title")

          # use_var("objects", Array(T), "columns", Array(String), "new_button", Bool, "show_button", Bool, "edit_button", Bool, "destroy_button", Bool) do
          #   table_from_models objects, columns: columns, new_button: new_button, show_button: show_button, edit_button: edit_button, destroy_button: destroy_button, context: context

          #   a %|class="btn btn-primary" href="/#{T.to_s.underscore}s/add"|, "Create new" if new_button
          # end
          ""
        end
      end

      def show(context, vars)
        context.ui do
          # h1 t(".title")

          # use_var("object", T, "columns", Array(String)) do
          #   table %|class="table table-responsive table-hover table-striped"| do
          #     columns.each do |column|
          #       tr do
          #         td t("db.#{T.name.underscore}.#{column}")
          #         td object[column]
          #       end
          #     end
          #   end
          # end
        end
      end

      def add(context, vars)
        context.ui do
          # h1 t(".title")

          # # TODO: action throws runtime exception instead of compile-time
          # simple_form(T.new, action: vars["action"].get) do |f|
          #   f.input :hostname, autofocus: true
          #   f.input :ip
          #   f.input :check_command

          #   f.submit
          # end
        end
      end

      def edit(context, vars)
        context.ui do
          # h1 t(".title")

          # use_var("object", T, "action", String) do
          #   pp object
          #   simple_form(object, action: action) do |f|
          #     f.input :hostname, autofocus: true
          #     f.input :ip
          #     f.input :check_command

          #     f.submit
          #   end
          # end
        end
      end
    end
  end
end
