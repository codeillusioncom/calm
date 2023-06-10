module Calm
  module Handler
    module ApplicationHelper
      def link_to(label, path, push_url = false)
        link_to(label, path, "")
      end

      def link_to(label, path, onclick, push_url = false)
        link_to(label, path, onclick, {} of String => String, push_url)
      end

      def link_to(label, path, onclick, data_args : Hash(String, String), push_url = false)
        "<button #{data_args.map { |k, v| "" + k + "=\"" + v + "\"" }.join(" ")} hx-push-url=\"#{push_url}\">#{label}</button>"
      end
    end
  end
end
