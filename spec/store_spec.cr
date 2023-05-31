require "./spec_helper"

describe Calm::Orm::Base do
  it "checks type conversion and storing" do
    user = User.new

    user.username = "johndoe"
    user.username.should eq "johndoe"
    user.username.class.should eq(String)
    typeof(user.username).should eq(String | Nil)

    user.id = 1
    user.id.should eq 1
    user.id.class.should eq Int32
    typeof(user.id).should eq Int32 | Nil

    user.invalid_sign_in_count = 2
    user.invalid_sign_in_count.should eq 2
    user.invalid_sign_in_count.class.should eq Int64
    typeof(user.invalid_sign_in_count).should eq Int64 | Nil
  end
end
