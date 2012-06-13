require 'spec_helper'

describe Cal::Month do

  subject { described_class.new @year, @month_number }

  before do
    @year = 2012
    @month_number = 3
  end

  describe "initialize" do
    it "coerces the year and month number to integers" do
      @year = "2012"
      @month_number = "04"
      subject.year.should == 2012
      subject.number.should == 4
    end
  end

  it { should be_a(Comparable) }

  describe "<=>" do
    it "is nil with a non month" do
      (subject <=> Object.new).should be_nil
    end

    context "given another month" do
      before { @other = described_class.new @year, @month_number }

      context "when the other's year is the same" do
        it "is 0 when the other's month is the same" do
          (subject <=> @other).should == 0
        end

        it "is -1 when the other's month is higher" do
          @month_number = 2
          (subject <=> @other).should == -1
        end

        it "is 1 when the other's month is lower" do
          @month_number = 4
          (subject <=> @other).should == 1
        end
      end

      it "is -1 when the other's year is higher" do
        @year = 2011
        (subject <=> @other).should == -1
      end

      it "is 1 when the other's year is lower" do
        @year = 2013
        (subject <=> @other).should == 1
      end
    end
  end

  describe "==" do
    it "is false with a non month" do
      (subject == Object.new).should be_false
    end

    context "given another month" do
      before { @month = described_class.new @year, @month_number }

      it "is true if the comparison is zero" do
        subject.stub(:<=>) { 0 }
        (subject == @month).should be_true
      end

      it "is false if the comparison is not zero" do
        subject.stub(:<=>) { -1 }
        (subject == @month).should be_false
      end
    end
  end

  it { subject.number.should == @month_number }

  describe "to_s" do
    it "is the result of formatting a date object" do
      date = Object.new
      format = Object.new
      result = Object.new
      Date.stub(:new) { |*args| date if args == [@year, @month_number] }
      date.stub(:strftime) { |f| result if f == format }
      subject.to_s(format).should == result
    end
  end

  describe "year" do
    it "is the given year" do
      subject.year.should == 2012
    end
  end

  describe "succ" do
    [[2012, 12, 2013, 1], [2012, 1, 2012, 2]].each do |year, month_number, new_year, new_month_number|
      it "is the next month" do
        @year = year
        @month_number = month_number
        subject.succ.should == described_class.new(new_year, new_month_number)
      end
    end
  end

  describe "previous" do
    [[2012, 12, 2012, 11], [2012, 1, 2011, 12]].each do |year, month_number, new_year, new_month_number|
      it "is the previous month" do
        @year = year
        @month_number = month_number
        subject.previous.should == described_class.new(new_year, new_month_number)
      end
    end
  end

  describe "to_month" do
    it { subject.to_month.should == subject }
  end

end