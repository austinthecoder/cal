require 'spec_helper'

describe Cal::MonthlyCalendar do

  describe "class methods" do
    subject { described_class }

    describe "from_month" do
      it "returns a calendar for the month's year and month number" do
        subject.from_month(Cal::Month.new(2012, 11), :start_week_on => :tuesday).should == subject.new(2012, 11, :start_week_on => :tuesday)
      end

      it "raises an error without something that can be converted to a month" do
        [nil, Object.new].each do |object|
          expect { subject.from_month(object) }.to raise_error(NoMethodError)
        end
      end
    end

    describe "from_param" do
      it "is the calendar for the given param" do
        calendar = subject.new 2012, 5, :start_week_on => :tuesday
        subject.from_param(calendar.to_param, :start_week_on => :tuesday).should == calendar
      end

      context "with a blank param" do
        it "returns a calendar for the current year and month" do
          [' ', nil].each do |param|
            date = Date.current
            subject.from_param(param).should == subject.new(date.year, date.month)
          end
        end
      end
    end
  end

  describe "instance methods" do
    subject { described_class.new @year, @month, @options }

    before do
      @year = 2012
      @month = 2
      @options = {}
    end

    it { should be_a(Comparable) }

    describe "initialize" do
      it "coerces the year and month number to integers" do
        @year = "2012"
        @month = "04"
        subject.should == described_class.new(2012, 4)
      end
    end

    describe "<=>" do
      it "is nil with a non monthly calendar" do
        (subject <=> Object.new).should be_nil
      end

      it "is nil with a non monthly calendar" do
        (subject <=> Object.new).should be_nil
      end

      context "given another monthly calendar" do
        before { @other = described_class.new @year, @month, @options }

        it "is nil when the other's start day is different" do
          @options[:start_week_on] = :tuesday
          (subject <=> @other).should be_nil
        end

        it "is the result of comparing the months when the other's start day is the same" do
          result = Object.new
          subject.month.stub(:<=>) { |m| result if m == @other.month }
          (subject <=> @other).should == result
        end
      end
    end

    describe "month" do
      it { subject.month.should == Cal::Month.new(@year, @month) }
    end

    describe "year" do
      it { subject.year.should == @year }
    end

    describe "first_day" do
      before { @year, @month = 2012, 2 }

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
      before { @year, @month = 2012, 2 }

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
        @year, @month = 2012, 2
        first_day = Cal::Day.new Date.new(2012, 1, 29), subject
        last_day = Cal::Day.new Date.new(2012, 3, 3), subject
        subject.days.should == (first_day..last_day)
      end
    end

    describe "weeks" do
      it "an array of the days in groups of 7" do
        @year, @month = 2012, 2
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
        @options[:start_week_on] = :wednesday
        subject.previous.should == described_class.new(@year, (@month - 1), @options)
      end
    end

    describe "next" do
      it "returns the calendar for the next month" do
        @options[:start_week_on] = :wednesday
        subject.next.should == described_class.new(@year, (@month + 1), @options)
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

    describe "to_param" do
      it "is the year and month string" do
        @year, @month = 2012, 12
        subject.to_param.should == "2012-12"
      end
    end
  end

end