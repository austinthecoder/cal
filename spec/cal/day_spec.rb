require 'spec_helper'

describe Cal::Day do
  subject { described_class.new @calendar, @date }

  before do
    @calendar = OpenStruct.new :current_day => Date.parse("2012-01-05")
    @date = Date.parse("2012-01-05")
  end

  describe "==" do
    it "is true with another day with the same calendar and date" do
      subject.should == described_class.new(@calendar, @date)
    end
  end

  describe "today?" do
    it "is true when the date is today" do
      @date = Date.current
      subject.should be_today
    end
  end

  describe "current?" do
    it "is true when the date is the calendars date" do
      @calendar.current_day = @date
      subject.should be_current
    end
  end

end