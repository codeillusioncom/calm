require "./spec_helper"

describe Calm::Orm::Base do
  # ################### base_store #########################
  it "sets persisted to false after instantiating" do
    user = User.new
    user.persisted?.should eq false
  end

  it "sets persisted to true after saving" do
    user_count = User.size
    user = User.new
    user.username = "johndoe"
    user.email = "john@doe.hu"
    user.password = "adminadmin"
    user.invalid_sign_in_count = 3
    user.persist
    user.persisted?.should eq true

    user_count.should eq(User.size - 1)
  end

  it "assigns value to class dynamically" do
    user = User.new
    user.username = "johndoe"
    user.invalid_sign_in_count = 3

    user.username.should eq("johndoe")
    user.invalid_sign_in_count.should eq(3)
    user.invalid_sign_in_count.should_not eq("3")
  end

  # ################### validation #########################

  it "validates presence of for an empty class" do
    user = User.new
    user.valid?.should eq false
    user.invalid?.should eq true
  end

  it "validates presence of for a non-empty class" do
    user = User.new
    user.username = "johndoe"
    user.email = "john@doe.hu"
    user.password = "adminadmin"
    user.valid?.should eq true
    user.invalid?.should eq false
  end

  it "check validation errors" do
    user = User.new
    user.validation_errors.should eq({:username => "can not be empty.",
                                      :password => "can not be empty.",
                                      :email    => "can not be empty."})
  end

  it "check validate" do
    user = User.new
    expect_raises(Calm::Db::Validation::ValidationError) do
      user.validate!.should eq(false)
    end
  end

  # ################### persistence ########################

  it "should not be dirty after loading" do
    user = User.new
    user.username = "johndoe"
    user.email = "john@doe.hu"
    user.password = "adminadmin"
    user.persist

    user = User.all.first
    if user
      user.dirty?.should eq(false)
    else
    end
  end

  it "should be dirty after modifying something" do
  end

  # ####################### psql ###########################

  it "shows the create table script" do
    User.create_table_script.should eq("create table \"user\" (id serial primary key, username text, password text, email text, invalid_sign_in_count bigint);")
  end

  it "saves one row and reads back with first" do
    user = User.new
    user.username = "johndoe2"
    user.email = "john@doe.com"
    user.password = "adminadmin"
    user.invalid_sign_in_count = 2
    user.persist

    user = User.all.where("username", "johndoe2").order("id", "asc").first
    user.should_not eq(nil)

    if user
      user.username.should eq "johndoe2"
      user.email.should eq "john@doe.com"
      user.password.should eq "adminadmin"
      user["invalid_sign_in_count"].should eq 2
      user.invalid_sign_in_count.should eq 2
    end
  end

  # it "saves one row and reads back with all" do
  #   user = User.new
  #   user.username = "johndoe2"
  #   user.email = "john@doe.com"
  #   user.password = "adminadmin"
  #   user.invalid_sign_in_count = 2
  #   user.persist

  #   user_all = User.all.where("username", "johndoe2").call.first

  #   if user
  #     user.username.should eq "johndoe2"
  #     user.email.should eq "john@doe.com"
  #     user.password.should eq "adminadmin"
  #     user.invalid_sign_in_count.should eq 2
  #   end
  # end
end
