module Calm
  module Db
    def find(id)
      sql = "select * from #{table} where id = #{id};"
    end

    def save
    end
  end
end
