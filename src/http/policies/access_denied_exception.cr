module Calm
  class AccessDeniedException < Exception
    def initialize
      super("Access denied")
    end
  end
end
