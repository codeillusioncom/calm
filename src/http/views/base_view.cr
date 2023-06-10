module Calm
  module Http
    class BaseView
      macro inherited
        def self._inherited
        puts "inherited"
        puts "finished"
        pp {{@type.stringify}}
        Calm::Handler::ApplicationHandler.view_classes[{{@type.stringify}}] = {{ @type.id }}
      end
      _inherited
      end

      def index
      end

      def show
      end

      def new
      end

      def create
      end

      def edit
      end

      def update
      end

      def destroy
      end

      def get_action(string)
        case string
        when "index"
          index
        when "show"
          show
        when "new"
          new
        when "create"
          create
        when "edit"
          edit
        when "update"
          update
        when "destroy"
          destroy
        end
      end
    end
  end
end
