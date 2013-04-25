require 'spec_helper'

describe Cal::Day do
  before do
    @date = Date.new 2012, 1, 15
    @calendar = OpenStruct.new :current_day => Date.new(2012, 1, 5)
  end

  it { Cal::Day.new(@date, @calendar).should be_a(Comparable) }

  describe "#==" do
    it "is true with another day with the same calendar and date" do
      Cal::Day.new(@date, @calendar).should == Cal::Day.new(@date, @calendar)
    end

    it "is false with another day with a different calendar" do
      Cal::Day.new(@date, @calendar).should_not == Cal::Day.new(@date, Object.new)
    end

    it "is false with another day with a different date" do
      Cal::Day.new(@date, @calendar).should_not == Cal::Day.new(Date.new(2012, 1, 14), @calendar)
    end

    it "is false with a non Cal::Day" do
      Cal::Day.new(@date, @calendar).should_not == Object.new
    end
  end

  describe "#today?" do
    it "is true when the date is today" do
      @date = Date.current
      Cal::Day.new(@date, @calendar).should be_today
    end
  end

  describe "#number" do
    [3, 15].each do |n|
      it "is the day of the month" do
        @date = Date.new 2012, 1, n
        Cal::Day.new(@date, @calendar).number.should == n
      end
    end
  end

  describe "#<=>" do
    it "is the result of comparing the dates" do
      other_date = Date.new 2012, 2, 15
      result = Object.new
      Cal::Day.new(@date, @calendar).date.stub(:<=>) { |obj| result if obj == other_date }
      (Cal::Day.new(@date, @calendar) <=> Cal::Day.new(other_date, Object.new)).should == result
    end
  end

  describe "#succ" do
    it "is the next day" do
      Cal::Day.new(@date, @calendar).succ.should == Cal::Day.new(Date.new(2012, 1, 16), @calendar)
    end
  end
end