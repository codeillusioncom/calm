require "./context_support/authentication_support"
require "./context_support/flash_support"
require "./context_support/params_support"
require "./context_support/ui_support"

module HTTP
  class Server
    class Context
      include ::Calm::Http::AuthenticationSupport
      include ::Calm::Http::FlashSupport
      include ::Calm::Http::ParamsSupport
      include ::Calm::Http::UISupport
    end
  end
end
