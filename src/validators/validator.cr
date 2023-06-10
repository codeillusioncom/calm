module Calm
  abstract class Validator
    abstract def validate(record)
  end
end
