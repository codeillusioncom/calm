module Calm
  module Http
    module Handler
      class Error
        include HTTP::Handler

        def call(context)
          begin
            call_next(context)
          rescue ex : Calm::AccessDeniedException
            context.flash("danger", "Access Denied!")
            context.response.redirect("/")
          end
        end
      end
    end
  end
end
