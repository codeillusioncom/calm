require "marionette"
require "./spec_helper"

include Marionette

describe "Calm" do
  # let(:session) { described_class.new(TEST_SESSION) }

  it "shows a website" do
    pp TEST_SESSION
    TEST_SESSION.navigate "http://localhost:3001/home"
    TEST_SESSION.current_url.should eq "http://localhost:3001/home"
  end

  it "show the title" do
    TEST_SESSION.title.should eq "Calm 0.1"
  end

  it "find something" do
    title_element = TEST_SESSION.wait_for_element("#main h1")
    title_element2 = TEST_SESSION.find_element!("#main>h1")
    pp title_element
  end
end
