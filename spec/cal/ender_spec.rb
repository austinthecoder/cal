require 'spec_helper'

describe Cal::Ender do
  subject { described_class.new @date }

  before do
    @date = Date.parse("2012-02-23")
  end

  describe "=" do
    it "is true with another calendar with the same date" do
      subject.should == described_class.new(@date)
    end
  end

  describe "date" do
    it "is the date given" do
      subject.date.should == @date
    end
  end

  describe "month" do
    it "is a month" do
      subject.month.should be_a(Cal::Month)
    end

    it "has a reference to the calendar" do
      subject.month.calendar.should == subject
    end
  end

  describe "weeks" do
    it "is the days in groups of 7" do
      subject.weeks.should == [
        %w[01-29 01-30 01-31 02-01 02-02 02-03 02-04].map { |s| Cal::Day.new subject, Date.parse("2012-#{s}") },
        %w[02-05 02-06 02-07 02-08 02-09 02-10 02-11].map { |s| Cal::Day.new subject, Date.parse("2012-#{s}") },
        %w[02-12 02-13 02-14 02-15 02-16 02-17 02-18].map { |s| Cal::Day.new subject, Date.parse("2012-#{s}") },
        %w[02-19 02-20 02-21 02-22 02-23 02-24 02-25].map { |s| Cal::Day.new subject, Date.parse("2012-#{s}") },
        %w[02-26 02-27 02-28 02-29 03-01 03-02 03-03].map { |s| Cal::Day.new subject, Date.parse("2012-#{s}") }
      ]
    end
  end

  describe "days" do
    it "is an array of all the viewable days" do
      jan = %w[01-29 01-30 01-31]
      feb = %w[02-01 02-02 02-03 02-04 02-05 02-06 02-07 02-08 02-09 02-10 02-11 02-12 02-13 02-14 02-15 02-16 02-17 02-18 02-19 02-20 02-21 02-22 02-23 02-24 02-25 02-26 02-27 02-28 02-29]
      mar = %w[03-01 03-02 03-03]

      subject.days.should == (jan + feb + mar).map do |s|
        Cal::Day.new subject, Date.parse("2012-#{s}")
      end
    end
  end

  describe "week_headings" do
    it "returns the days of the week" do
      subject.week_headings.should == %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
    end
  end

end