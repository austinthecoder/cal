require 'spec_helper'
require 'cal/day'

describe Cal::Day do
  before do
    @date = Date.new 2012, 1, 15
  end

  it { Cal::Day.new(@date).should be_a(Comparable) }

  describe "#==" do
    it "is true with another day with the same date" do
      Cal::Day.new(@date).should == Cal::Day.new(@date)
    end

    it "is false with another day with a different date" do
      Cal::Day.new(@date).should_not == Cal::Day.new(Date.new(2012, 1, 14))
    end

    it "is false with a non Cal::Day" do
      Cal::Day.new(@date).should_not == Object.new
    end
  end

  describe "#today?" do
    it "is true when the date is today" do
      @date = Date.current
      Cal::Day.new(@date).should be_today
    end
  end

  describe "#number" do
    [3, 15].each do |n|
      it "is the day of the month" do
        @date = Date.new 2012, 1, n
        Cal::Day.new(@date).number.should == n
      end
    end
  end

  describe '#month' do
    it 'is the month the day is in' do
      Cal::Day.new(Date.new(2012, 1, 15)).month.should == Cal::Month.new(2012, 1)
    end

    it 'always returns the same object' do
      day = Cal::Day.new(Date.new(2012, 1, 15))
      day.month.should equal day.month
    end
  end

  describe "#<=>" do
    it "is the result of comparing the dates" do
      other_date = Date.new 2012, 2, 15
      result = Object.new
      Cal::Day.new(@date).date.stub(:<=>) { |obj| result if obj == other_date }
      (Cal::Day.new(@date) <=> Cal::Day.new(other_date)).should == result
    end
  end

  describe "#succ" do
    it "is the next day" do
      Cal::Day.new(@date).succ.should == Cal::Day.new(Date.new(2012, 1, 16))
    end
  end
end