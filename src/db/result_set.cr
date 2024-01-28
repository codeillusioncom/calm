module Calm
  module Db
    class Order
      getter name
      getter order

      def initialize(@name : String, @order = "ASC")
      end
    end

    class ResultSet(T)
      getter query
      getter where
      @order_columns = Array(Order).new
      @page : Int64 = 1
      @items_on_page : Int32 = Calm.settings.items_on_page
      @total_elements = 0_i64
      @pagination = false

      def initialize(@query : String)
        @where = ""
      end

      def where(id_column, id_value)
        if where.blank?
          @where = " where #{id_column}='#{id_value}'"
        else
          @where += " and #{id_column}='#{id_value}'"
        end

        return self
      end

      def order(column : String, order = "ASC")
        @order_columns << Order.new(column, order)

        return self
      end

      def page(page : Int64, items_on_page = Calm.settings.items_on_page)
        @pagination = true
        @page = page
        @items_on_page = items_on_page

        return self
      end

      def conv(name, type, value)
        if type == String
          return value.as(String)
        elsif type == Int32
          return value.as(Int32)
        elsif type == Int64
          return value.as(Int64)
        else
          return nil
        end
      end

      def call
        if @pagination
          if @where.blank?
            @where += " WHERE "
          else
            @where += " and "
          end
          @where += " oid NOT IN ( SELECT oid FROM #{T.table_name}" if @pagination
        end

        command = @query + " " + @where
        if @order_columns.empty?
          if @pagination
            command += " ORDER BY #{T.id_key} ASC LIMIT #{@page * @items_on_page - @items_on_page} )"
            command += " ORDER BY #{T.id_key} ASC LIMIT #{@items_on_page}"
          end
        else
          reversed_order_columns = @order_columns.reverse

          if @pagination
            first_column = reversed_order_columns.pop
            command += " ORDER BY #{first_column.name} #{first_column.order} LIMIT #{@page * @items_on_page - @items_on_page} )"
            command += " ORDER BY #{first_column.name} #{first_column.order} LIMIT #{@items_on_page}"
          end

          reversed_order_columns.each do |column|
            command += " ORDER BY #{column.name} #{column.order} "
          end
        end

        Log.info { "SQL: #{command}" }

        return T.new.call(command)
      end

      def first
        arr = call
        arr.empty? ? nil : arr.first
      end

      def first_or_new
        arr = call
        arr.empty? ? T.new : arr.first
      end

      def size : Int64
        command = @query + " " + (@where || "") + ";"
        count_command = "select count(*) from" + command.split(" from ")[1]
        DB.open Calm.settings.database_url do |db|
          return db.scalar(count_command).as(Int64)
        end
      end

      # private def get_total_elements(where = "")
      #  @total_elements = T.size(where)
      # end
    end
  end
end
