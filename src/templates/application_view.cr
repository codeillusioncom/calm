class NotificationsView < Calm::BasicView
  def render
    @context.flash.map do |f|
      # alert(f.message, type: f.type, closeable: true)
      # TODO: f.type
      "<div class=\"alert alert-warning alert-dismissible fade show\" role=\"alert\">
        #{f.message}
        <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>
      </div>"
    end.join("\n")
  end
end

class SimpleForm < Calm::BasicView
  def initialize(@model, @action = "#", @method = "post", &block)
  end

  def render
    "xxx"
    # @lines << "<form action=\"#{action}\" method=\"#{method}\">"
    # f = form.new(@context, model)

    # @current_indent += 1
    # @indents << @current_indent

    # yield f

    # @lines << f.lines.join

    # @current_indent += 1
    # @indents << @current_indent

    # @lines << "</form>"
    # @indents << @current_indent
  end.join("\n")
end

class ApplicationView
  def index(context, &block)
    context.ui do
      doctype
      html(lang: "en", "data-bs-theme": "dark") do
        head do
          meta(charset: "UTF-8")
          meta(name: "viewport", content: "width=device-width,initial-scale=1.0")
          link(rel: "stylesheet", type: "text/css", href: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css", integrity: "sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM", crossorigin: "anonymous")
          link(rel: "stylesheet", type: "text/css", href: "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css")

          title { "Calm 0.1" }
        end

        body do
          nav(class: "navbar navbar-dark navbar-expand-lg bg-dark") do
            div(class: "container-fluid") do
              a(class: "navbar-brand", href: "#") do
                "Calm"
              end
              button(class: "navbar-toggler", type: "button", "data-bs-toggle": "collapse", "data-bs-target": "#navbarSupportedContent", "aria-controls": "navbarSupportedContent", "aria-expanded": "false", "aria-label": "Toggle navigation") do
                span(class: "navbar-toggler-icon") { }
              end
              div(class: "collapse navbar-collapse", id: "navbarSupportedContent") do
                ul(class: "navbar-nav me-auto mb-2 mb-lg-0") do
                  li(class: "nav-item") do
                    a(class: "nav-link active", "aria-current": "page", href: "#") { "Home" }
                  end
                  li(class: "nav-item dropdown") do
                    a(class: "nav-link dropdown-toggle", href: "#", role: "button", "data-bs-toggle": "dropdown", "aria-expanded": "false") do
                      "Dropdown"
                    end
                    ul(class: "dropdown-menu") do
                      li do
                        a(class: "dropdown-item", href: "#") { "Action" }
                      end
                      li do
                        hr(class: "dropdown-divider")
                      end
                      li do
                        a(class: "dropdown-item", href: "#") { "Action 2" }
                      end
                    end
                  end
                end
              end
            end
          end

          render NotificationsView

          div(id: "main", class: "container") do
            yield
          end
          script(src: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js", integrity: "sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz", crossorigin: "anonymous") { }
          script(src: "https://unpkg.com/htmx.org@1.9.2") { }
        end
      end
    end
  end
end
