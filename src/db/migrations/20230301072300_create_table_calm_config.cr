class M20230301072300CreateTableCalmConfig < Calm::Db::Migration
  def up
    create_table CalmConfig
  end

  def down
    puts "down..."
  end
end
