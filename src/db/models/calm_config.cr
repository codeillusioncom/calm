class CalmConfig < Calm::Db::Base
  mapping({key: String, value: String})

  validates_presence_of([:key])

  def self.id_key
    "key"
  end
end
