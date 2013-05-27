require 'spec_helper'
require 'cal/monthly_calendar'

describe Cal::MonthlyCalendar do
  it { Cal::MonthlyCalendar.new(2012, 2).should be_a(Comparable) }

  describe ".new" do
    it "coerces the year and month number to integers" do
      Cal::MonthlyCalendar.new('2012', '04').should == Cal::MonthlyCalendar.new(2012, 4)
    end
  end

  describe "#<=>" do
    it "is nil with a non monthly calendar" do
      (Cal::MonthlyCalendar.new(2012, 2) <=> Object.new).should be_nil
    end

    context "given another monthly calendar" do
      before { @other = Cal::MonthlyCalendar.new 2012, 2 }

      it "is nil when the other's start day is different" do
        (Cal::MonthlyCalendar.new(2012, 2, :start_week_on => :monday) <=> @other).should be_nil
      end

      it "is the result of comparing the months when the other's start day is the same" do
        result = Object.new
        calendar = Cal::MonthlyCalendar.new(2012, 2)
        calendar.month.stub(:<=>).with(@other.month) { result }
        (calendar <=> @other).should == result
      end
    end
  end

  describe "#month" do
    it { Cal::MonthlyCalendar.new(2012, 2).month.should == Cal::Month.new(2012, 2) }
  end

  describe "#year" do
    it { Cal::MonthlyCalendar.new(2012, 2).year.should == 2012 }
  end

  describe "#first_day" do
    [
      [:monday, [1, 30]],
      [:tuesday, [1, 31]],
      [:wednesday, [2, 1]],
      [:thursday, [1, 26]],
      [:friday, [1, 27]],
      [:saturday, [1, 28]]
    ].each do |weekday, month_day|
      context "when the weekday is set to start on #{weekday}" do
        it "is the first viewable day on the calendar" do
          calendar = Cal::MonthlyCalendar.new(2012, 2, :start_week_on => weekday)
          calendar.first_day.should == Cal::Day.new(Date.new(2012, *month_day))
        end
      end
    end

    it "is the first viewable day on the calendar, using sunday as the default start day" do
      calendar = Cal::MonthlyCalendar.new(2012, 2)
      calendar.first_day.should == Cal::Day.new(Date.new(2012, 1, 29))
    end
  end

  describe "#last_day" do
    [
      [:monday, [3, 4]],
      [:tuesday, [3, 5]],
      [:wednesday, [3, 6]],
      [:thursday, [2, 29]],
      [:friday, [3, 1]],
      [:saturday, [3, 2]]
    ].each do |weekday, month_day|
      context "when the weekday is set to start on #{weekday}" do
        it "is the last viewable day on the calendar" do
          calendar = Cal::MonthlyCalendar.new(2012, 2, :start_week_on => weekday)
          calendar.last_day.should == Cal::Day.new(Date.new(2012, *month_day))
        end
      end
    end

    it "is the last viewable day on the calendar, using sunday as the default start day" do
      calendar = Cal::MonthlyCalendar.new(2012, 2)
      calendar.last_day.should == Cal::Day.new(Date.new(2012, 3, 3))
    end
  end

  describe "#days" do
    it "is a range of the first day to the last day" do
      calendar = Cal::MonthlyCalendar.new(2012, 2)
      first_day = Cal::Day.new Date.new(2012, 1, 29)
      last_day = Cal::Day.new Date.new(2012, 3, 3)
      calendar.days.should == (first_day..last_day)
    end
  end

  describe "#weeks" do
    it "an array of the days in groups of 7" do
      calendar = Cal::MonthlyCalendar.new(2012, 2)
      calendar.weeks.should == [
        %w[01-29 01-30 01-31 02-01 02-02 02-03 02-04].map { |s| Cal::Day.new Date.parse("2012-#{s}") },
        %w[02-05 02-06 02-07 02-08 02-09 02-10 02-11].map { |s| Cal::Day.new Date.parse("2012-#{s}") },
        %w[02-12 02-13 02-14 02-15 02-16 02-17 02-18].map { |s| Cal::Day.new Date.parse("2012-#{s}") },
        %w[02-19 02-20 02-21 02-22 02-23 02-24 02-25].map { |s| Cal::Day.new Date.parse("2012-#{s}") },
        %w[02-26 02-27 02-28 02-29 03-01 03-02 03-03].map { |s| Cal::Day.new Date.parse("2012-#{s}") }
      ]
    end
  end

  describe "#previous" do
    it "returns the calendar for the previous month" do
      calendar = Cal::MonthlyCalendar.new(2012, 12, :start_week_on => :wednesday)
      calendar.previous.should == Cal::MonthlyCalendar.new(2012, 11, :start_week_on => :wednesday)
    end
  end

  describe "#next" do
    it "returns the calendar for the next month" do
      calendar = Cal::MonthlyCalendar.new(2012, 12, :start_week_on => :wednesday)
      calendar.next.should == Cal::MonthlyCalendar.new(2013, 1, :start_week_on => :wednesday)
    end
  end

  describe "#day_names" do
    it "defaults to sunday through saturday" do
      Cal::MonthlyCalendar.new(2012, 12).day_names.should == %i[sunday monday tuesday wednesday thursday friday saturday]
    end

    [
      %i[monday tuesday wednesday thursday friday saturday sunday],
      %i[tuesday wednesday thursday friday saturday sunday monday],
      %i[wednesday thursday friday saturday sunday monday tuesday],
      %i[thursday friday saturday sunday monday tuesday wednesday],
      %i[friday saturday sunday monday tuesday wednesday thursday],
      %i[saturday sunday monday tuesday wednesday thursday friday],
    ].each do |day_names|
      it "is #{day_names[0]} through #{day_names[6]} when the weekday is set to start on #{day_names[0]}" do
        calendar = Cal::MonthlyCalendar.new(2012, 12, :start_week_on => day_names[0])
        calendar.day_names.should == day_names
      end
    end
  end
end