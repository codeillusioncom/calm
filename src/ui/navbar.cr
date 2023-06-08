module Calm
  class Components
    def self.navbar(id = "navbar", title = "", root_url = "#", sign_in_items = true, items = [] of NamedTuple(name: String, url: String))
      Water.new do
        nav %|id="#{id}" class="navbar navbar-expand-lg bg-body-tertiary"| do
          div %|class="container-fluid"| do
            a %|class="navbar-brand" href="#{root_url}"|, title
            button %|class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="##{id}navbarSupportedContent" aria-controls="#{id}navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"| do
              span %|class="navbar-toggler-icon"|, ""
            end
            div %|class="collapse navbar-collapse" id="#{id}navbarSupportedContent"| do
              ul %|class="navbar-nav me-auto mb-2 mb-lg-0"| do
                items.each do |item|
                  li %|class="nav-item"| do
                    a %|class="nav-link active" aria-current="page" href="#{item[:url]}"|, item[:name]
                  end
                end
              end
              ul %|class="navbar-nav mb-2 mb-lg-0"| do
                li %|class="nav-item dropdown"| do
                  a %|class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"|, "Sign in"
                  ul %|class="dropdown-menu dropdown-menu-end"| do
                    li do
                      if 1 == 2
                        a %|class="dropdown-item" href="/users/sign_in"|, "My profile"
                        a %|class="dropdown-item" href="/users/sign_up"|, "Sign out"
                      else
                        a %|class="dropdown-item" href="/users/sign_in"|, "Sign in"
                        a %|class="dropdown-item" href="/users/sign_up"|, "Sign up"
                      end
                    end
                  end
                end
              end if sign_in_items
            end
          end
        end
      end
    end
  end
end
