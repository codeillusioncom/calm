module Calm
  module Db
    module Validation
      module CheckAcceptance
        ACCEPTANCE = [] of Symbol

        macro validates_acceptance_of(array)
        {% for name, index in array %}
          ACCEPTANCE << {{name}}
        {% end %}
      end

        private def check_acceptance(errors)
          ACCEPTANCE.each do |property|
            if self[property.to_s] != true
              errors[property.to_s] = "must be checked"
            end
          end
        end
      end
    end
  end
end
