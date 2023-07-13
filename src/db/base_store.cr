require "./db_converters"

module Calm
  module Db
    module BaseStore
      alias Types = (String.class | Int32.class | Int64.class | Float32.class | Float64.class | Bool.class | Nil.class)
      alias ObjTypes = (Array(Symbol) | String | Int32 | Int64 | Float32 | Float64 | Bool | Nil)

      def self.id_key
        "id"
      end

      include Calm::DbConverters
      @@STRUCT = Hash(String, Types).new

      def structure
        return @@STRUCT
      end

      def self.structure
        return @@STRUCT
      end

      # Returns true if the record is persisted, i.e. it’s not a new record and it was not destroyed, otherwise returns false.
      def persisted?
        @persisted
      end

      def persisted=(value)
        @persisted = value
      end

      macro mapping(properties)
        {% for key, type in properties %}
          {% properties[key] = {type: type} unless type.is_a?(HashLiteral) || type.is_a?(NamedTupleLiteral) %}
          @@STRUCT[{{key.stringify}}] = {{type}}
        {% end %}

        {% for key, type in properties %}
          {% type[:nilable] = true if type[:type].is_a?(Generic) && type[:type].type_vars.map(&.resolve).includes?(Nil) %}

          {% if type[:type].is_a?(Call) && type[:type].name == "|" &&
                  (type[:type].receiver.resolve == Nil || type[:type].args.map(&.resolve).any?(&.==(Nil))) %}
            {% type[:nilable] = true %}
          {% end %}
        {% end %}

        {% for key, type in properties %}
          @{{key.id}} : {{type[:type]}}?
          @{{key.id}}_old : {{type[:type]}}?

          def {{key.id}}=(_{{key.id}} : {{type[:type]}}?)
            @{{key.id}} = _{{key.id}}
          end

          def {{key.id}}_old=(_{{key.id}} : {{type[:type]}}?)
            @{{key.id}}_old = _{{key.id}}
          end

          def {{key.id}}
            @{{key.id}}
          end

          def {{key.id}}_old
            @{{key.id}}_old
          end
        {% end %}

        def initialize
          {% for key, type in properties %}
            @{{key.id}} = nil
          {% end %}
        end

        def call(command)
          objs = [] of self

          DB.open Calm.settings.database_url do |db|
            # TODO: public schema
            db.query command do |rs|
              rs.each do
                obj = self.class.new
                {% for key, type in properties %}
                  begin
                    value = rs.read({{type[:type]}})
                    obj[{{key.stringify}}] = value
                    obj["{{key.id}}_old"] == value
                  rescue
                    obj[{{key.stringify}}] = nil
                    obj["{{key.id}}_old"] == nil
                  end
                {% end %}
                obj.persisted = true
                objs << obj
              end
            end
          end

          return objs
        #end
      end
    end

      def instance_values
        data = Hash(String, String | Bool | Int32 | Int64 | Nil | Array(Symbol)).new
        {% for type in @type.instance_vars %}
        if @@STRUCT.keys.includes?({{type.stringify}})
          data[{{type.stringify}}] = self[{{type.stringify}}]
        end
        {% end %}
        return data
      end

      def [](variable)
        {% for ivar in @type.instance_vars %}
        if @@STRUCT.keys.includes? {{ivar.stringify}}
          if "{{ivar.id}}" == variable.to_s
            return @{{ivar}}
          elsif "{{ivar.id}}_old" == variable.to_s
          end
        end
        {% end %}
      end

      def []=(variable, value)
        {% for ivar in @type.instance_vars %}
        if @@STRUCT.keys.includes? {{ivar.stringify}}
          if "{{ivar.id}}" == variable.to_s
            if value.is_a?({{ ivar.type.id }})
              @{{ivar}} = value
            else
              raise "Invalid type #{value.class} for {{ivar.id.symbolize}} (expected {{ ivar.type.id }})"
            end
          end
          end
        {% end %}
      end
    end
  end
end
