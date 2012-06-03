require 'spec_helper'

describe Cal::Day do
  subject { described_class.new @calendar, @date }

  before do
    @calendar = OpenStruct.new :date => Date.parse("2012-01-05")
    @date = Date.parse("2012-01-05")
  end

  describe "==" do
    it "is true with another day with the same calendar and date" do
      subject.should == described_class.new(@calendar, @date)
    end
  end

end