module Calm
  module Db
    class MigrationData
      @name : String | Symbol
      @required : Bool
      @size : Int32
      @type : DataType.class

      getter name
      getter required
      getter size
      getter type

      def initialize(@name, @required, @size, @type)
      end
    end

    class DataType
    end

    class StringData < DataType
      def self.to_s(io)
        io << "varchar"
      end
    end
  end
end
