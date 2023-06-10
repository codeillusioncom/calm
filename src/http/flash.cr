@[Crinja::Attributes]
class Flash
  include Crinja::Object::Auto
  include JSON::Serializable

  property type : String
  property message : String
  property count = 0

  def initialize(@type : String, @message : String, @count : Int32 = 0)
  end
end
