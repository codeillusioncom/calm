module Calm
  module Http
    module Handler
      class Error
        include HTTP::Handler

        def call(context)
          begin
            call_next(context)
          rescue ex : Calm::AccessDeniedException
            context.flash("error", "Access Denied!")
          end
        end
      end
    end
  end
end
