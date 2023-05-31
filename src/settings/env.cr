module Calm
  class Env
    DEVELOPMENT = "development"
    TEST        = "test"

    def ==(value : String) : Bool
      id == value
    end

    def id
      @id ||= ENV["CALM_ENV"]? || DEVELOPMENT
    end

    def to_s(io)
      io << id
    end

    macro method_missing(call)
        {% if call.name.ends_with?('?') %}
          return self.==("{{ call.name[0..-2] }}")
        {% end %}
        super
      end
  end
end
