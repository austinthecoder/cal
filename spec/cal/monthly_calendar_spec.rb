require 'spec_helper'

describe Cal::MonthlyCalendar do

  subject { described_class.new @date }

  before { @date = Date.new 2012, 2 }

  describe "initialize" do
    it "raises an error if arg can't be converted to a date" do
      ['Octember', Object.new, '2012'].each do |obj|
        expect { described_class.new obj }.to raise_error
      end
    end

    it "doesn't raise an error if arg can be converted to a date" do
      [Date.current, Date.new(2012, 1, 15), '2012-02-24'].each do |obj|
        expect { described_class.new obj }.to_not raise_error
      end
    end
  end

  describe "date" do
    it "is the given date" do
      subject.date.should == @date
    end
  end

  describe "==" do
    it "is true with another monthly calendar in the same month and year" do
      calendar = described_class.new Date.new(@date.year, @date.month, (@date.day + 1))
      (subject == calendar).should be_true
    end

    it "is false with another monthly calendar with a different month" do
      calendar = described_class.new Date.new(@date.year, (@date.month + 1), @date.day)
      (subject == calendar).should be_false
    end

    it "is false with another monthly calendar with a different year" do
      calendar = described_class.new Date.new((@date.year + 1), @date.month, @date.day)
      (subject == calendar).should be_false
    end

    it "is false with a non monthly calendar" do
      (subject == Object.new).should be_false
    end
  end

  describe "month" do
    it { subject.month.should == Cal::Month.new(subject) }
  end

  describe "first_day" do
    it "is the first viewable day on the calendar" do
      @date = Date.new 2012, 2, 23
      subject.first_day.should == Cal::Day.new(Date.new(2012, 1, 29), subject)
    end
  end

  describe "last_day" do
    it "is the last viewable day on the calendar" do
      @date = Date.new 2012, 2, 23
      subject.last_day.should == Cal::Day.new(Date.new(2012, 3, 3), subject)
    end
  end

  describe "days" do
    it "is a range of all the viewable days" do
      @date = Date.new 2012, 2, 23
      first_day = Cal::Day.new Date.new(2012, 1, 29), subject
      last_day = Cal::Day.new Date.new(2012, 3, 3), subject
      subject.days.should == (first_day..last_day)
    end
  end

  describe "weeks" do
    it "an array of the days in groups of 7" do
      @date = Date.parse "2012-02-23"
      subject.weeks.should == [
        %w[01-29 01-30 01-31 02-01 02-02 02-03 02-04].map { |s| Cal::Day.new Date.parse("2012-#{s}"), subject },
        %w[02-05 02-06 02-07 02-08 02-09 02-10 02-11].map { |s| Cal::Day.new Date.parse("2012-#{s}"), subject },
        %w[02-12 02-13 02-14 02-15 02-16 02-17 02-18].map { |s| Cal::Day.new Date.parse("2012-#{s}"), subject },
        %w[02-19 02-20 02-21 02-22 02-23 02-24 02-25].map { |s| Cal::Day.new Date.parse("2012-#{s}"), subject },
        %w[02-26 02-27 02-28 02-29 03-01 03-02 03-03].map { |s| Cal::Day.new Date.parse("2012-#{s}"), subject }
      ]
    end
  end

  describe "previous" do
    it "returns the calendar for the previous month" do
      subject.previous.should == described_class.new(@date.prev_month)
    end
  end

  describe "next" do
    it "returns the calendar for the next month" do
      subject.next.should == described_class.new(@date.next_month)
    end
  end

end