require 'spec_helper'

describe Cal::MonthlyCalendar do

  subject { described_class.new @date, @options }

  before do
    @date = Date.new 2012, 2
    @options = {}
  end

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

  describe "year" do
    it { subject.year.should == Cal::Year.new(subject) }
  end

  describe "first_day" do
    before { @date = Date.new 2012, 2, 23 }

    [
      [:monday, [1, 30]],
      [:tuesday, [1, 31]],
      [:wednesday, [2, 1]],
      [:thursday, [1, 26]],
      [:friday, [1, 27]],
      [:saturday, [1, 28]]
    ].each do |weekday, month_day|
      context "when the weekday is set to start on #{weekday}" do
        before { @options[:start_week_on] = weekday }
        it "is the first viewable day on the calendar" do
          subject.first_day.should == Cal::Day.new(Date.new(2012, *month_day), subject)
        end
      end
    end

    it "is the first viewable day on the calendar, using sunday as the default start day" do
      subject.first_day.should == Cal::Day.new(Date.new(2012, 1, 29), subject)
    end
  end

  describe "last_day" do
    before { @date = Date.new 2012, 2, 23 }

    [
      [:monday, [3, 4]],
      [:tuesday, [3, 5]],
      [:wednesday, [3, 6]],
      [:thursday, [2, 29]],
      [:friday, [3, 1]],
      [:saturday, [3, 2]]
    ].each do |weekday, month_day|
      context "when the weekday is set to start on #{weekday}" do
        before { @options[:start_week_on] = weekday }
        it "is the last viewable day on the calendar" do
          subject.last_day.should == Cal::Day.new(Date.new(2012, *month_day), subject)
        end
      end
    end

    it "is the last viewable day on the calendar, using sunday as the default start day" do
      subject.last_day.should == Cal::Day.new(Date.new(2012, 3, 3), subject)
    end
  end

  describe "days" do
    it "is a range of the first day to the last day" do
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

  describe "day_names" do
    it "defaults to sunday through saturday" do
      subject.day_names.should == %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    end

    [
      %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday],
      %w[Tuesday Wednesday Thursday Friday Saturday Sunday Monday],
      %w[Wednesday Thursday Friday Saturday Sunday Monday Tuesday],
      %w[Thursday Friday Saturday Sunday Monday Tuesday Wednesday],
      %w[Friday Saturday Sunday Monday Tuesday Wednesday Thursday],
      %w[Saturday Sunday Monday Tuesday Wednesday Thursday Friday]
    ].each do |day_names|
      it "is #{day_names[0]} through #{day_names[6]} when the weekday is set to start on #{day_names[0]}" do
        @options[:start_week_on] = day_names[0].downcase.to_sym
        subject.day_names.should == day_names
      end
    end
  end

end