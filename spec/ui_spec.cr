require "water"

require "./spec_helper"
require "../src/ui/**"

describe Calm do
  # TODO: Write tests

  it "should render a div with String inside" do
    Calm::UI.new do
      div %|class="mt-2"| do
        "body"
      end
    end.should eq "<div class=\"mt-2\">\n  body\n</div>"
  end

  it "should render a div with methods inside" do
    Calm::UI.new do
      div %|class="mt-2"| do
        div %|class="mt-4"| do
          "body"
        end
      end
    end.should eq "<div class=\"mt-2\">\n" +
                  "  <div class=\"mt-4\">\n" +
                  "    body\n" +
                  "  </div>\n" +
                  "</div>"
  end

  it "should render a div with 2 methods inside" do
    Calm::UI.new do
      div %|class="mt-2"| do
        div %|class="mt-4"| do
          div %|class="mt-6"| do
            "body"
          end
        end
      end
    end.should eq "<div class=\"mt-2\">\n" +
                  "  <div class=\"mt-4\">\n" +
                  "    <div class=\"mt-6\">\n" +
                  "      body\n" +
                  "    </div>\n" +
                  "  </div>\n" +
                  "</div>"
  end

  it "should render a base html template" do
    Calm::UI.new do
      doctype
      html %|lang="en" data-bs-theme="dark"| do
        head do
          meta %|charset="UTF-8"|
          meta %|name="viewport" content="width=device-width,initial-scale=1.0"|
          title "Homeweb"
          link %|rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous"|
        end
        body do
          # Calm::Components.navbar(title: "Homeweb", root_url: "/", items: [{name: "Home", url: "/"}])
          navbar(title: "Homeweb", root_url: "/", items: [{name: "Home", url: "/"}, {name: "About", url: "/about"}, {name: "Sign in", url: "/sign_in"}])
          div %|class="container"| do
            "the content"
          end

          script %|src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"|, ""
          script %|src="https://unpkg.com/htmx.org@1.9.2"|, ""
        end
      end
    end.should eq "<!DOCTYPE html>\n" +
                  "<html lang=\"en\" data-bs-theme=\"dark\">\n" +
                  "  <head>\n" +
                  "    <meta charset=\"UTF-8\">\n" +
                  "    <meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0\">\n" +
                  "    <title>Homeweb</title>\n" +
                  "    <link rel=\"stylesheet\" type=\"text/css\" href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css\" integrity=\"sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM\" crossorigin=\"anonymous\">\n" +
                  "  </head>\n" +
                  "  <body>\n" +
                  "    <nav class=\"navbar navbar-expand-lg bg-body-tertiary\">\n" +
                  "      <div class=\"container-fluid\">\n" +
                  "        <a class=\"navbar-brand\" href=\"#\">Navbar</a>\n" +
                  "        <button class=\"navbar-toggler\" type=\"button\" data-bs-toggle=\"collapse\" data-bs-target=\"#navbarSupportedContent\" aria-controls=\"navbarSupportedContent\" aria-expanded=\"false\" aria-label=\"Toggle navigation\">\n" +
                  "          <span>class=&quot;navbar-toggler-icon&quot;</span>\n" +
                  "        </button>\n" +
                  "        <div class=\"collapse navbar-collapse\" id=\"navbarSupportedContent\">\n" +
                  "          <ul class=\"navbar-nav me-auto mb-2 mb-lg-0\">\n" +
                  "            <li class=\"nav-item\">\n" +
                  "              <a class=\"nav-link \" aria-current=\"page\" href=\"/\">Home</a>\n" +
                  "              <a class=\"nav-link \" aria-current=\"page\" href=\"/about\">About</a>\n" +
                  "              <a class=\"nav-link \" aria-current=\"page\" href=\"/sign_in\">Sign in</a>\n" +
                  "            </li>\n" +
                  "          </ul>\n" +
                  "        </div>\n" +
                  "      </div>\n" +
                  "    </nav>\n" +
                  "    <div class=\"container\">\n" +
                  "      the content\n" +
                  "    </div>\n" +
                  "    <script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js\" integrity=\"sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz\" crossorigin=\"anonymous\"></script>\n" +
                  "    <script src=\"https://unpkg.com/htmx.org@1.9.2\"></script>\n" +
                  "  </body>\n" +
                  "</html>"
  end
end
