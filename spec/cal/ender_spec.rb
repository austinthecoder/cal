require 'spec_helper'

describe Cal::Ender do
  subject { described_class.new @options }

  before do
    @options = {}
  end

  describe "initialize" do
    it "raises argument error if given format isn't :monthly" do
      @options[:format] = :weekly
      expect { subject }.to raise_error(ArgumentError)
    end

    it "raises argument error if the given month isn't recognized" do
      @options[:month] = 'Octember'
      expect { subject }.to raise_error(ArgumentError)
    end

    %w[01-28 03-04].each do |s|
      it "raises argument error if the given current_day isn't in the given month or in the viewable days from the previous or next month" do
        @options[:month] = 'February'
        @options[:current_day] = Date.parse "2012-#{s}"
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    %w[02-15 01-29 03-03].each do |s|
      it "doesn't raise argument error if the given current_day is in the given month or in the viewable days from the previous or next month" do
        @options[:month] = 'February'
        @options[:current_day] = Date.parse "2012-#{s}"
        expect { subject }.to_not raise_error
      end
    end

    it "raises argument error if the month is given and the current_day is" do
      @options[:month] = 'February'
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  describe "format" do
    it "defaults to monthly" do
      subject.format.should == :monthly
    end
  end

  describe "==" do
    it "is true with another calendar with the same format, month and current_day" do
      @options[:month] = 'February'
      @options[:current_day] = Date.parse "2012-02-01"
      @options[:format] = :monthly

      subject.should == described_class.new(@options)
    end
  end

  describe "current_day" do
    it "is the given current_day" do
      @options[:current_day] = Date.parse "2012-01-01"
      subject.current_day.should == @options[:current_day]
    end

    it "is today when the current_day and month isn't given" do
      subject.current_day.should == Date.current
    end
  end

  describe "month" do
    context "when the current_day is given" do
      before { @options[:current_day] = Date.parse "2012-05-15" }

      it "is the current_day's month" do
        subject.month.should == 'May'
      end

      it "is the given month" do
        @options[:month] = 'May'
        subject.month.should == 'May'
      end
    end

    it "is the current month when the current_day isn't given" do
      month = Date.current.strftime "%B"
      subject.month.should == month
    end
  end

  describe "weeks" do
    it "is the days in groups of 7" do
      @options[:current_day] = Date.parse "2012-02-23"
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
      @options[:current_day] = Date.parse "2012-02-23"
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