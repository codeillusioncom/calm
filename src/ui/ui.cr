module Calm
  module OpenTag
    macro def_open_tag(tag, alias_name = nil)
      {% real_tag = alias_name || tag %}

      def {{tag.id}}
        @lines << "<{{real_tag.id}}>"
        @indents << @current_indent
        @current_indent += 1
        yield
        @current_indent -= 1
        @lines << "</{{real_tag.id}}>"
        @indents << @current_indent

        return nil
      end

      def {{tag.id}}(attributes : String)
        @lines << "<{{real_tag.id}} #{attributes}>"
        @indents << @current_indent
        @current_indent += 1
        body = yield
        unless body.nil?
        	@lines << body
        	@indents << @current_indent
      	end
        #@current_indent -= 1
        #@indents << @current_indent
        @current_indent -= 1
        @lines << "</{{real_tag.id}}>"
        @indents << @current_indent

        return nil
      end

      def {{tag.id}}(attributes : String, content)
        @lines << "<{{real_tag.id}} #{attributes}>#{strip_content(content)}</{{real_tag.id}}>"
        @indents << @current_indent

        return nil
      end

      def {{tag.id}}(content)
        @lines << "<{{real_tag.id}}>#{strip_content(content)}</{{real_tag.id}}>"
        @indents << @current_indent

        return nil
      end
    end
  end

  module Tag
    def navbar(title = nil, root_url = "/", items = [] of NamedTuple(name: String, url: String, active: Bool))
      nav %|class="navbar navbar-expand-lg bg-body-tertiary"| do
        div %|class="container-fluid"| do
          a %|class="navbar-brand" href="#"|, "Navbar"
          button %|class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"| do
            span %|class="navbar-toggler-icon"|
          end
          div %|class="collapse navbar-collapse" id="navbarSupportedContent"| do
            ul %|class="navbar-nav me-auto mb-2 mb-lg-0"| do
              li %|class="nav-item"| do
                items.each do |item|
                  a %|class="nav-link #{item["active"] ? "active" : ""}" aria-current="page" href="#{item["url"]}"|, item["name"]
                end
              end
            end
          end
        end
      end

      return nil
    end

    def doctype(attributes = "html")
      @lines << "<!DOCTYPE #{attributes}>"
      @indents << @current_indent
    end

    def script(attributes, content)
      @lines << "<script #{attributes}>#{content}</script>"
      @indents << @current_indent
    end

    def script(content)
      @lines << "<script>#{content}</script>"
      @indents << @current_indent
    end

    def style(attributes, content)
      @lines << "<style #{attributes}>#{content}</style>"
      @indents << @current_indent
    end

    def style(content)
      @lines << "<style>#{content}</style>"
      @indents << @current_indent
    end

    def strip_content(content)
      ::HTML.escape(content.to_s)
    end
  end

  module SelfCloseTag
    macro def_self_close_tag(tag)
      def {{tag.id}}
        @lines << "<{{tag.id}}>"
        @indents << @current_indent
      end

      def {{tag.id}}(attributes : String)
        @lines << "<{{tag.id}} #{attributes}>"
        @indents << @current_indent
      end
    end

    SELF_CLOSE_TAGS = %w(area base br col embed hr img input keygen link menuitem meta param source track wbr)
    {% for tag in SELF_CLOSE_TAGS %}
      def_self_close_tag {{tag}}
    {% end %}
  end

  class UI
    include OpenTag
    include Tag
    include SelfCloseTag

    property lines : Array(String)
    property indents : Array(Int32)

    def initialize(@lines = [] of String, @indents = [] of Int32, @current_indent = 0)
    end

    def self.new
      builder = new
      with builder yield
      render_string(builder)
    end

    def self.render_string(builder)
      String.build do |str|
        builder.lines.each_with_index do |line, index|
          str << "  " * builder.indents[index]
          str << line
          str << "\n"
        end
        str.chomp!(10) # Remove last newline "\n"
      end
    end

    OPEN_TAGS = %w(a abbr address article aside b bdi body button code details dialog div dd dl dt em fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header html i iframe label li main mark menuitem meter nav ol option pre progress rp rt ruby s section small span strong summary table tbody td textarea th thead time title tr u ul video wbr)
    {% for tag in OPEN_TAGS %}
      def_open_tag {{tag}}
    {% end %}
  end
end
