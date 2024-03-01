module Calm
  class BasicView
    def initialize(@context : HTTP::Server::Context)
    end

    def render
    end
  end

  class UI
    macro def_simple_tag_no_closing(tag)
      def {{tag.id}}(**attributes)
        attributes_str = ""
        attributes_str = " #{attributes.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")}" if attributes.size > 0

        @current_indent += 1
        spaces = "  " * @current_indent
        @lines << "#{spaces}<{{tag.id}}#{attributes_str}>"
        @indents << @current_indent
        @current_indent -= 1

        return nil
      end
    end

    macro def_simple_tag(tag)
      def {{tag.id}}(**attributes)
        attributes_str = ""
        attributes_str = " #{attributes.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")}" if attributes.size > 0

        @current_indent += 1
        spaces = "  " * @current_indent
        @lines << "#{spaces}<{{tag.id}}#{attributes_str} />"
        @indents << @current_indent
        @current_indent -= 1

        return nil
      end
    end

    macro def_tag(tag, oneline = false)
      def {{tag.id}}(**attributes, &block)
        id_str = ""
        #id_str = " id=\"#{id}\"" unless id.nil?

        #id = nil, hxget = "", hxtrigger = "", hxtarget = "", hxswap = "", 
        attributes_str = ""
        attributes_str = " #{attributes.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")}" if attributes.size > 0

        @current_indent += 1
        spaces = "  " * @current_indent


        if {{ oneline }}
          body = yield
          if body.nil?
            @lines << "#{spaces}<{{tag.id}}#{id_str}#{attributes_str}></{{tag.id}}>"
          else
            @lines << "#{spaces}<{{tag.id}}#{id_str}#{attributes_str}>#{body}</{{tag.id}}>"
          end
        else
          @lines << "#{spaces}<{{tag.id}}#{id_str}#{attributes_str}>"
          body = yield
          unless body.nil?
            spaces_old = spaces
            spaces += "  "
            @lines << "#{spaces}" + body
            @indents << @current_indent
            spaces = spaces_old
          end
          @lines << "#{spaces}</{{tag.id}}>"
          @current_indent -= 1
        end

        return nil
      end
      def {{tag.id}}(**attributes)
        {{tag.id}}(**attributes) {}
      end
    end

    property linestoprint : Array(String)
    property lines : Array(String)
    property indents : Array(Int32)
    property context : HTTP::Server::Context

    def initialize(@context, @linestoprint = [] of String, @lines = [] of String, @indents = [] of Int32, @current_indent = 0)
    end

    def lines_joined
      @lines.join("\n")
    end

    def render(view : Calm::BasicView.class)
      @lines << view.new(@context).render

      return nil
    end

    def doctype
      @lines << "<!DOCTYPE html>"
    end

    def_tag("html")
    def_tag("head")
    def_simple_tag_no_closing("meta")
    def_simple_tag_no_closing("link")
    def_tag("title")
    def_tag("body")
    def_tag("nav")
    def_tag("a")
    def_tag("h1")
    def_tag("h2")
    def_tag("h3")
    def_tag("h4")
    def_tag("h5")
    def_tag("h6")
    def_tag("button")
    def_tag("span")
    def_tag("ul")
    def_tag("li")
    def_tag("hr", oneline: true)
    def_tag("script")
    def_tag("div")
    def_tag("form")
    def_tag("label", oneline: true)
    def_simple_tag("input")
    def_tag("textarea", oneline: true)
  end
end
