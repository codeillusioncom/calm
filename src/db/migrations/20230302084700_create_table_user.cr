class M20230302084700CreateTableUser < Calm::Db::Migration
  def up
    create_table User
  end

  def down
    pp "down"
  end
end
