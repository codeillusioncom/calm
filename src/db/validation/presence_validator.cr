module Calm
  module Db
    module Validation
      class PresenceValidator
        def self.validate(obj, p, errors)
          res = !obj[p].nil? && obj[p] != ""
          errors[p] = "can not be empty." unless res
        end
      end
    end
  end
end
