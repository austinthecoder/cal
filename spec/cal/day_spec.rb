require 'spec_helper'

describe Cal::Day do

  subject { described_class.new @date, @calendar }

  before do
    @date = Date.new 2012, 1, 15
    @calendar = OpenStruct.new :current_day => Date.new(2012, 1, 5)
  end

  describe "==" do
    it "is true with another day with the same calendar and date" do
      subject.should == described_class.new(@date, @calendar)
    end

    it "is false with another day with a different calendar" do
      subject.should_not == described_class.new(@date, Object.new)
    end

    it "is false with another day with a different date" do
      subject.should_not == described_class.new(Date.new(2012, 1, 14), @calendar)
    end

    it "is false with a non Cal::Day" do
      subject.should_not == Object.new
    end
  end

  describe "today?" do
    it "is true when the date is today" do
      @date = Date.current
      subject.should be_today
    end
  end

  describe "number" do
    [3, 15].each do |n|
      it "is the day of the month" do
        @date = Date.new 2012, 1, n
        subject.number.should == n
      end
    end
  end

end