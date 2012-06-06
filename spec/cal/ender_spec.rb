require 'spec_helper'

describe Cal::Ender do
  subject { described_class.new @date, @options }

  before do
    @date = Date.new 2012, 2, 1
    @options = {}
  end

  describe "initialize" do
    it "raises argument error if given format isn't :monthly" do
      @options[:format] = :weekly
      expect { subject }.to raise_error(ArgumentError)
    end

    it "raises an error if the first arg can't be converted to a date" do
      ['Octember', Object.new, '2012'].each do |obj|
        expect { described_class.new obj }.to raise_error
      end
    end

    it "doesn't raise an error if the first arg can be converted to a date" do
      [Date.current, Date.new(2012, 1, 15), '2012-02-24'].each do |obj|
        expect { described_class.new obj }.to_not raise_error
      end
    end
  end

  describe "format" do
    it "defaults to monthly" do
      subject.format.should == :monthly
    end

    it "otherwise is the given format" do
      @options[:format] = :monthly
      subject.format.should == :monthly
    end
  end

  describe "date" do
    it "is the given date" do
      subject.date.should == @date
    end
  end

  describe "==" do
    it "is true with another calendar with the same format and date" do
      @date = Date.new 2012, 2, 1
      @options[:format] = :monthly
      subject.should == described_class.new(@date, @options)
    end

    it "is false with another calendar with a different date" do
      @date = Date.new 2012, 2, 1
      @options[:format] = :monthly
      subject.should_not == described_class.new(Date.new(2012, 2, 2), @options)
    end

    it "is false with a non-Ender object" do
      subject.should_not == Object.new
    end
  end

  describe "month" do
    it { subject.month.should == Cal::Month.new(subject) }
  end

  describe "days" do
    it "is an array of all the viewable days" do
      @date = Date.new 2012, 2, 23

      prev_month_days = %w[01-29 01-30 01-31]
      days = %w[02-01 02-02 02-03 02-04 02-05 02-06 02-07 02-08 02-09 02-10 02-11 02-12 02-13 02-14 02-15 02-16 02-17 02-18 02-19 02-20 02-21 02-22 02-23 02-24 02-25 02-26 02-27 02-28 02-29]
      next_month_days = %w[03-01 03-02 03-03]

      subject.days.should == (prev_month_days + days + next_month_days).map do |s|
        Cal::Day.new subject, Date.parse("2012-#{s}")
      end
    end
  end

  describe "weeks" do
    it "is the days in groups of 7" do
      @date = Date.parse "2012-02-23"
      subject.weeks.should == [
        %w[01-29 01-30 01-31 02-01 02-02 02-03 02-04].map { |s| Cal::Day.new subject, Date.parse("2012-#{s}") },
        %w[02-05 02-06 02-07 02-08 02-09 02-10 02-11].map { |s| Cal::Day.new subject, Date.parse("2012-#{s}") },
        %w[02-12 02-13 02-14 02-15 02-16 02-17 02-18].map { |s| Cal::Day.new subject, Date.parse("2012-#{s}") },
        %w[02-19 02-20 02-21 02-22 02-23 02-24 02-25].map { |s| Cal::Day.new subject, Date.parse("2012-#{s}") },
        %w[02-26 02-27 02-28 02-29 03-01 03-02 03-03].map { |s| Cal::Day.new subject, Date.parse("2012-#{s}") }
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