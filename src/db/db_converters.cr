require "./base"

module Calm
  module DbConverters
    private def convert_type_from_crystal_to_sqlite(key, type, id)
      if type == Bool
        return "boolean"
      elsif type == Int32 || type == Int64
        if key == id
          return "serial primary key"
        else
          return "bigint"
        end
      elsif type == Float32 || type == Float64
        return "float"
      elsif type == String
        if key == id
          return "text primary key"
        else
          return "text"
        end
        # TODO: Array(TypeClass).class
        # TODO: Hash(String, TypeClass)
      else
        # TODO: error
      end
    end
  end
end
